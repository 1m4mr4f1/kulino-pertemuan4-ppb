import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../data/mock_data.dart';
import 'item_detail_screen.dart';
import 'cart_screen.dart';
import 'history_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final List<CartItem> cart = [];
  String selectedCategory = 'Semua';
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  List<String> get categories => ['Semua', 'Makanan', 'Minuman', 'Camilan'];

  List<Product> get filteredProducts {
    return MockData.products.where((p) {
      final matchCategory =
          selectedCategory == 'Semua' || p.category == selectedCategory;
      final matchSearch =
          p.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }

  int get totalCartCount => cart.fold(0, (sum, item) => sum + item.quantity);
  int get totalCartPrice => cart.fold(0, (sum, item) => sum + item.subtotal);

  void addToCart(Product product, {int quantity = 1, String notes = ''}) {
    setState(() {
      final index = cart.indexWhere(
        (item) => item.product.id == product.id && item.notes == notes,
      );
      if (index >= 0) {
        cart[index].quantity += quantity;
      } else {
        cart.add(CartItem(
          product: product,
          quantity: quantity,
          notes: notes,
        ));
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} dimasukkan ke keranjang'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void openDetail(Product product) async {
    final result = await Navigator.push<CartItem>(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(product: product),
      ),
    );

    if (result != null) {
      addToCart(result.product, quantity: result.quantity, notes: result.notes);
    }
  }

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          cartItems: cart,
          onClearCart: () {
            setState(() {
              cart.clear();
            });
          },
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  IconData getProductIcon(String iconName) {
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
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.storefront, size: 26),
            SizedBox(width: 8),
            Text(
              'WarungPOS',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Riwayat Transaksi',
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Cari menu warung...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            setState(() {
                              searchQuery = '';
                            });
                          },
                        )
                      : null,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    searchQuery = val;
                  });
                },
              ),
            ),
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedCategory = cat;
                        });
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 2;
                  double childAspectRatio = 0.82;

                  if (constraints.maxWidth >= 960) {
                    crossAxisCount = 4;
                    childAspectRatio = 0.9;
                  } else if (constraints.maxWidth >= 600) {
                    crossAxisCount = 3;
                    childAspectRatio = 0.85;
                  } else {
                    if (constraints.maxHeight < 450) {
                      crossAxisCount = 3;
                      childAspectRatio = 1.0;
                    }
                  }

                  if (filteredProducts.isEmpty) {
                    return const Center(
                      child: Text(
                        'Tidak ada menu yang sesuai kriteria.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: InkWell(
                          onTap: () => openDetail(product),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Container(
                                  color: theme.colorScheme.primaryContainer
                                      .withAlpha(50),
                                  child: Center(
                                    child: Icon(
                                      getProductIcon(product.iconName),
                                      size: 44,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      product.category,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rp ${product.price}',
                                          style: TextStyle(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        IconButton.filledTonal(
                                          iconSize: 18,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(
                                            minWidth: 32,
                                            minHeight: 32,
                                          ),
                                          icon: const Icon(Icons.add),
                                          onPressed: () => addToCart(product),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (cart.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 6,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Badge(
                      label: Text('$totalCartCount'),
                      child: const Icon(Icons.shopping_basket),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Total Pesanan',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          'Rp $totalCartPrice',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: openCart,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Buka Keranjang'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
