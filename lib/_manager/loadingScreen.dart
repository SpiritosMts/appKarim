/// show loading (while verifying user account)

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../invoices/invoiceView(home).dart';
import '../workers/workersView.dart';
import 'bindings.dart';
import 'myUi.dart';
import 'myVoids.dart';
import 'styles.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _VerifySigningInState();
}

class _VerifySigningInState extends State<LoadingScreen> {
  // StreamSubscription<User?>? user;
  //BrUser cUser = BrUser();

  late bool canShowCnxFailed;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    canShowCnxFailed = true;

    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkCnx();
    });
  }

  /// check connection state
  checkCnx({bool withFetchUser=false}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // Not connected to the internet
      print('## not connected');
      if (canShowCnxFailed) {
        showVerifyConnexion();

        if (this.mounted) {
          setState(() {
            canShowCnxFailed = false;
          });
        }
      }
    } else {
      // Connected to the internet
      print('## connected');
      timer.cancel();

      if(withFetchUser){
        authCtr.fetchUser();// find route depending on user role TODO

      }else{
        Get.offAll(() => HomeScreen());//Home

      }

      /// => next route < LOGIN (if no user logged in found)  / HOME (user found) >
    }

  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: backGroundTemplate(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60,
                ),

                /// Logo Image
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Image.asset(
                    'assets/images/factory.png',
                    fit: BoxFit.cover,
                    width: 170,
                    height: 170,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // text
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(),
                    child: appNameText(),
                  ),
                ),
                // check your cnx
                !canShowCnxFailed
                    ? Column(
                        children: [
                          Text(
                            'please verify network'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: accentColor1.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(
                            height: 100.h * .1,
                          ),
                        ],
                      )
                    : Container(),

                ///loading
                Padding(
                  padding:  EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: SizedBox(
                      width: 30.sp,
                      height: 30.sp,
                      child:  LoadingIndicator(
                        indicatorType: Indicator.circleStrokeSpin,
                        colors: [accentColor1],
                        strokeWidth: 6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
