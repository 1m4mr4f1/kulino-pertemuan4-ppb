import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  String notes;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.notes = '',
  });

  int get subtotal => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'notes': notes,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int? ?? 1,
      notes: json['notes'] as String? ?? '',
    );
  }
}
