import 'package:flutter/material.dart';
import '../models/transaction_record.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/transaction_repository_impl.dart';
import 'receipt_screen.dart';

class HistoryScreen extends StatefulWidget {
  final TransactionRepository? repository;

  const HistoryScreen({super.key, this.repository});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final TransactionRepository transactionRepo;
  List<TransactionRecord> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    transactionRepo = widget.repository ?? TransactionRepositoryImpl();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    setState(() {
      isLoading = true;
    });

    final list = await transactionRepo.getTransactions();

    if (!mounted) return;

    setState(() {
      transactions = list;
      isLoading = false;
    });
  }

  Future<void> clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Semua Riwayat?'),
        content: const Text(
          'Seluruh data rekaman transaksi yang tersimpan di perangkat akan dihapus secara permanen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await transactionRepo.clearTransactions();
      loadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        actions: [
          if (transactions.isNotEmpty)
            IconButton(
              tooltip: 'Hapus Riwayat',
              icon: const Icon(Icons.delete_outline),
              onPressed: clearHistory,
            ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : transactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 70,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Belum ada transaksi tersimpan',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: transactions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final trx =
                          transactions[transactions.length - 1 - index];
                      final date =
                          '${trx.timestamp.day.toString().padLeft(2, '0')}/${trx.timestamp.month.toString().padLeft(2, '0')} ${trx.timestamp.hour.toString().padLeft(2, '0')}:${trx.timestamp.minute.toString().padLeft(2, '0')}';

                      return Card(
                        elevation: 1.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal.shade50,
                            child: Icon(
                              trx.paymentMethod == 'QRIS'
                                  ? Icons.qr_code
                                  : Icons.money,
                              color: Colors.teal.shade700,
                            ),
                          ),
                          title: Text(
                            trx.id,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '$date • ${trx.items.length} item • ${trx.paymentMethod}',
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rp ${trx.totalAmount}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.teal,
                                ),
                              ),
                              const Icon(Icons.chevron_right, size: 18),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReceiptScreen(transaction: trx),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
