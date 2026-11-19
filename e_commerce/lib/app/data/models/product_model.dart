import 'package:intl/intl.dart';

/// Model data produk sepatu (Type-Safe Entity).
class ProductModel {
  final String id;
  final String title;
  final String category;
  final int price;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String description;
  final bool isFavorite;

  const ProductModel({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.description = '',
    this.reviewCount = 0,
    this.isFavorite = false,
  });

  /// Format harga ke mata uang Rupiah.
  String get formattedPrice {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return formatter.format(price);
  }

  /// Membuat salinan objek dengan perubahan parsial.
  ProductModel copyWith({
    String? id,
    String? title,
    String? category,
    int? price,
    double? rating,
    int? reviewCount,
    String? imageUrl,
    String? description,
    bool? isFavorite,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Deserialisasi defensif dari JSON REST API.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final id = rawId != null
        ? rawId.toString()
        : 'prod-${DateTime.now().millisecondsSinceEpoch}';

    final title = (json['title'] ?? json['name'] ?? 'Sepatu Sneakers')
        .toString();

    final rawCategory = (json['category'] ?? 'Lifestyle').toString();

    final category = rawCategory.isNotEmpty
        ? '${rawCategory[0].toUpperCase()}${rawCategory.substring(1)}'
        : 'General';

    // Konversi harga USD ke Rupiah jika nilainya di bawah 1000.
    final rawPrice = (json['price'] as num?)?.toInt() ?? 150000;
    final price = rawPrice < 1000 ? rawPrice * 15000 : rawPrice;

    final rating = (json['rating'] as num?)?.toDouble() ?? 4.8;

    int reviewCount;

    if (json['reviews'] is List) {
      reviewCount = (json['reviews'] as List).length;
    } else if (json['reviewCount'] is num) {
      reviewCount = (json['reviewCount'] as num).toInt();
    } else {
      reviewCount = 50 + (price % 150);
    }

    final imageUrl =
        (json['thumbnail'] ??
                json['imageUrl'] ??
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80')
            .toString();

    final description =
        (json['description'] ??
                'Sepatu sneakers berkualitas tinggi dengan bantalan empuk dan daya tahan luar biasa untuk gaya kasual dan olahraga.')
            .toString();

    return ProductModel(
      id: id,
      title: title,
      category: category,
      price: price,
      rating: rating,
      reviewCount: reviewCount,
      imageUrl: imageUrl,
      description: description,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  /// Konversi dari Map internal.
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toString() ?? '',
      title: (map['title'] ?? map['name'] ?? '').toString(),
      category: map['category']?.toString() ?? 'General',
      price: (map['price'] as num?)?.toInt() ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      imageUrl: map['imageUrl']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      isFavorite: map['isFavorite'] as bool? ?? false,
    );
  }

  /// Konversi objek ke Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'description': description,
      'isFavorite': isFavorite,
    };
  }

  /// Konversi objek ke JSON.
  Map<String, dynamic> toJson() => toMap();
}
