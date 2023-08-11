


import 'package:cloud_firestore/cloud_firestore.dart';

import '../_manager/myVoids.dart';

class Product {
  String? id;
  String? name;
  String? imageUrl;
  String? addedTime;
  double? currPrice;
  double? currBuyPrice;
  int? currQty;
  String? qtyPerUnit;
  Map<String, dynamic> prodChanges;
  Map<String, dynamic> buyHis;
  Map<String, dynamic> sellHis;

  Product({
    this.id = 'no-id',
     this.name= '',
     this.imageUrl= '',
     this.addedTime= '',
     this.qtyPerUnit= '',
     this.currPrice= 0.0,
     this.currBuyPrice= 0.0,
     this.currQty= 0,
     this.prodChanges= const{},
     this.buyHis= const{},
     this.sellHis= const{},
  });

  factory Product.fromJson(Map<String, dynamic> json) {

    Map<String, dynamic> prodChanges = Map<String, dynamic>.from(json['prodChanges']);
    Map<String, dynamic> buyHis = Map<String, dynamic>.from(json['buyHis']);
    Map<String, dynamic> sellHis = Map<String, dynamic>.from(json['sellHis']);

    return Product(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      qtyPerUnit: json['qtyPerUnit'],
      addedTime: json['addedTime'],
      //currPrice: getLastIndexMap(prodChanges)['price'],
      currPrice: json['currPrice'].toDouble(),
      currBuyPrice: json['currBuyPrice'].toDouble(),
      //currQty:  getLastIndexMap(prodChanges)['qty'],
      currQty:  json['currQty'].toInt(),
      prodChanges: prodChanges,
      buyHis: buyHis,
      sellHis: sellHis,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'qtyPerUnit': qtyPerUnit,
      'addedTime': addedTime,
      'currPrice': currPrice,
      'currBuyPrice': currBuyPrice,
      'currQty': currQty,
      'prodChanges': prodChanges,
      'buyHis': buyHis,
      'sellHis': sellHis,
    };
  }
}
