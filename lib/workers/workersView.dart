import 'package:flutter/material.dart';
import 'package:gajgaji/_manager/bindings.dart';
import 'package:gajgaji/_manager/myVoids.dart';
import 'package:gajgaji/workers/workersCtr.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_manager/firebaseVoids.dart';
import '../_manager/myLocale/myLocaleCtr.dart';
import '../_manager/myUi.dart';
import '../_manager/styles.dart';
import '../_models/worker.dart';
import 'addEditWorker.dart';
import 'workerInfo.dart';



//########################################################################
//########################################################################

class WorkersView extends StatefulWidget {
  const WorkersView({super.key});

  @override
  State<WorkersView> createState() => _WorkersViewState();
}
class _WorkersViewState extends State<WorkersView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workers'.tr),
        bottom: appBarUnderline(),
      ),

      body: GetBuilder<WorkersCtr>(
        builder: (context) {
          return FutureBuilder<List<Workerh>>(
            future: getAlldocsModelsFromFb<Workerh>(
              workersColl,
                  (json) => Workerh.fromJson(json)),
            builder: (BuildContext context, AsyncSnapshot<List<Workerh>> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {

                List<Workerh> workers = snapshot.data!;
                print('## workersList (ctr) updated');

                wrkCtr.workersList = workers;

                return  (workers.isNotEmpty)
                    ? ListView.builder(
                   // physics: const NeverScrollableScrollPhysics(),

                    //itemExtent: 180,

                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    shrinkWrap: true,
                    itemCount: workers.length,
                    itemBuilder: (BuildContext context, int index) {

                      Workerh wrk =  (workers[index]);
                      return workerCard(wrk);
                    }
                ):Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Text('no workers added yet'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
                      textStyle:  TextStyle(
                          fontSize: 23  ,
                          color: Colors.white,
                          fontWeight: FontWeight.w700
                      ),
                    )),
                  ),
                );


              } else if (snapshot.connectionState == ConnectionState.waiting) {
                print('## loading workers ...');

                return const Center(
                  child: CircularProgressIndicator(
                      color: Colors.white70
                  ),
                );
              }else if(snapshot.hasError) {

                print('## error: ${snapshot.error.toString()}');
                return Center(
                  child: Text(
                    snapshotErrorMsg,
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white70
                    ),
                  ),
                );
              } else {

                return Center(
                  child: Text(
                    "no data".tr,
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white70
                    ),
                  ),
                );
              }
            },
          );
        }
      ),

      /// add new worker
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: customFAB(
        text: 'New Worker'.tr,
        onPressed: () {
          Get.to(()=>AddEditWorker(),arguments: {'isAdd': true});
        },
      ),


    );
  }
}
