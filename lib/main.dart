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

import 'firebase_options.dart';
import 'manager/bindings.dart';
import 'manager/firebaseControl.dart';
import 'manager/intro.dart';
import 'manager/loadingScreen.dart';
import 'manager/myLocale/myLocale.dart';
import 'manager/myLocale/myLocaleCtr.dart';
import 'manager/myTheme/myTheme.dart';
import 'manager/myVoids.dart';


SharedPreferences? sharedPrefs;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
StreamSubscription? userStream;
///analy
// FirebaseAnalytics?  analytics;
// FirebaseAnalyticsObserver? observer ;
//FirebaseAnalyticsObserver get observer => FirebaseAnalyticsObserver(analytics: analytics);
/// INTRO /////////
int introTimes = 0;
bool showIntro = true;
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
  ///Crashlytics
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  ///ANLYTICS


}
Future<void> main() async { // if app not launched yet backgroundService void starts before
  print('##run_main');
  await WidgetsFlutterBinding.ensureInitialized();//don't touch

  await checkFirebase();
  ///alarm
  //await Alarm.init(showDebugLogs: true);
  ///PREFS
  sharedPrefs = await SharedPreferences.getInstance();



  /// NOTIFICATIONS

  //await NotificationController.initializeLocalNotifications(debug: true);///awesome notif

  ///BACKGROUND
  // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  // await initBackgroundState();
  ///BG_SERVICE
  // if(!await FlutterBackgroundService().isRunning()){
  //   await initializeBGService();
  // }
  //await initializeBGService();



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
  //MyThemeCtr themeCtr =   Get.put(MyThemeCtr());  //theme
  bool introShown = false;



  @override
  void initState() {
    ///NotificationController.startListeningNotificationEvents();

    // analytics = FirebaseAnalytics.instance;
    // observer = FirebaseAnalyticsObserver(analytics: analytics!);
    //introShown = sharedPrefs!.getBool('introShown') ?? false;

    super.initState();
  }

  ///  notif route  /////////////////////
  // List<Route<dynamic>> onGenerateInitialRoutes(String initialRouteName) {
  //   List<Route<dynamic>> pageStack = [];
  //
  //   pageStack.add(
  //       MaterialPageRoute(builder: (_) =>  MyHomeNotifPage())
  //   );
  //
  //   if (initialRouteName == '/notification-page' && NotificationController.initialAction != null) {
  //     pageStack.add(
  //         MaterialPageRoute(builder: (_) => NotificationPage(
  //             receivedAction: NotificationController.initialAction!))
  //     );
  //   }
  //   return pageStack;
  // }
  // Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  //   switch (settings.name) {
  //     case '/':
  //       return MaterialPageRoute(builder: (_) => const MyHomeNotifPage());
  //
  //
  //     case '/notification-page':
  //       ReceivedAction receivedAction = settings.arguments as ReceivedAction;
  //       return MaterialPageRoute(builder: (_) => NotificationPage(receivedAction: receivedAction)
  //       );
  //   }
  //   return null;
  // }

  /// ///////////////////
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
        builder: (context, orientation, deviceType) {
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'app-name',

            theme: customLightTheme,
            darkTheme: customDarkTheme,
            themeMode: ThemeMode.system,

            locale: langCtr.initlang,
            translations: MyLocale(),

            ///notif route
            // onGenerateInitialRoutes: onGenerateInitialRoutes,
            // onGenerateRoute: onGenerateRoute,

            // navigatorObservers:  [
            //   FirebaseAnalyticsObserver(analytics: analytics!),
            // ],

            initialBinding: GetxBinding(),
            //initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: () => ((introTimes < introShowTimes)|| showIntro) ? IntroScreen():LoadingScreen()),
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
