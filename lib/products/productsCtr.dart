

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
  final sellPriceTec = TextEditingController();
  final buyPriceTec = TextEditingController();
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
      //refreshProducts();//when app starts + when invoice checked
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
          currPrice: double.parse(sellPriceTec.text),
          currBuyPrice: double.parse(buyPriceTec.text),
        currQty: int.parse(qtyTec.text),
        prodChanges: {
          '0': ProdChange(
            time: todayToString(),
            sellPrice: double.parse(sellPriceTec.text),
            buyPrice: double.parse(buyPriceTec.text),
            qty: int.parse(qtyTec.text),
          ).toJson()//first when add new product
        }

      ).toJson();
      /// add prod to cloud
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

        sellPriceTec.clear();
        qtyTec.clear();
        update();
      }).catchError((error) async {
        print('## curr prod failed to updated :$error');
        //showSnack('curr price & qty updated',color: Colors.redAccent.withOpacity(0.8));
      });
      //Get.back();


  }



  /// this is added manuallu in (+) btn of each product card
  addBuyProc({required Product prod,required int chosenQty,required String invID,required String deliveryName,required double inputPrice}) async {

    addToMap(
        coll: productsColl,
        //withBackDialog: true,
        docID: prod.id,
        fieldMapName: 'buyHis',
        mapToAdd: BuySellProd(



          price: inputPrice,
          qty: chosenQty,
          restQty: prod.currQty! + chosenQty ,/// restQty
          total:  inputPrice * chosenQty,

          time: todayToString(),
          society: societyTec.text,//user enter this
          driver: driverTec.text,//user enter this
          mf:mfTec.text,//user enter this
          to: societyName,
          invID:invID,//

        ).toJson(),
        addSuccess: () {
          updateProduct(prod.id!,currQty: prod.currQty! + chosenQty,currBuyPrice: inputPrice);///auto buy of invoice
          print('## <${prod.name}> made < BUY > process (increase qty) "${prod.currQty!} + <${chosenQty}> = ${prod.currQty! + chosenQty} " + Change currBuyPrice [${prod.currBuyPrice}]=>[${inputPrice}]');


          ///if activate add each one alone uncomment this and the getBack below
          // Get.back();
          // bsPriceTec.clear();
          // bsQtyTec.clear();
          // driverTec.clear();
          // societyTec.clear();
          // mfTec.clear();

          // if (addBSProductKey.currentState!.validate()) {
          //   showLoading(text: 'Loading...'.tr);
          //   //Get.back();//hide loading
          // }
        }
    );
  }
  /// these are added automatically in the invoice in for loop one call for each product
  addSellProc({required Product prod,required int chosenQty,required String invID,required String deliveryName,required double income,required double inputPrice}){//merge with kridi
      addToMap(
          coll: productsColl,
          docID: prod.id,
          //withBackDialog: true,
          fieldMapName: 'sellHis',
          mapToAdd: BuySellProd(
              price: inputPrice,
              qty: chosenQty,
              restQty: prod.currQty! - chosenQty < 0?0:prod.currQty! - chosenQty,/// restQty
            total:  inputPrice * chosenQty,

              income: income,// income of single sell

              time: todayToString(),
              society: societyName, // our society name
              mf:societyMf,// from inv
              driver: 'our driver',// from inv
              invID:invID,// in sell auto
              to: deliveryName,


          ).toJson(),
          addSuccess: () {
            updateProduct(prod.id!,currQty: prod.currQty! - chosenQty < 0 ?0:prod.currQty! - chosenQty  );///auto sell of invoice
            print('## <${prod.name}> made < SELL > process (decrease qty) "${prod.currQty!} - <${chosenQty}> = ${prod.currQty! - chosenQty} "');


          }
      );

  }
  /// these are added automatically in the invoice in for loop one call for each product
  addReturnProc({required Product prod,required int chosenQty,required String invID,required bool isBuyInv}){//merge with kridi
    deleteFromMap(
          coll: productsColl,
          docID: prod.id,//to add the quantity
          //withBackDialog: true,
          fieldMapName: isBuyInv ? 'buyHis':'sellHis',//delete  from sellHis
          targetInvID: invID,// choose one of these
          //mapKeyToDelete: '',// choose one of these
          addSuccess: () {
            if(isBuyInv){
              updateProduct(prod.id!,currQty: prod.currQty! - chosenQty  );///auto return of buy invoice
              print('## <${prod.name}> made < RETURN > process (decrease qty) "${prod.currQty!} - <${chosenQty}> = ${prod.currQty! - chosenQty} "');

            }else{
              updateProduct(prod.id!,currQty: prod.currQty! + chosenQty  );///auto return of sell invoice
              print('## <${prod.name}> made < RETURN > process (increase qty) "${prod.currQty!} + <${chosenQty}> = ${prod.currQty! + chosenQty} "');


            }


          }
      );

  }
  /// this process made at first time adding the product & when you edit prd with pencil btn
  updateProductWithManualChange() async {//MAnual Changes
    print('## price: ${selectedProd.currPrice} / qty: ${selectedProd.currQty}');
    if (addProductKey.currentState!.validate() ) {

      bool sellPriceChanged =  double.parse(sellPriceTec.text) != selectedProd.currPrice;
      bool buyPriceChanged =  double.parse(buyPriceTec.text) != selectedProd.currBuyPrice;
      bool qtyChanged =  double.parse(qtyTec.text) != selectedProd.currQty;

      if( sellPriceChanged || buyPriceChanged || qtyChanged ){
        showLoading(text: 'Loading'.tr);
        productsColl.doc(selectedProd.id).get().then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            Map<String, dynamic> fieldMap = documentSnapshot.get('prodChanges');

            //int newItemIndex = fieldMap.length ;

            //New item to ADD
            fieldMap[getLastIndex(fieldMap, afterLast: true)] = ProdChange(
              time: todayToString(),
              sellPrice: sellPriceChanged? double.parse(sellPriceTec.text):88888,
              buyPrice: buyPriceChanged? double.parse(buyPriceTec.text):88888,
              qty: sellPriceChanged? int.parse(qtyTec.text):88888,
            ).toJson();// make manual change with btn

            await productsColl.doc(selectedProd.id).update({
              'prodChanges': fieldMap,
              'currBuyPrice': double.parse(buyPriceTec.text),
              'currPrice': double.parse(sellPriceTec.text),
              'currQty': int.parse(qtyTec.text),
              //'name': nameTec.text,
            }).then((value) async {
              Get.back(); //back loading
              Get.back(); //back dialog
              print('## product updated');
              showSnack('product updated'.tr, color: Colors.black54);
              buyPriceTec.clear();
              sellPriceTec.clear();
              qtyTec.clear();
              //nameTec.clear();
              Future.delayed(const Duration(milliseconds: 500), () {
                update();
              });
            }).catchError((error) async {
              print('## item to fieldMap FAILED to updated');
              showSnack('product failed to be updated'.tr, color: Colors.redAccent.withOpacity(0.8));
            });
          }
        });
      }else{
        showSnack('you need to make changes'.tr,color:Colors.black54);
      }
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
      title:isAdd? Text('Add New Product'.tr):Text('${'Update'.tr} "${selectedProd.name}"'.tr,
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

  /// depricated ***********
  // addprodChangeProc({required Product product,bool manual = false ,double newPrice = 0.0,bool isSell = false ,int bsQty = 0,int manualQty = 0,bool withBackDialog = false}){
  //
  //   int quantity = 0;
  //   if(manual){
  //     quantity = manualQty;
  //   }else{
  //     if(isSell) {quantity = product.currQty! - bsQty;}
  //     else { quantity = product.currQty! + bsQty;}
  //
  //   }
  //
  //   addToMap(
  //       coll: productsColl,
  //       docID: '${product.id}',
  //       fieldMapName: 'prodChanges',
  //       withBackDialog: withBackDialog,
  //       mapToAdd: ProdChange(
  //         time: todayToString(),
  //         price: newPrice!= 0.0 ? newPrice: product.currPrice,
  //         //buyPrice: double.parse(buyPriceTec.text),
  //
  //         qty: quantity,
  //
  //       ).toJson(),
  //       addSuccess: () {
  //         Get.back();
  //         priceTec.clear();
  //         qtyTec.clear();
  //
  //       }
  //   );
  // }

}