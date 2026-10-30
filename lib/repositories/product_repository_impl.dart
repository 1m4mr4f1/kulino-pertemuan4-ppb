import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../data/mock_data.dart';
import 'product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  static const String cacheKey = 'cached_products_json';
  static const String apiEndpoint =
      'https://raw.githubusercontent.com/1m4mr4f1/kulino-pertemuan4-ppb/main/api/products.json';

  final http.Client client;

  ProductRepositoryImpl({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<ProductFetchResult> fetchProducts({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();

    if (!forceRefresh) {
      final cachedJson = prefs.getString(cacheKey);
      if (cachedJson != null && cachedJson.isNotEmpty) {
        try {
          final List<dynamic> decoded = jsonDecode(cachedJson) as List<dynamic>;
          final list = decoded
              .map((item) => Product.fromJson(item as Map<String, dynamic>))
              .toList();
          if (list.isNotEmpty) {
            return ProductFetchResult(products: list, isFromCache: true);
          }
        } catch (_) {}
      }
    }

    try {
      final uri = Uri.parse(apiEndpoint);
      final response = await client.get(uri).timeout(
        const Duration(seconds: 4),
      );

      if (response.statusCode == 200) {
        final List<dynamic> decoded =
            jsonDecode(response.body) as List<dynamic>;
        final list = decoded
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();

        await prefs.setString(cacheKey, response.body);
        return ProductFetchResult(products: list, isFromCache: false);
      } else {
        return await _fallbackToCache(
          prefs,
          'Gagal mengambil data dari server (HTTP ${response.statusCode})',
        );
      }
    } on SocketException {
      return await _fallbackToCache(
        prefs,
        'Tidak ada koneksi internet. Menggunakan data tersimpan.',
      );
    } on TimeoutException {
      return await _fallbackToCache(
        prefs,
        'Waktu koneksi habis. Menggunakan data tersimpan.',
      );
    } catch (e) {
      return await _fallbackToCache(
        prefs,
        'Terjadi kendala jaringan: $e',
      );
    }
  }

  Future<ProductFetchResult> _fallbackToCache(
    SharedPreferences prefs,
    String message,
  ) async {
    final cachedJson = prefs.getString(cacheKey);
    if (cachedJson != null && cachedJson.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(cachedJson) as List<dynamic>;
        final list = decoded
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
        return ProductFetchResult(
          products: list,
          isFromCache: true,
          errorMessage: message,
        );
      } catch (_) {}
    }

    final defaultList = MockData.products;
    final encoded = jsonEncode(defaultList.map((e) => e.toJson()).toList());
    await prefs.setString(cacheKey, encoded);

    return ProductFetchResult(
      products: defaultList,
      isFromCache: true,
      errorMessage: message,
    );
  }
}
