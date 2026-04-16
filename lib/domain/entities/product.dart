class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String category;
  final String description;
  bool favorite;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
    this.favorite = false,
  });

  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? image,
    String? category,
    String? description,
    bool? favorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      category: category ?? this.category,
      description: description ?? this.description,
      favorite: favorite ?? this.favorite,
    );
  }
}
