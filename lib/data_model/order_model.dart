import 'package:zawtika/data_model/prodcut_model.dart';

class Order {
  int? id;
  int? confirmPrice;
  int? orgPrice;
  int? status;
  String? remark;
  int? itemId;
  int? userId;
  // List<Product>? products;
  Product? products;
  String? createAt;

  Order({
    this.id,
    this.confirmPrice,
    this.orgPrice,
    this.status,
    this.remark,
    this.itemId,
    this.userId,
    this.products,
    this.createAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] ?? 0,
        confirmPrice: json['confirm_price'] ?? 0,
        orgPrice: json['org_price'] ?? 0,
        status: json['confirm_status'] ?? 0,
        remark: json['remark'] ?? '',
        itemId: json['items_id'] ?? 0,
        userId: json['users_id'] ?? 0,
        createAt: json['created_at'] ?? '',
        products: Product.fromJson(json['items']),
        // products: (json['items'] as List<dynamic>?)
        //         ?.map((productJson) => Product.fromJson(productJson))
        //         .toList() ??
        //     [],
        // products: (json['items'] is List<dynamic>
        //     ? (json['items'] as List<dynamic>)
        //         .map((productJson) => Product.fromJson(productJson))
        //         .toList()
        //     : []),
      );

  Map<String, dynamic> toJson() => {
        'id': id ?? 0,
        'confirm_price': confirmPrice ?? 0,
        'org_price': orgPrice ?? 0,
        'confirm_status': status ?? 0,
        'remark': remark ?? '',
        'items_id': itemId ?? 0,
        'users_id': userId ?? 0,
      };
}
