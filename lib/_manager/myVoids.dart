

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
import 'bindings.dart';
import 'firebaseVoids.dart';
import 'myUi.dart';
import 'styles.dart';


FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseDatabase? get fbDatabase => FirebaseDatabase.instance;
User? get authCurrUser => FirebaseAuth.instance.currentUser;
FirebaseDatabase? get database => FirebaseDatabase.instance;
FirebaseAuth get fbAuth => FirebaseAuth.instance;

GoogleSignIn googleSign = GoogleSignIn();
String currency = 'TND';

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
String societyPhone = '52 09 50 87';
var workersColl = FirebaseFirestore.instance.collection('workers');
var clientsColl = FirebaseFirestore.instance.collection('clients');
var productsColl = FirebaseFirestore.instance.collection('products');
var invoicesColl = FirebaseFirestore.instance.collection('invoices');
var usersColl = FirebaseFirestore.instance.collection('users');

DateFormat dateFormatHM = DateFormat('dd-MM-yyyy HH:mm');
DateFormat dateFormatHMS = DateFormat('dd-MM-yyyy HH:mm:ss');


double awesomeDialogWidth =90.sp;

int refreshVerifInSec =5;
int introShowTimes =1;
bool verifyAnyCreatedAccount =false;
bool showLiveTime =false;




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
  list.sort((a, b) {
    DateTime timeA = dateFormatHM.parse(a.value['time']);
    DateTime timeB = dateFormatHM.parse(b.value['time']);
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

List<double> convertStringListToDoubleList(List<String> stringList) {
  List<double> doubleList = [];

  for (String stringValue in stringList) {
    double doubleValue = double.tryParse(stringValue) ?? 0.0;
    doubleList.add(doubleValue);
  }

  return doubleList;
}



bool isDateToday(String dateString) {
  // Create a DateFormat instance to parse the date string

  // Parse the date string to a DateTime object
  DateTime date = dateFormatHM.parse(dateString);

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
  bool isNegative = number < 0;
  if (isNegative) {
    numberString = numberString.substring(1); // Remove the negative sign
  }

  // Add comma separator from the right
  String formattedNumber = '';
  int count = 0;

  for (int i = numberString.length - 1; i >= 0; i--) {
    formattedNumber = numberString[i] + formattedNumber;
    count++;
    if (count == 3 && i > 0) {
      formattedNumber = ',' + formattedNumber;
      count = 0;
    }
  }

  if (isNegative) {
    formattedNumber = '-$formattedNumber'; // Add back the negative sign
  }

  if (number < 1000 && number > -1000) {
    formattedNumber = '0,$formattedNumber';
  }

  return formattedNumber;
}

String extractDate(String dateTimeString) {
  List<String> parts = dateTimeString.split(' '); // Split the string by space
  String datePart = parts[0]; // Get the first part, which is the date
  return datePart;
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



String todayToString({bool showDay = false,bool showHoursNminutes = false,bool showSeconds = true}) {
  //final formattedStr = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':' nn]);
  //DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");

  if (showDay) {
     dateFormat = DateFormat("dd-MM-yyyy");
  }
  if (showHoursNminutes) {
    dateFormat = DateFormat("dd-MM-yyyy HH:mm");
  }
  if (showSeconds) {
    dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
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

void updateFieldInFirestore(String collectionName, String docId, String fieldName, dynamic fieldValue,{Function()? addSuccess,}) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firestore.collection(collectionName).doc(docId).update({
    fieldName: fieldValue,
  }).then((value) {
    print('## Field updated successfully <$collectionName/$docId/$fieldName> = <${fieldValue}>');
    addSuccess!();

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
  //print('## downloadeding models...');

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

