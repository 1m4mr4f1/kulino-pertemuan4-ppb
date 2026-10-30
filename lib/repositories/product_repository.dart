import '../models/product.dart';

class ProductFetchResult {
  final List<Product> products;
  final bool isFromCache;
  final String? errorMessage;

  ProductFetchResult({
    required this.products,
    required this.isFromCache,
    this.errorMessage,
  });
}

abstract class ProductRepository {
  Future<ProductFetchResult> fetchProducts({bool forceRefresh = false});
}
