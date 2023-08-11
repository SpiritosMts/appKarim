

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gajgaji/_manager/bindings.dart';
import 'package:gajgaji/_models/prodChange.dart';
import 'package:get/get.dart';

import '../_manager/firebaseVoids.dart';
import '../_manager/myVoids.dart';
import '../_manager/styles.dart';
import '../_models/buySellProd.dart';
import '../_models/product.dart';
import '../main.dart';
import 'addBSProdDialog.dart';
import 'addProductDialog.dart';

class ProductsCtr extends GetxController {

  bool isSell =true;

  List<Product>  productsList= [];
  List<String>  productsNames= [];
  Product selectedProd = Product();


  //add new product
  GlobalKey<FormState> addProductKey = GlobalKey<FormState>();
  final priceTec = TextEditingController();
  final buyPpriceTec = TextEditingController();
  final nameTec = TextEditingController();
  final qtyTec = TextEditingController();
  final qtyPerUnitTec = TextEditingController();

  //add buy product
  GlobalKey<FormState> addBSProductKey = GlobalKey<FormState>();
  final bsPriceTec = TextEditingController();
  final bsQtyTec = TextEditingController();
  final societyTec = TextEditingController();
  final mfTec = TextEditingController();
  final driverTec = TextEditingController();

  //######################################################################################################"


  selectProduct(Product prd){
    selectedProd = prd;
    debugPrint('## select Product < ${prd.name} > ');
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 0), () {
      refreshProducts();//when app starts + when invoice checked
    });
  }

  //######################################################################################################"

  refreshProducts({bool alone = true ,List<Product>? prds}) async{
    if(alone) productsList = await getAlldocsModelsFromFb<Product>(productsColl, (json) => Product.fromJson(json));
    else productsList = prds!;
    productsNames = extractNames(productsList);
    print('## GET Products <${productsList.length}>');
  }
  List<String> extractNames(List<Product> prds) {
    List<String> names = [];
    for (var prd in prds) {
      if (prd.name != null) {
        names.add(prd.name!);
      }
    }
    return names;
  }


  /// add enw product
  addProduct() async {
    if (addProductKey.currentState!.validate() && !productsNames.contains(nameTec.text)) {
      showLoading(text: 'Loading'.tr);

      Map<String, dynamic> modelToAdd = Product(
          name: nameTec.text,
          buyHis: {},
          sellHis: {},
          qtyPerUnit: qtyPerUnitTec.text,
          imageUrl: '',
          addedTime: todayToString(),
        currPrice: double.parse(priceTec.text),
          currBuyPrice: double.parse(buyPpriceTec.text),
        currQty: int.parse(qtyTec.text),
        prodChanges: {
          '0': ProdChange(
            time: todayToString(),
            price: double.parse(priceTec.text),
            qty: int.parse(qtyTec.text),
          ).toJson()
        }

      ).toJson();
      /// add worker to cloud
      addDocument(
        fieldsMap: modelToAdd,
        collName: productsCollName,
        specificID: '${nameTec.text} -ID'
      ).then((value) {
        Get.back();// hide dialog
        // showSuccess(
        //     sucText: 'new product has been created successfully'.tr,
        //     btnOkPress: () {
        //       Get.back();
        // });

        // priceTec.clear();
        // qtyTec.clear();
        // nameTec.clear();
        Future.delayed(const Duration(milliseconds: 500), () {
          update();
        });
      }).catchError((error) {
        print("## Failed to add product: $error");
      });
      Get.back(); //hide loading

    }
  }
  /// add/subtract qty from current-qty
  updateProduct(String productID,{double? currPrice ,double? currBuyPrice,int? currQty}) async {
    //showLoading(text: 'Loading...'.tr);

    Map<String,dynamic> updatedMap = {};


      if(currPrice != null){
        updatedMap['currPrice']= currPrice;
      }
      if(currQty != null){/// update this after (+/-) the qty
        updatedMap['currQty']= currQty;
      }
      if(currBuyPrice != null){
        updatedMap['currBuyPrice']= currBuyPrice;
      }

      //print('## <$productID> trying to update currQty=<$currQty>');
      //print('## <$productID> mapToUpdate= $updatedMap');
      await productsColl.doc(productID).update(updatedMap).then((value) async {
        //Get.back();//back loading
        //Get.back();//back dialog
        //print('## curr price & qty updated');
        //showSnack('curr price & qty updated',color:Colors.black54);
        //print('## <$productID> new curr qty is < $currQty >');

        priceTec.clear();
        qtyTec.clear();
        update();
      }).catchError((error) async {
        print('## curr prod failed to updated :$error');
        //showSnack('curr price & qty updated',color: Colors.redAccent.withOpacity(0.8));
      });
      //Get.back();


  }



  /// this is added manuallu in (+) btn of each product card
  addBuyProc() async {
    if (addBSProductKey.currentState!.validate()) {
      showLoading(text: 'Loading...'.tr);

       addToMap(
          coll: productsColl,
          //withBackDialog: true,
          docID: selectedProd.id,
          fieldMapName: 'buyHis',
          mapToAdd: BuySellProd(
              price: double.parse(bsPriceTec.text),/// this is the buy price that will be in currBuyPrice
              qty: int.parse(bsQtyTec.text),
              restQty: selectedProd.currQty! + int.parse(bsQtyTec.text),
              total:  double.parse(bsPriceTec.text)* int.parse(bsQtyTec.text),

              time: todayToString(),
              society: societyTec.text,
              driver: driverTec.text,
              mf:mfTec.text,
              to: societyName,
              invID:'',// in sell auto

          ).toJson(),
          addSuccess: () {
            updateProduct(selectedProd.id!,currQty: selectedProd.currQty! + int.parse(bsQtyTec.text),currBuyPrice: double.parse(bsPriceTec.text));///manual buy of invoice
            print('## <${selectedProd.name}> made < BUY > process (increase qty) "${selectedProd.currQty!} + <${bsQtyTec.text}> = ${selectedProd.currQty! + int.parse(bsQtyTec.text)} "');

            Get.back();

            bsPriceTec.clear();
            bsQtyTec.clear();
            driverTec.clear();
            societyTec.clear();
            mfTec.clear();
          }
      );
      //Get.back();
      Get.back();//hide loading

    }

  }
  /// these are added automatically in the invoice in for loop one call for each product
  addSellProc({required Product prod,required int chosenQty,required String invID,required String deliveryName,required double income}){//merge with kridi
      addToMap(
          coll: productsColl,
          docID: prod.id,
          //withBackDialog: true,
          fieldMapName: 'sellHis',
          mapToAdd: BuySellProd(
              price: prod.currPrice,
              qty: chosenQty,
              restQty: prod.currQty! - chosenQty,/// restQty
              income: income,// income of single sell
              total:  prod.currPrice! * chosenQty,

              time: todayToString(),
              society: societyName, // our society name
              mf:societyMf,// from inv
              driver: 'our driver',// from inv
              invID:invID,// in sell auto
              to: deliveryName,


          ).toJson(),
          addSuccess: () {
            updateProduct(prod.id!,currQty: prod.currQty! - chosenQty);///auto sell of invoice
            print('## <${prod.name}> made < SELL > process (decrease qty) "${prod.currQty!} - <${chosenQty}> = ${prod.currQty! - chosenQty} "');


          }
      );

  }
  /// this process made at first time adding the product & when you edit prd with pencil btn
  updateProductWithManualChange() async {//MAnual Changes
    if (addProductKey.currentState!.validate()) {
      showLoading(text: 'Loading'.tr);
      productsColl.doc(selectedProd.id).get().then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          Map<String, dynamic> fieldMap = documentSnapshot.get('prodChanges');

          //int newItemIndex = fieldMap.length ;

          //New item to ADD
          fieldMap[getLastIndex(fieldMap,afterLast: true)] = ProdChange(
            time: todayToString(),
            price: double.parse(priceTec.text),
            qty: int.parse(qtyTec.text),
          ).toJson();


          await productsColl.doc(selectedProd.id).update({
            'prodChanges': fieldMap,
            'currPrice': double.parse(priceTec.text),
            'currQty': int.parse(qtyTec.text),
            //'name': nameTec.text,
          }).then((value) async {
            Get.back();//back loading
            Get.back();//back dialog
            print('## product updated');
            showSnack('product updated',color:Colors.black54);
            priceTec.clear();
            qtyTec.clear();
            //nameTec.clear();
            Future.delayed(const Duration(milliseconds: 500), () {
              update();

            });
          }).catchError((error) async {
            print('## item to fieldMap FAILED to updated');
            showSnack('product failed to be updated',color: Colors.redAccent.withOpacity(0.8));
          });
        }
      });
    }
  }



  // Dialogs
  addBSProductDialog({bool isSell =false}) {
    return AlertDialog(
      backgroundColor: dialogsCol,
      title: Text( isSell?  'Add New Sell'.tr:'Add New Buy'.tr,
        style: TextStyle(
          color: dialogTitleCol,
        ),),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: AddBuySellProd(isSell:isSell),
    );
  }
  addProductDialog({required bool isAdd}) {//this all is in anim method

    ///with animation

    return AlertDialog(
      backgroundColor: dialogsCol,
      title:isAdd? Text('Add New Product'.tr):Text('Update "${selectedProd.name}"'.tr,
        style: TextStyle(
          color: dialogTitleCol,
        ),),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: AddProduct(isAdd: isAdd),
    );

    ///without animation
    // showDialog(
    //     context: navigatorKey.currentContext!,
    //     builder: (_) {
    //       return AlertDialog(
    //         backgroundColor: dialogsCol,
    //         title:isAdd? Text('Add New Product'.tr):Text('Update "${selectedProd.name}"'.tr),
    //         shape: const RoundedRectangleBorder(
    //           borderRadius: BorderRadius.all(
    //             Radius.circular(12.0),
    //           ),
    //         ),
    //         content: AddProduct(isAdd: isAdd),
    //       );
    //     });

  }

  //depricated
  addprodChangeProc({required Product product,bool manual = false ,double newPrice = 0.0,bool isSell = false ,int bsQty = 0,int manualQty = 0,bool withBackDialog = false}){

    int quantity = 0;
    if(manual){
      quantity = manualQty;
    }else{
      if(isSell) {quantity = product.currQty! - bsQty;}
      else { quantity = product.currQty! + bsQty;}

    }

    addToMap(
        coll: productsColl,
        docID: '${product.id}',
        fieldMapName: 'prodChanges',
        withBackDialog: withBackDialog,
        mapToAdd: ProdChange(
          time: todayToString(),
          price: newPrice!= 0.0 ? newPrice: product.currPrice,
          qty: quantity,

        ).toJson(),
        addSuccess: () {
          Get.back();
          priceTec.clear();
          qtyTec.clear();

        }
    );
  }

}