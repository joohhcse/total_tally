class Product {
  final int? id;
  final String name;
  final int quantity;
  final double price;

  const Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  Product copyWith({
    int? id,
    String? name,
    int? quantity,
    double? price,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity?? this.quantity,
      price: price ?? this.price,
    );
  }

  // 인코딩을 위한 toJson 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity' : quantity,
      'price' : price,
    };
  }

  // 디코딩을 위한 팩토리 생성자
  factory Product.fromMap(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    quantity: json['quantity'],
    price: json['price'],
  );
}
