import '../../domain/entities/special_offer_entity.dart';

class SpecialOfferModel extends SpecialOffer {
  SpecialOfferModel({
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.discount,
  });

  factory SpecialOfferModel.fromJson(Map<String, dynamic> json) {
    return SpecialOfferModel(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      discount: json['discount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'discount' : discount,
    };
  }
}
