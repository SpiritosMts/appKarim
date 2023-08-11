


import 'package:cloud_firestore/cloud_firestore.dart';

import '../_manager/myVoids.dart';

class Clienth {

  String? id;
  String? name ;

  String? email;
  String? address;
  String? phone;



  Clienth({
    this.id = 'no-id',
    this.name = '',

    this.email = '',
    this.address = '',
    this.phone = '',


  });



  factory Clienth.fromJson(Map<String, dynamic> jsonDoc) {
    return Clienth(
      id: jsonDoc['id'],
      name: jsonDoc['name'],
      email: jsonDoc['email'],
      address: jsonDoc['address'],
      phone: jsonDoc['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,//inp
      'email': email,//inp
      'address': address,//inp
      'phone': phone,//inp
    };
  }
}



