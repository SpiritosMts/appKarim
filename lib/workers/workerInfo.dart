
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gajgaji/_manager/bindings.dart';
import 'package:gajgaji/_manager/firebaseVoids.dart';
import 'package:gajgaji/_manager/myVoids.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../_manager/myLocale/myLocaleCtr.dart';
import '../_manager/myUi.dart';
import '../_manager/styles.dart';
import '../_models/expKridi.dart';
import 'addEditWorker.dart';
import 'workersCtr.dart';





class WorkerInfo extends StatefulWidget {
  const WorkerInfo({super.key});

  @override
  State<WorkerInfo> createState() => _WorkerInfoState();
}

class _WorkerInfoState extends State<WorkerInfo> with TickerProviderStateMixin{

  late TabController _tcontroller;
  final List<String> titleList = [
    "Info".tr,
    "Expenses".tr,
    "Kridi".tr,
  ];
  String currentTitle = 'Info'.tr;

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
      if(currentTitle == titleList[1]){//exp

        wrkCtr.isExp=true;
      }else{//kridi
        wrkCtr.isExp=false;

      }
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


            controller: _tcontroller,
            isScrollable: false,
            indicatorWeight: 4,
            tabs: [
              Tab( icon: Icon(Icons.person)),//info
              Tab(icon: FaIcon(Icons.money_off_sharp),),//expenses
              Tab(icon: Icon(Icons.attach_money_outlined),),//kridi
            ],
          ),
          title: Text(currentTitle),
        ),
        body: TabBarView(
          controller: _tcontroller,
          children: [
            /// info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    prop('ID:'.tr, '${wrkCtr.selectedWorker.id}'),
                    prop('Name:'.tr, '${wrkCtr.selectedWorker.name}'),
                    prop('Age:'.tr, '${wrkCtr.selectedWorker.age}'),
                    prop('Sex:'.tr, '${wrkCtr.selectedWorker.sex}'),
                    prop('Phone:'.tr, '${wrkCtr.selectedWorker.phone}'),
                    prop('Address:'.tr, '${wrkCtr.selectedWorker.address}'),
                    prop('Join Date:'.tr, '${wrkCtr.selectedWorker.joinDate}'),
                    prop('Email:'.tr, '${wrkCtr.selectedWorker.email}'),
                    prop('Role:'.tr, '${wrkCtr.selectedWorker.role}'),
                    prop('Speciality:'.tr, '${wrkCtr.selectedWorker.speciality}'),
                    prop('Salary:'.tr, '${wrkCtr.selectedWorker.salary}',extraTxt: '$currency'),

                    prop('Total Expenses:'.tr, '${wrkCtr.selectedWorker.totalExpenses}',color: Colors.redAccent,extraTxt: '$currency'),
                    prop('Total Kridi:'.tr, '${wrkCtr.selectedWorker.totalKridi}',color: Colors.greenAccent,extraTxt: '$currency'),

                    prop('Verified:'.tr, '${wrkCtr.selectedWorker.verified? 'Yes'.tr:'No'.tr}'),

                  ],
                ),
              ),
            ),
            /// expenses
            customStreamBuilder(
              stream:workersColl.where('id', isEqualTo: wrkCtr.selectedWorker.id!).snapshots() ,
              hasDataWidget: ( snapshotData) {
                var worker = snapshotData.docs.first;
                Map<String, dynamic> mapList = worker.get('expensesHis');
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
                      ExpKridi expKridi = ExpKridi.fromJson(mapList[key]);
                      return expKridiCard(key, expKridi,isExp: wrkCtr.isExp);
                    }
                ):Padding(
                  padding: EdgeInsets.only(top: 35.h),

                  child: Text('no expenses found'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
                    textStyle:  TextStyle(
                        fontSize: 23  ,
                        color: Colors.white,
                        fontWeight: FontWeight.w700
                    ),
                  )),
                );
              },
            ),            /// kridi
            customStreamBuilder(
              stream:workersColl.where('id', isEqualTo: wrkCtr.selectedWorker.id!).snapshots() ,
              hasDataWidget: ( snapshotData) {
                var worker = snapshotData.docs.first;
                Map<String, dynamic> mapList = worker.get('kridiHis');
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
                      ExpKridi expKridi = ExpKridi.fromJson(mapList[key]);
                      return expKridiCard(key, expKridi,isExp: wrkCtr.isExp);
                    }
                ):Padding(
                  padding: EdgeInsets.only(top: 35.h),

                  child: Text('no kridi found'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
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
        //             /// go edit worker props
        //             Get.to(()=>AddEditWorker(),arguments: {'isAdd': false});
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
        //             if(wrkCtr.isExp){//exp
        //               showAnimDialog(wrkCtr.addExpKridiDialog(isExpense: true));
        //
        //             }else{//kridi
        //               showAnimDialog(wrkCtr.addExpKridiDialog(isExpense: false));
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
