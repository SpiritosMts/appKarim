import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gajgaji/_manager/bindings.dart';
import 'package:gajgaji/products/productsCtr.dart';
import 'package:gajgaji/workers/workersCtr.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../_manager/myUi.dart';
import '../_manager/styles.dart';

class AddClient extends StatelessWidget {
  final bool isAdd;

  AddClient({required this.isAdd});

  //###############################################################"
  //###############################################################"

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsCtr>(
        initState: (_) {
          if (!isAdd) {//update

            // cltCtr.priceTec.text = cltCtr.selectedProd.currPrice.toString();
            // cltCtr.qtyTec.text = cltCtr.selectedProd.currQty.toString();
          }
          else{//add
            cltCtr.phoneTec.text = '';
            cltCtr.emailTec.text = '';
            cltCtr.addressTec.text = '';
            cltCtr.nameTec.text = '';
          }
        },
        dispose: (_) {},
        builder: (ctr) => SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: cltCtr.registerClientKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 10,
                    ),

                    /// components


                    customTextField(
                      controller: cltCtr.nameTec,
                      labelText: 'Name'.tr,
                      hintText: ''.tr,
                      icon: Icons.person,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "name can't be empty".tr;
                        }

                        return null;
                      },
                    ),


                    SizedBox(
                      height: 18,
                    ),
                    customTextField(
                      textInputType: TextInputType.number,
                      controller: cltCtr.phoneTec,
                      labelText: 'Phone'.tr,
                      hintText: ''.tr,
                      icon: Icons.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "number can't be empty".tr;
                        }
                        else {
                          return null;
                        }
                      },
                    ),

                    SizedBox(
                      height: 18,
                    ),
                    customTextField(
                      textInputType: TextInputType.streetAddress,

                      controller: cltCtr.addressTec,
                      labelText: 'Address'.tr,
                      hintText: ''.tr,
                      icon: Icons.home,

                    ),


                    SizedBox(
                      height: 18,
                    ),
                    customTextField(
                      textInputType: TextInputType.emailAddress,

                      controller: cltCtr.emailTec,
                      labelText: 'Email'.tr,
                      hintText: ''.tr,
                      icon: Icons.email,

                    ),


                    SizedBox(
                      height: 18,
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
                              style: TextStyle(
                                  color: dialogButtonTextCol),
                            ),
                          ),
                          //add
                          TextButton(
                            style: filledStyle(),
                            onPressed: () async {
                                cltCtr.addClient();
                            },
                            child: Text(
                             "Add".tr,
                              style: TextStyle(
                                  color: dialogButtonTextCol),
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
