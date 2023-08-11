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

class AddProduct extends StatelessWidget {
  final bool isAdd;

  AddProduct({required this.isAdd});

  //###############################################################"
  //###############################################################"

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsCtr>(
        initState: (_) {
          if (!isAdd) {//update

            prdCtr.priceTec.text = prdCtr.selectedProd.currPrice.toString();
            prdCtr.qtyTec.text = prdCtr.selectedProd.currQty.toString();
          }
          else{//add
            prdCtr.priceTec.text = '';
            prdCtr.buyPpriceTec.text = '';
            prdCtr.qtyTec.text = '';
            prdCtr.nameTec.text = '';
            prdCtr.qtyPerUnitTec.text = '';
          }
        },
        dispose: (_) {},
        builder: (ctr) => SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: prdCtr.addProductKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 10,
                    ),

                    /// components


                    if(isAdd) customTextField(
                      controller: prdCtr.nameTec,
                      labelText: 'Name'.tr,
                      hintText: ''.tr,
                      icon: Icons.shopping_cart_outlined,
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
                      controller: prdCtr.priceTec,
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

                    SizedBox(
                      height: 18,
                    ),
                    if(isAdd) customTextField(
                      textInputType: TextInputType.number,
                      controller: prdCtr.buyPpriceTec,
                      labelText: 'buy Price'.tr,
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

                    SizedBox(
                      height: 18,
                    ),
                    customTextField(
                      controller: prdCtr.qtyTec,
                      labelText: 'Quantity'.tr,
                      hintText: ''.tr,
                      icon: Icons.category,
                      textInputType: TextInputType.number,
                      validator: (value) {
                        RegExp positiveIntegerPattern = RegExp(r'^\d+$');

                        if (value!.isEmpty) {
                          return "quantity can't be empty".tr;
                        }
                        if (!positiveIntegerPattern.hasMatch(value!)) {
                          return 'Please enter a valid quantity'.tr;
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 18,
                    ),
                   if(isAdd) customTextField(
                      controller: prdCtr.qtyPerUnitTec,
                      labelText: 'Qty per unit'.tr,
                      hintText: ''.tr,
                      icon: Icons.grid_view_outlined,
                      textInputType: TextInputType.number,

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
                              if (isAdd) {
                                prdCtr.addProduct();
                              } else {
                                prdCtr.updateProductWithManualChange();
                                // ichangesf (prdCtr.addProductKey.currentState!.validate()) {
                                //   prdCtr.addprodChangeProc(
                                //       product: prdCtr.selectedProd,
                                //       manual: true,
                                //       withBackDialog: true,
                                //       manualQty: int.parse(prdCtr.qtyTec.text),
                                //       newPrice: double.parse(prdCtr.priceTec.text)
                                //   );
                                // }
                              }
                            },
                            child: Text(
                             isAdd? "Add".tr:"Update".tr,
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
