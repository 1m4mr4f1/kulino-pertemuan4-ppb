import 'cart_item.dart';

class TransactionRecord {
  final String id;
  final DateTime timestamp;
  final List<CartItem> items;
  final int totalAmount;
  final int paidAmount;
  final int changeAmount;
  final String paymentMethod;

  TransactionRecord({
    required this.id,
    required this.timestamp,
    required this.items,
    required this.totalAmount,
    required this.paidAmount,
    required this.changeAmount,
    required this.paymentMethod,
  });
}
