import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gajgaji/_models/buySellProd.dart';
import 'package:gajgaji/_models/invoice.dart';
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
import '../_models/product.dart';
import 'package:collection/collection.dart';
class InvoicesHistory extends StatefulWidget {
  const InvoicesHistory({super.key});

  @override
  State<InvoicesHistory> createState() => _InvoicesHistoryState();
}

class _InvoicesHistoryState extends State<InvoicesHistory> with TickerProviderStateMixin{

  late TabController _tcontroller;
  final List<String> titleList = [
    "History".tr,
    "Charts".tr,
  ];
  String currentTitle = '';
  Map<String,dynamic> allItems = {};
  Map<String,dynamic> selectedMonthMap = {};
  List<Invoice> monthInvoices =[];

  String selectedMonth = '';

  double totalIncome = 0.0;
  double totalSell = 0.0;

  List<String> sellList =[];
  List<String> incomeList =[];
  List<String> timeList =[];

  List<double> incomes =[];
  List<double> totals =[];
  List<String> dates =[];
  List<Product> allProdsMonth=[];
  // /////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();

    currentTitle = titleList[0];//initial tab
    _tcontroller = TabController(length: 2, vsync: this);
    _tcontroller.addListener(changeTitle);//listen to tab changes

    allItems=invCtr.allItems;
    if(allItems.isNotEmpty) {
      selectMonth(allItems.keys.first);
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
     debugPrint('## select: [$month] ');
     //debugPrint('## ${printFormattedJson(allItems[month])}');

    selectedMonth = month;

    selectedMonthMap ={};
    selectedMonthMap = Map.from(allItems[month]);
    totalIncome = selectedMonthMap['totalIncome']??0.0;
    totalSell = selectedMonthMap['totalSell']??0.0;

    //didnt use those
    // sellList = selectedMonthMap['sellList']??[];
    // incomeList = selectedMonthMap['incomeList']??[];
    // timeList = selectedMonthMap['timeList']??[];



    //remove these keys
    selectedMonthMap.remove('totalIncome');
    selectedMonthMap.remove('totalSell');

    selectedMonthMap.remove('sellList');
    selectedMonthMap.remove('incomeList');
    selectedMonthMap.remove('timeList');

    monthInvoices = selectedMonthMap.values.whereType<Invoice>().toList();
     totals = invCtr.extractTotals(monthInvoices.reversed.toList());
     incomes = invCtr.extractIncomes(monthInvoices.reversed.toList());
     dates = invCtr.extractDates(monthInvoices.reversed.toList());
    print('## select: [$month] => ${monthInvoices.length} INV ');

    // get top 5 products ////////////////////:
    //  List<double> totalSellList =[];
    //  List<double> totalIncomeList =[];
    //  List<int> totalQtyList =[];
    //  Map<String,dynamic> productsOrder ={};
     List<Product> allProds = prdCtr.productsList;
     allProdsMonth = [];
     for(int i = 0; i < allProds.length; i ++) {
       Map<String, dynamic> allItemsProd = allProds[i].allItems;

       if(allItemsProd.containsKey(month)){
         allProdsMonth.add(allProds[i]);
         // double prodTotal = allItemsProd[month]['totalSell']??0.0;
         // double prodIncome = allItemsProd[month]['totalIncome']??0.0;
         // int prodSelledQty = allItemsProd[month]['totalSelledQty']??0;

         //print('## ${allProds[i].name}: qty=  $prodSelledQty');

         // totalSellList.add(prodTotal);
         // totalIncomeList.add(prodIncome);
         // totalQtyList.add(prodSelledQty);
       }
     }
     allProdsMonth.sort((a, b) => (b.allItems[month]['totalSell'] ?? 0.0)
         .compareTo(a.allItems[month]['totalSell'] ?? 0.0));

     // List<double> totalss = [];
     // for (Product prd in allProdsMonth) {
     //   if (prd.allItems[month]['totalSell'] != null) {
     //     totalss.add(prd.allItems[month]['totalSell']!);
     //   }
     // }

     // 3 list choose order by what
     // totalSellList = sortDescending(totalSellList);
     // totalIncomeList = sortDescending(totalIncomeList);
     // totalQtyList = sortDescendingInt(totalQtyList);


     print('## [${allProds.length} all_PRODS]: [${allProds.length} ($month)_PRODS]:// ');



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
                //itemExtent: 130,
                padding: const EdgeInsets.only(top: 5,bottom:60, right: 15, left: 15,),
                shrinkWrap: true,
                reverse: false,
                itemCount: selectedMonthMap.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = selectedMonthMap.keys.elementAt(index);

                  //Invoice inv = Invoice.fromJson(selectedMonthMap[key]);
                    return invoiceCard(selectedMonthMap[key],int.parse(key));


                }
            ):Padding(
              padding: EdgeInsets.only(top: 35.h),
              child: Text('no Invoices found'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
                textStyle:  TextStyle(
                    fontSize: 23  ,
                    color: Colors.white,
                    fontWeight: FontWeight.w700
                ),
              )),
            ),
            /// Charts /////////////////////////////////////////////////////////////////////////////////////////////////////////
        (monthInvoices.length > 2) ?   SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //chart
              SizedBox(
                //height: 50.h,
                child: chartGraphValues(
                  valueInterval: 20,
                  graphName: 'sells & incomes'.tr,
                  dataList: [],
                  // list { 'time':25, 'value':147 }
                  timeListX: dates,
                  //list [25,26 ..] // X
                  valListY: [totals,incomes],
                  chartsColors: [totalCol,winIncomeCol],// this should math the valListY in length and order
                  //list [147,144 ..] // Y
                  // minGraph: getDoubleMinValue(invCtr.incomes) - 500,
                  minGraph: -1000000,
                  //maxGraph: (getDoubleMaxValue(invCtr.totals) + 500).toInt().toDouble(),
                  maxGraph: 6000000,
                  extraMinMax: 300.0,
                  width: dates.length /14 > 1 ? dates.length /14 : 1,//multiplied by 100.w
                )
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 8.0),
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
                        text: 'total Sell:'.tr,
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
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 8.0),
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
                        text: 'total Income:'.tr,
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
              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
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
                        'Top Products'.tr,
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
              ),

              // top products
              DataTable(
                horizontalMargin: 20,
columnSpacing: 20,
                columns:  <DataColumn>[
                  DataColumn(label: Text('#'),),
                  DataColumn(label: Text('Name'.tr)),
                  DataColumn(label: Text('Qty'.tr)),
                  DataColumn(label: Text('Sells'.tr)),
                  DataColumn(label: Text('Incomes'.tr)),
                ],
                rows: allProdsMonth.mapIndexed((index,Product prd){
                  return DataRow(
                      cells: [
                        DataCell(Text('${index+1}')),
                        DataCell(Text(prd.name!)),
                        DataCell(Text('${prd.allItems[selectedMonth]['totalSelledQty']}',style: TextStyle(color: Colors.white70),)),
                        DataCell(Text('${formatNumberAfterComma2(prd.allItems[selectedMonth]['totalSell'])}',style: TextStyle(color: totalCol),)),
                        DataCell(Text('${formatNumberAfterComma2(prd.allItems[selectedMonth]['totalIncome'])}',style: TextStyle(color: winIncomeCol),)),
                      ]);
                }).toList(),
              )

            ],
          ),
        )
            : Center(
          child: Text('should have at least 3 invoices to show statistics'.tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.indieFlower(
                textStyle: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.w700),
              )),
        ),
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