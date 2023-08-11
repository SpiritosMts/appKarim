

import 'package:flutter/material.dart';
import 'package:gajgaji/_models/invoice.dart';
import 'package:gajgaji/invoices/changeTotalSellDialog.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_manager/bindings.dart';
import '../_manager/firebaseVoids.dart';
import '../_manager/myUi.dart';
import '../_manager/myVoids.dart';
import '../_manager/styles.dart';
import '../_models/invProd.dart';
import '../_models/product.dart';
import '../main.dart';
import 'addEditInvoice.dart';
import 'changeAddedDialog.dart';

class InvoicesCtr extends GetxController {


  double societyCash = 0.0;

  Invoice selectedInvoice = Invoice();
  List<Invoice> invoicesList = [];// list of invoices (home)
  List<Product>  productsOfAddingCard= [];
  List<double> incomes =[];
  List<double> totals =[];
  List<String> dates =[];
  //bool isExp = true;
  
  InvProd addingCardInvProd = InvProd();//adding invProd (AddingCard)
  Product addingCardProd = Product();//adding prod (AddingCard)
  List<InvProd> invProdsList = [];//added prods list
  Map<String, dynamic> invProdsMap={};//added prods map

  String invType = '';

  
  double sliderVal = 20.0;
  double maxQty = 700.0;
  double outIncomeTotal = 0.0;
  double outSellTotal = 0.0;
  double outBuyTotal = 0.0;

  double returnIncomeTotal = 0.0;
  double returnSellTotal = 0.0;
  double returnBuyTotal = 0.0;

  Color outSellCol = Colors.blue;
  selectInvoice(Invoice inv) {
    //invType = inv.type!;
    selectedInvoice = inv;

    print('## INvoice <${inv.id}> selected');
  }

  GlobalKey<FormState> invTotalSellKey = GlobalKey<FormState>();//total price to change (bf check)
  final totalSellPriceTec = TextEditingController();

  GlobalKey<FormState> invAddedKey = GlobalKey<FormState>();//each product to change price (bf check)
  final afterReturnPriceTec = TextEditingController();
  final afterReturnQtyTec = TextEditingController();

  GlobalKey<FormState> invToAddKey = GlobalKey<FormState>();
  final addingPriceTec = TextEditingController();
  final addingQtyTec = TextEditingController();

  GlobalKey<FormState> addEditInvoiceKey = GlobalKey<FormState>();

  final deliveryNameTec = TextEditingController();
  final deliveryTruckNumTec = TextEditingController();
  final deliveryPhoneTec = TextEditingController();
  final deliveryEmailTec = TextEditingController();
  final deliveryAddressTec = TextEditingController();

  @override
  onInit() {
    super.onInit();
    //print('## init HomeCtr');
    sharedPrefs!.reload();
    Future.delayed(const Duration(milliseconds: 50), ()  async {
      societyCash = await getFieldFromFirestore('prData','privateData','societyCash');
      update(['societyCash']);
      print('## societyCash: $societyCash');


    });
  }

  refreshAllInvoices(List<Invoice> invoices){
    invCtr.invoicesList = invoices;
    totals = extractTotals(invoicesList.reversed.toList());
    incomes = extractIncomes(invoicesList.reversed.toList());
    dates = extractDates(invoicesList.reversed.toList());

  }

  addSubSocietyCash(double amount){
    societyCash += amount;
    updateFieldInFirestore('prData','privateData','societyCash',societyCash);
    update(['societyCash']);
  }

  resetAddINvoice(){

    deliveryNameTec.text = '';
    deliveryTruckNumTec.text = '';
    deliveryPhoneTec.text = '';
    deliveryEmailTec.text = '';
    deliveryAddressTec.text = '';

    invProdsList.clear();
    update(['addedProds']);
    outIncomeTotal = 0.0;
    outSellTotal = 0.0;
    outBuyTotal = 0.0;
    sliderVal = 20.0;

    //productsOfAddingCard = prdCtr.productsList;/// init all products

    initAddingCard();
    invProdsMap.clear();
  }

  initAddingCard(){
     addingCardInvProd = InvProd();

     addingCardProd = (productsOfAddingCard.isNotEmpty ? productsOfAddingCard[0] : Product());

     invCtr.maxQty = addingCardProd.currQty!.toDouble();
     invCtr.sliderVal = 0.0;

     //addingQtyTec.text = addingCardProd.currQty.toString();//selected Prod => textField (qty)
     addingQtyTec.text = '0';
     addingPriceTec.text = addingCardProd.currPrice!.toInt().toString();//selected Prod => textField (price)
     updateAddingCard();
     invCtr.update(['addingCard']);

  }

  updateAddingCard({bool updatePriceField = false}){
    InvProd invProd = invCtr.addingCardInvProd;


    if(updatePriceField) {
      //addingQtyTec.text = invCtr.addingCardProd.currQty.toString();//selected Prod => textField (qty)
      addingQtyTec.text ='0';
      addingPriceTec.text = invCtr.addingCardProd.currPrice!.toInt().toString();//selected Prod => textField (qty)
    }

    if (invToAddKey.currentState != null && invToAddKey.currentState!.validate()) {
      invProd.qty = int.tryParse(invCtr.addingQtyTec.text) ?? 0;
      invProd.priceSell = double.tryParse(invCtr.addingPriceTec.text) ?? 0.0;
    }


    invProd.name = invCtr.addingCardProd.name;//from dropDown
    invProd.priceBuy = invCtr.addingCardProd.currBuyPrice;//from dropDown

    invProd.totalBuy =  invProd.qty! * invProd.priceBuy!;
    invProd.totalSell =  invProd.qty! * invProd.priceSell!;
    invProd.income = invProd.totalSell! - invProd.totalBuy!;

    //sliderVal= invProd.qty!.toDouble();//update slider with (qty)


    //#####
    invCtr.addingCardInvProd = invProd;
    update(['addingCard']);

  }
  /// arrow
  addInvProdToList(){
    if (invToAddKey.currentState!.validate()) {

      invProdsList.add(addingCardInvProd);
      update(['addedProds']);
      refreshInvProdsTotals();//calculate total buy sell income
      //print('## invProds map length (prods added in invoice): ${invProdsList.length}');
      String productNameToRemove = addingCardInvProd.name!;
      productsOfAddingCard.removeWhere((product) => product.name == productNameToRemove);

      initAddingCard(); /// reset adding card REMOVING the added ones
    }

  }

  refreshInvProdsTotals({bool withTotal =true}){

    if(withTotal) outSellTotal = 0.0;
    outBuyTotal = 0.0;
    outIncomeTotal = 0.0;

    for (var invProd in invProdsList) {
      if(withTotal){
        outSellTotal += invProd.totalSell ?? 0.0;
        outSellCol = Colors.blue;
      }

      outBuyTotal += invProd.totalBuy ?? 0.0;
      //outIncomeTotal += invProd.income ?? 0.0;
    }
    outIncomeTotal = outSellTotal - outBuyTotal;
    update(['invTotal']);

  }


  convertInvProdsMapToList(Map<String, dynamic>? productsRetunedOut){
    /// convert map to list
    invProdsList = productsRetunedOut!.entries.map((entry) {
      int index = int.tryParse(entry.key) ?? 0;
      Map<String, dynamic> jsonData = entry.value as Map<String, dynamic>;
      return InvProd.fromJson(jsonData);
    }).toList();
    ///make changes to list (add/edit Prods) then conv to map
  }
  convertInvProdsListToMap(){
    ///convert list to map
    invProdsMap = invProdsList.asMap().map((index, invProd) {
      return MapEntry(index.toString(), invProd.toJson());
    });
  }

  addInvoice(){

    if (addEditInvoiceKey.currentState!.validate()) {

      if(invProdsList.isEmpty) {
        showSnack('you have to add at least one product',color: Colors.black38.withOpacity(0.8));
        return;
      }

      showNoHeader(
        txt: 'Are you sure you want to send this invoice ?'.tr,
        icon: Icons.send,
        btnOkColor: Colors.green,
        btnOkText: 'Send'.tr,
      ).then((toAllow) {// if admin accept
        if (toAllow) {
          showLoading(text: 'Loading'.tr);

          convertInvProdsListToMap();
      Map<String, dynamic> invoiceToAdd = Invoice(
        deliveryName: deliveryNameTec.text,
        deliveryPhone: deliveryPhoneTec.text,
        deliveryEmail: deliveryEmailTec.text,
        deliveryTruckNum:  deliveryTruckNumTec.text,
        deliveryAddress: deliveryAddressTec.text,
        productsOut: invProdsMap,// calc
        outTotal: outSellTotal,// calc
        timeOut: todayToString(),
        timeReturn: todayToString(),
        verified: false,
        totalChanged: false,
        type: invType,
          ///after return
        //timeReturn: todayToString(),
        productsReturned: {},
        returnTotal: 0.0,
        income: 0.0,


      ).toJson();
      /// add invoice to cloud
      addDocument(
        fieldsMap: invoiceToAdd,
        collName: invoicesCollName,
      ).then((value) {
        Future.delayed(const Duration(milliseconds: 500), () {
          update();
        });
        Get.back(); /// --hide loading
        // showSuccess(
        //     sucText: 'new invoice has been added'.tr,
        //     btnOkPress: () {
        //     }
        //     );
        Get.back();


      }).catchError((error) {
        print("Failed to add invoice: $error");
      });

        }
      });

    }
  }
  checkInvoice(){
    showNoHeader(
      txt: 'Are you sure you want to check this invoice ?'.tr,
      icon: Icons.check,
      btnOkColor: Colors.green,
      btnOkText: 'Check'.tr,
    ).then((toAllow) {// if admin accept
      if (toAllow) {


        /// /////////////////////


        showLoading(text: 'Loading'.tr);
        convertInvProdsListToMap();

        Map<String, dynamic> invoiceToCheck = {
          'timeReturn': todayToString(),
          'productsReturned': invProdsMap,
          'returnTotal': outSellTotal,
          'income': outIncomeTotal,
          'verified': true,
          'totalChanged': outSellTotal != selectedInvoice.outTotal,

        };

        /// check invoice to cloud
        updateDoc(
          fieldsMap: invoiceToCheck,
          collName: invoicesCollName,
          docID: invCtr.selectedInvoice.id!,
        ).then((value) {

          /// update society cash
          addSubSocietyCash(outSellTotal);
          /// update each product with sellProc with FOR
          for (InvProd invProd in invProdsList) {
            Product? foundProduct = prdCtr.productsList.firstWhere((product) => product.name == invProd.name, orElse: () => Product());
            if(foundProduct.name != '') {
              prdCtr.addSellProc(
                  prod: foundProduct,
                  chosenQty: invProd.qty!,
                  invID: invCtr.selectedInvoice.id!,
                  income: invProd.income!,
                  deliveryName: invCtr.selectedInvoice.deliveryName!
              );

            }else{
              showSnack('product<${foundProduct.name}> cant be added (empty)',color:Colors.black54);
              print('## product<${foundProduct.name}> cant be added (empty)');
            }
          }
          /// refresg all products
          prdCtr.refreshProducts();
          Future.delayed(const Duration(milliseconds: 1000), () {
            update();
          });
          Get.back(); /// --hide loading

          showSuccess(
              sucText: 'Invoice has been checked'.tr,
              btnOkPress: () {
                Get.back();//hide success
                Get.back();
              });
          // Get.back();//
          // Get.back();//
          // Get.back();//


        }).catchError((error) {
          print("## Failed to check invoice: $error");
        });

        /// //////////////////////


      }
    });


  }

  List<double> extractIncomes(List<Invoice> invoices) {
    List<double> incomes = [];
    for (var invoice in invoices) {
      if (invoice.income != null) {
        incomes.add(invoice.income!);
      }
    }
    return incomes;
  }
  List<double> extractTotals(List<Invoice> invoices) {
    List<double> totals = [];
    for (var invoice in invoices) {
      if (invoice.returnTotal != null) {
        totals.add(invoice.returnTotal!);
      }
    }
    return totals;
  }
  List<String> extractDates(List<Invoice> invoices) {
    List<String> dates = [];
    for (var invoice in invoices) {
      if (invoice.timeReturn != null) {

        dates.add(getDayString(invoice.timeReturn!));
      }
    }
    return dates;
  }



  changeAddedProdReturn(int index){
    if (invAddedKey.currentState!.validate()) {
      invProdsList[index].priceSell = double.tryParse(afterReturnPriceTec.text) ?? 0.0;
      invProdsList[index].qty = int.tryParse(afterReturnQtyTec.text) ?? 0;
      invProdsList[index].totalSell = invProdsList[index].qty! * invProdsList[index].priceSell!;
      invProdsList[index].totalBuy = invProdsList[index].qty! * invProdsList[index].priceBuy!;
      invProdsList[index].income = invProdsList[index].totalSell! - invProdsList[index].totalBuy!;
      print('## ${invProdsList[index].name} => ${invProdsList[index].priceSell} (${invProdsList[index].qty})');
      refreshInvProdsTotals();
      invCtr.update(['addedProds']);
      Get.back();
    }
  }
  changetotalPrice(){
    if (invTotalSellKey.currentState!.validate()) {
      outSellTotal = double.tryParse(totalSellPriceTec.text) ?? 0.0;
      outSellCol = Colors.yellowAccent;
      print('## outSellTotal => ${outSellTotal} ');
      refreshInvProdsTotals(withTotal: false);
      invCtr.update(['invTotal']);
      Get.back();
    }
  }






  changeAddedDialog({required double price,required int qty ,required int index}) {
    return AlertDialog(
      backgroundColor: dialogsCol,
      title:Text('Change price/qty'.tr,
        style: TextStyle(
          color: dialogTitleCol,
        ),),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: ChangeAdded(price: price,qty: qty,index: index),
    );
  }
  changeTotalSellDialog({required double price}) {
    showDialog(
      barrierDismissible: true,
      context: navigatorKey.currentContext!,
      builder: (_) => AlertDialog(
        backgroundColor: dialogsCol,
        title:Text('Change total sell'.tr,
          style: TextStyle(
          color: dialogTitleCol,
        ),
      ),

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        content: ChangeTotal(price: price),

      ),
    );
  }


  showTypeDialog() {
    showDialog(
      barrierDismissible: true,
      context: navigatorKey.currentContext!,
      builder: (_) => AlertDialog(
        backgroundColor: dialogsCol,
        //title:Text('Choose Type'.tr),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        content: Builder(
          builder: (context) {
            return SizedBox(
              height: 100.h / 3,
             // width: 100.w  ,
              child: invoicesType(),
            );
          },
        ),
      ),
    );
  }
  invoicesType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 35.0),

          child:Text('Invoice type'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
            textStyle:  TextStyle(
                fontSize: 25  ,
                color:greenSwatch[50],
                fontWeight: FontWeight.w700
            ),
          ),),
        ),
        ListTile(
          title: Text('Multiple'.tr),
          onTap: () {
            Get.back();
            invType='Multiple';

            Get.to(()=>AddEditInvoice(),arguments: {'isAdd': true,'isVerified': false,});

          },
        ),
        const Divider(
          thickness: 1,
        ),
        ListTile(
          title: Text('Delivery'.tr),
          onTap: () {
            Get.back();
            invType='Delivery';
            Get.to(()=>AddEditInvoice(),arguments: {'isAdd': true,'isVerified': false,});

          },
        ),
        const Divider(
          thickness: 1,
        ),
        ListTile(
          title: Text('Client'.tr),
          onTap: () {
            Get.back();
            invType='Client';

            Get.to(()=>AddEditInvoice(),arguments: {'isAdd': true,'isVerified': false,});

          },
        ),
      ],
    );
  }



}