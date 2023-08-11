

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../main.dart';
import '../_models/worker.dart';
import 'auth/authCtr.dart';
import 'bindings.dart';
import 'firebaseVoids.dart';
import 'styles.dart';


FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseDatabase? get fbDatabase => FirebaseDatabase.instance;
User? get authCurrUser => FirebaseAuth.instance.currentUser;
FirebaseDatabase? get database => FirebaseDatabase.instance;
FirebaseAuth get fbAuth => FirebaseAuth.instance;

GoogleSignIn googleSign = GoogleSignIn();

String snapshotErrorMsg = 'check Connexion'.tr;
String workersCollName = 'workers';
String clientsCollName = 'clients';
String productsCollName = 'products';
String invoicesCollName = 'invoices';
String prDataCollName = 'prData';
String usersCollName = 'users';
String societyName = 'Gajgaji Karim';
String societyMf = '1384432/J/C/N/000';
String societyAdress = 'Route Bannene Bembla - Monastir 5000';
String societyPhone = '22 35 32 49';
var workersColl = FirebaseFirestore.instance.collection('workers');
var clientsColl = FirebaseFirestore.instance.collection('clients');
var productsColl = FirebaseFirestore.instance.collection('products');
var invoicesColl = FirebaseFirestore.instance.collection('invoices');
var usersColl = FirebaseFirestore.instance.collection('users');


double awesomeDialogWidth =90.sp;

int refreshVerifInSec =5;
int introShowTimes =1;
bool verifyAnyCreatedAccount =false;
bool showLiveTime =false;


bool isCtrInitialized<T extends GetxController>() {
  return Get.isRegistered<T>();
}

// String getUserNameByID(userID){
//   String userName = 'unknown';
//   for (var patID in authCtr.cUser.patients!) {
//     if (patID == userID) {
//       return patient['name'];
//     }
//   }
//     return userName;
//
// }
Map<String, Map<String, dynamic>> orderMapByTime(Map<String, dynamic> mp){

  List<MapEntry<String, dynamic>> list = mp.entries.toList();
  DateFormat dateFormat = DateFormat('dd-MM-yyyy HH:mm');
  list.sort((a, b) {
    DateTime timeA = dateFormat.parse(a.value['time']);
    DateTime timeB = dateFormat.parse(b.value['time']);
    return timeB.compareTo(timeA);
  });

  // for (int index = 0; index < list.length; index++) {
  //   //   print('## ${list[index].value}');
  //   sortedMap[index.toString()] = list[index].value;
  // }

  Map<String, Map<String, dynamic>> sortedMap = {};
  list.asMap().forEach((index, entry) {
    sortedMap[entry.key] = entry.value;
  });

  return sortedMap;
}

Future<void> removeField() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final QuerySnapshot invoicesSnapshot = await firestore.collection('invoices').get();

  for (QueryDocumentSnapshot docSnapshot in invoicesSnapshot.docs) {
    // Check if the field 'changedTotal' exists in the document
      // Update the document to remove the field 'changedTotal'
      await firestore.collection('invoices').doc(docSnapshot.id).update({
        'changedTotal': FieldValue.delete(),

      });

  }
}
Future<void> addChangedTotalField() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final QuerySnapshot invoicesSnapshot = await firestore.collection('invoices').get();

  for (QueryDocumentSnapshot docSnapshot in invoicesSnapshot.docs) {
    await firestore.collection('invoices').doc(docSnapshot.id).update({
      'totalChanged': false, // Set the initial value to false
    });
  }
}


String formatNumberAfterComma(String number) {
  //final string = number.toString();
  if(number.contains('.')){
    final decimalIndex = number.indexOf('.');
    final end = min(decimalIndex + 3, number.length);
    return number.substring(0, end);
  }else{
    return number;
  }

}
String printFormattedJson(Map<String, dynamic> json) {
  JsonEncoder encoder = JsonEncoder.withIndent('  ');
  String prettyPrint = encoder.convert(json);
  return prettyPrint;
}
bool isDateToday(String dateString) {
  // Create a DateFormat instance to parse the date string
  DateFormat dateFormat = DateFormat('dd-MM-yyyy HH:mm');

  // Parse the date string to a DateTime object
  DateTime date = dateFormat.parse(dateString);

  // Get the current date
  DateTime currentDate = DateTime.now();

  // Compare the day of the parsed date with the day of the current date
  return date.day == currentDate.day && date.month == currentDate.month && date.year == currentDate.year;
}
String formatNumberAfterComma2(double number) {
  String numberString = number.toStringAsFixed(0); // Convert to a string without decimal digits

  if (number == 0) {
    return '0'; // Return '0' for zero value
  }

  // Handle negative numbers
  bool isNegative = false;
  if (number < 0) {
    isNegative = true;
    numberString = numberString.substring(1); // Remove the negative sign
  }

  // Pad the number with leading zeros if necessary
  while (numberString.length < 4) {
    numberString = '0$numberString';
  }

  // Add comma separator from the right
  int separatorIndex = numberString.length - 3;
  numberString = numberString.substring(0, separatorIndex) +
      ',' +
      numberString.substring(separatorIndex);

  if (isNegative) {
    numberString = '-$numberString'; // Add back the negative sign
  }

  return numberString;


}
String extractDate(String dateTimeString) {
  List<String> parts = dateTimeString.split(' '); // Split the string by space
  String datePart = parts[0]; // Get the first part, which is the date
  return datePart;
}
String formatNumberAfterComma3(double number) {

  String numberString = number.toStringAsFixed(0); // Convert to a string without decimal digits

  // Pad the number with leading zeros if necessary
  while (numberString.length < 4) {
    numberString = '0$numberString';
  }

  if (number < 1) {
    numberString = '0,$numberString';
  }

  // Add comma separator from the right
  int separatorIndex = numberString.length - 3;
  numberString = numberString.substring(0, separatorIndex) +
      ',' +
      numberString.substring(separatorIndex);

  return numberString;
}
double getDoubleMinValue(List<double> values) {
  return values.reduce((currentMin, value) => value < currentMin ? value : currentMin);
}
double getDoubleMaxValue(List<double> values) {
  return values.reduce((currentMax, value) => value > currentMax ? value : currentMax);
}

// String getMinValue(List<String> values) {
//   return values.reduce((currentMin, value) {
//     return (value.compareTo(currentMin) < 0) ? value : currentMin;
//   });
// }

double getMinValue(List<String> values) {
  List<double> doubleList = values.map((str) => double.parse(str)).toList();
  double minValue = doubleList.reduce((currentMin, value) => value < currentMin ? value : currentMin);
  return minValue;
}

double getMaxValue(List<String> values) {
  List<double> doubleList = values.map((str) => double.parse(str)).toList();
  double maxValue = doubleList.reduce((currentMax, value) => value > currentMax ? value : currentMax);
  return maxValue;
}
fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
fieldUnfocusAll() {
  FocusManager.instance.primaryFocus?.unfocus();
}
double replaceWithClosestHalf(double value) {
  int intValue = value.toInt();
  double decimalPart = value - intValue;

  if (decimalPart < 0.25) {
    return intValue.toDouble();
  } else if (decimalPart >= 0.25 && decimalPart < 0.75) {
    return intValue.toDouble() + 0.5;
  } else {
    return intValue.toDouble() + 1.0;
  }
}
showTos(txt, {Color color = Colors.black87,bool withPrint = false}) async {
  Fluttertoast.showToast(
      msg: txt,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
  if(withPrint) print(txt);
}

Future<bool> canConnectToInternet() async {
  bool canConnect = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    /// connected to internet
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //is connected
      canConnect = true;
    }
    /// failed to connect to internet
  } on SocketException catch (_) {
    // not connected

  }
  return canConnect;
}
double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = math.cos;
  var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * math.asin(math.sqrt(a));
}

Map<String, dynamic> addCaracterAtStartIfKeys(String caracter, Map<String, dynamic> originalMap){
  Map<String, dynamic> modifiedMap = {};

  originalMap.forEach((key, value) {
    String modifiedKey = caracter + key;
    modifiedMap[modifiedKey] = value;
  });
  return modifiedMap;
}

showSnack(txt,{Color? color}) {
  Get.snackbar(
    txt,
    '',
    messageText: Container(),
    colorText: Colors.white,
    backgroundColor:color?? Colors.greenAccent.withOpacity(0.70),
    snackPosition: SnackPosition.BOTTOM,
  );
}


String getMonthName(int monthNumber) {
  switch (monthNumber) {
    case 1:
      return "January".tr;
    case 2:
      return "February".tr;
    case 3:
      return "March".tr;
    case 4:
      return "April".tr;
    case 5:
      return "May".tr;
    case 6:
      return "June".tr;
    case 7:
      return "July".tr;
    case 8:
      return "August".tr;
    case 9:
      return "September".tr;
    case 10:
      return "October".tr;
    case 11:
      return "November".tr;
    case 12:
      return "December".tr;
    default:
      return "Unknown".tr;
  }
}



String todayToString({bool showHours = true}) {
  //final formattedStr = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':' nn]);
  //DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");

  if (showHours) {
    dateFormat = DateFormat("dd-MM-yyyy HH:mm");
  }
  return dateFormat.format(DateTime.now());
}

String getLastIndex(Map<String, dynamic> fieldMap,{bool afterLast = false}){

  int newItemIndex=0;
  if(fieldMap.isNotEmpty){
    newItemIndex = fieldMap.keys
        .map((key) => int.parse(key))
        .reduce((value, element) => value > element ? value : element)+0;

  }

  if(afterLast){
    newItemIndex ++;
  }
  return newItemIndex.toString();
}
Map<String, dynamic> getLastIndexMap(Map<String, dynamic> fieldMap){

  return fieldMap[getLastIndex(fieldMap)];
}


void showGetSnackbar(String title,String desc,{Color? color}){
  Get.snackbar(

    title,
    desc,
    duration: Duration(seconds: 2),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor:color?? Colors.redAccent.withOpacity(0.8),
    colorText: Colors.white,
  );
}


showVerifyConnexion(){
  AwesomeDialog(
    context: navigatorKey.currentContext!,
    width: awesomeDialogWidth,

    dialogBackgroundColor: dialogsCol,
    autoDismiss: true,
    dismissOnTouchOutside: true,
    animType: AnimType.SCALE,
    headerAnimationLoop: false,
    dialogType: DialogType.INFO,
    btnOkColor: Colors.blueAccent,
    // btnOkColor: yellowColHex

    //showCloseIcon: true,
    padding: EdgeInsets.symmetric(vertical: 15.0),
    titleTextStyle: TextStyle(fontSize: 17.sp,color: dialogTitleCol),
    descTextStyle: TextStyle(fontSize: 15.sp),
    buttonsTextStyle: TextStyle(fontSize: 14.sp),

    title: 'Failed to Connect'.tr,
    desc: 'please verify network'.tr,

    btnOkText: 'Retry'.tr,
    btnOkOnPress: () {

    },
    onDismissCallback: (type) {
      print('Dialog Dissmiss from callback $type');
    },
    //btnOkIcon: Icons.check_circle,

  ).show();
}
showLoading({required String text}) {

  return AwesomeDialog(
    dialogBackgroundColor: dialogsCol,
    width: awesomeDialogWidth,
    dismissOnBackKeyPress: true,
    //change later to false
    autoDismiss: true,
    customHeader: Transform.scale(
      scale: .7,
      child: const LoadingIndicator(
        indicatorType: Indicator.ballClipRotate,
        colors: [accentColor1],
        strokeWidth: 10,
      ),
    ),
    titleTextStyle: TextStyle(fontSize: 18.sp,color: dialogTitleCol),
    descTextStyle: TextStyle(fontSize: 16.sp,height: 1.5),
    buttonsTextStyle: TextStyle(fontSize: 15.sp),
    context: navigatorKey.currentContext!,
    dismissOnTouchOutside: false,
    animType: AnimType.scale,
    headerAnimationLoop: false,
    dialogType: DialogType.NO_HEADER,

    //padding: EdgeInsets.all(8),

    title: text,
    desc: 'Please wait'.tr,
  ).show();
}
showFailed({String? faiText}) {
  return AwesomeDialog(
      dialogBackgroundColor: dialogsCol,
      width: awesomeDialogWidth,

      autoDismiss: true,
      context: navigatorKey.currentContext!,
      dismissOnTouchOutside: false,
      animType: AnimType.SCALE,
      headerAnimationLoop: false,
      dialogType: DialogType.ERROR,
      //showCloseIcon: true,
      titleTextStyle: TextStyle(
        color: dialogTitleCol
      ),
      title: 'Failure'.tr,
      btnOkText: 'Ok'.tr,
      descTextStyle: GoogleFonts.almarai(
        height: 1.8,
        textStyle: const TextStyle(fontSize: 14),
      ),
      desc: faiText,
      btnOkOnPress: () {},
      btnOkColor: Colors.red,
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      }).show();
  ;
}
showSuccess({String? sucText, Function()? btnOkPress}) {
  return AwesomeDialog(
    dialogBackgroundColor: dialogsCol,
    width: awesomeDialogWidth,

    autoDismiss: true,
    context: navigatorKey.currentContext!,
    dismissOnBackKeyPress: false,
    headerAnimationLoop: false,
    dismissOnTouchOutside: false,
    animType: AnimType.leftSlide,
    dialogType: DialogType.success,
    //showCloseIcon: true,
    //title: 'Success'.tr,

    titleTextStyle: TextStyle(
      color: dialogTitleCol
    ),
    descTextStyle:TextStyle(fontSize: 15.sp),
    desc: sucText,
    btnOkText: 'Ok'.tr,

    btnOkOnPress: () {
      btnOkPress!();
    },
    // onDissmissCallback: (type) {
    //   debugPrint('## Dialog Dissmiss from callback $type');
    // },
    //btnOkIcon: Icons.check_circle,
  ).show();
}
showWarning({String? txt, Function()? btnOkPress}) {
  return AwesomeDialog(
    dialogBackgroundColor: dialogsCol,
    width: awesomeDialogWidth,

    autoDismiss: true,
    context: navigatorKey.currentContext!,
    dismissOnBackKeyPress: false,
    headerAnimationLoop: false,
    dismissOnTouchOutside: false,
    animType: AnimType.scale,
    dialogType: DialogType.warning,
    //showCloseIcon: true,
    //title: 'Success'.tr,

    descTextStyle: GoogleFonts.almarai(
      height: 1.8,
      textStyle: const TextStyle(fontSize: 14),
    ),
    btnOkColor: Color(0xFFFEB800),
    desc: txt,
    btnOkText: 'Ok'.tr,

    btnOkOnPress: () {
      btnOkPress!();
    },
    // onDissmissCallback: (type) {
    //   debugPrint('## Dialog Dissmiss from callback $type');
    // },
    //btnOkIcon: Icons.check_circle,
  ).show();
}
showAlarm({int? alarmID,String? name}) {
  return AwesomeDialog(

    dialogBackgroundColor: dialogsCol,
    width: awesomeDialogWidth,

    autoDismiss: true,
    context: navigatorKey.currentContext!,
    dismissOnBackKeyPress: false,
    headerAnimationLoop: true,
    dismissOnTouchOutside: false,
    animType: AnimType.scale,
    dialogType: DialogType.warning,
    //showCloseIcon: true,
    //title: 'Success'.tr,

    descTextStyle: GoogleFonts.almarai(
      height: 1.8,
      textStyle: const TextStyle(fontSize: 14),
    ),
    btnOkColor: Color(0xFFFEB800),
    //desc: 'You are in danger',
    btnOkText: 'Stop'.tr,

    body: AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText('${authCtr.cUser.role == 'patient' ? 'You are': '${name} is'} in danger'.tr,
            textStyle: GoogleFonts.indieFlower(
              textStyle:  TextStyle(
                  fontSize: 21,
                  color: accentColor0,
                  fontWeight: FontWeight.w800
              ),
            ),
            speed: const Duration(
              milliseconds: 80,
            )),
      ],
      isRepeatingAnimation: true,
      totalRepeatCount: 40,
    ),
    btnOkOnPress: () {
      Alarm.stop(alarmID!).then((_) {
        Get.back();
      });
    },

  ).show();
}
showShouldVerify({bool isLoadingScreen =false}) {
  return AwesomeDialog(
    dialogBackgroundColor: dialogsCol,
    width: awesomeDialogWidth,

    autoDismiss: true,
    context: navigatorKey.currentContext!,

    showCloseIcon: true,
    dismissOnTouchOutside: true,
    animType: AnimType.SCALE,
    headerAnimationLoop: false,
    dialogType: DialogType.INFO,
    title: 'Verification'.tr,
    desc: 'Your email is not verified\nVerify now?'.tr,
    btnOkText: 'Verify'.tr,
    btnCancelText: 'cancel'.tr,
    btnOkColor: Colors.blue,
    btnOkIcon: Icons.send,
    btnOkOnPress: () {
      ///Get.to(() => VerifyScreen());
    },
    // btnCancelOnPress: (){
    //   authCtr.signOut();
    //
    //
    //   Get.offAll(() => LoginScreen());
    //
    // },
    onDismissCallback: (_){
      if(isLoadingScreen){
        authCtr.signOut();
        ///Get.offAll(() => Login());
      }

    },
    padding: EdgeInsets.symmetric(vertical: 20.0),
  ).show();
}
showChangeProp({title,body, Function()? btnOkPress,icon}) {
  return AwesomeDialog(
    dialogBackgroundColor: primaryColor,
    width: awesomeDialogWidth,

    customHeader: icon,
    autoDismiss: false  ,
    context: navigatorKey.currentContext!,

    showCloseIcon: false,
    dismissOnTouchOutside: true,
    animType: AnimType.scale,
    headerAnimationLoop: false,
dismissOnBackKeyPress: true,

     btnCancelOnPress: (){
      Get.back();
     },
    dialogType: DialogType.noHeader,
    title: title,
    titleTextStyle: TextStyle(
      color: Colors.blueAccent
    ),
    body: body,
    //desc: 'Your email is not verified\nVerify now?'.tr,
    btnOkText: 'Change'.tr,
    btnCancelText: 'cancel'.tr,
    btnCancelColor: Colors.grey,

    btnOkColor: accentColor0,

    btnOkIcon: Icons.check,
    btnOkOnPress: () {
      btnOkPress!();
    },
    onDismissCallback: (type) {
      print('## Dialog Dissmiss from callback $type');
      //Get.back();
    },
    padding: EdgeInsets.symmetric(vertical: 20.0),
  ).show();
}
Future<bool> showNoHeader({String? txt,String? btnOkText,Color btnOkColor = errorColor,IconData? icon}) async {
  bool shouldDelete = false;

  await AwesomeDialog(
    context: navigatorKey.currentContext!,
    width: awesomeDialogWidth,

    dialogBackgroundColor: dialogsCol,//default :themeData
    autoDismiss: true,
    isDense: true,
    dismissOnTouchOutside: true,
    showCloseIcon: false,
    headerAnimationLoop: false,
    dialogType: DialogType.noHeader,
    animType: AnimType.scale,
    btnCancelIcon: Icons.arrow_back_ios_sharp,
    btnCancelColor: Colors.transparent,
    btnOkIcon: icon ?? Icons.delete,
    //btnOkColor: btnOkColor ?? Colors.red,

    btnCancel:  TextButton(
      style: borderStyle(color: btnOkColor),
      onPressed: () {
        shouldDelete = false;
        Get.back();

      },
      child: Text(
        "Cancel".tr,
        style: TextStyle(color: dialogButtonTextCol),
      ),
    ),
    btnOk: TextButton(
      style: filledStyle(color: btnOkColor  ),
      onPressed: ()  {
        shouldDelete = true;
        Get.back();
      },
      child: Text(
        btnOkText ??'delete'.tr,
        style: TextStyle(color: dialogButtonTextCol),
      ),
    ),
    titleTextStyle: TextStyle(fontSize: 18.sp,color: dialogTitleCol),
    descTextStyle: TextStyle(fontSize: 16.sp),
      buttonsTextStyle: TextStyle(fontSize: 15.sp),

    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
    // texts
    title: 'Verification'.tr,
    desc: txt ?? 'Are you sure you want to delete this image'.tr,
    btnCancelText: 'cancel'.tr,
    btnOkText: btnOkText ??'delete'.tr ,

    // buttons functions
    btnOkOnPress: () {
      shouldDelete = true;
    },
    btnCancelOnPress: () {
      shouldDelete = false;
    },




  ).show();
  return shouldDelete;
}



/// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void updateFieldInFirestore(String collectionName, String docId, String fieldName, dynamic fieldValue) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firestore.collection(collectionName).doc(docId).update({
    fieldName: fieldValue,
  }).then((value) {
    print('## Field updated successfully <$collectionName/$docId/$fieldName> = <${fieldValue}>');
  }).catchError((error) {
    print('## Error updating field: $error /// <$collectionName/$docId/$fieldName> = <${fieldValue}>');

  });
}
Future<dynamic> getFieldFromFirestore(String collectionName, String docId, String fieldName) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    DocumentSnapshot snapshot = await firestore.collection(collectionName).doc(docId).get();
    if (snapshot.exists) {

      dynamic docMap = snapshot.data() as Map<String, dynamic>;
      dynamic fieldValue = docMap[fieldName];

      if (fieldValue is int) {
        return fieldValue.toDouble(); // Convert int to double
      } else {
        return fieldValue;
      }
    } else {
      print('## Document not found <$collectionName/$docId>');
      return null;
    }
  } catch (error) {
    print('## Error retrieving field <$collectionName/$docId/$fieldName> : $error');
    return null;
  }
}
/// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void declineAppoi(appoiID) {
  usersColl.doc(authCtr.cUser.id)
      .get()
      .then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      Map<String, dynamic> appointments = documentSnapshot.get('appointments');

      appointments.remove(appoiID);

      await usersColl.doc(authCtr.cUser.id).update({
        'appointments': appointments,
      }).then((value) async {
        print('## appointment declined');
        showSnack('appointment declined',color:Colors.black54);
      }).catchError((error) async {
        showSnack('appointment declining error',color: Colors.redAccent.withOpacity(0.8));
      });
    }
  });
}
void acceptAppoi(appoiID) {
  usersColl.doc(authCtr.cUser.id).get().then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      Map<String, dynamic> appointments = documentSnapshot.get('appointments');

      appointments[appoiID]['new'] = false;

      await usersColl.doc(authCtr.cUser.id).update({
        'appointments': appointments,
      }).then((value) async {
        print('## appointment accepted');
        showSnack('appointment accepted');
      }).catchError((error) async {
        showSnack('appointment accepting error',color:Colors.redAccent.withOpacity(0.8));
      });
    }
  });
}
Future<List<DocumentSnapshot>> getDocumentsByColl(coll) async {
  QuerySnapshot snap = await coll.get();

  final List<DocumentSnapshot> documentsFound = snap.docs;

  print('## collection docs number from firestore => (${documentsFound.length})');

  return documentsFound;
}

Future<void> removeElementsFromList(List elements, String fieldName, String docID, String collName) async {
  print('## start deleting list <$elements>_<$fieldName>_<$docID>_<$collName>');

  CollectionReference coll = FirebaseFirestore.instance.collection(collName);

  coll.doc(docID).get().then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      // export existing elements
      List<dynamic> oldElements = documentSnapshot.get(fieldName);
      print('## oldElements:(before delete) $oldElements');

      // remove elements from oldElements
      List<dynamic> elementsRemoved = [];

      for (var element in elements) {
        if (oldElements.contains(element)) {
          oldElements.removeWhere((e) => e == element);
          elementsRemoved.add(element);
          //print('# removed <$element> from <$oldElements>');

        }
      }

      print('## oldElements:(after delete) $oldElements');
      await coll.doc(docID).update(
        {
          fieldName: oldElements,
        },
      ).then((value) async {
        print(
            '## successfully deleted list <$elementsRemoved> FROM <$fieldName>_<$docID>_<$collName>');
      }).catchError((error) async {
        print(
            '## failure to delete list <$elementsRemoved> FROM  <$fieldName>_<$docID>_<$collName>');
      });
    } else if (!documentSnapshot.exists) {
      print('## docID not existing');
    }
  });
}
Future<void> addElementsToList(
    List newElements, String fieldName, String docID, String collName,
    {bool canAddExistingElements = true}) async {
  print(
      '## start adding list <$newElements> TO <$fieldName>_<$docID>_<$collName>');

  CollectionReference coll = FirebaseFirestore.instance.collection(collName);

  coll.doc(docID).get().then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      // export existing elements
      List<dynamic> oldElements = documentSnapshot.get(fieldName);
      print('## oldElements: $oldElements');
      // element to add
      List<dynamic> elementsToAdd = [];
      if (canAddExistingElements) {
        elementsToAdd = newElements;
      } else {
        for (var element in newElements) {
          if (!oldElements.contains(element)) {
            elementsToAdd.add(element);
          }
        }
      }

      print('## elementsToAdd: $elementsToAdd');
      // add element
      List<dynamic> newElementList = oldElements + elementsToAdd;
      print('## newElementListMerged: $newElementList');

      //save elements
      await coll.doc(docID).update(
        {
          fieldName: newElementList,
        },
      ).then((value) async {
        print(
            '## successfully added list <$elementsToAdd> TO <$fieldName>_<$docID>_<$collName>');
      }).catchError((error) async {
        print(
            '## failure to add list <$elementsToAdd> TO <$fieldName>_<$docID>_<$collName>');
      });
    } else if (!documentSnapshot.exists) {
      print('## docID not existing');
    }
  });
}

updateDoc2(CollectionReference coll, docID, Map<String, dynamic> mapToUpdate) async {
  coll.doc(docID).update(mapToUpdate).then((value) async {
    print("### doc with id:<$docID> updated ");
  }).catchError((e) async {
    print("## Failed to update document: $e");
  });
}


/// Check If Document Exists
Future<bool> checkIfDocExists(String collName, String docId) async {
  try {
    // Get reference to Firestore collection
    var collectionRef = FirebaseFirestore.instance.collection(collName);

    var doc = await collectionRef.doc(docId).get();
    return doc.exists;
  } catch (e) {
    throw e;
  }
}
void openNotif(notifID) {
  usersColl
      .doc(authCtr.cUser.id)
      .get()
      .then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      Map<String, dynamic> notifications = documentSnapshot.get('notifications');

      notifications[notifID]['new'] = false;

      await usersColl.doc(authCtr.cUser.id).update({
        'notifications': notifications,
      }).then((value) async {
        //showSnack('appointment accepted');
      }).catchError((error) async {
        //showSnack('appointment accepting error',color:Colors.redAccent.withOpacity(0.8));
      });
    }
  });
}
void deleteNotif(notifID) {
  usersColl.doc(authCtr.cUser.id)
      .get()
      .then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      Map<String, dynamic> notifications = documentSnapshot.get('notifications');


      notifications.remove(notifID);

      await usersColl.doc(authCtr.cUser.id).update({
        'notifications': notifications,
      }).then((value) async {
        print('## notif deleted');
        //showSnack('appointment declined',color:Colors.black54);
      }).catchError((error) async {
        print('## notif delete failed');

        //showSnack('appointment declining error',color: Colors.redAccent.withOpacity(0.8));
      });
    }
  });
}


void removePatient(Worker patient) async {
  String patID = 'patient.id!';
  String dctrID = 'patient.doctorAttachedID!';

  //add doctor to patient
  updateDoc2(usersColl, patID, {'doctorAttachedID': ''});

  //remove patient from doctor
  removeElementsFromList([patID], 'patients', dctrID, 'sc_users').then((value) {
    //showSnack("${patient.name} ${'removed from my patients list'.tr}",color: Colors.redAccent.withOpacity(0.8));

  });

  //remove doctor to patient
  //refresh curr user
  //authCtr.refreshCuser();///refresh

}
void addPatient(Worker patient) async {
  String patID = 'patient.id!';
  String dctrID = authCtr.cUser.id!;

  //add doctor to patient
  updateDoc2(usersColl, patID, {'doctorAttachedID': dctrID});

  //add patient to doctor
  await addElementsToList([patID], 'patients', dctrID, 'sc_users').then((value) {
    //showSnack("${patient.name} ${'added to my patients list'.tr}");

  });

  //refresh curr user
  //authCtr.refreshCuser();
}
void showAnimDialog(Widget? child,{DialogTransitionType? animationType,int? milliseconds}){
  showAnimatedDialog(
    context: navigatorKey.currentContext!,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return child??Container()  ;
    },
    animationType:animationType?? DialogTransitionType.slideFromTop,
    curve: Curves.fastOutSlowIn,
    duration: Duration(milliseconds: milliseconds??500),
  );
}

Future<List<T>> getAlldocsModelsFromFb<T>(
    CollectionReference coll,
    T Function(Map<String, dynamic>) fromJson,
    ) async {
  print('## downloadeding models...');

  List<T> models = [];
  List<DocumentSnapshot> docs = await getDocumentsByCollCondition(coll);
  for (var doc in docs) {
    T model = fromJson(doc.data() as Map<String, dynamic>);
    models.add(model);
  }

  //print('## downloaded < ${models.length} > docs from <${coll.path}>');
  return models;
}

languageList() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 25.0),

        child:Text('choose language'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
          textStyle:  TextStyle(
              fontSize: 25  ,
              color:greenSwatch[50],
                fontWeight: FontWeight.w700
          ),
        ),),
      ),
      ListTile(
        title: Text('English'.tr),
        onTap: () {
          lngCtr.changeLang('en');

          Get.back();
        },
      ),


      const Divider(
        thickness: 1,
      ),
      ListTile(
        title: Text('French'.tr),
        onTap: () {
          lngCtr.changeLang('fr');

          Get.back();
        },
      ),
    ],
  );
}
showLanguageDialog() {
  showDialog(
    barrierDismissible: true,
    context: navigatorKey.currentContext!,
    builder: (_) => AlertDialog(
      backgroundColor: dialogsCol,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return SizedBox(
            height: 200,
            //width: 100.w  ,
            child: languageList(),
          );
        },
      ),
    ),
  );
}

