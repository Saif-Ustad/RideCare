class ServiceEntity {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final String subCategory;
  final String categoryId;
  final String price;
  final int estimatedTime;
  final bool isAvailable;

  ServiceEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.subCategory,
    required this.categoryId,
    required this.price,
    required this.estimatedTime,
    required this.isAvailable,
  });
}