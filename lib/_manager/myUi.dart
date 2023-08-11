import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gajgaji/_models/buySellProd.dart';
import 'package:gajgaji/_models/prodChange.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_models/client.dart';
import '../_models/expKridi.dart';
import '../_models/invProd.dart';
import '../_models/invoice.dart';
import '../_models/product.dart';
import '../_models/worker.dart';
import '../invoices/addEditInvoice.dart';
import '../products/productInfos.dart';
import '../workers/addEditWorker.dart';
import '../workers/workerInfo.dart';
import '../x_printPdf/app.dart';
import 'bindings.dart';
import 'firebaseVoids.dart';
import 'myLocale/myLocaleCtr.dart';
import 'myVoids.dart';
import 'styles.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

richTextWidget() {
  return RichText(
    locale: Locale(currLang!),
    textAlign: TextAlign.start,
//softWrap: true,
    text: TextSpan(children: [
      WidgetSpan(
        child: Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Icon(
            size: 20,
            Icons.check,
            color: Colors.green,
          ),
        ),
      ),
      WidgetSpan(
          child: SizedBox(
        width: 0,
      )),
      TextSpan(
          text: 'سنقوم بإنشاء محتوى جذاب ومتميز للإعلانات الخاصة بك لجذب اهتمام الجمهور.'.tr,
          style: GoogleFonts.almarai(
            height: 1.8,
            textStyle: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
          )),
    ]),
  );
}

///
///
///
///
// ///notifCard
// Widget notifCard(String ind, Map<String, dynamic> notifInfo,) {
//   bool newNotif = notifInfo['new'];
//   String usrName = notifInfo['usrName'];
//   String bpmVal = notifInfo['bpm'];
//   String time = notifInfo['time'];
//   String day = notifInfo['day'];
//   String month = notifInfo['month'];
//
//   double lat = double.parse(notifInfo['lat']);
//   double lng = double.parse(notifInfo['lng']);
//
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 4.0),
//     child: Container(
//       height:  120,
//       child: Stack(
//
//         children: [
//
//
//
//
//
//           Card(
//             color: cardColor,
//             elevation: 50,
//             shadowColor: Colors.black,
//             //color: dialogsCol.withOpacity(0.5),
//             shape: RoundedRectangleBorder(
//                 side: BorderSide(
//                     color: newNotif ? Colors.green : Colors.white38,
//                     width: 3),
//                 borderRadius: BorderRadius.circular(20)),
//             child: Padding(
//               padding: const EdgeInsets.only(top: 17.0),
//               // child:Row(
//               //   children: [
//               //
//               //   ],
//               // ),
//               child: ListTile(
//                 dense: false,
//                 //isThreeLine: false,
//                 leading: MonthSquare(day,month),
//                 title: Text(usrName,
//                   maxLines: 1,
//                   style: TextStyle(
//                       color: newNotif ? newCardCol : Colors.grey,
//                       fontWeight: FontWeight.w500,
//                     fontSize: 20
//
//                 ),),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 4),
//                     Text("Heart rate: $bpmVal bpm",
//                       style: TextStyle(
//                         //color: cardColor.withOpacity(0.85),
//                         color: newNotif? newCardCol: Colors.white.withOpacity(0.80),
//                         fontSize: 15,
//
//                       ),),
//                     SizedBox(height: 4),
//                     Text("Time: ${time}",style: TextStyle(
//                         color: Colors.white.withOpacity(0.80),
//                         fontSize: 15,
//                         fontWeight: FontWeight.w400
//
//
//                     ),),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//          // if(authCtr.cUser.role == 'doctor')
//            Positioned(
//             bottom: 40,
//             right: (currLang =='ar')? null:25,//english
//             left: (currLang =='ar')? 25:null,//arabic
//             child: CircleAvatar(
//               backgroundColor: Colors.blueGrey,
//               radius: 20,
//               child: IconButton(
//                 padding: EdgeInsets.zero,
//                 icon: Icon(Icons.pin_drop_sharp,size: 22),
//                 color: Colors.white,
//                 onPressed: () {
//                   Get.to(() => MapMarker(), arguments: {
//                     'pos': LatLng(lat, lng),
//                     'patName': usrName,
//                   });
//                   openNotif(ind);
//                 },
//               ),
//             ),
//           ),
//            Positioned(
//             bottom: 13,
//              right: (currLang =='ar')? null:13,//english
//              left: (currLang =='ar')? 13:null,//arabic
//             child:   GestureDetector(
//
//               child: Icon(
//                 size: 20,
//                 Icons.close,
//                 //weight: 50,
//                 color: Colors.red.withOpacity(0.65),
//               ),
//               onTap: () {
//
//                 deleteNotif(ind);
//
//               },
//             ),
//
//            ),
//
//
//         ],
//       ),
//     ),
//   );
// }
//
//
//
// ///adviceCard
// Widget adviceCard(advice, {bool newAdvice = false}) { //doctor
//
//   Color itemCol = newAdvice ? Colors.green : Colors.white38;
//
//   String title=advice['title'];
//   String desc=advice['description'];
//   return GestureDetector(
//     onTap: () async {
//
//       Get.to(()=>OneAdvice(body: desc.tr,title: title.tr,));
//     },
//     child: Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: Container(
//         width: 100.w,
//         height: 140,
//         child: Stack(
//           children: [
//             Card(
//               color: cardColor,
//               elevation: 50,
//               shape: RoundedRectangleBorder(
//                   side: BorderSide(
//                       color: itemCol,
//                       width: 2),
//                   borderRadius: BorderRadius.circular(20)),
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(18, 5, 15, 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 15),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           advice['image'],
//                           width: 65,
//                           color:itemCol,
//                         ),
//                         SizedBox(width: 13),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(right: 0.0),
//                               child: SizedBox(
//
//                                 width: 51.w,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//
//                                   children: [
//                                     Text(
//                                       title.tr,
//                                       textAlign: TextAlign.start,
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 1,
//                                       style: TextStyle(color: Colors.white, fontSize: 15),
//                                     ),
//                                     SizedBox(height: 5),
//
//                                     Text(
//                                       '${desc.tr}}',
//                                       maxLines: 3,
//                                       textAlign: TextAlign.start,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                           color: itemCol,
//                                           fontSize: 13),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//
//                             SizedBox(height: 5),
//
//                             // Text(
//                             //   'Time: ${advice['time']}',
//                             //   style: TextStyle(
//                             //       color: Colors.white54, fontSize: 11),
//                             // ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     ),
//   );
// }
//
// ///patientsCard
// Widget patientCard(ScUser user, List<dynamic> doctrPats) {
//   return GestureDetector(
//     onTap: () {
//       //if(doctrPats.contains(user.id)) Get.to(() => PatientInfo());
//     },
//     child: Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: Container(
//         width: 100.w,
//         height: 120,
//         child: Stack(
//           children: [
//             Card(
//               color: cardColor,
//               elevation: 50,
//               shape: RoundedRectangleBorder(
//                   side: BorderSide(color: Colors.white38, width: 2),
//                   borderRadius: BorderRadius.circular(20)),
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 15),
//
//                     ///patient simple info
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           'assets/images/patient.png',
//                           width: 72,
//                           color: Colors.blueGrey,
//                         ),
//                         SizedBox(width: 10),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ///name
//                             Text(
//                               '${user.name}',
//                               style:
//                               TextStyle(color: Colors.white, fontSize: 18),
//                             ),
//                             SizedBox(height: 5),
//
//                             ///email
//                             Text(
//                               user.email!,
//                               style:
//                               TextStyle(color: Colors.white, fontSize: 11),
//                             ),
//                             SizedBox(height: 5),
//
//                             ///ge,der
//                             Text(
//                               '${user.sex!} (${user.age})',
//                               style:
//                               TextStyle(color: Colors.white, fontSize: 13),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             (!doctrPats.contains(user.id))?
//               Positioned(
//                 bottom: 40,
//                 right: (currLang =='ar')? null:25,//english
//                 left: (currLang =='ar')? 25:null,//arabic
//                 child: CircleAvatar(
//                   backgroundColor: Colors.blueGrey,
//                   radius: 20,
//                   child: IconButton(
//                     padding: EdgeInsets.zero,
//                     icon: Icon(Icons.add),
//                     color: Colors.white,
//                     onPressed: () {
//                       addPatient(user);
//                       dcCtr.updateCtr();
//                     },
//                   ),
//                 ),
//               ):Positioned(
//                 bottom: 40,
//               right: (currLang =='ar')? null:25,//english
//               left: (currLang =='ar')? 25:null,//arabic
//                               child: CircleAvatar(
//                   backgroundColor: Colors.blueGrey,
//                   radius: 20,
//                   child: IconButton(
//                     padding: EdgeInsets.zero,
//                     icon: Icon(Icons.message,size: 19),
//                     color: Colors.white,
//                     onPressed: () {
//                       Get.to(() => ChatRoom(), arguments: {'user': user});
//                     },
//                   ),
//                 ),
//               ),
//
//
//             if(doctrPats.contains(user.id)) Positioned(
//                 bottom: 10,
//                 right: (currLang =='ar')? null:20,//english
//                 left: (currLang =='ar')? 20:null,//arabic
//                 child: GestureDetector(
//
//                   child: Text(
//                     'Remove'.tr,
//                     //weight: 50,
//                     style: TextStyle(
//                       color: Colors.red.withOpacity(0.7),
//                       fontWeight: FontWeight.w500,
//                       fontSize: 13,
//                     ),
//                   ),
//                   onTap: () {
//                     showNoHeader(
//                       txt: 'Are you sure you want to remove this patient ?'.tr,
//                       icon: Icons.close,
//                       btnOkColor: Colors.red,
//                       btnOkText: 'Remove'.tr,
//                     ).then((toAllow) {// if admin accept
//                       if (toAllow) {
//                         removePatient(user);
//                         Future.delayed(const Duration(milliseconds: 500), () {
//                           dcCtr.updateCtr();
//
//
//                         });
//
//                       }
//                     });
//
//                   },
//                 )
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
// ///patientsCard
// Widget userCard(ScUser user) {
//   //double cardHei = user.role=='doctor'? 160: 130;
//   double cardHei = 130;
//
//   return GestureDetector(
//
//     child: Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: Container(
//         width: 100.w,
//         height: cardHei,
//         child: Stack(
//           children: [
//             Card(
//               color: cardColor,
//               elevation: 50,
//               shape: RoundedRectangleBorder(
//                   side: BorderSide(color: Colors.white38, width: 2),
//                   borderRadius: BorderRadius.circular(20)),
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 5, 15, 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 15),
//
//                     ///patient simple info
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           'assets/images/patient.png',
//                           width: 72,
//                           color: Colors.blueGrey,
//                         ),
//                         SizedBox(width: 10),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ///name
//                             Text(
//                               '${user.name}',
//                               style:
//                               TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(height: 5),
//
//                             ///email
//                             Text(
//                               user.email!,
//                               style:
//                               TextStyle(color: Colors.white, fontSize: 11),
//                             ),
//                             SizedBox(height: 5),
//
//
//                             Text(
//                               //'${user.sex!} (${user.age})',
//                               '${user.sex!} (${user.age != '' ? user.age:user.speciality})',
//
//                               style:
//                               TextStyle(color: Colors.white, fontSize: 13),
//                             ),
//                             SizedBox(height: 5),
//
//                             (user.role == 'doctor')? Text(
//                               'Tax: F6KH-ZFG564-6FKDZ',
//                               style: TextStyle(color: Colors.white, fontSize: 13),
//                             ): Text(
//                               'Tel: ${user.number!}',
//                               style:
//                               TextStyle(color: Colors.white, fontSize: 13),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             !user.accepted?
//               Positioned(
//                 bottom: cardHei/3,
//                 right: (currLang =='ar')? null:25,//english
//                 left: (currLang =='ar')? 25:null,//arabic
//                 child: CircleAvatar(
//                   backgroundColor: Colors.greenAccent.withOpacity(0.7),
//                   radius: 20,
//                   child: IconButton(
//                     padding: EdgeInsets.zero,
//                     icon: Icon(Icons.check),
//                     color: Colors.white,
//                     onPressed: () {
//                       showNoHeader(
//                         txt: 'Are you sure you want to accept this user ?'.tr,
//                         icon: Icons.check,
//                         btnOkColor: Colors.green,
//                         btnOkText: 'add'.tr,
//                       ).then((toAllow) {// if admin accept
//                         if (toAllow) {
//
//                           acceptUser(user.id!);
//                         }
//                       });
//
//                     },
//                   ),
//                 ),
//               ):Positioned(
//                 bottom: cardHei/3,
//               right: (currLang =='ar')? null:25,//english
//               left: (currLang =='ar')? 25:null,//arabic
//                 child: CircleAvatar(
//                   backgroundColor: Colors.red.withOpacity(0.6),
//                   radius: 20,
//                   child: IconButton(
//                     padding: EdgeInsets.zero,
//                     icon: Icon(Icons.close,size: 19),
//                     color: Colors.white,
//                     onPressed: () {
//                       showNoHeader(
//                         txt: 'Are you sure you want to remove this user ?'.tr,
//                         icon: Icons.close,
//                         btnOkColor: Colors.red,
//                         btnOkText: 'Remove'.tr,
//                       ).then((toAllow) {// if admin accept
//                         if (toAllow) {
//                           deleteUser(user.id!);// delete user from firestore
//                           deleteUserFromAuth(user.email, user.pwd);// delete from auth
//                         }
//                       });
//                       },
//                   ),
//                 ),
//               ),
//
//
//           ],
//         ),
//       ),
//     ),
//   );
// }
// ///apooiCard
// Widget appoiCard(String key, Map<String, dynamic> appoiInfo,) {
//
//   bool newAppoi = appoiInfo['new'];
//   String patientName = appoiInfo['patientName'];
//   String time = appoiInfo['time'];
//   String day = appoiInfo['day'];
//   String month = appoiInfo['month'];
//   String topic = appoiInfo['topic'];
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 4.0),
//     child: Container(
//       height: newAppoi ? 120:100,
//       child: Stack(
//         children: [
//           Card(
//             shadowColor: Colors.black,
//             color: dialogsCol.withOpacity(0.5),
//             shape: RoundedRectangleBorder(
//                 side: BorderSide(
//                     color: newAppoi ? Colors.green : Colors.white38,
//                     width: 3),
//                 borderRadius: BorderRadius.circular(20)),
//             child: Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               // child:Row(
//               //   children: [
//               //
//               //   ],
//               // ),
//               child: ListTile(
//                 dense: false,
//                 //isThreeLine: false,
//                 leading: MonthSquare(day,month),
//                 title: Text(patientName,style: TextStyle(
//                     color: cardColor,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 20
//
//                 ),),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 4),
//                     Text("${'Topic'.tr}: ${topic}",
//                       maxLines: 1,
//                       // overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         //color: cardColor.withOpacity(0.85),
//                         color: Colors.white.withOpacity(0.80),
//                         fontSize: 15,
//
//
//
//                       ),),
//                     SizedBox(height: 4),
//                     Text("${'Time'.tr}: ${time}",style: TextStyle(
//                         color: !newAppoi? Colors.white: Colors.white.withOpacity(0.80),
//                         fontSize: 15,
//                         fontWeight: !newAppoi? FontWeight.w800 :FontWeight.w400
//
//                     ),),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           newAppoi
//               ? Positioned(
//               bottom: 15,
//               right: (currLang =='ar')? null:10,//english
//               left: (currLang =='ar')? 10:null,//arabic
//               child: Row(mainAxisSize: MainAxisSize.min, children: [
//                 GestureDetector(
//                   // child: Icon(
//                   //   size: 20,
//                   //   Icons.check,
//                   //   //weight: 50,
//                   //   color: cardColor,
//                   // ),
//                   child: Text(
//                     'Accept'.tr,
//                     //weight: 50,
//                     style: TextStyle(
//                         color: primaryColorMat[800],
//                         fontWeight: FontWeight.w500
//                     ),
//                   ),
//                   onTap: () {
//                     // showNoHeader(
//                     //   txt: 'Are you sure you want to accept this user request ?',
//                     //   icon: Icons.check,
//                     //   btnOkColor: Colors.green,
//                     //   btnOkText: 'Accept',
//                     // ).then((toAllow) {// if admin accept
//                     //   if (toAllow) {
//                     //     acceptUser(user.id!);
//                     //     getUsersData();//refresh
//                     //   }
//                     // });
//                     acceptAppoi(key);
//
//                   },
//                 ),
//                 SizedBox(width: 17),
//                 GestureDetector(
//                   child: Text(
//                     'Decline'.tr,
//                     //weight: 50,
//                     style: TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.w500
//                     ),
//                   ),
//
//
//                   onTap: () {
//
//                     declineAppoi(key);
//                   },
//                 ),
//                 SizedBox(width: 10),
//
//               ]))
//               : Container()
//         ],
//       ),
//     ),
//   );
// }


Widget customFAB({String? text ,IconData? icon ,VoidCallback? onPressed }){
 return Padding(
    padding:  EdgeInsets.symmetric(horizontal: 00.0, vertical: 20),
    child: Container(
      // height: 40.0,
      // width: 130.0,
      //constraints: BoxConstraints(minWidth: 56.0),

      child: FittedBox(
        child: FloatingActionButton.extended(
          onPressed: onPressed,


          //backgroundColor: yellowColHex,
          label: Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              Icon(icon??Icons.add),
              SizedBox(width: 8),
              Text(
                text??'',
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


/// workers

Widget expKridiCard(key, ExpKridi expKridi, {bool isExp = true}) {
  double cardHei = 130;

  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      width: 100.w,
      height: cardHei,
      child: Stack(
        children: [
          Card(
            color: cardColor,
            elevation: 50,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white38, width: 2), borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      monthSquare(expKridi.time!),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///price
                          Text(
                            '${formatNumberAfterComma2(expKridi.price!)} $currency',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),

                          ///time

                          SizedBox(height: 5),

                          Text(
                            '${'type:'.tr} ${expKridi.type}',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          SizedBox(height: 5),

                          Text(
                            '${'desc:'.tr} ${expKridi.desc}',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 13,
            right: (currLang == 'ar') ? null : 13, //english
            left: (currLang == 'ar') ? 13 : null, //arabic
            child: GestureDetector(
              child: Icon(
                size: 20,
                Icons.close,
                //weight: 50,
                color: Colors.red.withOpacity(0.65),
              ),
              onTap: () {
                ///deleteExpKridi(ind);
                if (isExp) {
                  deleteFromMap(
                      coll: workersColl, docID: wrkCtr.selectedWorker.id, fieldMapName: 'expensesHis', mapKeyToDelete: key);
                } else {
                  deleteFromMap(
                      coll: workersColl, docID: wrkCtr.selectedWorker.id, fieldMapName: 'kridiHis', mapKeyToDelete: key);
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget workerCard(Workerh worker) {
  //double cardHei = user.role=='doctor'? 160: 130;
  double cardHei = 130;

  return GestureDetector(
    onTap: () {
      // open expenses and his tabs
      wrkCtr.selectWorker(worker);
      Get.to(() => WorkerInfo());
    },
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 100.w,
        height: cardHei,
        child: Stack(
          children: [
            Card(
              color: cardColor,
              elevation: 50,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color:  Colors.white38, width: 2),
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/user.png',
                          width: 72,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///name
                            Text(
                              '${worker.name}',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${'Tel:'.tr} ${worker.phone}',
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                            ///email
                            // Text(
                            //   'Email: ${worker.email}',
                            //   style: TextStyle(color: Colors.white, fontSize: 11),
                            // ),
                            //SizedBox(height: 5),
                            SizedBox(height: 5),
                            ///krdi
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: RichText(
                                locale: Locale(currLang!),
                                textAlign: TextAlign.start,
                                //softWrap: true,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: 'kridi:'.tr,
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle: TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: '  ${formatNumberAfterComma2(worker.totalKridi!)}',
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle: TextStyle(color:  Colors.white , fontSize: 15, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: '  $currency',
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500),
                                      )),
                                ]),
                              ),
                            ),
                            ///expenses
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: RichText(
                                locale: Locale(currLang!),
                                textAlign: TextAlign.start,
                                //softWrap: true,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: 'expenses:'.tr,
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: '  ${formatNumberAfterComma2(worker.totalKridi!)}',
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle: TextStyle(color:  Colors.white , fontSize: 15, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: '  $currency',
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500),
                                      )),
                                ]),
                              ),
                            ),




                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 13,
              right: (currLang == 'ar') ? null : 13, //english
              left: (currLang == 'ar') ? 13 : null, //arabic
              child: GestureDetector(
                child: Icon(
                  size: 20,
                  Icons.close,
                  //weight: 50,
                  color: Colors.white.withOpacity(0.40),
                ),
                onTap: () {
                  showNoHeader(
                    txt: 'Are you sure you want to remove this worker ?'.tr,
                    icon: Icons.close,
                    btnOkColor: Colors.red,
                    btnOkText: 'Remove'.tr,
                  ).then((toAllow) {
                    // if admin accept
                    if (toAllow) {
                      deleteDoc(
                          docID: worker.id!,
                          coll: workersColl,
                          btnOnPress: () {
                            showSnack('"${worker.name}" ${'removed'.tr}', color: Colors.redAccent.withOpacity(0.8));
                            Future.delayed(const Duration(milliseconds: 500), () {
                              wrkCtr.update();
                            });
                          });

                      /// remove product from coll
                    }
                  });
                },
              ),
            ),
            Positioned(
              bottom: 13,
              right: (currLang == 'ar') ? null : 13, //english
              left: (currLang == 'ar') ? 13 : null, //arabic
              child: GestureDetector(
                child: Icon(
                  size: 20,
                  Icons.edit,
                  //weight: 50,
                  color: Colors.white.withOpacity(0.4),
                ),
                onTap: () {
                  wrkCtr.selectWorker(worker);
                  Get.to(() => AddEditWorker(), arguments: {'isAdd': false});
                },
              ),
            ),
            Positioned(
              bottom: cardHei / 3,
              right: (currLang == 'ar') ? null : 25, //english
              left: (currLang == 'ar') ? 25 : null, //arabic
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.redAccent.withOpacity(0.6),
                    radius: 18,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.money_off_sharp, size: 19),
                      color: Colors.white,
                      onPressed: () {
                        wrkCtr.selectWorker(worker);
                        showAnimDialog(wrkCtr.addExpKridiDialog(isExpense: true));
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.greenAccent.withOpacity(0.6),
                    radius: 18,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.attach_money, size: 19),
                      color: Colors.white,
                      onPressed: () {
                        wrkCtr.selectWorker(worker);
                        showAnimDialog(wrkCtr.addExpKridiDialog(isExpense: false));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// clients
Widget clientCard(Clienth client) {
  //double cardHei = user.role=='doctor'? 160: 130;
  double cardHei = 130;

  return GestureDetector(
    onTap: () {
      // open expenses and his tabs
      // cltCtr.selectClient(client);
      // Get.to(() => WorkerInfo());
    },
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 100.w,
        height: cardHei,
        child: Stack(
          children: [
            Card(
              color: cardColor,
              elevation: 50,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color:  Colors.white38, width: 2),
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/user.png',
                          width: 72,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///name
                            Text(
                              '${client.name}',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${'Tel:'.tr} ${client.phone}',
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                            SizedBox(height: 5),

                            ///address
                            Text(
                              '${'Address:'.tr} ${client.address}',
                              style: TextStyle(color: Colors.white, fontSize: 11),
                            ),
                            SizedBox(height: 5),
                            ///email

                            Text(
                              '${'Email:'.tr} ${client.email}',
                              style: TextStyle(color: Colors.white, fontSize: 11),
                            ),
                            SizedBox(height: 5),




                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 13,
              right: (currLang == 'ar') ? null : 13, //english
              left: (currLang == 'ar') ? 13 : null, //arabic
              child: GestureDetector(
                child: Icon(
                  size: 20,
                  Icons.close,
                  //weight: 50,
                  color: Colors.white.withOpacity(0.40),
                ),
                onTap: () {
                  showNoHeader(
                    txt: 'Are you sure you want to remove this client ?'.tr,
                    icon: Icons.close,
                    btnOkColor: Colors.red,
                    btnOkText: 'Remove'.tr,
                  ).then((toAllow) {
                    // if admin accept
                    if (toAllow) {
                      deleteDoc(
                          docID: client.id!,
                          coll: clientsColl,
                          btnOnPress: () {
                            showSnack('"${client.name}" removed'.tr, color: Colors.redAccent.withOpacity(0.8));
                            Future.delayed(const Duration(milliseconds: 500), () {
                              cltCtr.update();
                            });
                          });

                      /// remove product from coll
                    }
                  });
                },
              ),
            ),

          ],
        ),
      ),
    ),
  );
}

/// Products

Widget productCard(Product product) {
  //double cardHei = user.role=='doctor'? 160: 130;
  double cardHei = 130;
  Color sellPriceCol = Colors.blue;

  return GestureDetector(
    onTap: () {
      // open expenses and his tabs
      prdCtr.selectProduct(product);
      Get.to(() => ProductInfo());
    },
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 100.w,
        height: cardHei,
        child: Stack(
          children: [
            Card(
              color: cardColor,
              elevation: 50,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white38, width: 2), borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/bottle.png',
                          width: 72,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///name
                            Text(
                              '${product.name}',
                              style: TextStyle(
                                  color: (product.currPrice! < product.currBuyPrice! || product.currQty! <= 0 ) ?  Colors.redAccent.withOpacity(0.7): Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),

                            Text(
                              '${'qty:'.tr} ${product.currQty}',
                              style: TextStyle(color:product.currQty! > 0 ? Colors.white:Colors.redAccent, fontSize: 13),
                            ),
                            SizedBox(height: 5),

                            ///sell price
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: RichText(
                                locale: Locale(currLang!),
                                textAlign: TextAlign.start,
                                //softWrap: true,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: 'sell Price:'.tr,
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: '  ${formatNumberAfterComma2(product.currPrice!)}',
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle: TextStyle(color: product.currPrice! <= product.currBuyPrice! ? Colors.redAccent : Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: '  $currency',
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500),
                                      )),
                                ]),
                              ),
                            ),
                            SizedBox(height: 5),

                            ///buy price
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: RichText(
                                locale: Locale(currLang!),
                                textAlign: TextAlign.start,
                                //softWrap: true,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: 'buy Price:'.tr,
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: '  ${formatNumberAfterComma2(product.currBuyPrice!)}',
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle: TextStyle(color: product.currBuyPrice! <= 0.0 ? Colors.redAccent : Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: '  $currency',
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle:
                                        const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500),
                                      )),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 13,
              right: (currLang == 'ar') ? null : 13, //english
              left: (currLang == 'ar') ? 13 : null, //arabic
              child: GestureDetector(
                child: Icon(
                  size: 20,
                  Icons.close,
                  //weight: 50,
                  color: Colors.white.withOpacity(0.3),
                ),
                onTap: () {
                  showNoHeader(
                    txt: 'Are you sure you want to remove this product ?'.tr,
                    icon: Icons.close,
                    btnOkColor: Colors.red,
                    btnOkText: 'Remove'.tr,
                  ).then((toAllow) {
                    // if admin accept
                    if (toAllow) {
                      deleteDoc(
                          docID: product.id!,
                          coll: productsColl,
                          btnOnPress: () {
                            showSnack('"${product.name}" ${'removed'.tr}', color: Colors.redAccent.withOpacity(0.8));
                            prdCtr.update();
                          });

                      /// remove product from coll
                    }
                  });
                },
              ),
            ),
            Positioned(
              bottom: 13,
              right: (currLang == 'ar') ? null : 13, //english
              left: (currLang == 'ar') ? 13 : null, //arabic
              child: GestureDetector(
                child: Icon(
                  size: 20,
                  Icons.edit,
                  //weight: 50,
                  color: Colors.white.withOpacity(0.4),
                ),
                onTap: () {
                  prdCtr.selectProduct(product);
                  showAnimDialog(prdCtr.addProductDialog(isAdd: false));
                },
              ),
            ),
            Positioned(
              bottom: cardHei / 3,
              right: (currLang == 'ar') ? null : 25, //english
              left: (currLang == 'ar') ? 25 : null, //arabic
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.greenAccent.withOpacity(0.35),
                    radius: 18,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.add, size: 19),
                      color: Colors.white,
                      onPressed: () {
                        prdCtr.selectProduct(product);
                        showAnimDialog(prdCtr.addBSProductDialog(isSell: false));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
Widget bsProdCard(key, BuySellProd bsProd) {
  double cardHei = 130;
  Color incomeCol = bsProd.income! > 0 ? winIncomeCol : looseIncomeCol;
  String type = '';
  if(key.startsWith("0s")){
    type = 'sell';

  }else  if(key.startsWith("0b")){
    type = 'buy';

  }
  else {
    type = 'manual';
  }


  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      width: 100.w,
      height: cardHei,
      child: Stack(
        children: [
          Card(
            color: cardColor,
            elevation: 50,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white38, width: 2), borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      monthSquare(bsProd.time!),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///price
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
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
                                    text: '${formatNumberAfterComma2(bsProd.price!)}',
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                                    )),
                                TextSpan(
                                    text: ' $currency',
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle:
                                          const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                                    )),
                                TextSpan(
                                    text: '  (${bsProd.qty}) $key',
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                                    )),
                              ]),
                            ),
                          ),
                          SizedBox(height: 5),

                          ///qty rest
                          Text(
                            '${'rest quantity:'.tr} ${bsProd.restQty}',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                          SizedBox(height: 5),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
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
                                    text: 'total:'.tr,
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                    )),
                                TextSpan(
                                    text: '  ${formatNumberAfterComma2(bsProd.total!)}',
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle: TextStyle(color: totalCol, fontSize: 13, fontWeight: FontWeight.w500),
                                    )),
                                TextSpan(
                                    text: '  $currency',
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle:
                                          const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500),
                                    )),
                              ]),
                            ),
                          ),
                          SizedBox(height: 5),

                          if(type == 'buy') Text(
                            //'society: ${bsProd.society} (${bsProd.mf})',
                            '${'society:'.tr} ${bsProd.society}',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          if(type == 'sell') Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
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
                                    text: 'income:'.tr,
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                    )),
                                TextSpan(
                                    text: '  ${formatNumberAfterComma2(bsProd.income!)}',
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle: TextStyle(color: incomeCol, fontSize: 13, fontWeight: FontWeight.w500),
                                    )),
                                TextSpan(
                                    text: '  $currency',
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle:
                                      const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500),
                                    )),
                              ]),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          ///remove
          Positioned(
            top: 13,
            right: (currLang == 'ar') ? null : 13, //english
            left: (currLang == 'ar') ? 13 : null, //arabic
            child: GestureDetector(
              child: Icon(
                size: 20,
                Icons.close,
                //weight: 50,
                color: Colors.white.withOpacity(0.35),
              ),
              onTap: () {
                ///deleteExpKridi(ind);
                if (type=='sell') {
                  deleteFromMap(coll: productsColl, docID: prdCtr.selectedProd.id, fieldMapName: 'sellHis', mapKeyToDelete: key.substring(2));
                } else if(type=='buy'){
                  deleteFromMap(coll: productsColl, docID: prdCtr.selectedProd.id, fieldMapName: 'buyHis', mapKeyToDelete: key.substring(2));
                }else{//manual

                }
              },
            ),
          ),
          ///Type
          Positioned(
            bottom: 13,
            right: (currLang == 'ar') ? null : 13, //english
            left: (currLang == 'ar') ? 13 : null, //arabic
            child: Text(
              type.toUpperCase(),
              style: TextStyle(color: type=='sell'? Colors.greenAccent:type=='buy'? Colors.redAccent: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),

        ],
      ),
    ),
  );
}
Widget manualProdChangeCard(String key, ProdChange prodChange) {
  double cardHei = 100;

  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      width: 100.w,
      height: cardHei,
      child: Stack(
        children: [
          Card(
            color: cardColor,
            elevation: 50,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white38, width: 2), borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      monthSquare(prodChange.time!),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///price

                          Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
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
                                    text: 'price:'.tr,
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle: TextStyle(color: Colors.white54, fontSize: 15, fontWeight: FontWeight.w500),
                                    )),
                                TextSpan(
                                    text: '  ${formatNumberAfterComma2(prodChange.price!)}',
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                                    )),
                                TextSpan(
                                    text: '  $currency',
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle:
                                          const TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w500),
                                    )),
                              ]),
                            ),
                          ),
                          SizedBox(
                            height: 11,
                          ),

                          ///qty
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: RichText(
                              locale: Locale(currLang!),
                              textAlign: TextAlign.start,
                              //softWrap: true,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'qty:'.tr,
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle: TextStyle(color: Colors.white54, fontSize: 15, fontWeight: FontWeight.w500),
                                    )),
                                TextSpan(
                                    text: '  ${prodChange.qty}',
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                                    )),
                              ]),
                            ),
                          ),

                          SizedBox(height: 5),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          ///Type
          Positioned(
            bottom: 13,
            right: (currLang == 'ar') ? null : 13, //english
            left: (currLang == 'ar') ? 13 : null, //arabic
            child: Text(
              'MANUAL',
              style: TextStyle(color:Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          ///remove
          Positioned(
            top: 13,
            right: (currLang == 'ar') ? null : 13, //english
            left: (currLang == 'ar') ? 13 : null, //arabic
            child: GestureDetector(
              child: Icon(
                size: 20,
                Icons.close,
                //weight: 50,
                color: Colors.white.withOpacity(0.35),
              ),
              onTap: () {
               deleteFromMap(
                    coll: productsColl, docID: prdCtr.selectedProd.id, fieldMapName: 'prodChanges', mapKeyToDelete: key.substring(2));
              },
            ),
          ),
        ],
      ),
    ),
  );
}

///Invoice
Widget invoiceCard(Invoice inv,int index, {bool isAdd = false}) {
  double cardHei = 130;
  Color incomeCol = inv.income! > 0 ? winIncomeCol : looseIncomeCol;

  List<Invoice> allInvs = invCtr.invoicesList;
  double dayTotalSell = allInvs[index].returnTotal!;
  double dayTotalIncome = allInvs[index].income!;
  bool newDay = true;

  /// check if its new
  if(index !=0){
    if(getDayString(allInvs[index].timeReturn!) != getDayString(allInvs[index-1].timeReturn!)){
      newDay = true; // day != day-bf
    }else{
      newDay = false;

    }
  }
  /// if new calculate total
  if(newDay && index < allInvs.length-1){
    for (int i = index+1; i < allInvs.length; i++) {

      if(getDayString(allInvs[index].timeReturn!) == getDayString(allInvs[i].timeReturn!)){
        dayTotalSell += allInvs[i].returnTotal!;
        dayTotalIncome += allInvs[i].income!;
      }else{
        // get out from for loop
        break;
      }

    }

  }

    return GestureDetector(
    onTap: () {
      // open expenses and his tabs
      invCtr.selectInvoice(inv);
      Get.to(() => AddEditInvoice(), arguments: {'isAdd': false, 'isVerified': inv.verified,});
    },
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
         if(newDay) Padding(
            padding: const EdgeInsets.only(bottom:5.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
                    child: Text(
                      '${getDayString(inv.timeReturn!)}  ${getMonthString(inv.timeReturn!)}',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: dividerColor,
                    ),
                  ),

                  ///day total
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RichText(
                      locale: Locale(currLang!),
                      textAlign: TextAlign.start,
                      //softWrap: true,

                      text: TextSpan(

                          children: [
                        // TextSpan(
                        //     text: 'Total:',
                        //     style: GoogleFonts.almarai(
                        //       height: 1,
                        //       textStyle: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                        //     )),
                        TextSpan(
                            text: '${formatNumberAfterComma2(dayTotalIncome)}',

                            style: GoogleFonts.almarai(

                              height: 1,
                              textStyle: TextStyle(color: dayTotalIncome > 0 ? winIncomeCol : looseIncomeCol, fontSize: 15, fontWeight: FontWeight.w500),
                            )),
                        TextSpan(
                            text: ' / ',
                            style: GoogleFonts.almarai(
                              height: 1,
                              textStyle: TextStyle(color: Colors.white54, fontSize: 15, fontWeight: FontWeight.w500),
                            )),
                        TextSpan(
                            text: '${formatNumberAfterComma2(dayTotalSell)}',
                            style: GoogleFonts.almarai(
                              height: 1,
                              textStyle: TextStyle(color: totalCol, fontSize: 15, fontWeight: FontWeight.w500),
                            )),
                        TextSpan(
                            text: '  $currency',
                            style: GoogleFonts.almarai(
                              height: 1,
                              textStyle:
                              const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500),
                            )),
                      ]),
                    ),
                  ),
                ],
              ),

            ),
          ),
          Container(
            width: 100.w,
            height: cardHei,
            child: Stack(
              children: [
                Card(
                  color: cardColor,
                  elevation: 50,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: isDateToday(inv.timeReturn!) ?  activeCardBorder:normalCardBorder, width: 2),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 15, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            monthSquare(inv.timeReturn!),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                ///type
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: RichText(
                                    locale: Locale(currLang!),
                                    textAlign: TextAlign.start,
                                    //overflow: TextOverflow.ellipsis, // Set overflow behavior

                                    //softWrap: true,
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: '${(!kIsWeb && inv.deliveryName!.length>20) ? '${inv.deliveryName!.substring(0, 19)}...' : inv.deliveryName}',

                                          style: GoogleFonts.almarai(
                                            height: 1,
                                            textStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                          )),

                                      TextSpan(
                                          text: '  ${inv.type}',
                                          style: GoogleFonts.almarai(
                                            height: 1,
                                            textStyle:
                                            const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500),
                                          )),
                                    ]),
                                  ),
                                ),
                                SizedBox(height: 8),

                                ///return
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: RichText(
                                    locale: Locale(currLang!),
                                    textAlign: TextAlign.start,
                                    //softWrap: true,
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: 'Total:'.tr,
                                          style: GoogleFonts.almarai(
                                            height: 1,
                                            textStyle: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                          )),
                                      TextSpan(
                                          text: '  ${ inv.verified! ? formatNumberAfterComma2(inv.returnTotal!):formatNumberAfterComma2(inv.outTotal!)}',
                                          style: GoogleFonts.almarai(
                                            height: 1,
                                            textStyle: TextStyle(color: totalCol, fontSize: 16, fontWeight: FontWeight.w500),
                                          )),
                                      TextSpan(
                                          text: '  $currency${inv.totalChanged! ? ', changed':''}',
                                          style: GoogleFonts.almarai(
                                            height: 1,
                                            textStyle:
                                                const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500),
                                          )),
                                    ]),
                                  ),
                                ),
                                SizedBox(height: 8),

                                ///income
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
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
                                          text: 'Income:'.tr,
                                          style: GoogleFonts.almarai(
                                            height: 1,
                                            textStyle: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                          )),
                                      TextSpan(
                                          text: '  ${formatNumberAfterComma2(inv.income!)}',
                                          style: GoogleFonts.almarai(
                                            height: 1,
                                            textStyle: TextStyle(color: incomeCol, fontSize: 13, fontWeight: FontWeight.w500),
                                          )),
                                      TextSpan(
                                          text: '  $currency',
                                          style: GoogleFonts.almarai(
                                            height: 1,
                                            textStyle:
                                                const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500),
                                          )),
                                    ]),
                                  ),
                                ),
                                SizedBox(height: 0),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                ///remove
                Positioned(
                  top: 13,
                  right: (currLang == 'ar') ? null : 13, //english
                  left: (currLang == 'ar') ? 13 : null, //arabic
                  child: GestureDetector(
                    child: Icon(
                      size: 20,
                      Icons.close,
                      //weight: 50,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    onTap: () {
                      showNoHeader(
                        txt: 'Are you sure you want to remove this invoice ?'.tr,
                        icon: Icons.close,
                        btnOkColor: Colors.red,
                        btnOkText: 'Remove'.tr,
                      ).then((toAllow) {
                        // if admin accept
                        if (toAllow) {
                          deleteDoc(
                              docID: inv.id!,
                              coll: invoicesColl,
                              btnOnPress: () {
                                showSnack('${'invoice'.tr} "${inv.id}" ${'removed'.tr}', color: Colors.redAccent.withOpacity(0.8));
                                invCtr.update();
                              });

                          /// remove product from coll
                        }
                      });
                    },
                  ),
                ),
               // if(inv.verified!) Positioned(
               //    bottom: 13,
               //    right: (currLang == 'ar') ? null : 13, //english
               //    left: (currLang == 'ar') ? 13 : null, //arabic
               //    child: GestureDetector(
               //      child: Icon(
               //        size: 20,
               //        Icons.print,
               //        //weight: 50,
               //        color: Colors.yellowAccent.withOpacity(0.3),
               //      ),
               //      onTap: () {
               //        invCtr.selectInvoice(inv);
               //        Get.to(()=>PrintScreen());
               //      },
               //    ),
               //  ),
                Positioned(
                  bottom: cardHei / 3,
                  right: (currLang == 'ar') ? null : 25, //english
                  left: (currLang == 'ar') ? 25 : null, //arabic
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: inv.verified! ? Colors.greenAccent.withOpacity(0.3) : Color(0xFFFFD700).withOpacity(0.2),
                        radius: 18,
                        child: Icon(
                          color: inv.verified! ? Colors.greenAccent : Color(0xFFFFD700),
                          inv.verified! ? Icons.check : Icons.access_time_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
Widget invAddingCard({bool canRemove = false}) {
  double cardHei = 285;
  Color incomeCol = invCtr.addingCardInvProd.income! > 0 ? winIncomeCol : looseIncomeCol;

  DropdownButton<Product> buildDropdown(List<Product> productList) {
    return DropdownButton<Product>(
      value: invCtr.addingCardProd,
      items: productList.map((Product product) {
        return DropdownMenuItem<Product>(
          value: product,
          child: Text(product.name ?? ''),
        );
      }).toList(),
      dropdownColor: blueColHex2,
      onChanged: (Product? selectedProduct) {
        // Handle the selected product
        if (selectedProduct != null) {
          //Product prod = invCtr.selectedInvProdToAdd ;
          invCtr.addingCardProd = selectedProduct; //selected dropDown Product

          invCtr.maxQty = selectedProduct.currQty!.toDouble();
          invCtr.sliderVal = 0.0;

          invCtr.updateAddingCard(updatePriceField: true); //update sell price
          invCtr.update(['addingCard']);
          //invCtr.invToAddPriceTec.text = invCtr.selectedInvProdToAdd.priceSell!.toInt().toString();

          // InvProd invProd = InvProd(
          //   priceBuy: selectedProduct.currBuyPrice,
          //   priceSell: selectedProduct.currPrice,
          //
          // );
          // invCtr.selectedInvProdToAdd = invProd;
          print('## Selected Product: ${selectedProduct.name}');
        }
      },
    );
  }

  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      width: 95.w,
      height: cardHei,
      child: Stack(
        children: [
          Card(
            color: cardColor,
            elevation: 50,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white38, width: 2), borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: invCtr.invToAddKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// /////////////////////////////////////////////////////////////////////
                        /// dropdown / price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ///dropdown
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: SizedBox(width: 44.w, height: 40, child: buildDropdown(invCtr.productsOfAddingCard)),
                            ),
                            SizedBox(width: 5.w),
                            ///price
                            SizedBox(
                              width: 28.w,
                              height: 70,
                              child: TextFormField(
                                maxLength: 9,
                                onChanged: (val) {
                                  invCtr.updateAddingCard();
                                },
                                controller: invCtr.addingPriceTec,
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.white, fontSize: 14.5),
                                validator: (value) {
                                  final numberRegExp = RegExp(r'^\d*\.?\d+$');

                                  if (value!.isEmpty) {
                                    return "empty".tr;
                                  }
                                  // if (value.length > 9) {
                                  //   return "long".tr;
                                  // }
                                  if (!numberRegExp.hasMatch(value!)) {
                                    return 'not valid'.tr;
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                  focusColor: Colors.white,
                                  fillColor: Colors.white,
                                  hoverColor: Colors.white,
                                  contentPadding: const EdgeInsets.only(bottom: 0, left: 20, top: 0),
                                  suffixIconConstraints: BoxConstraints(minWidth: 50),
                                  prefixIconConstraints: BoxConstraints(minWidth: 50),
                                  border: InputBorder.none,
                                  hintText: ''.tr,
                                  labelText: 'Price'.tr,
                                  labelStyle: TextStyle(color: Colors.white60, fontSize: 14.5),
                                  hintStyle: TextStyle(color: Colors.white30, fontSize: 14.5),
                                  errorStyle: TextStyle(color: Colors.redAccent.withOpacity(.9), fontSize: 12, letterSpacing: 1),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.white38)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.white70)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: BorderSide(color: Colors.redAccent.withOpacity(.7))),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.redAccent)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7),

                        /// slider / qty
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ///slider
                            SizedBox(
                              width: 50.w,
                              height: 50,
                              child: RotatedBox(
                                quarterTurns: 4,
                                child: Slider(
                                  inactiveColor: Colors.white.withOpacity(0.4),
                                  divisions: invCtr.maxQty.toInt() > 0 ? invCtr.maxQty.toInt() : 1,
                                  min: 0,
                                  max: invCtr.maxQty,
                                  value: invCtr.sliderVal,
                                  onChangeEnd: (val) async {
                                    // invCtr.sliderVal;
                                    // invCtr.update(['addingCard']);
                                  },
                                  onChanged: (val) {
                                    invCtr.sliderVal = val;
                                    invCtr.addingQtyTec.text = val.toInt().toString(); // slider update textField
                                    //invCtr.selectedInvProdToAdd.qty = val.toInt();
                                    //invCtr.update(['addingCard']);
                                    invCtr.updateAddingCard();
                                  },
                                ),
                              ),
                            ),
                            ///qty
                            SizedBox(
                              width: 28.w,
                              height: 70,
                              child: TextFormField(
                                maxLength: 6,
                                onChanged: (val) {
                                  try {
                                    double parsedValue = double.parse(val);

                                    if (parsedValue < invCtr.maxQty) {
                                      invCtr.sliderVal = double.parse(val); // textField update slider
                                    } else {
                                      invCtr.sliderVal = invCtr.maxQty; // textField update slider
                                    }
                                    invCtr.updateAddingCard();
                                  } catch (e) {
                                    invCtr.sliderVal = 0;
                                    //showSnack('please enter a number to update slider'.tr,color: Colors.black38.withOpacity(0.8));
                                  }

                                },
                                controller: invCtr.addingQtyTec,
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.white, fontSize: 14.5),
                                validator: (value) {
                                  RegExp positiveIntegerPattern = RegExp(r'^\d+$');

                                  if (value!.isEmpty) {
                                    return "empty".tr;
                                  }
                                  if (!positiveIntegerPattern.hasMatch(value!)) {
                                    return 'not valid'.tr;
                                  }
                                  if (double.parse(value) > invCtr.maxQty) {
                                    return '${'max='.tr} ${invCtr.maxQty.toInt()}';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  focusColor: Colors.white,
                                  fillColor: Colors.white,
                                  hoverColor: Colors.white,
                                  contentPadding: const EdgeInsets.only(bottom: 0, left: 20, top: 0),
                                  suffixIconConstraints: BoxConstraints(minWidth: 50),
                                  prefixIconConstraints: BoxConstraints(minWidth: 50),
                                  border: InputBorder.none,
                                  hintText: ''.tr,
                                  labelText: 'Qty'.tr,
                                  labelStyle: TextStyle(color: Colors.white60, fontSize: 14.5),
                                  hintStyle: TextStyle(color: Colors.white30, fontSize: 14.5),
                                  errorStyle: TextStyle(color: Colors.redAccent.withOpacity(.9), fontSize: 12, letterSpacing: 1),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.white38)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.white70)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: BorderSide(color: Colors.redAccent.withOpacity(.7))),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.redAccent)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        /// /////////////////////////////////////////////////////////////////////
                        SizedBox(height: cardHei / 15),
                        ///sell calc
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
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
                                    height: 1.8,
                                    textStyle: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                                  )),
                              TextSpan(
                                  text: ' ${formatNumberAfterComma2(invCtr.addingCardInvProd.priceSell!)} ',
                                  style: GoogleFonts.almarai(
                                    height: 1.8,
                                    textStyle: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                  )),
                              TextSpan(
                                  text: 'x'.tr,
                                  style: GoogleFonts.almarai(
                                    height: 1.8,
                                    textStyle: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                                  )),
                              TextSpan(
                                  text: ' (${invCtr.addingCardInvProd.qty!})  ',
                                  style: GoogleFonts.almarai(
                                    height: 1.8,
                                    textStyle: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                  )),
                              TextSpan(
                                  text: '='.tr,
                                  style: GoogleFonts.almarai(
                                    height: 1.8,
                                    textStyle: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                                  )),
                              TextSpan(
                                  text: ' ${formatNumberAfterComma2(invCtr.addingCardInvProd.totalSell!)} ',
                                  style: GoogleFonts.almarai(
                                    height: 1.8,
                                    textStyle: TextStyle(color: totalCol, fontSize: 13, fontWeight: FontWeight.w500),
                                  )),

                              ///currency
                              TextSpan(
                                  text: '  $currency',
                                  style: GoogleFonts.almarai(
                                    height: 1.8,
                                    textStyle: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500),
                                  )),
                            ]),
                          ),
                        ),
                        ///buy calc
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
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
                                  text: 'total Buy:'.tr,
                                  style: GoogleFonts.almarai(
                                    height: 1.8,
                                    textStyle: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                                  )),
                              TextSpan(
                                  text: ' ${formatNumberAfterComma2(invCtr.addingCardInvProd.priceBuy!)} ',
                                  style: GoogleFonts.almarai(
                                    height: 1.8,
                                    textStyle: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                  )),
                              TextSpan(
                                  text: 'x'.tr,
                                  style: GoogleFonts.almarai(
                                    height: 1.8,
                                    textStyle: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                                  )),
                              TextSpan(
                                  text: ' (${invCtr.addingCardInvProd.qty!})  ',
                                  style: GoogleFonts.almarai(
                                    height: 1.8,
                                    textStyle: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                  )),
                              TextSpan(
                                  text: '='.tr,
                                  style: GoogleFonts.almarai(
                                    height: 1.8,
                                    textStyle: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                                  )),
                              TextSpan(
                                  text: ' ${formatNumberAfterComma2(invCtr.addingCardInvProd.totalBuy!)} ',
                                  style: GoogleFonts.almarai(
                                    height: 1.8,
                                    textStyle: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                  )),

                              ///currency
                              TextSpan(
                                  text: '  $currency',
                                  style: GoogleFonts.almarai(
                                    height: 1.8,
                                    textStyle: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500),
                                  )),
                            ]),
                          ),
                        ),
                        ///income calc
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
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
                                  text: 'income:'.tr,
                                  style: GoogleFonts.almarai(
                                    height: 1.8,
                                    textStyle: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                  )),
                              TextSpan(
                                  text: ' ${formatNumberAfterComma2(invCtr.addingCardInvProd.income!)}',
                                  style: GoogleFonts.almarai(
                                    height: 1.8,
                                    textStyle: TextStyle(color: incomeCol, fontSize: 13, fontWeight: FontWeight.w500),
                                  )),
                              TextSpan(
                                  text: '  $currency',
                                  style: GoogleFonts.almarai(
                                    height: 1.8,
                                    textStyle: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500),
                                  )),
                            ]),
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // add prod to "invProdsAdded" list and conv it to "invProdMap" map
          Positioned(
            bottom: cardHei / 10,
            right: (currLang == 'ar') ? null : 25, //english
            left: (currLang == 'ar') ? 25 : null, //arabic
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.greenAccent.withOpacity(0.6),
                  radius: 18,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.arrow_forward, size: 19),
                    color: Colors.white,
                    onPressed: () {
                      invCtr.addInvProdToList();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
Widget invAddedCard({required InvProd prodAdded, required int index, bool canRemove = false, bool editable = false}) {
  double cardHei = 140;
  double calculatedIncome = (prodAdded.qty!) * (prodAdded.priceSell! - prodAdded.priceBuy!);
  Color incomeCol = calculatedIncome > 0 ? winIncomeCol : looseIncomeCol;

  return GestureDetector(
    onTap: () {
      // open dialog (price / qty)

      if (editable) {
        showAnimDialog(
          invCtr.changeAddedDialog(price: prodAdded.priceSell!, qty: prodAdded.qty!, index: index),
          milliseconds: 200,
        );
      }
    },
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 95.w,
        height: cardHei,
        child: Stack(
          children: [
            Card(
              color: cardColor,
              elevation: 50,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white38, width: 2), borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   'assets/images/user.png',
                        //   width: 72,
                        //   color: Colors.blueGrey,
                        // ),
                        SizedBox(width: 30),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///name
                            Text(
                              '${prodAdded.name}  (${prodAdded.qty})',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),

                            SizedBox(height: 5),

                            ///sell
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
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
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: ' ${formatNumberAfterComma2(prodAdded.priceSell!)} ',
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: 'x'.tr,
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: ' (${prodAdded.qty!})  ',
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: '='.tr,
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: ' ${formatNumberAfterComma2(prodAdded.totalSell!)} ',
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle: TextStyle(color: totalCol, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),

                                  ///currency
                                  TextSpan(
                                      text: '  $currency',
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500),
                                      )),
                                ]),
                              ),
                            ),

                            ///buy
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
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
                                      text: 'total Buy:'.tr,
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: ' ${formatNumberAfterComma2(prodAdded.priceBuy!)} ',
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: 'x'.tr,
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: ' (${prodAdded.qty!})  ',
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: '='.tr,
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: ' ${formatNumberAfterComma2(prodAdded.totalBuy!)} ',
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),

                                  ///currency
                                  TextSpan(
                                      text: '  $currency',
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500),
                                      )),
                                ]),
                              ),
                            ),

                            ///income
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
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
                                      text: 'income:'.tr,
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: ' ${formatNumberAfterComma2(prodAdded.income!)} ',
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle: TextStyle(color: incomeCol, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: '  $currency',
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500),
                                      )),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (canRemove)Positioned(
                top: 13,
                right: (currLang == 'ar') ? null : 13, //english
                left: (currLang == 'ar') ? 13 : null, //arabic
                child: GestureDetector(
                  child: Icon(
                    size: 20,
                    Icons.close,
                    //weight: 50,
                    color: Colors.red.withOpacity(0.65),
                  ),
                  onTap: () {
                    invCtr.invProdsList.removeAt(index);
                    invCtr.update(['addedProds']);
                    Product removedProduct = prdCtr.productsList.firstWhere(
                          (product) => product.name == prodAdded.name,
                    );

                    invCtr.productsOfAddingCard.add(removedProduct);
                    invCtr.initAddingCard();
                    invCtr.refreshInvProdsTotals();

                  },
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

String currency = 'TND';

/// ****** DEFAULT WIDGETS **************///////////////////////////////////////////////

Widget customStreamBuilder({Stream<QuerySnapshot<Object?>>? stream, required Widget Function(QuerySnapshot) hasDataWidget}) {
  return SafeArea(
    child: SingleChildScrollView(
      child: Column(children: [
        StreamBuilder<QuerySnapshot>(
          stream: stream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('connection error'.tr));
              } else if (snapshot.hasData) {
                //return hasDataWidget(snapshot.data!);
                return hasDataWidget(snapshot.data!);
              } else {
                return Center(child: Text('empty data'.tr));
              }
            } else {
              return Container();
            }
          },
        ),
      ]),
    ),
  );
}

Widget appNameText() {
  return Text(
    'Gajgaji Karim',
    textAlign: TextAlign.center,
    style: GoogleFonts.indieFlower(
      textStyle: TextStyle(fontSize: 33, color: Colors.white, fontWeight: FontWeight.w700),
    ),
  );
}

Widget customTextField(
    {Color? color,
    bool enabled = true,
    void Function(String)? onChanged,
    TextInputType? textInputType,
    String? hintText,
    String? labelText,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool obscure = false,
    bool isPwd = false,
    bool isDense = false,
    Function()? onSuffClick,
    IconData? icon}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Container(
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        keyboardType: textInputType,
        textInputAction: TextInputAction.done,
        obscureText: obscure,

        ///pwd

        enabled: enabled,
        style: TextStyle(color: Colors.white, fontSize: 14.5),
        validator: validator,
        decoration: InputDecoration(
          //enabled: false,

          isDense: isDense,
          alignLabelWithHint: false,
          filled: false,
          isCollapsed: false,

          focusColor: color ?? Colors.white,
          fillColor: color ?? Colors.white,
          hoverColor: color ?? Colors.white,
          contentPadding: const EdgeInsets.only(bottom: 0, right: 20, top: 0),
          suffixIconConstraints: BoxConstraints(minWidth: 50),
          prefixIconConstraints: BoxConstraints(minWidth: 50),
          prefixIcon: Icon(
            icon,
            color: Colors.white70,
            size: 22,
          ),
          suffixIcon: isPwd
              ? IconButton(

                  ///pwd

                  icon: Icon(
                    !obscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white70,
                  ),
                  onPressed: onSuffClick)
              : null,
          border: InputBorder.none,
          disabledBorder: InputBorder.none,

          hintText: hintText!,
          labelText: labelText!,
          labelStyle: TextStyle(color: Colors.white60, fontSize: 14.5),
          hintStyle: TextStyle(color: Colors.white30, fontSize: 14.5),

          errorStyle: TextStyle(color: Colors.redAccent.withOpacity(.9), fontSize: 12, letterSpacing: 1),

          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.white38)),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.white70)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.redAccent.withOpacity(.7))),
          focusedErrorBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.redAccent)),
        ),
      ),
    ),
  );
}

getDayString(String time){
  return DateFormat("dd-MM-yyyy HH:mm").parse(time).day.toString();
}
getMonthString(String time){
  return getMonthName(DateFormat("dd-MM-yyyy HH:mm").parse(time).month);

}
Widget monthSquare(String time) {
  String day = DateFormat("dd-MM-yyyy HH:mm").parse(time).day.toString();
  String monthName = getMonthName(DateFormat("dd-MM-yyyy HH:mm").parse(time).month);
  String timeString = DateFormat("HH:mm").format(DateFormat("dd-MM-yyyy HH:mm").parse(time));

  return Container(
    width: 70,
    height: 70,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      //color: Colors.white,
      // border: Border.all(
      //   color: Colors.white,
      //   width: 2,
      // ),
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            day,
            maxLines: 1,
            style: TextStyle(
              fontSize: 37,
              height: 0.5,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            monthName,
            maxLines: 1,
            style: TextStyle(
              fontSize: 13,
              height: 0,
              color: Colors.white,
            ),
          ),
          Text(
            timeString,
            maxLines: 1,
            style: TextStyle(
              fontSize: 13,
              height: 0.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget backGroundTemplate({Widget? child}) {
  return Container(
    //alignment: Alignment.topCenter,
    width: 100.w,
    height: 100.h,
    decoration: const BoxDecoration(
        // image: DecorationImage(
        //   //image: AssetImage("assets/images/bg.png"),
        //   image: NetworkImage("https://img.freepik.com/premium-vector/general-view-factorys-industrial-premises-from-inside_565173-3.jpg"),
        //   fit: BoxFit.cover,
        // ),
        ),
    child: child,
  );
}

Widget customButton(
    {bool reversed = false,
    Function()? btnOnPress,
    Widget? icon,
    String textBtn = 'button',
    double btnWidth = 200,
    Color? fillCol,
    Color? borderCol}) {
  List<Widget> buttonItems = [
    icon!,

    SizedBox(width: 10),
    Text(
      textBtn,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
    //Icon(Icons.send_rounded,  color: Colors.white,),
  ];

  return SizedBox(
    width: btnWidth,
    child: ElevatedButton(
      onPressed: btnOnPress!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: reversed ? buttonItems.reversed.toList() : buttonItems,
      ),
      style: ElevatedButton.styleFrom(
        primary: fillCol ?? cstmButtonFillCol.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(
          color: borderCol ?? cstmButtonBorderCol,
          width: 2,
        ),
      ),
    ),
  );
}

Widget prop(title, prop, {Color color = Colors.white, double spaceBetween = 15.0, String extraTxt = ''}) {
  return Padding(
    padding: EdgeInsets.only(bottom: spaceBetween),
    child: Row(
      children: [
        Text(
          '$title',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19, color: color),
        ),
        SizedBox(width: 8),
        Text(
          '$prop',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white70),
        ),
        SizedBox(width: 5),
        Text(
          '$extraTxt',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11, color: Colors.white),
        ),
      ],
    ),
  );
}
