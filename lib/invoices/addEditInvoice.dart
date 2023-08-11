import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gajgaji/_manager/bindings.dart';
import 'package:gajgaji/_manager/myVoids.dart';
import 'package:gajgaji/_models/invoice.dart';
import 'package:gajgaji/_models/product.dart';
import 'package:gajgaji/invoices/invoiceCtr.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_manager/firebaseVoids.dart';
import '../_manager/myLocale/myLocaleCtr.dart';
import '../_manager/myUi.dart';
import '../_manager/styles.dart';
import '../_models/invProd.dart';
import '../_models/worker.dart';
import '../x_printPdf/app.dart';

class AddEditInvoice extends StatefulWidget {
  const AddEditInvoice({super.key});

  @override
  State<AddEditInvoice> createState() => _AddEditInvoiceState();
}

class _AddEditInvoiceState extends State<AddEditInvoice> {
  bool isAdd = Get.arguments['isAdd'];
  bool isVerified = Get.arguments['isVerified'];

  double spaceFields = 25;




  @override
  void initState() {
    super.initState();

    invCtr.productsOfAddingCard = prdCtr.productsList.where((product) => product.currQty! > 0).toList();

    if(!isAdd){

      invCtr.invType = invCtr.selectedInvoice.type!;

      invCtr.resetAddINvoice();

      invCtr.deliveryNameTec.text = invCtr.selectedInvoice.deliveryName!;
      invCtr.deliveryTruckNumTec.text = invCtr.selectedInvoice.deliveryTruckNum!;
      invCtr.deliveryPhoneTec.text = invCtr.selectedInvoice.deliveryPhone!;
      invCtr.deliveryEmailTec.text = invCtr.selectedInvoice.deliveryEmail!;
      invCtr.deliveryAddressTec.text = invCtr.selectedInvoice.deliveryAddress!;

      if(invCtr.selectedInvoice.verified!){
        invCtr.convertInvProdsMapToList(invCtr.selectedInvoice.productsReturned!);

      }else{
        invCtr.convertInvProdsMapToList(invCtr.selectedInvoice.productsOut!);

      }

      invCtr.refreshInvProdsTotals();    //init products list
      invCtr.update(['addedProds']);

      //print('## ${invCtr.InvProdsAdded}');

    }else{
      invCtr.selectInvoice(Invoice());
      invCtr.resetAddINvoice();

      //invCtr.outIncomeTotal = invCtr.selectedInvoice.

    }


    //init adding card
    invCtr.initAddingCard();
  }


  //###############################################################"
  //###############################################################"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: backGroundTemplate(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Form(
                  key:  invCtr.addEditInvoiceKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          child: Text(
                           //isAdd? 'New Invoice'.tr : isVerified? 'Verified Invoice'.tr : 'Returned Invoice'.tr,
                          '${ isAdd?  invCtr.invType:invCtr.selectedInvoice.type} Invoice'.tr,
                            style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 35,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Container(
                          child: Text(
                           isAdd? ''.tr : isVerified? 'Time: ${invCtr.selectedInvoice.timeReturn}'.tr : 'Time: ${invCtr.selectedInvoice.timeOut}'.tr,
                            style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                        SizedBox(
                          height: 40,
                        ),

                        /// /////////////////////////////////

                        //name
                        if(invCtr.selectedInvoice.deliveryName !='' && !isAdd || isAdd )  Padding(
                          padding:  EdgeInsets.only(bottom: spaceFields),
                          child: customTextField(
                            controller: invCtr.deliveryNameTec,
                            labelText: 'delivery name'.tr,
                            hintText: 'Enter name'.tr,
                            icon: Icons.person,
                            enabled: isAdd,

                            validator: (value) {
                              if (value!.isEmpty) {
                                return "name can't be empty".tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        //phone
                        if(invCtr.selectedInvoice.deliveryPhone !='' && !isAdd || isAdd ) Padding(
                          padding:  EdgeInsets.only(bottom: spaceFields),
                          child: customTextField(
                            textInputType: TextInputType.phone,
                            controller: invCtr.deliveryPhoneTec,
                            labelText: 'delivery phone'.tr,
                            hintText: 'Enter phone'.tr,
                            icon: Icons.phone,
                            enabled: isAdd,

                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return "phone can't be empty".tr;
                            //   } else {
                            //     return null;
                            //   }
                            // },
                          ),
                        ),
                        if(invCtr.selectedInvoice.deliveryAddress !='' && !isAdd || isAdd ) Padding(
                          padding:  EdgeInsets.only(bottom: spaceFields),
                          child: customTextField(
                            controller: invCtr.deliveryAddressTec,
                            enabled: isAdd,

                            labelText: 'Address'.tr,
                            hintText: 'Enter address'.tr,
                            icon: Icons.location_city,

                          ),
                        ),

                        //email
                         if(invCtr.selectedInvoice.deliveryEmail !='' && !isAdd || isAdd ) Padding(
                           padding:  EdgeInsets.only(bottom: spaceFields),
                           child: customTextField(
                            controller: invCtr.deliveryEmailTec,
                            textInputType: TextInputType.emailAddress,
                            enabled: isAdd,

                            labelText: 'delivery email'.tr,
                            hintText: 'Enter email'.tr,
                            icon: Icons.email,
                        ),
                         ),

                        //truck
                       if(invCtr.selectedInvoice.deliveryTruckNum !='' && !isAdd || isAdd ) Padding(
                         padding:  EdgeInsets.only(bottom: spaceFields),
                         child: customTextField(
                            controller: invCtr.deliveryTruckNumTec,
                            textInputType: TextInputType.text,
                            labelText: 'Truck number'.tr,
                            hintText: 'Enter number'.tr,
                            enabled: isAdd,

                            icon: Icons.fire_truck,
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return "truck number can't be empty".tr;
                            //   } else {
                            //     return null;
                            //   }
                            // },
                          ),
                       ),

                        /// /////////////////////////////////

                        SizedBox(height: 8.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: dividerColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Products'.tr,
                                style: TextStyle(color: Colors.white, fontSize: 19),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: dividerColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spaceFields),

                        /// ///////// added prods list ///////////////////
                        GetBuilder<InvoicesCtr>(
                          id: 'addedProds',
                          builder: (ctr) {
                          return Column(
                            children: List.generate(invCtr.invProdsList.length, (index) {
                              return invAddedCard(prodAdded:invCtr.invProdsList[index],index: index ,canRemove:  isAdd, editable: (!isAdd && !invCtr.selectedInvoice.verified!) );//make the key of map as index
                            }),
                          );
                        }
                      ),

                        /// ///////// adding card /////////////////////////
                        if(isAdd ) GetBuilder<InvoicesCtr>(
                           id: 'addingCard',
                           builder: (ctr) {
                             return invCtr.productsOfAddingCard.isNotEmpty? invAddingCard():Container();
                           }
                         ),

                        /// /////////////////////////////////////////////////
                        SizedBox(height: 20),


                        // ListView.builder(
                        //     //physics: const NeverScrollableScrollPhysics(),
                        //
                        //     itemExtent: 130,
                        //     padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        //     shrinkWrap: true,
                        //     reverse: true,
                        //     //itemCount: invCtr.InvProdsAdded.length,
                        //     itemCount:3,
                        //     itemBuilder: (BuildContext context, int index) {
                        //       //InvProd invProd = invCtr.InvProdsAdded[index];/// change
                        //       return invToAddCard();/// change
                        //     }
                        // ),

                        ///Button add / update
                       if(!isVerified) Container(
                          //color: Colors.red,
                          width: 90.w,
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(

                              elevation: 0.1,
                              side: const BorderSide(width: 1.5, color: Colors.white),
                              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if(isAdd) {
                            invCtr.addInvoice();
                          } else {
                              invCtr.checkInvoice();
                          }
                        },
                            child: Text(
                              isAdd? "Send Invoice".tr:"Check Invoice".tr,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        GetBuilder<InvoicesCtr>(
                          id: 'invTotal',
                          builder: (ctr) {
                           Color incomeCol = invCtr.outIncomeTotal > 0.0 ? winIncomeCol : looseIncomeCol;


                            return Column(
                              children: [
                                ///sell
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: RichText(
                                    locale: Locale(currLang!),
                                    textAlign: TextAlign.start,
                                    //softWrap: true,
                                    text: TextSpan(children: [
                                      WidgetSpan(
                                          child: SizedBox(
                                            width: 0,
                                          )),
                                      TextSpan(
                                          text: 'invoice outSell:',

                                          style: GoogleFonts.almarai(

                                            height: 1.8,
                                            textStyle: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )),
                                      TextSpan(
                                          text: ' ${formatNumberAfterComma2(invCtr.outSellTotal)} ',

                                          style: GoogleFonts.almarai(

                                            height: 1.8,
                                            textStyle:  TextStyle(
                                                color: invCtr.outSellCol,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )),


                                      ///currency
                                      TextSpan(
                                          text: '  $currency',
                                          style: GoogleFonts.almarai(
                                            height: 1.8,
                                            textStyle: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )),


                                    ]),
                                  ),
                                ),

                                ///buy
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: RichText(
                                    locale: Locale(currLang!),
                                    textAlign: TextAlign.start,
                                    //softWrap: true,
                                    text: TextSpan(children: [
                                      WidgetSpan(
                                          child: SizedBox(
                                            width: 0,
                                          )),
                                      TextSpan(
                                          text: 'invoice outBuy:',

                                          style: GoogleFonts.almarai(

                                            height: 1.8,
                                            textStyle: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )),
                                      TextSpan(
                                          text: ' ${formatNumberAfterComma2(invCtr.outBuyTotal)} ',

                                          style: GoogleFonts.almarai(

                                            height: 1.8,
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )),

                                      ///currency
                                      TextSpan(
                                          text: '  $currency',
                                          style: GoogleFonts.almarai(
                                            height: 1.8,
                                            textStyle: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )),


                                    ]),
                                  ),
                                ),

                                ///income
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: RichText(
                                    locale: Locale(currLang!),
                                    textAlign: TextAlign.start,
                                    //softWrap: true,
                                    text: TextSpan(children: [
                                      WidgetSpan(
                                          child: SizedBox(
                                            width: 0,
                                          )),

                                      TextSpan(
                                          text: 'invoice income:',

                                          style: GoogleFonts.almarai(

                                            height: 1.8,
                                            textStyle:  TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )),
                                      TextSpan(
                                          text: ' ${formatNumberAfterComma2(invCtr.outIncomeTotal)}',


                                          style: GoogleFonts.almarai(

                                            height: 1.8,
                                            textStyle:  TextStyle(
                                                color: incomeCol,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )),
                                      TextSpan(
                                          text: '  $currency',
                                          style: GoogleFonts.almarai(
                                            height: 1.8,
                                            textStyle: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )),


                                    ]),
                                  ),
                                ),
                              ],
                            );
                          }
                        ),
                        SizedBox( height:20),

                      ],
                    ),
                  ),
                ),
              ),
              /// back_btn
              Positioned(
                top: 25,
                left: 5,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 35,
                        height: 35,
                        color: Colors.transparent,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      //color: yellowColHex,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      /// BUTTONS
      floatingActionButton: !isAdd ? Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () {
                Get.to(()=>PrintScreen());

              },
              backgroundColor: Colors.yellowAccent.withOpacity(0.2),
              heroTag: null,
              child: const Icon(Icons.print),
            ),
            if(!isVerified) FloatingActionButton(
              onPressed: () {
                //change outsell
                invCtr.changeTotalSellDialog(price: invCtr.outSellTotal);

              },
              backgroundColor: Colors.blue.withOpacity(0.3),
              heroTag: null,
              child: const Icon(Icons.currency_exchange),
            ),
          ],
        ),
      ):null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    
    );
    
  }
}
