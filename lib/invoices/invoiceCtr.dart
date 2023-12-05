

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
  int invCount =0;
  List<Invoice> notCheckedSellInvoices = [];
  List<Invoice> notCheckedBuyInvoices = [];
  List<Invoice> orderedInvs =[];//once when loaded
  bool isBuy = false;

  InvProd addingCardInvProd = InvProd();//current adding invProd (AddingCard)
  Product addingCardProd = Product();//selected product of dropDown in "AddingCard"
  List<InvProd> invProdsList = [];//added prods list those which was an "AddingCard"
  List<Product>  productsOfAddingCard= [];//available dropdown prods can be  chosen in "AddingCard"
  Map<String,dynamic> invProdsMap ={}; // "invProdsList" converted to map to add it to fb
  String invType = ''; // Multiple, delivery , client

  Map<String, Map<String,dynamic>> allItems={}; //


  
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

  GlobalKey<FormState> invToAddKey = GlobalKey<FormState>();// price / qty in adding card
  final addingPriceTec = TextEditingController();
  final addingQtyTec = TextEditingController();

  GlobalKey<FormState> addEditInvoiceKey = GlobalKey<FormState>();
  final deliveryNameTec = TextEditingController();
  final deliveryTruckNumTec = TextEditingController();
  final deliveryPhoneTec = TextEditingController();
  final deliveryEmailTec = TextEditingController();
  final deliveryAddressTec = TextEditingController();
  final deliveryMatFisTec = TextEditingController();


  GlobalKey<FormState> treasuryKey = GlobalKey<FormState>();
  final treasuryTec = TextEditingController();

  @override
  onInit() {
    super.onInit();
    //print('## init HomeCtr');
    sharedPrefs!.reload();
    Future.delayed(const Duration(milliseconds: 50), ()  async {
      societyCash = await getFieldFromFirestore('prData','privateData','societyCash');
      update(['societyCash']);
      //print('## societyCash: $societyCash');
    });
  }

  /// /////////////////////////////////  Graph  ///////////////////////////////////
  refreshAllInvoices(List<Invoice> invoices){
    allItems ={};
    invoicesList = invoices;
    notCheckedSellInvoices = invoices.where((invoice) => (invoice.verified == false && invoice.isBuy==false)).toList();
    notCheckedBuyInvoices = invoices.where((invoice) => (invoice.verified == false && invoice.isBuy==true)).toList();
    prdCtr.refreshProducts(); //refrech products after refresh invoices

    print('## INVOICES ALL = [${invoicesList.length}]');
    print('## INVOICES<SELL> NOT VERIFIED = [${notCheckedSellInvoices.length}]');
    print('## INVOICES<BUY> NOT VERIFIED = [${notCheckedBuyInvoices.length}]');

// INIT /////////////////////////////////////

    // maybe name / type
    Map<String, dynamic> monthItems = {};
    String monthKey = '';
    //double monthTotalBuy = 0.0;
    double monthTotalSell = 0.0;
    double monthIncome = 0.0;
    //int monthQtySelled = 0;
    //int monthQtyPurchased = 0;
    List<String> monthTotalList = [];
    List<String> monthIncomeList = [];
    //List<String> monthQtyList = [];
    List<String> monthTimeList = [];
// //////////////////////////////////////////////////////


    addToMonthsMap(int index, Invoice inv) {
      monthItems[index.toString()] = inv;


      double singleTotal = (inv.returnTotal ?? 0).toDouble();
      double singleIncome = (inv.income ?? 0).toDouble();


      monthTotalSell += singleTotal; //double
      monthIncome += singleIncome;//double
      monthTotalList.add(singleTotal.toString());//list
      monthIncomeList.add(singleIncome.toString());//list
      monthTimeList.add(inv.timeReturn!);//list



    }

// //////////////////////////////////////////////////////

    passToNewMonth() {
      //double
      monthItems['totalIncome'] = monthIncome;
      monthItems['totalSell'] = monthTotalSell;
      //lists
      monthItems['sellList'] = monthTotalList;
      monthItems['incomeList'] = monthIncomeList;
      monthItems['timeList'] = monthTimeList;
      //print('## [$monthKey] => ${monthItems.length-5} INVOICES');
      allItems[monthKey] = monthItems; //add month

      // //// CLEAR //////////////////////
      monthKey = '';
      monthTotalSell = 0.0;
      monthIncome = 0.0;

      monthIncomeList =[];
      monthTotalList =[];
      monthTimeList =[];

      monthItems ={};
    }
/// //////////////////////////////////////////////////////
    for(int i = 0; i < invoicesList.length; i ++) {

      Invoice currInv = invoicesList[i];


        String entryMonth = getMonthString(currInv.timeReturn!);
        String entryYear = getYearString(currInv.timeReturn!);

        if (i == 0) {// first card /last time
          monthKey = '$entryMonth $entryYear';
          addToMonthsMap(i, currInv); //
        } else {
          Invoice prevInv = invoicesList[i - 1];

          String currMonth =getMonthString(currInv.timeReturn!) ;
          String prevMonth = getMonthString(prevInv.timeReturn!);
          if ( currMonth == prevMonth ) {//same month
            ///print('## INDEX [ $index ] SAME month [ $currMonth - $prevMonth ]');
            addToMonthsMap(i, currInv); //

          } else {//new month //pass to new month
            ///print('## INDEX [ $index ] DIFF month ********** [ $currMonth - $prevMonth ]');

            passToNewMonth();

            // //////////////////////

            monthKey = '$entryMonth $entryYear';
            addToMonthsMap(i, currInv); //
          }
          if(i == invoicesList.length - 1){
            ///print('## LAST-CARD ');
            passToNewMonth();

          }
        }

    }




    //debugPrint('## ALL INVOICES => (${invoicesList.length}) ##  ${printFormattedJson(allItems)}');



  }

  //get data for graphs
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

  /// ///////////////////////////////////////////////////////////////////////////////




  /// /////////////////////////////////  ADD   ////////////////////////////////////////////:



  //add invoice to fb
  addSellInvoice(){

    if (addEditInvoiceKey.currentState!.validate()) {

      if(invProdsList.isEmpty) {
        showSnack('you have to add at least one product'.tr,color: Colors.black38.withOpacity(0.8));
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
            deliveryMatFis: deliveryMatFisTec.text,

            productsOut: invProdsMap,// prods map
            outTotal: isBuy ? -1*outBuyTotal:outSellTotal,// add to user cz its sell
            timeOut: todayToString(),
            timeReturn: todayToString(),
            verified: false,
            totalChanged: false,
            isBuy: isBuy,
            type: invType,
            index: (invCtr.invCount+1).toString(),
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
              invCtr.invCount++;
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
            print("## Failed to add invoice: $error");
          });

        }
      });

    }
  }

  //zeroi fields
  resetAddINvoice(){

    deliveryNameTec.text = '';
    deliveryTruckNumTec.text = '';
    deliveryPhoneTec.text = '';
    deliveryEmailTec.text = '';
    deliveryAddressTec.text = '';
    deliveryMatFisTec.text = '';

    invProdsList.clear();
    update(['addedProds']);
    outIncomeTotal = 0.0;
    outSellTotal = 0.0;
    outBuyTotal = 0.0;
    sliderVal = 20.0;
    isBuy= false;


    //productsOfAddingCard = prdCtr.productsList;/// init all products

    initAddingCard();
    invProdsMap.clear();
  }

  //reset the adding card values exmp 'select first product in dropdowwn'
  initAddingCard(){
    addingCardInvProd = InvProd();

    addingCardProd = (productsOfAddingCard.isNotEmpty ? productsOfAddingCard[0] : Product());

    if(isBuy) {
      invCtr.maxQty = 20000;
      invCtr.productsOfAddingCard = prdCtr.productsList.toList();//show only prods that have qty

    }else{
      invCtr.maxQty = addingCardProd.currQtyReduced!.toDouble();
      invCtr.productsOfAddingCard = prdCtr.productsList.where((product) => product.currQty! > 0).toList();//show only prods that have qty

    }

    invCtr.sliderVal = 0.0;

    //addingQtyTec.text = addingCardProd.currQty.toString();//selected Prod => textField (qty)
    addingQtyTec.text = '0';
    if(isBuy) {
      addingPriceTec.text = addingCardProd.currBuyPrice!.toInt().toString();
    }else{
      addingPriceTec.text = addingCardProd.currPrice!.toInt().toString();//selected Prod => textField (price)
    }

    updateAddingCard(updatePriceField: true);
    invCtr.update(['addingCard']);

  }

  //update that card of adding products every time we change price,qty or move slider or change prod in dropdown
  updateAddingCard({bool updatePriceField = false}){
    InvProd invProd = invCtr.addingCardInvProd;


    ///just at first when init the adding card
    if(updatePriceField) {

      //init qty txtF
      addingQtyTec.text ='0';
      //addingQtyTec.text = invCtr.addingCardProd.currQty.toString();//selected Prod => textField (qty)

      //init buy
      invProd.priceBuy = invCtr.addingCardProd.currBuyPrice;//from dropDown
      invProd.priceSell = invCtr.addingCardProd.currPrice;//from dropDown

      //init price txtF
      if(!isBuy){
        addingPriceTec.text = invCtr.addingCardProd.currPrice!.toInt().toString(); //selected Prod => textField (qty)
      }else{
        addingPriceTec.text = invCtr.addingCardProd.currBuyPrice!.toInt().toString(); //selected Prod => textField (qty)
      }
    }

    if (invToAddKey.currentState != null && invToAddKey.currentState!.validate()) {
      invProd.qty = int.tryParse(invCtr.addingQtyTec.text) ?? 0;
      if(!isBuy){
        invProd.priceSell = double.tryParse(invCtr.addingPriceTec.text) ?? 0.0;
      }else{
        invProd.priceBuy = double.tryParse(invCtr.addingPriceTec.text) ?? 0.0;

      }
    }


    invProd.name = invCtr.addingCardProd.name;//from dropDown
    //invProd.priceBuy = invCtr.addingCardProd.currBuyPrice;//from dropDown

    invProd.totalBuy =  invProd.qty! * invProd.priceBuy!;
    invProd.totalSell =  invProd.qty! * invProd.priceSell!; //not used if "isBuy"
    invProd.income = invProd.totalSell! - invProd.totalBuy!; //not used if "isBuy"

    //sliderVal= invProd.qty!.toDouble();//update slider with (qty)


    //#####
    invCtr.addingCardInvProd = invProd;
    update(['addingCard']);

  }

  // arrow in adding card
  addInvProdToList(){
    if (invToAddKey.currentState != null && invToAddKey.currentState!.validate() ) {

      invProdsList.add(addingCardInvProd);
      update(['addedProds']);
      refreshInvProdsTotals();//calculate total buy sell income
      //print('## invProds map length (prods added in invoice): ${invProdsList.length}');
      String productNameToRemove = addingCardInvProd.name!;
      productsOfAddingCard.removeWhere((product) => product.name == productNameToRemove);//to not show again in dropdown list

      /// reset adding card REMOVING the added ones
      initAddingCard(); //after adding new addingCard
    }

  }

  //refresh total "sell,buy,inc" of inv (exmp: when add new prod)
  refreshInvProdsTotals({bool withSellTotal =true,bool withBuyTotal =true}){

    if(withSellTotal) outSellTotal = 0.0;
    if(withBuyTotal) outBuyTotal = 0.0;
    outIncomeTotal = 0.0;

    for (var invProd in invProdsList) {
      if(withSellTotal){
        outSellTotal += invProd.totalSell ?? 0.0;
        outSellCol = Colors.blue;
      }

      if(withBuyTotal){
        outBuyTotal += invProd.totalBuy ?? 0.0;

      }
      //outIncomeTotal += invProd.income ?? 0.0;
    }
    outIncomeTotal = outSellTotal - outBuyTotal;
    update(['invTotal']);

  }

  // invoice type dialog
  showTypeDialog() {
    return AlertDialog(
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
            Get.to(()=>AddEditInvoice(),arguments: {'isAdd': true,'isVerified': false,'isBuy': false,});

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
            Get.to(()=>AddEditInvoice(),arguments: {'isAdd': true,'isVerified': false,'isBuy': false,});

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

            Get.to(()=>AddEditInvoice(),arguments: {'isAdd': true,'isVerified': false,'isBuy': false,});

          },
        ),
      ],
    );
  }


  /// /////////////////////////////////  CHECK   ////////////////////////////////////////////

  //check inv this made to allow user to change prods price and qty he made
  checkSellInvoice(){
    bool once =true;
    showNoHeader(
      txt: 'Are you sure you want to check this invoice ?'.tr,
      icon: Icons.check,
      btnOkColor: Colors.green,
      btnOkText: 'Check'.tr,
    ).then((toAllow) {// if admin accept
      if (toAllow) {

        //check prods qty should not be less than 0
        for (InvProd invProd in invProdsList) {
          Product? foundProduct = prdCtr.productsList.firstWhere((product) => product.name == invProd.name, orElse: () => Product());

          if(foundProduct.currQty! - invProd.qty! < 0){
            showSnack('product <${foundProduct.name}> qty error'.tr,color:Colors.black54);
            //so either u change sell qty in inv or add new qty to product
            return;
          }
        }

        /// /////////////////////

        showLoading(text: 'Loading'.tr);
        convertInvProdsListToMap();
        Map<String, dynamic> invoiceToCheck = {
          //'timeReturn': todayToString(),
          'productsReturned': invProdsMap,
          'returnTotal': outSellTotal,
          'income': outIncomeTotal,
          'verified': true,
          'totalChanged': outSellTotal != selectedInvoice.outTotal,
        };

        /// check invoice to db
        updateDoc(
          fieldsMap: invoiceToCheck,
          collName: invoicesCollName,
          docID: invCtr.selectedInvoice.id!,
        ).then((value) {
          print('## ## inv<${selectedInvoice.index} / ${selectedInvoice.id}> CHECKED !!!');


          /// update society cash
          addSubSocietyCash(1 * outSellTotal);
          /// update each product with sellProc with FOR
          for (InvProd invProd in invProdsList) {
            Product? foundProduct = prdCtr.productsList.firstWhere((product) => product.name == invProd.name, orElse: () => Product());
            if(foundProduct.name != '') {
              //update prod qty & add history proc which is sell 'proc'
              prdCtr.addSellProc(
                  prod: foundProduct,
                  inputPrice: invProd.priceSell!,
                  chosenQty: invProd.qty!,
                  invID: invCtr.selectedInvoice.id!,
                  income: invProd.income!,
                  deliveryName: invCtr.selectedInvoice.deliveryName!
              );
              print('## product<${foundProduct.name}><SELL> added to history INFO');
            }else{
              showSnack('product<${foundProduct.name}><SELL> cant be added (empty)',color:Colors.black54);
              print('## product<${foundProduct.name}><SELL> cant be added to history INFO (empty)');
            }
          }
          Get.back(); /// --hide loading
          showSuccess(
              sucText: 'Invoice has been checked'.tr,
              btnOkPress: () {
                Get.back();//hide success
                Get.back();
              });
          /// refresg all products
          Future.delayed(const Duration(milliseconds: 2000), () {
            prdCtr.refreshProducts();
            update();
          });



        }).catchError((error) {
          print("## Failed to check invoice: $error");
        });

        /// //////////////////////


      }
    });


  }

  checkBuyInvoice(){
    bool once =true;
    showNoHeader(
      txt: 'Are you sure you want to check this invoice ?'.tr,
      icon: Icons.check,
      btnOkColor: Colors.green,
      btnOkText: 'Check'.tr,
    ).then((toAllow) {// if admin accept
      if (toAllow) {

        ///check prods qty should not be less than 0
        // for (InvProd invProd in invProdsList) {
        //   Product? foundProduct = prdCtr.productsList.firstWhere((product) => product.name == invProd.name, orElse: () => Product());
        //
        //   // if(foundProduct.currQty! - invProd.qty! < 0){
        //   //   showSnack('product <${foundProduct.name}> qty error'.tr,color:Colors.black54);
        //   //   //so either u change sell qty in inv or add new qty to product
        //   //   return;
        //   // }
        // }

        /// /////////////////////

        showLoading(text: 'Loading'.tr);
        convertInvProdsListToMap();
        Map<String, dynamic> invoiceToCheck = {
          //'timeReturn': todayToString(),
          'productsReturned': invProdsMap,//the new map after updating its products
          'returnTotal': -1*outBuyTotal,
          'income': 0,
          'verified': true,
          'totalChanged': outBuyTotal != selectedInvoice.outTotal,
        };

        /// check invoice to db
        updateDoc(
          fieldsMap: invoiceToCheck,
          collName: invoicesCollName,
          docID: invCtr.selectedInvoice.id!,
        ).then((value) {
          print('## ## inv<${selectedInvoice.index} / ${selectedInvoice.id}> CHECKED !!! ');


          /// update society cash
          addSubSocietyCash( outBuyTotal);
          /// update each product with sellProc with FOR
          for (InvProd invProd in invProdsList) {
            Product? foundProduct = prdCtr.productsList.firstWhere((product) => product.name == invProd.name, orElse: () => Product());
            if(foundProduct.name != '') {
              //update prod qty & add history proc which is sell 'proc'
              prdCtr.addBuyProc(///manual prod add qty <BUY>
                  prod: foundProduct,
                  inputPrice: invProd.priceBuy!,
                  chosenQty: invProd.qty!,
                  invID: invCtr.selectedInvoice.id!,
                  deliveryName: invCtr.selectedInvoice.deliveryName!
              );
              print('## product<${foundProduct.name}><BUY> added to history INFO');
            }else{
              showSnack('product<${foundProduct.name}><BUY> cant be added (empty)',color:Colors.black54);
              print('## product<${foundProduct.name}><BUY> cant be added to history INFO (empty)');
            }
          }
          Get.back(); /// --hide loading
          showSuccess(
              sucText: 'Invoice has been checked'.tr,
              btnOkPress: () {
                Get.back();//hide success
                Get.back();
              });
          /// refresg all products
          Future.delayed(const Duration(milliseconds: 2000), () {
            prdCtr.refreshProducts();
            update();
          });



        }).catchError((error) {
          print("## Failed to check invoice: $error");
        });

        /// //////////////////////


      }
    });


  }


  //change added single prod price/qty (waiting inv)
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


  //change total sell of inv (draft)
  changeTotalInvPrice(){
    if (invTotalSellKey.currentState!.validate()) {
      if(invCtr.selectedInvoice.isBuy!){
        outBuyTotal = double.tryParse(totalSellPriceTec.text) ?? 0.0;
        print('## outBuyTotal => ${outBuyTotal} ');
        refreshInvProdsTotals(withBuyTotal: false);

      }else{
        outSellTotal = double.tryParse(totalSellPriceTec.text) ?? 0.0;
        outSellCol = Colors.yellowAccent;
        print('## outSellTotal => ${outSellTotal} ');
        refreshInvProdsTotals(withSellTotal: false);

      }

      invCtr.update(['invTotal']);
      Get.back();
    }
  }


  /// change price or qty of added product  'DIALOG'
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

  /// change total sell of invoice  'DIALOG'
  changeTotalSellDialog({required double price}) {
    return AlertDialog(
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

    );
  }


  /// /////////////////////////////////  Remove   ////////////////////////////////////////////

  removeInvoice(Invoice inv) async {
    await showNoHeader(
    txt: 'Are you sure you want to remove this invoice ?'.tr,
    icon: Icons.close,
    btnOkColor: Colors.red,
    btnOkText: 'Remove'.tr,
    ).then((toAllow) {
      // if admin accept
      if (toAllow) {


        //if inv checked set back products qty of each one
        ///ASK for it in dialog
        if(inv.verified!) {
          showNoHeader(
            txt: 'Do you want to return the sold quantity ?'.tr,
            icon: Icons.history,
            btnOkColor: Colors.blueAccent,
            btnOkText: 'Get back'.tr,
          ).then((toGetBack) {
            if (toGetBack) {
              invCtr.addSubSocietyCash(-1 * inv.outTotal!);// return society cash

              List<InvProd> prods = invCtr.convertInvProdsMapToList(inv.productsReturned!);//convert prods map to InvProd list

              /// //////////////////////////////////////////////////////////////////////////////+
              /// update each product in inv to return its qty
              for (InvProd invProd in prods) {
                Product? foundProduct = prdCtr.productsList.firstWhere((product) => product.name == invProd.name, orElse: () => Product());
                if (foundProduct.name != '') {
                  prdCtr.addReturnProc(
                    prod: foundProduct,
                    chosenQty: invProd.qty!,
                    invID: inv.id!,
                    isBuyInv: inv.isBuy!,
                  );
                  print('## inv<${inv.id}> : product<${foundProduct.name}>qty<${invProd.qty!}>  returned');
                } else {
                  showSnack('product<${foundProduct.name}> cant be returned (empty)', color: Colors.black54);
                  print('## product<${foundProduct.name}> cant be returned (empty)');
                }
              }
              /// //////////////////////////////////////////////////////////////////////////////
              // delete inv doc
              deleteDoc(
                  docID: inv.id!,
                  coll: invoicesColl,
                  btnOnPress: () {
                    showSnack('${'invoice'.tr} "${inv.index}" ${'removed'.tr}',
                        color: Colors.redAccent.withOpacity(0.8));
                    invCtr.update();
                    invCtr.invCount--;

                  }
                  );
              Get.back();
            }
          });
        }
        else{//not verified
          // delete inv doc
          deleteDoc(
              docID: inv.id!,
              coll: invoicesColl,
              btnOnPress: () {
                showSnack('${'invoice'.tr} "${inv.index}" ${'removed'.tr}',
                    color: Colors.redAccent.withOpacity(0.8));
                invCtr.update();
                invCtr.invCount--;

              });
        }

        prdCtr.refreshProducts();
      }
    });
  }

  /// ////////////////////////////////////////////////////////////////////////////////////////

  /// convert Added Prods List
  // convert Map to List<invProdsList>
  List<InvProd> convertInvProdsMapToList(Map<String, dynamic>? productsRetunedOut){
    List<InvProd> list=[];
    /// convert map to list

    list = productsRetunedOut!.entries.map((entry) {
      int index = int.tryParse(entry.key) ?? 0;
      Map<String, dynamic> jsonData = entry.value as Map<String, dynamic>;
      return InvProd.fromJson(jsonData);
    }).toList();
    return list;
    ///make changes to list (add/edit Prods) then conv to map
  }

  // convert List<invProdsList> to Map
  convertInvProdsListToMap(){

    ///convert list to map
    invProdsMap = invProdsList.asMap().map((index, invProd) {
      return MapEntry(index.toString(), invProd.toJson());
    });
  }

  /// //////////////////////////////////////////////////////////////////////////////////////////










  /// change the amount in treasury
  changeTreasuryDialog({bool isExpense = true}) {
    treasuryTec.text = societyCash.toString();
    return AlertDialog(
      backgroundColor: dialogsCol,
      title: Text('Treasury: ${formatNumberAfterComma2(societyCash)} TND'.tr ,
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
          key: treasuryKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 20,),

              /// components

              customTextField(
                textInputType: TextInputType.number,
                controller: treasuryTec,
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
                        changeTreasury();
                      },
                      child: Text(
                        "Change".tr,
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


  //change amount in treasury
  changeTreasury(){
    if (treasuryKey.currentState!.validate()) {
      showLoading(text: 'Loading...'.tr);
      try {
        double parsedValue = double.parse(treasuryTec.text);
        updateFieldInFirestore('prData','privateData','societyCash',parsedValue,
            addSuccess: (){
              treasuryTec.clear();
              societyCash = parsedValue;
              update(['societyCash']);

              Get.back(); // hide loading
              Get.back();

            });
      } catch (e) {
        // Handle parsing error
        print('## Error parsing input as a double: $e');
      }



    }


  }
  addSubSocietyCash(double amount){
    societyCash += amount;
    updateFieldInFirestore('prData','privateData','societyCash',societyCash);
    update(['societyCash']);
  }






}