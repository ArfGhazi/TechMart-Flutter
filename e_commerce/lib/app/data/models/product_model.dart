class ProductModel {
  final String id;
  final String title;
  final String category;
  final int price;
  final double rating;
  final String imageUrl;
  final String description;

  const ProductModel({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.description = '',
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'price': price,
      'rating': rating,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}
