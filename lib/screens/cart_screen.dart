import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pos_provider.dart';
import '../theme/app_theme.dart';
import 'receipt_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String selectedPaymentMethod = 'Tunai';
  final TextEditingController cashController = TextEditingController();
  int paidAmount = 0;
  bool isProcessing = false;

  int calculateChange(int total) {
    if (selectedPaymentMethod == 'QRIS') {
      return 0;
    }
    return (paidAmount >= total) ? (paidAmount - total) : 0;
  }

  @override
  void initState() {
    super.initState();
    cashController.addListener(() {
      final val = int.tryParse(cashController.text.replaceAll('.', '')) ?? 0;
      setState(() {
        paidAmount = val;
      });
    });
  }

  @override
  void dispose() {
    cashController.dispose();
    super.dispose();
  }

  Future<void> handleCheckout(PosProvider pos) async {
    if (pos.cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang masih kosong')),
      );
      return;
    }

    final total = pos.totalCartPrice;
    final finalPaid = selectedPaymentMethod == 'QRIS' ? total : paidAmount;

    if (selectedPaymentMethod == 'Tunai' && finalPaid < total) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Uang pembayaran kurang dari total tagihan'),
        ),
      );
      return;
    }

    setState(() {
      isProcessing = true;
    });

    final transaction = await pos.processCheckout(
      paidAmount: finalPaid,
      paymentMethod: selectedPaymentMethod,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptScreen(transaction: transaction),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosProvider>();

    if (pos.cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Keranjang Pesanan')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Keranjang Belanja Kosong',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Pilih menu dari katalog untuk membuat pesanan.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Buka Katalog Menu'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Pesanan'),
        actions: [
          IconButton(
            tooltip: 'Kosongkan Keranjang',
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () => pos.clearCart(),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 768;
            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: buildItemList(pos),
                  ),
                  const VerticalDivider(width: 1, color: AppColors.border),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: buildPaymentSection(pos),
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                Expanded(child: buildItemList(pos)),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: AppColors.border),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0A0F172A),
                        blurRadius: 10,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: buildPaymentSection(pos),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildItemList(PosProvider pos) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: pos.cart.length,
      separatorBuilder: (context, index) =>
          const Divider(color: AppColors.borderSubtle, height: 16),
      itemBuilder: (context, index) {
        final item = pos.cart[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rp ${item.product.price} / porsi',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (item.notes.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Catatan: ${item.notes}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFD97706),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton.outlined(
                    style: IconButton.styleFrom(
                      minimumSize: const Size(36, 36),
                      padding: EdgeInsets.zero,
                      side: const BorderSide(color: AppColors.border),
                    ),
                    icon: const Icon(Icons.remove, size: 16),
                    onPressed: () {
                      pos.updateQuantity(index, item.quantity - 1);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${item.quantity}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(36, 36),
                      padding: EdgeInsets.zero,
                    ),
                    icon: const Icon(Icons.add, size: 16, color: Colors.white),
                    onPressed: () {
                      pos.updateQuantity(index, item.quantity + 1);
                    },
                  ),
                ],
              ),
              const SizedBox(width: 14),
              SizedBox(
                width: 75,
                child: Text(
                  'Rp ${item.subtotal}',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildPaymentSection(PosProvider pos) {
    final total = pos.totalCartPrice;
    final change = calculateChange(total);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Tagihan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'Rp $total',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SegmentedButton<String>(
          style: SegmentedButton.styleFrom(
            selectedBackgroundColor: AppColors.primary,
            selectedForegroundColor: Colors.white,
            backgroundColor: Colors.white,
          ),
          segments: const [
            ButtonSegment(value: 'Tunai', label: Text('Tunai')),
            ButtonSegment(value: 'QRIS', label: Text('QRIS')),
          ],
          selected: {selectedPaymentMethod},
          onSelectionChanged: (val) {
            setState(() {
              selectedPaymentMethod = val.first;
            });
          },
        ),
        const SizedBox(height: 12),
        if (selectedPaymentMethod == 'Tunai') ...[
          TextField(
            controller: cashController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Uang Diterima Kasir',
              prefixText: 'Rp ',
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ActionChip(
                  backgroundColor: AppColors.primaryContainer,
                  side: const BorderSide(color: Color(0xFFDBEAFE)),
                  label: const Text(
                    'Uang Pas',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  onPressed: () {
                    cashController.text = total.toString();
                  },
                ),
                const SizedBox(width: 6),
                ActionChip(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.border),
                  label: const Text('20.000', style: TextStyle(fontSize: 12)),
                  onPressed: () {
                    cashController.text = '20000';
                  },
                ),
                const SizedBox(width: 6),
                ActionChip(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.border),
                  label: const Text('50.000', style: TextStyle(fontSize: 12)),
                  onPressed: () {
                    cashController.text = '50000';
                  },
                ),
                const SizedBox(width: 6),
                ActionChip(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.border),
                  label: const Text('100.000', style: TextStyle(fontSize: 12)),
                  onPressed: () {
                    cashController.text = '100000';
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kembalian:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'Rp $change',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              border: Border.all(color: const Color(0xFFDBEAFE)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.qr_code, color: AppColors.primary),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'QRIS Siap Di-scan Pelanggan (Nominal Otomatis)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: isProcessing ? null : () => handleCheckout(pos),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
          icon: isProcessing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.check_circle_outline, size: 18),
          label: Text(
            isProcessing ? 'Memproses Transaksi...' : 'Selesaikan Transaksi',
          ),
        ),
      ],
    );
  }
}
