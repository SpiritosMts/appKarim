import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gajgaji/_models/invoice.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'bindings.dart';
import 'myVoids.dart';
import 'dart:io';



Future<int> getChildrenNum(String ref) async {
  int childrennum = 0;
  DatabaseReference serverData = database!.ref(ref); //'patients/sr1'
  final snapshot = await serverData.get();
  if (snapshot.exists) {
    childrennum = snapshot.children.length;
    print('## <$ref> exists with [${childrennum}] children');
  } else {
    print('## <$ref> DONT exists');
  }
  //update(['chart']);
  return childrennum;
}



/// add DOCUMENT to fireStore
Future<void> addDocument(
    {required fieldsMap,
    required String collName,
    bool addID = true,
    String specificID = '',
    bool addRealTime = false,
    String docPathRealtime = '',
    Map<String, dynamic>? realtimeMap}) async {
  CollectionReference coll = FirebaseFirestore.instance.collection(collName);

  // Map fields={
  //   'name': nameController.text,
  //   'email': emailController.text,
  //   'pwd': passwordController.text,
  //   //'verified':false,
  //   'garages': [],
  // };

  if (specificID != '') {
    coll.doc(specificID).set(fieldsMap).then((value) async {
      print("## DOC ADDED TO <$collName>");

      //add id to doc
      if (addID) {
        //set id
        coll.doc(specificID).update(
          {
            ///this
            'id': specificID,
          },
          //SetOptions(merge: true),
        );
        if (addRealTime) {
          DatabaseReference serverData = database!.ref(docPathRealtime);
          await serverData.update({"$specificID": realtimeMap}).then((value) async {});
        }
      }
    }).catchError((error) {
      print("## Failed to add doc to <$collName>: $error");
    });
  } else {
    coll.add(fieldsMap).then((value) async {
      print("## DOC ADDED TO <$collName>");

      //add id to doc
      if (addID) {
        String docID = value.id;
        //set id
        coll.doc(docID).update(
          {
            ///this
            'id': docID,
          },
          //SetOptions(merge: true),
        );
        if (addRealTime) {
          DatabaseReference serverData = database!.ref(docPathRealtime);
          await serverData.update({"$docID": realtimeMap}).then((value) async {});
        }
      }
    }).catchError((error) {
      print("## Failed to add doc to <$collName>: $error");
    });
  }
}

Future<void> updateDoc({required String collName, required String docID, Map<String, dynamic> fieldsMap = const {}}) async {
  CollectionReference coll = FirebaseFirestore.instance.collection(collName);

  await coll.doc(docID).get().then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      await coll.doc(docID).update(fieldsMap).then((value) async {
        showSnack('doc updated'.tr);
        print('## doc updated');
        //Get.back();//cz it in dialog
      }).catchError((error) async {
        showSnack('doc failed to updated'.tr);
        print('## doc falide to updated');
      });
    }
  });
}




addDoc(CollectionReference coll) async {
  Map<String, dynamic> mapToAdd = {
    'null': null,
    'string': 'hajime',
    'number': 4.5,
    'geopoint': const GeoPoint(0.1, 4.5),
    //'reference': 'ref',
    'map': {
      'key0': 'value0',
      'key1': 'value1',
      'key2': 'value2',
    },
    'list': [
      'item0',
      'item1',
      'item2',
    ]
  };

  coll.add(mapToAdd).then((value) async {
    String docID = value.id;
    coll.doc(docID).update({
      'id': docID,
    });
    print("### doc added with id:<$docID>");
  }).catchError((e) async {
    print("## Failed to add document: $e");
  });
}






Future<List<DocumentSnapshot>> getDocumentsByCollCondition(
  CollectionReference coll, {
  bool onlyAccepted = false,
}) async {
  QuerySnapshot snap =  await coll.get();

  final List<DocumentSnapshot> documentsFound = snap.docs; //return QueryDocumentSnapshot .data() to convert to json// or "userDoc.get('email')" for each field

  print('## collection: <${coll.path}> docs length = < ${documentsFound.length} >');

  return documentsFound;
}




deleteDoc({Function()? btnOnPress, required String docID, coll}) {
  coll.doc(docID).delete().then((value) async {
    print('## doc deleted');
    //removeUserServers(userID);
    btnOnPress!();
    //showSnack('doc deleted'.tr, color: Colors.redAccent.withOpacity(0.8));
  }).catchError((error) async {
    print('## doc deleting error = ${error}');
    //showSnack('doctor accepted');
  });
  ;
}








void deleteFromMap({coll, docID, fieldMapName, String mapKeyToDelete ='', bool withBackDialog = false, String targetInvID ='', Function()? addSuccess,}) {

  //we need either targetInvID or mapKeyToDelete to delete item from map
  print('## try deleting map in ${coll}/$docID/$fieldMapName/$mapKeyToDelete');
   print('## targetInvID = <$targetInvID> mapKeyToDelete = <$mapKeyToDelete>');

  coll.doc(docID).get().then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      Map<String, dynamic> fieldMap = documentSnapshot.get(fieldMapName);


      String keyToDelete =  mapKeyToDelete;

        if(targetInvID != '' ){
          for (var entry in fieldMap.entries) {
            if (entry.value['invID'] == targetInvID) {
              keyToDelete =  entry.key;
            }
          }
        }


      fieldMap.remove(keyToDelete);

      await coll.doc(docID).update({
        '${fieldMapName}': fieldMap,
      }).then((value) async {
        if (withBackDialog) Get.back();
        addSuccess!();

        print('## item from fieldMap<$fieldMapName> deleted');
      }).catchError((error) async {
        print('## item from fieldMap<$fieldMapName> FAILED to deleted: $error');

        //showSnack('appointment declining error',color: Colors.redAccent.withOpacity(0.8));
      });
    } else {
      print('## doc<$docID> dont exist');
    }
  });
}

void addToMap({coll, docID, fieldMapName, mapToAdd, Function()? addSuccess, bool withBackDialog = false}) {
  coll.doc(docID).get().then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      Map<String, dynamic> fieldMap = documentSnapshot.get(fieldMapName);

      //int newItemIndex = fieldMap.length ;

      //New  item to ADD
      fieldMap[getLastIndex(fieldMap, afterLast: true)] = mapToAdd;

      await coll.doc(docID).update({
        '${fieldMapName}': fieldMap,
      }).then((value) async {
        if (withBackDialog) Get.back();
        print('## item to fieldMap added');
        //showSnack('item added', color: Colors.black54);
        addSuccess!();
      }).catchError((error) async {
        print('## item to fieldMap FAILED to added');
        //showSnack('item failed to be added', color: Colors.redAccent.withOpacity(0.8));
      });
    } else {
      print('## doc<$docID> dont exist');
    }
  });
}


