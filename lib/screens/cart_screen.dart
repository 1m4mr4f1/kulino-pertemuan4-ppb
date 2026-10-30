import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/transaction_record.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/transaction_repository_impl.dart';
import 'receipt_screen.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final VoidCallback onClearCart;
  final TransactionRepository? transactionRepository;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onClearCart,
    this.transactionRepository,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final TransactionRepository transactionRepo;
  String selectedPaymentMethod = 'Tunai';
  final TextEditingController cashController = TextEditingController();
  int paidAmount = 0;

  int get totalAmount {
    return widget.cartItems.fold(0, (sum, item) => sum + item.subtotal);
  }

  int get changeAmount {
    if (selectedPaymentMethod == 'QRIS') {
      return 0;
    }
    return (paidAmount >= totalAmount) ? (paidAmount - totalAmount) : 0;
  }

  @override
  void initState() {
    super.initState();
    transactionRepo = widget.transactionRepository ?? TransactionRepositoryImpl();
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

  Future<void> processPayment() async {
    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang masih kosong')),
      );
      return;
    }

    final finalPaid = selectedPaymentMethod == 'QRIS' ? totalAmount : paidAmount;

    if (selectedPaymentMethod == 'Tunai' && finalPaid < totalAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Uang pembayaran kurang dari total tagihan'),
        ),
      );
      return;
    }

    final transaction = TransactionRecord(
      id: 'TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      timestamp: DateTime.now(),
      items: List.from(widget.cartItems),
      totalAmount: totalAmount,
      paidAmount: finalPaid,
      changeAmount: selectedPaymentMethod == 'QRIS' ? 0 : (finalPaid - totalAmount),
      paymentMethod: selectedPaymentMethod,
    );

    await transactionRepo.saveTransaction(transaction);
    widget.onClearCart();

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
    final theme = Theme.of(context);

    if (widget.cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Keranjang Pesanan')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 72,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'Keranjang Belanja Kosong',
                style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Pilih Menu Sekarang'),
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
            onPressed: () {
              setState(() {
                widget.onClearCart();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;
            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: buildItemList(),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: buildPaymentSection(theme),
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                Expanded(child: buildItemList()),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 8,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: buildPaymentSection(theme),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildItemList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: widget.cartItems.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final item = widget.cartItems[index];
        return Row(
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
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Rp ${item.product.price} x ${item.quantity}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  if (item.notes.isNotEmpty)
                    Text(
                      'Catatan: ${item.notes}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade800,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  color: Colors.red.shade400,
                  onPressed: () {
                    setState(() {
                      if (item.quantity > 1) {
                        item.quantity--;
                      } else {
                        widget.cartItems.removeAt(index);
                      }
                    });
                  },
                ),
                Text(
                  '${item.quantity}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: Colors.green.shade600,
                  onPressed: () {
                    setState(() {
                      item.quantity++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              width: 80,
              child: Text(
                'Rp ${item.subtotal}',
                textAlign: TextAlign.end,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildPaymentSection(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Tagihan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              'Rp $totalAmount',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SegmentedButton<String>(
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
              labelText: 'Uang Diterima',
              prefixText: 'Rp ',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ActionChip(
                  label: const Text('Uang Pas'),
                  onPressed: () {
                    cashController.text = totalAmount.toString();
                  },
                ),
                const SizedBox(width: 6),
                ActionChip(
                  label: const Text('20.000'),
                  onPressed: () {
                    cashController.text = '20000';
                  },
                ),
                const SizedBox(width: 6),
                ActionChip(
                  label: const Text('50.000'),
                  onPressed: () {
                    cashController.text = '50000';
                  },
                ),
                const SizedBox(width: 6),
                ActionChip(
                  label: const Text('100.000'),
                  onPressed: () {
                    cashController.text = '100000';
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kembalian:'),
              Text(
                'Rp $changeAmount',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              border: Border.all(color: Colors.green.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.qr_code, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'QRIS Siap Di-scan Pelanggan (Nominal Otomatis)',
                    style: TextStyle(fontSize: 13, color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: processPayment,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Proses Pembayaran'),
        ),
      ],
    );
  }
}
