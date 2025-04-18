import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ridecare/data/models/category_model.dart';

abstract class CategoryRemoteDatasource {
  Future<List<CategoryModel>> getAllCategories();
}

class CategoryRemoteDatasourceImpl implements CategoryRemoteDatasource {
  final FirebaseFirestore firestore;

  CategoryRemoteDatasourceImpl({required this.firestore});

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final snapshot = await firestore.collection('categories').get();

    return snapshot.docs.map((doc) {
      return CategoryModel(id: doc.id, name: doc['name'] as String);
    }).toList();
  }
}
