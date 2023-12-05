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
import '../_models/client.dart';
import '../_models/worker.dart';
import 'clientsCtr.dart';



//########################################################################
//########################################################################

class ClientsView extends StatefulWidget {
  const ClientsView({super.key});

  @override
  State<ClientsView> createState() => _ClientsViewState();
}
class _ClientsViewState extends State<ClientsView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clients'.tr),
        bottom: appBarUnderline(),
      ),

      body: GetBuilder<ClientsCtr>(
        builder: (context) {
          return FutureBuilder<List<Clienth>>(
            future: getAlldocsModelsFromFb<Clienth>(
              clientsColl,
                  (json) => Clienth.fromJson(json)),
            builder: (BuildContext context, AsyncSnapshot<List<Clienth>> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {

                List<Clienth> clients = snapshot.data!;
                print('## clientsList (ctr) updated');

                cltCtr.clientsList = clients;


                return  (clients.isNotEmpty)
                    ? ListView.builder(
                   // physics: const NeverScrollableScrollPhysics(),

                    //itemExtent: 180,

                    padding: const EdgeInsets.only(top: 5,bottom:60, right: 15, left: 15,),
                    shrinkWrap: true,
                    itemCount: clients.length,
                    itemBuilder: (BuildContext context, int index) {

                      Clienth clt =  (clients[index]);
                      return clientCard(clt);
                    }
                ):Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Text('no clients added yet'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
                      textStyle:  TextStyle(
                          fontSize: 23  ,
                          color: Colors.white,
                          fontWeight: FontWeight.w700
                      ),
                    )),
                  ),
                );


              } else if (snapshot.connectionState == ConnectionState.waiting) {
                print('## loading clients ...');

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
        text: 'New Client'.tr,
        onPressed: () {
          showAnimDialog(cltCtr.addClientDialog(isAdd: true));
        },
      ),


    );
  }
}
