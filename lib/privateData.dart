


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';



bool access = false;
Future<List<DocumentSnapshot>> getDocumentsByColl(String collName) async {
  QuerySnapshot snap = await FirebaseFirestore.instance.collection(collName).get();

  final List<DocumentSnapshot> documentsFound = snap.docs;

  print('## collection:<${collName}> docs length =(${documentsFound.length})');

  return documentsFound;
}
Future<void> getPrivateData()async{
  print('## getting PD...');

  List<DocumentSnapshot> privateData = await getDocumentsByColl('prData');

  DocumentSnapshot privateDataDoc = privateData[0];// get first one

  access = privateDataDoc.get('access');



}