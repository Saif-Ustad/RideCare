import 'package:ridecare/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({required super.id, required super.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json, String docId) {
    return CategoryModel(
      id: docId,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
