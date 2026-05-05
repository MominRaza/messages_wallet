import 'dart:io';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../shared/models/spending_model.dart';
import '../../utils/group_transactions_by_month.dart';
import 'transactions_list_item.dart';

@RoutePage()
class AccountScreen extends StatefulWidget {
  const AccountScreen({required this.transactions, required this.title, super.key});
  final String title;
  final List<Transaction> transactions;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Future<void> _export() async {
    try {
      final csv = "Date,Type,Amount,Description\n${widget.transactions.map((t) => "${t.dateTime},${t.type},${t.transactionAmount},${t.body.replaceAll(',', ' ')}").join('\n')}";
      final file = File('${(await getTemporaryDirectory()).path}/${widget.title.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(csv);
      // ignore: deprecated_member_use
      await Share.shareXFiles([XFile(file.path)], text: 'Export ${widget.title} Transactions');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final groups = groupTransactionsByMonth(widget.transactions);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title, overflow: TextOverflow.ellipsis), centerTitle: false, elevation: 0, actions: [IconButton(icon: const Icon(Icons.share), onPressed: _export)]),
      body: groups.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.receipt_long_outlined, size: 64), const SizedBox(height: 16), Text('No transactions found', style: Theme.of(context).textTheme.titleMedium)]))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: groups.length,
              itemBuilder: (c, i) {
                final g = groups[i];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          // ignore: deprecated_member_use
                          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withOpacity(0.7)]), borderRadius: BorderRadius.circular(20)), child: Text('${g.month} ${g.year}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12))),
                          const SizedBox(width: 12),
                          Expanded(child: Divider(color: Theme.of(context).dividerColor, thickness: 1)),
                          // ignore: deprecated_member_use
                          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: (g.totalAmount >= 0 ? Colors.green : Colors.red).withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text('${g.totalAmount >= 0 ? '+' : ''}${_formatCurrency(g.totalAmount)}', style: TextStyle(color: g.totalAmount >= 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 13))),
                        ],
                      ),
                    ),
                    ...g.transactions.map((t) => TransactionListItem(transaction: t)),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _SummaryItem(label: 'Total Credit', amount: g.totalCredit, color: Colors.green, icon: Icons.arrow_downward),
                            Container(width: 1, height: 30, color: Theme.of(context).dividerColor),
                            _SummaryItem(label: 'Total Debit', amount: g.totalDebit, color: Colors.red, icon: Icons.arrow_upward, isDebit: true),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
    );
  }

  String _formatCurrency(double a) => NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0).format(a.abs());
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.amount, required this.color, required this.icon, this.isDebit = false});
  final String label; final double amount; final Color color; final IconData icon; final bool isDebit;

  @override
  Widget build(BuildContext context) => Row(children: [Icon(icon, color: color, size: 20), const SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: Theme.of(context).textTheme.labelSmall), Text('${isDebit ? '-' : '+'} ₹ ${amount.toInt()}', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14))])]);
}