import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../theme/app_theme.dart';

class ItemDetailScreen extends StatefulWidget {
  final Product product;

  const ItemDetailScreen({super.key, required this.product});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int quantity = 1;
  final TextEditingController notesController = TextEditingController();

  IconData getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'lunch_dining':
        return Icons.lunch_dining;
      case 'dinner_dining':
        return Icons.dinner_dining;
      case 'ramen_dining':
        return Icons.ramen_dining;
      case 'soup_kitchen':
        return Icons.soup_kitchen;
      case 'local_drink':
        return Icons.local_drink;
      case 'local_bar':
        return Icons.local_bar;
      case 'coffee':
        return Icons.coffee;
      case 'bakery_dining':
        return Icons.bakery_dining;
      case 'fastfood':
      default:
        return Icons.fastfood;
    }
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.product.price * quantity;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: constraints.maxHeight > 500 ? 170 : 120,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFDBEAFE)),
                        ),
                        child: Center(
                          child: Icon(
                            getCategoryIcon(widget.product.iconName),
                            size: constraints.maxHeight > 500 ? 76 : 48,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFDBEAFE),
                              ),
                            ),
                            child: Text(
                              widget.product.category,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                          Text(
                            'Rp ${widget.product.price}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.product.description,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(color: AppColors.border),
                      ),
                      const Text(
                        'Jumlah Porsi',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          IconButton.outlined(
                            style: IconButton.styleFrom(
                              minimumSize: const Size(44, 44),
                              side: const BorderSide(color: AppColors.border),
                            ),
                            onPressed: quantity > 1
                                ? () {
                                    setState(() {
                                      quantity--;
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.remove, size: 20),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 10,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$quantity',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          IconButton.filled(
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              minimumSize: const Size(44, 44),
                            ),
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            icon: const Icon(Icons.add,
                                size: 20, color: Colors.white),
                          ),
                          const Spacer(),
                          Text(
                            'Rp $total',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Catatan Pesanan',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: notesController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText:
                              'Contoh: Jangan terlalu pedas, kuah dipisah...',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () {
                          final item = CartItem(
                            product: widget.product,
                            quantity: quantity,
                            notes: notesController.text.trim(),
                          );
                          Navigator.pop(context, item);
                        },
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                        label: Text('Tambahkan ke Keranjang (Rp $total)'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
