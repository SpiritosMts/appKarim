import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gajgaji/_models/expKridi.dart';
import 'package:gajgaji/_models/client.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../_manager/firebaseVoids.dart';
import '../_manager/myVoids.dart';
import '../_manager/styles.dart';
import '../_models/client.dart';
import '../main.dart';
import 'addClientDialog.dart';

class ClientsCtr extends GetxController {
  List<Clienth> clientsList = [];
  Clienth selectedClient = Clienth();

  selectClient(Clienth clt) {
    selectedClient = clt;
    print('## Client<${clt.name}> selected');
  }

  //client
  GlobalKey<FormState> registerClientKey = GlobalKey<FormState>();

  final nameTec = TextEditingController();
  final phoneTec = TextEditingController();
  final addressTec = TextEditingController();
  final emailTec = TextEditingController();

  @override
  onInit() {
    super.onInit();
    //print('## init HomeCtr');
    Future.delayed(const Duration(milliseconds: 50), () {
      // downloadStoresFromDb().whenComplete(()async {
      //   //stNearbyMarkers = await loadNearbyMarkers(stMarkers, selectedProduct, sliderVal);// after download stores data
      // });
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  addClient() async {
    if (registerClientKey.currentState!.validate()) {
      showLoading(text: 'Loading'.tr);


      Map<String, dynamic> clientToAdd = Clienth(
        name: nameTec.text,
        phone: phoneTec.text,
        address: addressTec.text,
        email: emailTec.text,

      ).toJson();

      /// add client to cloud
      addDocument(
        fieldsMap: clientToAdd,
        collName: clientsCollName,
      ).then((value) {
        Get.back(); //hide loading

        showSuccess(
            sucText: 'new client has been created successfully'.tr,
            btnOkPress: () {
              Get.back();
            });
        Future.delayed(const Duration(milliseconds: 500), () {
          update();
        });
      }).catchError((error) {
        print("Failed to add client: $error");
      });
    }
  }

  updateClient() async {
    if (registerClientKey.currentState!.validate()) {
      showLoading(text: 'Loading'.tr);

      Map<String, dynamic> updateUserMap = {
        'name': nameTec.text,
        'phone': phoneTec.text,
        'address': addressTec.text,
        'email': emailTec.text,
      };

      updateDoc(collName: clientsCollName, docID: selectedClient.id!, fieldsMap: updateUserMap).then((value) {
        Get.back(); //hide loading

        showSuccess(
            sucText: 'client has been updated successfully'.tr,
            btnOkPress: () {
              Get.back();
              Get.back();

            });
        Future.delayed(const Duration(milliseconds: 500), () {
          update();
        });
      }).catchError((error) {
        print("Failed to update client: $error");
      });
    }
  }

  addClientDialog({required bool isAdd}) {

    return AlertDialog(
      backgroundColor: dialogsCol,

      title:Text('Add New Client'.tr,
        style: TextStyle(
          color: dialogTitleCol,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: AddClient(isAdd: isAdd),
    );
  }

}
