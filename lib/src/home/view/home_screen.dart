import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

import '../../../app_router.gr.dart';
import '../../shared/models/spending_model.dart';
import '../../shared/view/issue_dialog.dart';
import '../../utils/currency.dart';
import '../../utils/universal_parser.dart';
import '../../accounts/view/no_bank_card_view.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  
  Map<String, List<Transaction>> _transactionsGroup = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _checkPermissionAndLoad();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissionAndLoad() async {
    final status = await Permission.sms.status;
    if (status.isGranted) {
      await _loadRealTransactions();
    } else {
      final result = await Permission.sms.request();
      if (result.isGranted) {
        await _loadRealTransactions();
      } else {
        setState(() {
          _error = 'SMS permission is required to read transactions';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadRealTransactions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final smsQuery = SmsQuery();
      final messages = await smsQuery.querySms();
      
      final List<Transaction> allTransactions = [];
      final Set<String> uniqueKeys = {};
      
      for (var message in messages) {
        final transaction = UniversalParser.parseSms(message);
        if (transaction != null) {
          final key = '${transaction.transactionAmount}_${transaction.dateTime.millisecondsSinceEpoch}_${transaction.accountNumber}';
          if (uniqueKeys.add(key)) {
            allTransactions.add(transaction);
          }
        }
      }
      
      final Map<String, List<Transaction>> groups = {};
      for (var t in allTransactions) {
        groups.putIfAbsent(t.accountNumber, () => []).add(t);
      }
      
      for (var value in groups.values) {
        value.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      }
      
      setState(() {
        _transactionsGroup = groups;
        _isLoading = false;
      });
      _fadeController.forward();
      
    } catch (e) {
      setState(() {
        _error = 'Error loading transactions: $e';
        _isLoading = false;
      });
    }
  }

  double get _totalBalance {
    double balance = 0;
    for (var transactions in _transactionsGroup.values) {
      if (transactions.isNotEmpty) {
        final lastTxn = transactions.last;
        if (lastTxn.finalAmount != null) {
          balance += lastTxn.finalAmount!;
        }
      }
    }
    return balance;
  }

  double get _totalCredit {
    double credit = 0;
    for (var transactions in _transactionsGroup.values) {
      for (var t in transactions) {
        if (t.type == TransactionType.credited || t.type == TransactionType.creditCardReversed) {
          credit += t.transactionAmount;
        }
      }
    }
    return credit;
  }

  double get _totalDebit {
    double debit = 0;
    for (var transactions in _transactionsGroup.values) {
      for (var t in transactions) {
        if (t.type != TransactionType.credited && t.type != TransactionType.creditCardReversed) {
          debit += t.transactionAmount;
        }
      }
    }
    return debit;
  }

  Future<void> _exportAllTransactions() async {
    try {
      String csv = 'Date,Type,Amount,Account,Description\n';
      for (var entry in _transactionsGroup.entries) {
        for (var t in entry.value) {
          csv += '${t.dateTime},${t.type},${t.transactionAmount},${entry.key},${t.body.replaceAll(',', ' ')}\n';
        }
      }
      
      final tempDir = await getTemporaryDirectory();
      final fileName = 'all_transactions_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsString(csv);
      
      // ignore: deprecated_member_use
      await Share.shareXFiles([XFile(file.path)], 
        text: 'My Transactions Export',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              Text(_error!),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _checkPermissionAndLoad,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadRealTransactions,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Messages Wallet'),
              centerTitle: false,
              pinned: true,
              floating: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    switch (value) {
                      case 'settings':
                        context.router.push(const SettingsRoute());
                        break;
                      case 'export':
                        _exportAllTransactions();
                        break;
                      case 'feedback':
                        showIssueDialog(context);
                        break;
                      case 'repo':
                        launchUrl(
                          Uri.https('github.com', '/MominRaza/messages_wallet'),
                        );
                        break;
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings, size: 20),
                          SizedBox(width: 12),
                          Text('Settings'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'export',
                      child: Row(
                        children: [
                          Icon(Icons.share, size: 20),
                          SizedBox(width: 12),
                          Text('Export All Transactions'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'repo',
                      child: Row(
                        children: [
                          Icon(Icons.star, size: 20),
                          SizedBox(width: 12),
                          Text('Star GitHub Repo'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'feedback',
                      child: Row(
                        children: [
                          Icon(Icons.feedback, size: 20),
                          SizedBox(width: 12),
                          Text('Feedback'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            SliverToBoxAdapter(
              child: _buildAtmCard(),
            ),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Accounts',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '${_transactionsGroup.length} accounts',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final entry = _transactionsGroup.entries.elementAt(index);
                  return _buildBankCard(entry);
                },
                childCount: _transactionsGroup.length,
              ),
            ),
            
            const SliverToBoxAdapter(
              child: NoBankCardView(),
            ),
            
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAtmCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                      const Color(0xFF004D40),
                    ],
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Total Balance',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Container(
                          width: 32,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.credit_card,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: _totalBalance),
                      duration: const Duration(milliseconds: 1000),
                      builder: (context, value, child) {
                        return Text(
                          currencyFormat(value),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_downward,
                                  color: Colors.green,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                currencyFormat(_totalCredit),
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                'Total Credit',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        Container(
                          width: 1,
                          height: 50,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_upward,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                currencyFormat(_totalDebit),
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                'Total Debit',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        Container(
                          width: 1,
                          height: 50,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.blue,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_transactionsGroup.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                'Total Accounts',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBankCard(MapEntry<String, List<Transaction>> entry) {
    final transactions = entry.value;
    final lastTransaction = transactions.last;
    final isCreditCard = entry.key.contains('Credit Card');
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => context.router.push(
          AccountRoute(
            title: entry.key,
            transactions: transactions,
          ),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isCreditCard
                            ? const [Colors.purple, Colors.deepPurple]
                            : const [Colors.blue, Colors.indigo],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isCreditCard ? Icons.credit_card : Icons.account_balance,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCreditCard ? 'Credit Card' : 'Bank Account',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Text(
                          entry.key,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${transactions.length} txn',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Balance',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        lastTransaction.finalAmount != null
                            ? currencyFormat(lastTransaction.finalAmount!)
                            : 'N/A',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Last Transaction',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '₹ ${lastTransaction.transactionAmount.abs().toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: lastTransaction.type == TransactionType.credited
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}