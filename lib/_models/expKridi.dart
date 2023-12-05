


import 'package:cloud_firestore/cloud_firestore.dart';

import '../_manager/myVoids.dart';

class ExpKridi {
  String? time;
  String? desc;
  String? type;
  double? price;
  bool? paid;

  ExpKridi({
    this.time='',
    this.desc='',
    this.type='',
    this.paid=false,
    this.price=0.0,
  });

  factory ExpKridi.fromJson(Map<String, dynamic> json) {
    return ExpKridi(
      time: json['time'],
      desc: json['desc'],
      type: json['type'],
      paid: json['paid'],
      price: json['price']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'desc': desc,
      'paid': paid,
      'type': type,
      'price': price,
    };
  }
}


