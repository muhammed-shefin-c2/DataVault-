// lib/domain/entities/bundle_entity.dart
class BundleEntity {
  final String id;
  final String media;
  final String price;
  final String userId;
  final DateTime createdAt;

  BundleEntity({
    required this.id,
    required this.media,
    required this.price,
    required this.userId,
    required this.createdAt,
  });

  factory BundleEntity.fromJson(Map<String, dynamic> json) {
    return BundleEntity(
      id: json['id'] as String,
      media: json['media'] as String,
      price: json['price'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'media': media,
        'price': price,
        'user_id': userId,
        'created_at': createdAt.toIso8601String(),
      };
}