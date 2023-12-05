
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gajgaji/_models/expKridi.dart';
import 'package:gajgaji/_models/worker.dart';
import 'package:gajgaji/workers/addExpKridiDialog.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../_manager/bindings.dart';
import '../_manager/firebaseVoids.dart';
import '../_manager/myUi.dart';
import '../_manager/myVoids.dart';
import '../_manager/styles.dart';
import '../_models/client.dart';
import '../main.dart';

class WorkersCtr extends GetxController {
  List<Workerh> workersList = [];
  bool isExp = true;
  Workerh selectedWorker = Workerh();

  selectWorker(Workerh wrk) {
    selectedWorker = wrk;
    print('## Worker<${wrk.name}> selected');
  }

  //worker
  GlobalKey<FormState> registerWorkerKey = GlobalKey<FormState>();

  final nameTec = TextEditingController();
  final ageTec = TextEditingController();
  final phoneTec = TextEditingController();
  final addressTec = TextEditingController();
  final salaryTec = TextEditingController();

  final emailTec = TextEditingController();
  final roleTec = TextEditingController();
  final specialityTec = TextEditingController();
  String sex = 'Male'.tr;
  final selectedGender = ['Male'.tr, 'Female'.tr];

  GlobalKey<FormState> expKridiWorkerKey = GlobalKey<FormState>();

  //req
  final priceTec = TextEditingController();
  final typeTec = TextEditingController();
  final descTec = TextEditingController();

  @override
  onInit() {
    super.onInit();
    //print('## init HomeCtr');
    Future.delayed(const Duration(milliseconds: 50), () {});
  }

  @override
  void onClose() {
    super.onClose();
  }

  addWorker() async {
    if (registerWorkerKey.currentState!.validate()) {
      showLoading(text: 'Loading'.tr);

      // Map<String, dynamic> addUserMap = {
      //   'name': nameTec.text,
      //   'age': ageTec.text,
      //   'phone': phoneTec.text,
      //   'address': addressTec.text,
      //   'salary': double.parse(salaryTec.text)??0.0,
      //
      //   'email': emailTec.text,
      //   'role': roleTec.text,
      //   'speciality': specialityTec.text,
      //   'sex': sex,
      //
      //
      //   'joinDate': todayToString(),
      //   'verified': true ,
      //
      //
      //   'totalKridi': 0.0,
      //   'totalExpenses': 0.0,
      //   'expensesHis': {},
      //   'kridiHis': {},
      // };

      Map<String, dynamic> workerToAdd = Workerh(
        name: nameTec.text,
        age: ageTec.text,
        phone: phoneTec.text,
        address: addressTec.text,
        salary: double.parse(salaryTec.text) ?? 0.0,
        email: emailTec.text,
        role: roleTec.text,
        speciality: specialityTec.text,
        sex: sex,
        joinDate: todayToString(showDay: true),
        verified: true,
        totalKridi: 0.0,
        totalExpenses: 0.0,
        expensesHis: {},
        kridiHis: {},
      ).toJson();

      /// add worker to cloud
      addDocument(
        fieldsMap: workerToAdd,
        collName: workersCollName,
      ).then((value) {
        Get.back(); //hide loading

        showSuccess(
            sucText: 'new worker has been created successfully'.tr,
            btnOkPress: () {
              Get.back();
            });
        Future.delayed(const Duration(milliseconds: 500), () {
          update();
        });
      }).catchError((error) {
        print("Failed to add worker: $error");
      });
    }
  }

  updateWorker() async {
    if (registerWorkerKey.currentState!.validate()) {
      showLoading(text: 'Loading'.tr);

      Map<String, dynamic> updateUserMap = {
        'name': nameTec.text,
        'age': ageTec.text,
        'phone': phoneTec.text,
        'address': addressTec.text,
        'salary': double.parse(salaryTec.text),
        'email': emailTec.text,
        'role': roleTec.text,
        'speciality': specialityTec.text,
        'sex': sex,
      };

      updateDoc(collName: workersCollName, docID: selectedWorker.id!, fieldsMap: updateUserMap).then((value) {
        Get.back(); //hide loading

        showSuccess(
            sucText: 'worker has been updated successfully'.tr,
            btnOkPress: () {
              Get.back();
              Get.back();
            });
        Future.delayed(const Duration(milliseconds: 500), () {
          update();
        });
      }).catchError((error) {
        print("Failed to update worker: $error");
      });
    }
  }



  addExpense() {
    //merge with kridi
    if (expKridiWorkerKey.currentState!.validate()) {
      showLoading(text: 'Loading...'.tr);

      addToMap(
          coll: workersColl,
          docID: selectedWorker.id,
          fieldMapName: 'expensesHis',
          withBackDialog: true,
          mapToAdd: ExpKridi(
              time: todayToString(),
              price: double.parse(priceTec.text),
              type: typeTec.text,
              desc: descTec.text
          ).toJson(),
          addSuccess: () {
            invCtr.addSubSocietyCash(-1 * double.parse(priceTec.text));/// sub from treasury
            updateFieldInFirestore('workers',selectedWorker.id!,'totalExpenses',selectedWorker.totalExpenses! + double.parse(priceTec.text));/// add to total exp
            update();


            Get.back(); // hide loading
            priceTec.clear();
            typeTec.clear();
            descTec.clear();
          });
      //Get.back();

    }
  }

  addKridi() {
    if (expKridiWorkerKey.currentState!.validate()) {
      showLoading(text: 'Loading...'.tr);

      addToMap(
          withBackDialog: true,
          coll: workersColl,
          docID: selectedWorker.id,
          fieldMapName: 'kridiHis',
          mapToAdd: ExpKridi(
              time: todayToString(),
              price: double.parse(priceTec.text),
              type: typeTec.text,
              desc: descTec.text)
              .toJson(),
          addSuccess: () {

            invCtr.addSubSocietyCash(-1 * double.parse(priceTec.text));/// sub from treasury
            updateFieldInFirestore('workers',selectedWorker.id!,'totalKridi',selectedWorker.totalKridi! + double.parse(priceTec.text));/// add to total kridi
            update();
            Get.back(); // hide loading
            priceTec.clear();
            typeTec.clear();
            descTec.clear();
          });
      //Get.back();

    }
  }
      returnKridi() {
      if (expKridiWorkerKey.currentState!.validate()) {
        showLoading(text: 'Loading...'.tr);

        addToMap(
            withBackDialog: true,
            coll: workersColl,
            docID: selectedWorker.id,
            fieldMapName: 'kridiHis',
            mapToAdd: ExpKridi(
                time: todayToString(),
                price: double.parse(priceTec.text),
                type: typeTec.text,
                desc: descTec.text,
              paid: true,/// returned kridi
            )
                .toJson(),
            addSuccess: () {
              double newTotal = 0.0;
              if(selectedWorker.totalKridi! - double.parse(priceTec.text) < 0){
                newTotal = selectedWorker.totalKridi!;
              }else {
                newTotal = selectedWorker.totalKridi! - double.parse(priceTec.text);
              }

              invCtr.addSubSocietyCash(double.parse(priceTec.text) > selectedWorker.totalKridi! ? selectedWorker.totalKridi!:double.parse(priceTec.text));///  treasury
              updateFieldInFirestore('workers',selectedWorker.id!,'totalKridi',newTotal);  /// sub frm total kridi
                     update();
              Get.back(); // hide loading
              Get.back();//retuen to wrk list
              update();
              priceTec.clear();
              typeTec.clear();
              descTec.clear();
            });

      }
    }

    //dialogs

    addExpKridiDialog({bool isExpense = true}) {
      return AlertDialog(
        backgroundColor: dialogsCol,
        title: Text(isExpense ? 'Add New Expensive'.tr : 'Add New Kridi'.tr,
          style: TextStyle(
            color: dialogTitleCol,
          ),),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        content: AddExpKridi(isExpense: isExpense),
      );
    }

    returnKridiDialog({bool isExpense = true}) {
      return AlertDialog(
        backgroundColor: dialogsCol,
        title: Text('Kridi: ${formatNumberAfterComma2(selectedWorker!.totalKridi!)} TND'.tr ,
          style: TextStyle(
            color: dialogTitleCol,
          ),),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,

          child: Form(
            key: wrkCtr.expKridiWorkerKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 20,),

                /// components

                customTextField(
                  textInputType: TextInputType.number,
                  controller: wrkCtr.priceTec,
                  labelText: 'Price'.tr,
                  hintText: ''.tr,
                  icon: Icons.attach_money,
                  validator: (value) {
                    final numberRegExp = RegExp(r'^\d*\.?\d+$');
                    if (value!.isEmpty) {
                      return "price can't be empty".tr;
                    }
                    if (!numberRegExp.hasMatch(value!)) {
                      return 'Please enter a valid price'.tr;
                    }

                    return null;

                  },
                ),
                SizedBox(height: 18,),






                /// buttons
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //cancel
                      TextButton(
                        style: borderStyle(),
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          "Cancel".tr,
                          style: TextStyle(color: dialogButtonTextCol),
                        ),
                      ),
                      //add
                      TextButton(
                        style: filledStyle(),
                        onPressed: () async {
                            returnKridi();
                        },
                        child: Text(
                          "Sub".tr,
                          style: TextStyle(color: dialogButtonTextCol ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
