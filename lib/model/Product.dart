class Product {
  final int? id;
  final String name;
  final double price;

  const Product({
    this.id,
    required this.name,
    required this.price,
  });

  Product copyWith({
    int? id,
    String? name,
    double? price,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price' : price,
    };
  }
}
