class Product {
  final String id;
  final String name;
  final String category;
  final int price;
  final String description;
  final String iconName;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.iconName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'iconName': iconName,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: json['price'] as int,
      description: json['description'] as String,
      iconName: json['iconName'] as String,
    );
  }
}
