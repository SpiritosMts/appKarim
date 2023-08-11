import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gajgaji/_models/buySellProd.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_manager/bindings.dart';
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
    "Transactions History".tr,
    "Charts".tr,
    "Buy History".tr,
  ];
  String currentTitle = 'Manual Changes'.tr;

  @override
  void initState() {
    super.initState();

    currentTitle = titleList[0];//initial tab
    _tcontroller = TabController(length: 3, vsync: this);
    _tcontroller.addListener(changeTitle);//listen to tab changes
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




  //#########################################################################
  //#########################################################################

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorWeight: 4,


            controller: _tcontroller,
            isScrollable: false,
            tabs: [
              Tab( icon: Icon(Icons.shopping_cart_outlined)),//info
              Tab(icon: FaIcon(Icons.show_chart),),//expenses
              Tab(icon: Icon(Icons.money_off_csred_outlined),),//kridi
            ],
          ),
          title: Text(currentTitle),
        ),
        body: TabBarView(
          controller: _tcontroller,
          children: [

            /// Sell BUY MANUAL /////////////////////////////////////////////////////////////////////////////////////////////////////////
            customStreamBuilder(
              stream: productsColl.where('id', isEqualTo: prdCtr.selectedProd.id!).snapshots() ,
              hasDataWidget: ( snapshotData) {
                var model = snapshotData.docs.first;
                /// //////////////////:
                Map<String, dynamic> mapListSell = model.get('sellHis');
                mapListSell = addCaracterAtStartIfKeys('0s', mapListSell);

                Map<String, dynamic> mapListBuy = model.get('buyHis');
                mapListBuy = addCaracterAtStartIfKeys('0b', mapListBuy);// add "0b" at start of each key

                Map<String, dynamic> mapListManual = model.get('prodChanges');
                mapListManual = addCaracterAtStartIfKeys('0m', mapListManual);

                Map<String, dynamic> mapList = {...mapListSell, ...mapListBuy, ...mapListManual};// merge
                /// //////////////////:

                mapList = orderMapByTime(mapList);


                return  (mapList.isNotEmpty)
                    ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),

                    itemExtent: 130,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    shrinkWrap: true,
                    reverse: false,
                    itemCount: mapList.length,
                    itemBuilder: (BuildContext context, int index) {
                       String key = mapList.keys.elementAt(index);

                       if(key.startsWith("0m")) {//manual
                         ProdChange prodChange = ProdChange.fromJson(mapList[key]);
                         return manualProdChangeCard(key, prodChange);
                       }else { // buy & sell
                         BuySellProd prod = BuySellProd.fromJson(mapList[key]);
                         return bsProdCard(key, prod);
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
                );
              },
            ),
            /// prodChanges /////////////////////////////////////////////////////////////////////////////////////////////////////////
            customStreamBuilder(
              stream:productsColl.where('id', isEqualTo: prdCtr.selectedProd.id!).snapshots() ,
              hasDataWidget: ( snapshotData) {
                var model = snapshotData.docs.first;
                Map<String, dynamic> mapList = model.get('prodChanges');
                mapList = orderMapByTime(mapList);


                return  (mapList.isNotEmpty)
                    ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),

                    itemExtent: 130,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    shrinkWrap: true,
                    reverse: false,
                    itemCount: mapList.length,
                    itemBuilder: (BuildContext context, int index) {
                      String key = mapList.keys.elementAt(index);
                      ProdChange prodChange = ProdChange.fromJson(mapList[key]);/// change
                      return manualProdChangeCard(key, prodChange);/// change
                    }
                ):Padding(
                  padding: EdgeInsets.only(top: 35.h),
                  child: Text('no changes found'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
                    textStyle:  TextStyle(
                        fontSize: 23  ,
                        color: Colors.white,
                        fontWeight: FontWeight.w700
                    ),
                  )),
                );
              },
            ),
      /// Buy /////////////////////////////////////////////////////////////////////////////////////////////////////////
            customStreamBuilder(
              stream:productsColl.where('id', isEqualTo: prdCtr.selectedProd.id!).snapshots() ,
              hasDataWidget: ( snapshotData) {
                var model = snapshotData.docs.first;
                Map<String, dynamic> mapList = model.get('buyHis');
                mapList = orderMapByTime(mapList);

                //print('## $mapList');
                return  (mapList.isNotEmpty)
                    ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),

                    itemExtent: 130,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    shrinkWrap: true,
                    reverse: false,
                    itemCount: mapList.length,
                    itemBuilder: (BuildContext context, int index) {
                      String key = mapList.keys.elementAt(index);
                      BuySellProd prod = BuySellProd.fromJson(mapList[key]);
                      return bsProdCard(key, prod);
                    }
                ):Padding(
                  padding: EdgeInsets.only(top: 35.h),
                  child: Text('no Buy history found'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
                    textStyle:  TextStyle(
                        fontSize: 23  ,
                        color: Colors.white,
                        fontWeight: FontWeight.w700
                    ),
                  )),
                );
              },
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
