import 'package:zawtika/data_model/image_model.dart';

class Product {
  int? id;
  String? productName;
  String? itemCode;
  String? description;
  String? price;
  int? kyat;
  int? pae;
  int? yway;
  List<MediaImage>? image;

  Product({
    this.id,
    this.productName,
    this.itemCode,
    this.description,
    this.price,
    this.kyat,
    this.pae,
    this.yway,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json['id'] ?? 0,
      productName: json['name'] ?? '',
      itemCode: json['itemcode'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      kyat: json['k'] ?? 0,
      pae: json['p'] ?? 0,
      yway: json['y'] ?? 0,
      image: (json['image'] as List<dynamic>?)
          ?.map((imageJson) => MediaImage.fromJson(imageJson))
          .toList());
  Map<String, dynamic> toJson() => {
        'id': id ?? 0,
        'name': productName ?? '',
        'itemcode': itemCode ?? '',
        'description': description ?? '',
        'price': price ?? '',
        'k': kyat ?? '',
        'p': pae ?? '',
        'y': yway ?? '',
      };
}
