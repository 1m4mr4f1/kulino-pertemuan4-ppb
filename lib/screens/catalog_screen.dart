import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../providers/pos_provider.dart';
import '../theme/app_theme.dart';
import 'item_detail_screen.dart';
import 'cart_screen.dart';
import 'history_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String selectedCategory = 'Semua';
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  List<String> get categories => ['Semua', 'Makanan', 'Minuman', 'Camilan'];

  List<Product> getFilteredProducts(List<Product> products) {
    return products.where((p) {
      final matchCategory =
          selectedCategory == 'Semua' || p.category == selectedCategory;
      final matchSearch =
          p.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }

  void openDetail(Product product) async {
    final result = await Navigator.push<CartItem>(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(product: product),
      ),
    );

    if (result != null && mounted) {
      context.read<PosProvider>().addToCart(
            result.product,
            quantity: result.quantity,
            notes: result.notes,
          );
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Text('${product.name} ditambahkan'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CartScreen(),
      ),
    );
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
    final pos = context.watch<PosProvider>();
    final filtered = getFilteredProducts(pos.products);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.storefront,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'WarungPOS',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Segarkan Data Server',
            icon: const Icon(Icons.sync),
            onPressed: () => pos.loadProducts(forceRefresh: true),
          ),
          IconButton(
            tooltip: 'Riwayat Transaksi',
            icon: const Icon(Icons.receipt_long_outlined),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: pos.isOffline
                    ? const Color(0xFFFFFBEB)
                    : AppColors.primaryContainer,
                border: Border(
                  bottom: BorderSide(
                    color: pos.isOffline
                        ? const Color(0xFFFDE68A)
                        : const Color(0xFFDBEAFE),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    pos.isOffline ? Icons.cloud_off : Icons.cloud_done,
                    size: 16,
                    color: pos.isOffline
                        ? const Color(0xFFB45309)
                        : AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      pos.isOffline
                          ? 'Mode Offline: Memakai data tersimpan di perangkat'
                          : 'Mode Online: Terhubung dengan server REST API',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: pos.isOffline
                            ? const Color(0xFF92400E)
                            : AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Cari menu makanan atau minuman...',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            searchController.clear();
                            setState(() {
                              searchQuery = '';
                            });
                          },
                        )
                      : null,
                  isDense: true,
                ),
                onChanged: (val) {
                  setState(() {
                    searchQuery = val;
                  });
                },
              ),
            ),
            SizedBox(
              height: 42,
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
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
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
              child: pos.isLoadingProducts
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.primary,
                      ),
                    )
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => pos.loadProducts(forceRefresh: true),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = 2;
                          double childAspectRatio = 0.74;

                          if (constraints.maxWidth >= 1024) {
                            crossAxisCount = 4;
                            childAspectRatio = 0.82;
                          } else if (constraints.maxWidth >= 640) {
                            crossAxisCount = 3;
                            childAspectRatio = 0.78;
                          } else if (constraints.maxWidth <= 340) {
                            crossAxisCount = 2;
                            childAspectRatio = 0.68;
                          }

                          if (filtered.isEmpty) {
                            return ListView(
                              children: [
                                SizedBox(height: constraints.maxHeight * 0.3),
                                Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 48,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Tidak ada menu yang cocok.',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: childAspectRatio,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final product = filtered[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x060F172A),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () => openDetail(product),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              getProductIcon(product.iconName),
                                              size: 40,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 0, 12, 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              product.category,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    'Rp ${product.price}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: AppColors.primary,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                                IconButton.filled(
                                                  iconSize: 18,
                                                  padding: EdgeInsets.zero,
                                                  style:
                                                      IconButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primary,
                                                    minimumSize:
                                                        const Size(44, 44),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  icon: const Icon(Icons.add,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    pos.addToCart(product);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        content: Text(
                                                          '${product.name} ditambahkan',
                                                        ),
                                                        duration:
                                                            const Duration(
                                                          seconds: 1,
                                                        ),
                                                      ),
                                                    );
                                                  },
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
            ),
            if (pos.totalCartCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: AppColors.border, width: 1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0A0F172A),
                      blurRadius: 10,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFDBEAFE)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${pos.totalCartCount}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Total Pesanan',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          'Rp ${pos.totalCartPrice}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: openCart,
                      icon: const Icon(Icons.arrow_forward, size: 18),
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
