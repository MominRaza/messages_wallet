// ignore_for_file: deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../app_router.gr.dart';
import '../../shared/models/spending_model.dart';
import '../../utils/currency.dart';
import '../../utils/date_time.dart';
import '../../utils/final_balance.dart';

class BankCardView extends StatefulWidget {
  const BankCardView({required this.entry, super.key});

  final MapEntry<String, List<Transaction>> entry;

  @override
  State<BankCardView> createState() => _BankCardViewState();
}

class _BankCardViewState extends State<BankCardView> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lastTransaction = widget.entry.value.last;
    final totalTransactions = widget.entry.value.length;
    final recentTransactions = widget.entry.value.reversed.take(3).toList();

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            child: Hero(
              tag: 'bank_card_${widget.entry.key.replaceAll(' ', '_')}',
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () => context.router.push(
                    AccountRoute(
                      title: widget.entry.key,
                      transactions: widget.entry.value,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bank Header with Icon
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.primary.withOpacity(0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _getBankIcon(widget.entry.key),
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
                                    _getBankName(widget.entry.key),
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  // REMOVED HERO FROM HERE - Now just a simple Text
                                  Text(
                                    widget.entry.key,
                                    style: Theme.of(context).textTheme.bodySmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$totalTransactions txn',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Balance Section
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Current Balance',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    finalBalance(
                                      lastTransaction.type,
                                      lastTransaction.finalAmount,
                                    ).split(':')[1].trim(),
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Theme.of(context).dividerColor,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Last Activity',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatDateTime(lastTransaction.dateTime).split(' at')[0],
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Recent Transactions
                        if (recentTransactions.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Transactions',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              TextButton(
                                onPressed: () => context.router.push(
                                  AccountRoute(
                                    title: widget.entry.key,
                                    transactions: widget.entry.value,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('View All'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...recentTransactions.asMap().entries.map((entry) {
                            return _AnimatedTransactionTile(
                              transaction: entry.value,
                              index: entry.key,
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getBankIcon(String accountNumber) {
    if (accountNumber.contains('Axis')) return Icons.account_balance;
    if (accountNumber.contains('Baroda')) return Icons.account_balance;
    if (accountNumber.contains('Cosmos')) return Icons.account_balance;
    return Icons.credit_card;
  }

  String _getBankName(String accountNumber) {
    if (accountNumber.contains('Axis')) return 'Axis Bank';
    if (accountNumber.contains('Baroda')) return 'Bank of Baroda';
    if (accountNumber.contains('Cosmos')) return 'Cosmos Bank';
    return 'Bank Account';
  }
}

class _AnimatedTransactionTile extends StatelessWidget {
  const _AnimatedTransactionTile({
    required this.transaction,
    required this.index,
  });

  final Transaction transaction;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1,
      duration: Duration(milliseconds: 300 + (index * 50)),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.2, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
        )),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatDateTime(transaction.dateTime).split(' at')[0],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      transaction.body.length > 50
                          ? '${transaction.body.substring(0, 50)}...'
                          : transaction.body,
                      style: Theme.of(context).textTheme.labelMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                currencyFormat(transaction.transactionAmount, transaction.type),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: _getAmountColor(transaction.type),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getAmountColor(TransactionType type) {
    switch (type) {
      case TransactionType.credited:
      case TransactionType.creditCardReversed:
        return Colors.green;
      default:
        return Colors.red;
    }
  }
}