

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../clients/clientsCtr.dart';
import '../invoices/invoiceCtr.dart';
import '../products/productsCtr.dart';
import '../workers/workersCtr.dart';
import 'myLocale/myLocaleCtr.dart';
import 'myTheme/myThemeCtr.dart';


//AuthController authCtr = AuthController.instance;

WorkersCtr get wrkCtr => Get.find<WorkersCtr>();
ClientsCtr get cltCtr => Get.find<ClientsCtr>();
InvoicesCtr get invCtr => Get.find<InvoicesCtr>();
ProductsCtr get prdCtr => Get.find<ProductsCtr>();
MyLocaleCtr get lngCtr => Get.find<MyLocaleCtr>();
MyThemeCtr get themeCtr => Get.find<MyThemeCtr>();



///PatientsListCtr get patListCtr => Get.find<PatientsListCtr>(); //default


class GetxBinding implements Bindings {
  @override
  void dependencies() {
    //TODO

    //Get.put<AuthController>(AuthController());


    Get.put<ProductsCtr>(ProductsCtr());
    Get.put<ClientsCtr>(ClientsCtr());
    Get.put<WorkersCtr>(WorkersCtr());
    Get.put<InvoicesCtr>(InvoicesCtr());
   //Get.lazyPut<WorkersCtr>(() => WorkersCtr(),fenix: true);
   //Get.lazyPut<InvoicesCtr>(() => InvoicesCtr(),fenix: true);
   //Get.lazyPut(() => ProductsCtr(),fenix: true);


    //print("## getx dependency injection completed (Get.put() )");

  }
}