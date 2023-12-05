import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gajgaji/_models/buySellProd.dart';
import 'package:gajgaji/products/productsCtr.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_manager/bindings.dart';
import '../_manager/charts/chartsUi.dart';
import '../_manager/myLocale/myLocaleCtr.dart';
import '../_manager/myUi.dart';
import '../_manager/myVoids.dart';
import '../_manager/styles.dart';
import '../_models/prodChange.dart';

class ProductInfo extends StatefulWidget {
  const ProductInfo({super.key});

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> with TickerProviderStateMixin{

  late TabController _tcontroller;
  final List<String> titleList = [
    "History".tr,
    "Charts".tr,
    "Buy History".tr,
  ];
  String currentTitle = '';
  Map<String,dynamic> allItems = {};
  Map<String,dynamic> selectedMonthMap = {};
  String selectedMonth = '';

  double totalBuy = 0.0;
  double totalIncome = 0.0;
  double totalSell = 0.0;
  int totalSelledQty = 0;
  int totalPurchasedQty = 0;
  List<double> sellList =[];
  List<double> incomeList =[];
  List<double> qtyList =[];
  List<String> dates =[];

  // /////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();

    print('## init <ProductInfo>');
    currentTitle = titleList[0];//initial tab
    _tcontroller = TabController(length: 2, vsync: this);
    _tcontroller.addListener(changeTitle);//listen to tab changes

    allItems=prdCtr.selectedProd.allItems;
    print('## <ProductInfo>(${prdCtr.selectedProd.name}) ## allItems: (${allItems.length})${allItems.keys.toList()} ');

    if(allItems.isNotEmpty) {
      selectMonth(allItems.keys.first);
      //Future.delayed(Duration(milliseconds: 0),(){selectMonth(allItems.keys.first);});


    }

  }

  @override
  void dispose() {
    _tcontroller.dispose();
    super.dispose();
  }
  void changeTitle() {
    setState(() {
      // get index of active tab & change current appbar title
      currentTitle = titleList[_tcontroller.index];
      // if(currentTitle == titleList[1]){//exp
      //
      //   prdCtr.isSell=true;
      // }else{//
      //   prdCtr.isSell=false;
      //
      // }
    });
  }

  selectMonth(String month){
   /// debugPrint('## select: [$month] ${printFormattedJson(allItems[month])}');

    selectedMonth = month;

    selectedMonthMap = {};
    selectedMonthMap = Map.from(allItems[month]);

    totalBuy = selectedMonthMap['totalBuy']??0.0;
    totalIncome = selectedMonthMap['totalIncome']??0.0;
    totalSell = selectedMonthMap['totalSell']??0.0;
    totalSelledQty = selectedMonthMap['totalSelledQty']??0;
    totalPurchasedQty = selectedMonthMap['totalPurchasedQty']??0;

    List<String> l0 = selectedMonthMap['sellList'] ?? [];
    sellList = convertStringListToDoubleList(l0.reversed.toList());

    List<String> l1 = selectedMonthMap['incomeList']?? [];
    incomeList = convertStringListToDoubleList(l1.reversed.toList());

    List<String> l2 = selectedMonthMap['qtyList']?? [];
    qtyList = convertStringListToDoubleList(l2.reversed.toList());

    List<String> l3 = selectedMonthMap['timeList']?? [];
    List<String> timesList = l3.reversed.toList();
    dates = [];
    timesList.forEach((time) {
      dates.add(getDayString(time));
    });
    ///print('## dates = "$dates" sellList = "${sellList.length}" ');


    //remove these keys
    selectedMonthMap.remove('totalBuy');
    selectedMonthMap.remove('totalIncome');
    selectedMonthMap.remove('totalSell');
    selectedMonthMap.remove('totalSelledQty');
    selectedMonthMap.remove('totalPurchasedQty');
    selectedMonthMap.remove('sellList');
    selectedMonthMap.remove('incomeList');
    selectedMonthMap.remove('qtyList');
    selectedMonthMap.remove('timeList');


    setState(() {

    });
  }


  //#########################################################################
  //#########################################################################

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,/// tab length
      child: Scaffold(

        appBar: AppBar(
          bottom: TabBar(
            indicatorWeight: 4,
            controller: _tcontroller,
            isScrollable: false,
            tabs: [
              Tab(icon: Icon(Icons.shopping_cart_outlined)),//info
              Tab(icon: FaIcon(Icons.show_chart),),//expenses
              //Tab(icon: Icon(Icons.money_off_csred_outlined),),//kridi
            ],
          ),
          //automaticallyImplyLeading: false,
          elevation: 4,
          //backgroundColor: appbarColor,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Text(currentTitle,
                textAlign: TextAlign.center,
                ),
          ),
          actions: <Widget>[
            GetBuilder<ProductsCtr>(
              //id:'appBar',
                builder: (gc) {
                  //&& chCtr.selectedServer != ''
                  return allItems.isNotEmpty ? Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: DropdownButton<String>(
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      underline: Container(),
                      dropdownColor:dropDownCol ,
                      // value:(gc.selectedServer!='' && gc.myPatients.isNotEmpty)? gc.myPatients[gc.selectedServer]!.name : 'no patients',
                      value: selectedMonth,
                      //value:'name',
                      items: allItems.keys.map((String month) {
                        return DropdownMenuItem<String>(
                          value: month,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                month,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (month) {
                        if(month != selectedMonth){
                          selectMonth(month!);

                          Future.delayed(const Duration(milliseconds: 200), () {
                            setState(() {});
                          });
                        }


                      },
                    ),
                  )
                      : Container();
                }),
          ],
        ),
        body: TabBarView(
          controller: _tcontroller,
          children: [

            /// Sell BUY MANUAL /////////////////////////////////////////////////////////////////////////////////////////////////////////
            (selectedMonthMap.isNotEmpty) ? ListView.builder(
                //physics: const NeverScrollableScrollPhysics(),
                itemExtent: 130,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                shrinkWrap: true,
                reverse: false,
                itemCount: selectedMonthMap.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = selectedMonthMap.keys.elementAt(index);

                  removeItemByKey(k){
                    selectedMonthMap.remove(k);
                    setState(() {});
                  }
                  if(key.startsWith("0m")) {//manual
                    ProdChange prodChange = ProdChange.fromJson(selectedMonthMap[key]);
                    return manualProdChangeCard(key, prodChange,whenRemove: (){removeItemByKey(key);});
                  }else { // buy(0b) & sell(0s)
                    BuySellProd prod = BuySellProd.fromJson(selectedMonthMap[key]);
                    return bsProdCard(key, prod,whenRemove: (){removeItemByKey(key);});
                  }

                }
            ):Padding(
              padding: EdgeInsets.only(top: 35.h),
              child: Text('no Transactions found'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
                textStyle:  TextStyle(
                    fontSize: 23  ,
                    color: Colors.white,
                    fontWeight: FontWeight.w700
                ),
              )),
            ),
            /// Charts /////////////////////////////////////////////////////////////////////////////////////////////////////////
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //chart sells incomes
                  SizedBox(
                    //height: 50.h,
                    child: (selectedMonthMap.length > 1) ? chartGraphValues(
                      valueInterval: 20,
                      graphName: 'sells & incomes'.tr,
                      dataList: [],
                      // list { 'time':25, 'value':147 }
                      timeListX: dates,
                      //list [25,26 ..] // X
                      valListY: [sellList,incomeList],
                      chartsColors: [totalCol,winIncomeCol],// this should math the valListY in length and order
                      //list [147,144 ..] // Y
                      // minGraph: getDoubleMinValue(invCtr.incomes) - 500,
                      minGraph: -1000000,
                      //maxGraph: (getDoubleMaxValue(invCtr.totals) + 500).toInt().toDouble(),
                      maxGraph: 10000000,
                      extraMinMax: 300.0,
                      width: selectedMonthMap.length >15 ? selectedMonthMap.length / 15:1,//multiplied by 100.w
                    )
                        : Center(
                      child: Text('no charts data to show'.tr,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.indieFlower(
                            textStyle: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.w700),
                          )),
                    ),
                  ),
                  //chart qty
                  SizedBox(
                    //height: 50.h,
                    child: (selectedMonthMap.length > 1) ? chartGraphValues(
                      valueInterval: 20,
                      graphName: 'Quantity'.tr,
                      dataList: [],
                      withRedLine: false,
                      // list { 'time':25, 'value':147 }
                      timeListX: dates,
                      //list [25,26 ..] // X
                      valListY: [qtyList],
                      chartsColors: [totalCol],// this should math the valListY in length and order
                      //list [147,144 ..] // Y
                      // minGraph: getDoubleMinValue(invCtr.incomes) - 500,
                      minGraph: 0,
                      //maxGraph: (getDoubleMaxValue(invCtr.totals) + 500).toInt().toDouble(),
                      maxGraph: 10000,
                      extraMinMax: 300.0,
                      width: selectedMonthMap.length >15 ? selectedMonthMap.length / 15:1,//multiplied by 100.w
                    )
                        : Center(
                      child: Text('no charts data to show'.tr,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.indieFlower(
                            textStyle: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.w700),
                          )),
                    ),
                  ),

                  SizedBox(height: 10),
                  //buy
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
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
                            text: 'Total Buy:'.tr,
                            style: GoogleFonts.almarai(
                              height: 1,
                              textStyle: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                            )),
                        TextSpan(
                            text: '  ${formatNumberAfterComma2(totalBuy)}',
                            style: GoogleFonts.almarai(
                              height: 1,
                              textStyle: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
                            )),
                        TextSpan(
                            text: '  $currency',
                            style: GoogleFonts.almarai(
                              height: 1,
                              textStyle:
                              const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                            )),

                        /// buy qty
                        TextSpan(
                            text: '  /  Qty:'.tr,
                            style: GoogleFonts.almarai(
                              height: 1,
                              textStyle: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                            )),
                        TextSpan(
                            text: '  ${totalPurchasedQty}',
                            style: GoogleFonts.almarai(
                              height: 1,
                              textStyle: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
                            )),
                      ]),
                    ),
                  ),
                  //sell
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
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
                            text: 'Total Sell:'.tr,
                            style: GoogleFonts.almarai(
                              height: 1,
                              textStyle: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                            )),
                        TextSpan(
                            text: '  ${formatNumberAfterComma2(totalSell)}',
                            style: GoogleFonts.almarai(
                              height: 1,
                              textStyle: TextStyle(color: totalCol, fontSize: 18, fontWeight: FontWeight.w500),
                            )),
                        TextSpan(
                            text: '  $currency',
                            style: GoogleFonts.almarai(
                              height: 1,
                              textStyle:
                              const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                            )),
                        /// qty sell

                        /// buy qty
                        TextSpan(
                            text: '  /  Qty:'.tr,
                            style: GoogleFonts.almarai(
                              height: 1,
                              textStyle: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                            )),
                        TextSpan(
                            text: '  ${totalSelledQty}',
                            style: GoogleFonts.almarai(
                              height: 1,
                              textStyle: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
                            )),
                      ]),
                    ),
                  ),
                  //income
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
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
                            text: 'Total Income:'.tr,
                            style: GoogleFonts.almarai(
                              height: 1,
                              textStyle: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                            )),
                        TextSpan(
                            text: '  ${formatNumberAfterComma2(totalIncome)}',
                            style: GoogleFonts.almarai(
                              height: 1,
                              textStyle: TextStyle(color: winIncomeCol, fontSize: 18, fontWeight: FontWeight.w500),
                            )),
                        TextSpan(
                            text: '  $currency',
                            style: GoogleFonts.almarai(
                              height: 1,
                              textStyle:
                              const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                            )),
                      ]),
                    ),
                  ),
                  SizedBox(height: 40),

                ],
              ),
            ),
            /// Buy /////////////////////////////////////////////////////////////////////////////////////////////////////////
          //Container(),
          ],
        ),
        //##########################################################################
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        // floatingActionButton:Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20),
        //   child: Align(
        //     alignment: Alignment.bottomRight,
        //     child: Container(
        //       height: 40.0,
        //       width: 130.0,
        //       child: FittedBox(
        //         child: currentTitle == titleList[0]? FloatingActionButton.extended(
        //           onPressed: () {
        //             /// change price and qty
        //             prdCtr.addProductDialog(isAdd: false);
        //
        //           },
        //           heroTag: 'edit',
        //           backgroundColor: yellowColHex,
        //           label: Row(
        //             children: [
        //               const Icon(Icons.edit),
        //               const SizedBox(width: 5),
        //               Text(
        //                 "Edit".tr,
        //                 style: TextStyle(color: Theme.of(context).backgroundColor),
        //               ),
        //             ],
        //           ),
        //         ):FloatingActionButton.extended(
        //           onPressed: () {
        //
        //             if(prdCtr.isSell){//sell
        //               showAnimDialog(prdCtr.addBSProductDialog(isSell: true));
        //
        //             }else{//buy
        //               showAnimDialog(prdCtr.addBSProductDialog(isSell: false));
        //
        //             }
        //           },
        //           heroTag: 'addItem',
        //           backgroundColor: yellowColHex,
        //           label: Row(
        //             children: [
        //               const Icon(Icons.add),
        //               const SizedBox(width: 5),
        //               Text(
        //                 "Add".tr,
        //                 style: TextStyle(color: Theme.of(context).backgroundColor),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}



// customStreamBuilder(
// stream:productsColl.where('id', isEqualTo: prdCtr.selectedProd.id!).snapshots() ,
// hasDataWidget: ( snapshotData) {
// var model = snapshotData.docs.first;
// Map<String, dynamic> mapList = model.get('buyHis');
// mapList = orderMapByTime(mapList);
//
// //print('## $mapList');
// return  (mapList.isNotEmpty)
// ? ListView.builder(
// physics: const NeverScrollableScrollPhysics(),
//
// itemExtent: 130,
// padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
// shrinkWrap: true,
// reverse: false,
// itemCount: mapList.length,
// itemBuilder: (BuildContext context, int index) {
// String key = mapList.keys.elementAt(index);
// BuySellProd prod = BuySellProd.fromJson(mapList[key]);
// return bsProdCard(key, prod);
// }
// ):Padding(
// padding: EdgeInsets.only(top: 35.h),
// child: Text('no Buy history found'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
// textStyle:  TextStyle(
// fontSize: 23  ,
// color: Colors.white,
// fontWeight: FontWeight.w700
// ),
// )),
// );
// },
// ),