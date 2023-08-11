import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gajgaji/_manager/bindings.dart';
import 'package:gajgaji/workers/workersCtr.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../_manager/myUi.dart';
import '../_manager/styles.dart';

class AddExpKridi extends StatelessWidget {
  final bool isExpense;
  AddExpKridi({ required this.isExpense});



  //###############################################################"
  //###############################################################"

  @override
  Widget build(BuildContext context) {

    return GetBuilder<WorkersCtr>(
        initState: (_) {
        },
        dispose: (_) {
        },
        builder: (ctr) => SingleChildScrollView(
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
                    customTextField(
                      controller: wrkCtr.typeTec,
                      labelText: 'Type'.tr,
                      hintText: ''.tr,
                      icon: Icons.category,

                    ),

                    SizedBox(height: 18,),
                    customTextField(
                      controller: wrkCtr.descTec,
                      labelText: 'Description'.tr,
                      hintText: ''.tr,
                      icon: Icons.description,

                    ),





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
                              if(isExpense){
                                wrkCtr.addExpense();

                              }else{
                                wrkCtr.addKridi();

                              }
                            },
                            child: Text(
                              "Add".tr,
                              style: TextStyle(color: dialogButtonTextCol ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
