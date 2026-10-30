import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/transaction_record.dart';
import '../theme/app_theme.dart';

class ReceiptScreen extends StatelessWidget {
  final TransactionRecord transaction;

  const ReceiptScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${transaction.timestamp.day.toString().padLeft(2, '0')}/${transaction.timestamp.month.toString().padLeft(2, '0')}/${transaction.timestamp.year} ${transaction.timestamp.hour.toString().padLeft(2, '0')}:${transaction.timestamp.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Struk Pembayaran'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Salin No. Transaksi',
            icon: const Icon(Icons.copy, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: transaction.id));
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  content: const Text('Nomor transaksi disalin ke clipboard'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x080F172A),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: AppColors.primary,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Center(
                          child: Text(
                            'WARUNG MAKAN SEDERHANA',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Center(
                          child: Text(
                            'Jl. Kulino No. 4, Semarang',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: AppColors.border),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'No. Transaksi',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              transaction.id,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Waktu',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              dateStr,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Metode',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              transaction.paymentMethod,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        if (transaction.latitude != null &&
                            transaction.longitude != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'GPS Hardware',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '${transaction.latitude!.toStringAsFixed(4)}, ${transaction.longitude!.toStringAsFixed(4)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 16),
                        const Divider(color: AppColors.border),
                        const SizedBox(height: 8),
                        const Text(
                          'Rincian Pesanan:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...transaction.items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${item.product.name} x${item.quantity}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Rp ${item.subtotal}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                if (item.notes.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      'Catatan: ${item.notes}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontStyle: FontStyle.italic,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                        const Divider(color: AppColors.border),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Rp ${transaction.totalAmount}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Diterima',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              'Rp ${transaction.paidAmount}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Kembalian',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              'Rp ${transaction.changeAmount}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            'Terima kasih atas pesanan Anda!',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    icon: const Icon(Icons.home, size: 18),
                    label: const Text('Kembali ke Katalog & Pesanan Baru'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
