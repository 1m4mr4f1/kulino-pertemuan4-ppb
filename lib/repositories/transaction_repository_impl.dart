import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_record.dart';
import 'transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  static const String storageKey = 'saved_pos_transactions';

  @override
  Future<List<TransactionRecord>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(storageKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> list = jsonDecode(jsonString) as List<dynamic>;
      return list
          .map((item) => TransactionRecord.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveTransaction(TransactionRecord transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getTransactions();
    existing.add(transaction);

    final encoded = jsonEncode(existing.map((e) => e.toJson()).toList());
    await prefs.setString(storageKey, encoded);
  }

  @override
  Future<void> clearTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey);
  }
}
