import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gajgaji/_manager/bindings.dart';
import 'package:gajgaji/workers/workersCtr.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../_manager/myUi.dart';
import '../_manager/styles.dart';

class AddBuySellProd extends StatelessWidget {
  final bool isSell;
  AddBuySellProd({ required this.isSell});



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
            key: prdCtr.addBSProductKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //SizedBox(height: 20,),

                /// components

                SizedBox(height: 10,),

                customTextField(
                  textInputType: TextInputType.number,
                  controller: prdCtr.bsPriceTec,
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
                  controller: prdCtr.bsQtyTec,
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


                SizedBox(height: 18,),
               if(!isSell) customTextField(
                  controller: prdCtr.societyTec,
                  labelText: 'Society'.tr,
                  hintText: ''.tr,
                  icon: Icons.category,

                ),
                SizedBox(height: 18,),
                if(!isSell) customTextField(
                  controller: prdCtr.mfTec,
                  labelText: 'MF'.tr,
                  hintText: ''.tr,
                  icon: Icons.category,

                ),
                SizedBox(height: 18,),
                if(!isSell) customTextField(
                  controller: prdCtr.driverTec,
                  labelText: 'Driver'.tr,
                  hintText: ''.tr,
                  icon: Icons.category,
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
                          style: TextStyle(color: dialogButtonTextCol),
                        ),
                      ),
                      //add
                      TextButton(
                        style: filledStyle(),
                        onPressed: () async {
                          if(isSell){
                            //prdCtr.addSellProc();

                          }else{
                            ///manual prod add qty <BUY> //u can activate

                            // prdCtr.addBuyProc(
                            //     prod: prdCtr.selectedProd,
                            //     chosenQty: int.parse(prdCtr.bsQtyTec.text),
                            //     invID: '',
                            //     deliveryName: invCtr.selectedInvoice.deliveryName!
                            // );
                          }
                        },
                        child: Text(
                          "Add".tr,
                          style: TextStyle(color: dialogButtonTextCol),
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
