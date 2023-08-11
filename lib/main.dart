import 'dart:async';
import 'dart:ui';


// import 'package:firebase_analytics/observer.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '_manager/myTheme/myThemeCtr.dart';
import '_manager/styles.dart';
import 'firebase_options.dart';
import '_manager/bindings.dart';
import '_manager/firebaseControl.dart';
import '_manager/intro.dart';
import '_manager/loadingScreen.dart';
import '_manager/myLocale/myLocale.dart';
import '_manager/myLocale/myLocaleCtr.dart';
import '_manager/myVoids.dart';


SharedPreferences? sharedPrefs;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
StreamSubscription? userStream;
///analy
// FirebaseAnalytics?  analytics;
// FirebaseAnalyticsObserver? observer ;
//FirebaseAnalyticsObserver get observer => FirebaseAnalyticsObserver(analytics: analytics);
/// INTRO /////////
int introTimes = 0;
bool showIntro = false  ;

introTimesGet()async{
  introTimes = sharedPrefs!.getInt('intro')??0 ;
  print('## introTimes_get_<$introTimes>');

}
Future<void> checkFirebase() async {
  if (await Firebase.initializeApp() != null) {
    print("## Firebase is already initialized");
  } else {
    print("## Firebase is not initialized: INITIALIZE NOW");
    await initFirebase();
  }
}
Future<void> initFirebase() async {  /// FIREBASE_INIT

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


}
Future<void> main() async {
  print('##run_main');
  await WidgetsFlutterBinding.ensureInitialized();//don't touch
  await initFirebase();

  ///PREFS
  sharedPrefs = await SharedPreferences.getInstance();


  /// RUN_APP
  runApp(MyApp()); //should contain materialApp
}

///################################################################################################################
///################################################################################################################
//
class MyApp extends StatefulWidget {


  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  MyLocaleCtr langCtr =   Get.put(MyLocaleCtr());  //lang
  MyThemeCtr themeCtr =   Get.put(MyThemeCtr());  //theme
  bool introShown = false;



  @override
  void initState() {
    super.initState();
  }


  /// ///////////////////
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
        builder: (context, orientation, deviceType) {
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Gajgaji',

            //theme: waterAndSodaTheme,
            theme: customLightTheme,
            darkTheme: customDarkTheme,
            themeMode: ThemeMode.light,

            locale: langCtr.initlang,
            translations: MyLocale(),

            initialBinding: GetxBinding(),
            getPages: [
              GetPage(name: '/', page: () => ((introTimes < introShowTimes) && showIntro) ? IntroScreen():LoadingScreen()),
              //GetPage(name: '/', page: () => ScreenManager()),//in test mode

            ],
          );
        }
    );
  }
}


/// Buttons Page Route
class ScreenManager extends StatefulWidget {
  @override
  _ScreenManagerState createState() => _ScreenManagerState();
}


class _ScreenManagerState extends State<ScreenManager> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          TextButton(
              onPressed: () {
                Get.to(() => LoadingScreen());
              },
              child: Text('LoadingScreen')),

          TextButton(
              onPressed: () async {
                await fbAuth.signOut();
                await googleSign.signOut();
                //sharedPrefs!.setBool('isGuest', false);
                print('## user signed out');
              },
              child: Text('LogOut')),

          TextButton(
              onPressed: () {
                Get.to(() => FirebaseControl());
              },
              child: Text('Firebase control')),


          TextButton(
              onPressed: () {
                //sharedPrefs!.remove('saved_purchases');
                sharedPrefs!.clear();
                print('## prefs_cleared');

              },
              child: Text('clear prefs')),



        ],
      ),
    );
  }
}
