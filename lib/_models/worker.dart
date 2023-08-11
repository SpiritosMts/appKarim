


import 'package:cloud_firestore/cloud_firestore.dart';

import '../_manager/myVoids.dart';

class Workerh {

  String? id;
  String? name ;
  String? sex;
  String? age;
  //String? birthDay;

  String? joinDate;
  String? email;
  String? address;
  String? phone;
  String? role;
  String? speciality;

  double? totalKridi;
  double? totalExpenses;
  double? salary;

  Map<String,dynamic> expensesHis;
  Map<String,dynamic> kridiHis;
  bool verified;





  Workerh({
    this.id = 'no-id',
    this.name = '',
    this.sex = '',
    this.age = '',


    this.joinDate = '',
    this.email = '',
    this.address = '',
    this.phone = '',
    this.role = '',
    this.speciality = '',//doc

    this.totalKridi = 0.0,
    this.totalExpenses = 0.0,
    this.salary = 0.0,


    this.expensesHis = const{},
    this.kridiHis = const{},

    this.verified = false,


  });



  factory Workerh.fromJson(Map<String, dynamic> jsonDoc) {
    return Workerh(
      id: jsonDoc['id'],
      name: jsonDoc['name'],
      sex: jsonDoc['sex'],
      age: jsonDoc['age'],
      joinDate: jsonDoc['joinDate'],
      email: jsonDoc['email'],
      address: jsonDoc['address'],
      phone: jsonDoc['phone'],
      role: jsonDoc['role'],
      speciality: jsonDoc['speciality'],
      totalKridi: jsonDoc['totalKridi']?.toDouble(),
      salary: jsonDoc['salary']?.toDouble(),
      totalExpenses: jsonDoc['totalExpenses']?.toDouble(),
      expensesHis: Map<String, dynamic>.from(jsonDoc['expensesHis']),
      kridiHis: Map<String, dynamic>.from(jsonDoc['kridiHis']),
      verified: jsonDoc['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,//inp
      'sex': sex,//inp
      'age': age,//inp
      'joinDate': joinDate,
      'email': email,//inp
      'address': address,//inp
      'phone': phone,//inp
      'role': role,//inp
      'speciality': speciality,//inp

      'totalKridi': totalKridi,
      'totalExpenses': totalExpenses,
      'salary': salary,
      'expensesHis': expensesHis,
      'kridiHis': kridiHis,
      'verified': verified,
    };
  }
}

Future<Workerh> getWorkerByID(String id) async {

 var coll = FirebaseFirestore.instance.collection('workers'); //model collection
  if(id == '' || id.length != 20 ) return Workerh();
  final event = await coll.where('id', isEqualTo: id).get();
 QueryDocumentSnapshot<Map<String, dynamic>> doc = event.docs.single;
  return Workerh.fromJson(doc.data());
}





void printWorker(Workerh user) {
  print(
      '#### WORKER() ####\n'
          'id: ${user.id}\n'
          'role: ${user.role}\n'
          'name: ${user.name}\n'
          'sex: ${user.sex}\n'
          'age: ${user.age}\n'
          'joinDate: ${user.joinDate}\n'
          'email: ${user.email}\n'
          'address: ${user.address}\n'
          'phone: ${user.phone}\n'
          'speciality: ${user.speciality}\n'
          'totalKridi: ${user.totalKridi}\n'
          'totalExpenses: ${user.totalExpenses}\n'
          'salary: ${user.salary}\n'
          'expensesHis: ${user.expensesHis}\n'
          'kridiHis: ${user.kridiHis}\n'
          'verified: ${user.verified}\n'
  );
}