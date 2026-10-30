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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'changeAmount': changeAmount,
      'paymentMethod': paymentMethod,
    };
  }

  factory TransactionRecord.fromJson(Map<String, dynamic> json) {
    return TransactionRecord(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalAmount: json['totalAmount'] as int,
      paidAmount: json['paidAmount'] as int,
      changeAmount: json['changeAmount'] as int,
      paymentMethod: json['paymentMethod'] as String,
    );
  }
}
