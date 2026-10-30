import '../models/transaction_record.dart';

abstract class TransactionRepository {
  Future<List<TransactionRecord>> getTransactions();
  Future<void> saveTransaction(TransactionRecord transaction);
  Future<void> clearTransactions();
}
