import '../../domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  ServiceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.iconUrl,
    required super.subCategory,
    required super.categoryId,
    required super.categoryName,
    required super.price,
    required super.estimatedTime,
    required super.isAvailable,
  });

  factory ServiceModel.fromJson(
    Map<String, dynamic> serviceJson,
    Map<String, dynamic> mainServiceJson,
    Map<String, dynamic> categoryJson,
  ) {
    return ServiceModel(
      id: mainServiceJson['id'],
      name: mainServiceJson['name'],
      description: mainServiceJson['description'],
      iconUrl: mainServiceJson['iconUrl'],
      subCategory: mainServiceJson['subCategory'],
      categoryId: mainServiceJson['categoryId'],
      categoryName: categoryJson['name'],
      price: (serviceJson['price'] as num).toDouble(),
      estimatedTime: serviceJson['estimatedTime'],
      isAvailable: serviceJson['isAvailable'],
    );
  }
}
