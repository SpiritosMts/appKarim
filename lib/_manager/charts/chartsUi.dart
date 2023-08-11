import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gajgaji/_manager/styles.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import '../bindings.dart';
import '../myVoids.dart';

int eachTimeHis = 1;
bool showBottomIndexZero = false;

SideTitles get topTitles => SideTitles(
      //interval: 1,
      showTitles: true,
      getTitlesWidget: (value, meta) {
        String text = '';
        switch (value.toInt()) {}

        return Text(
          text,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11),
        );
      },
    );

SideTitles leftTitles(int valueInterval) {
  return SideTitles(
    //interval: 10,
    showTitles: true,

    getTitlesWidget: (value, meta) {
      String text = '';
      switch (value.toInt()) {
        // case -50:
        //   text = '-50';
        //   break;
        // case 0:
        //   text = '0';
        //   break;
        // case 50:
        //   text = '50';
        //   break;
        // case 100:
        //   text = '100';
        //   break;
      }
      if (value.toInt() % valueInterval == 0) {
        text = value.toInt().toString();
      }
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Text(
          text,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: chartValuesColor),
        ),
      );
    },
  );
}

SideTitles bottomTimeTitles(int eachTime, List<String> timeList) {
  //gas_times
  return SideTitles(
    interval: 1,
    showTitles: true,
    getTitlesWidget: (value, meta) {
      int index = value.toInt(); // 0 , 1 ,2 ...
      String bottomText = '';

      //print('## ${value.toInt()}');

      //bool isDivisibleBy15 = ((value.toInt() % 13 == 0) );
      //bottomText = (value.toInt() ).toString();

      switch (value.toInt() % eachTime) {
        case 0:
//        bottomText = DateFormat('HH:mm:ss').format(newDateTime);
          bottomText = timeList[index];

          break;
        // case 0:
        //   bottomText = DateFormat('mm:ss').format(newDateTime);
        //   break;
      }
      if (value.toInt() == 0 && !showBottomIndexZero) bottomText = '';

      return Text(
        bottomText,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: Colors.white),
      );
    },
  );
}

List<FlSpot> generateHistorySpots(List<double> valList) {
  //print('## generate spots...');
  List<FlSpot> spots = [];
  for (int i = 0; i < valList.length; i++) {
    //bool isLast = i % spots.length == 0;
    spots.add(FlSpot(
        i.toDouble(), // X
        valList[i] // Y
        ));
  }

  return spots;
}

/// live_listen
// Widget chartGraphLive({Color? bgCol, int valueInterval = 50, SideTitles? bottomTitles, String? dataType, List<FlSpot>? flSpots, String? dataName, List<double>? dataList, double? minVal, double? maxVal, double? width}) {
//   //print('## chart update');
//
//   chCtr.checkDangerState(dataType);
//
//   //print('## isInDanger = $isInDanger');
//
//   return Column(
//     children: [
//       Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Text(ptCtr.getStringStream as String,style: TextStyle(color: Colors.white),),
//             if (chCtr.isConnected)
//               RippleAnimation(
//                 child: Container(
//                   //color:Colors.green,
//                   width: 5,
//                   height: 5,
//                 ),
//                 color: !(chCtr.isInDanger) ? chCtr.chartLineNormalColor : chCtr.chartLineDangerColor,
//                 delay: const Duration(milliseconds: 300),
//                 repeat: true,
//                 minRadius: 15,
//                 ripplesCount: 6,
//                 duration: const Duration(milliseconds: 6 * 300),
//               ),
//             SizedBox(width: 10),
//             Text(
//               '${'bpm Live'.tr} (${dataList!.last})',
//               textAlign: TextAlign.left,
//               style: TextStyle(fontSize: 24, color: Colors.white70),
//             ),
//           ],
//         ),
//       ),
//       SingleChildScrollView(
//         child: Container(
//           height: 100.h / 3,
//           width: width,
//           child: Padding(
//             padding: const EdgeInsets.only(right: 6.0, left: 0),
//             child: Container(
//               // color: Colors.grey[200],
//               child: LineChart(
//                 swapAnimationDuration: Duration(milliseconds: 40),
//                 swapAnimationCurve: Curves.linear,
//                 LineChartData(
//                   clipData: FlClipData.all(),
//                   // no overflow
//                   lineTouchData: LineTouchData(
//                       enabled: true,
//                       touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {},
//                       touchTooltipData: LineTouchTooltipData(
//                         tooltipBgColor: valuePopColor,
//                         tooltipRoundedRadius: 20.0,
//                         showOnTopOfTheChartBoxArea: false,
//                         fitInsideHorizontally: true,
//                         tooltipMargin: 50,
//                         tooltipHorizontalOffset: 20,
//                         fitInsideVertically: true,
//                         tooltipPadding: EdgeInsets.all(8.0),
//                         //maxContentWidth: 40,
//                         getTooltipItems: (touchedSpots) {
//                           return touchedSpots.map(
//                                 (LineBarSpot touchedSpot) {
//                               //gc.changeGazTappedValue(gc.dataPoints[touchedSpot.spotIndex].toString());
//                               const textStyle = TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.white,
//                               );
//                               return LineTooltipItem(
//                                 formatNumberAfterComma('${dataList![touchedSpot.spotIndex]}'),
//                                 textStyle,
//                               );
//                             },
//                           ).toList();
//                         },
//                       ),
//                       getTouchedSpotIndicator: (LineChartBarData barData, List<int> indicators) {
//                         return indicators.map(
//                               (int index) {
//                             final line = FlLine(color: Colors.white, strokeWidth: 2, dashArray: [2, 5]);
//                             return TouchedSpotIndicatorData(
//                               line,
//                               FlDotData(show: false),
//                             );
//                           },
//                         ).toList();
//                       },
//                       getTouchLineEnd: (_, __) => double.infinity),
//                   //baselineY: 0,
//                   minY: minVal,
//                   maxY: maxVal,
//
//                   ///rangeAnnotations
//                   rangeAnnotations: RangeAnnotations(
//                     // verticalRangeAnnotations:[
//                     //   VerticalRangeAnnotation(x1: 1,x2: 2),
//                     //   VerticalRangeAnnotation(x1: 3,x2: 4)
//                     // ],
//                       horizontalRangeAnnotations: [
//                         HorizontalRangeAnnotation(y1: chCtr.maxSafeZone, y2: chCtr.maxSafeZone + 0.6, color: Colors.redAccent),
//                         // HorizontalRangeAnnotation(y1: chCtr.minSafeZone,y2: chCtr.minSafeZone+0.2,color: Colors.redAccent),
//                         // HorizontalRangeAnnotation(y1: 3,y2: 4),
//                         // HorizontalRangeAnnotation(y1: 5,y2: 6),
//                       ]),
//
//                   backgroundColor: bgCol ?? secondaryColor.withOpacity(0.3),
//
//                   /// backgound
//                   borderData: FlBorderData(
//                       border: const Border(
//                         //  bottom: BorderSide(),
//                         //  left: BorderSide(),
//                         //  top: BorderSide(),
//                         // right: BorderSide(),
//                       )),
//                   gridData: FlGridData(
//                     show: false,
//                     horizontalInterval: 50,
//                     verticalInterval: 1,
//                   ),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     bottomTitles: AxisTitles(sideTitles: bottomTitles ?? SideTitles(showTitles: true)),
//                     leftTitles: AxisTitles(sideTitles: leftTitles(valueInterval)),
//                     topTitles: AxisTitles(sideTitles: topTitles),
//                     rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   ),
//                   lineBarsData: [
//                     LineChartBarData(
//                       ///fill
//                       // belowBarData: BarAreaData(
//                       //     color: Colors.blue,
//                       //     //cutOffY: 0,
//                       //     //ap aplyCutOffY: true,
//                       //     spotsLine: BarAreaSpotsLine(
//                       //       show: true,
//                       //     ),
//                       //     show: true
//                       // ),
//                       dotData: FlDotData(
//                         show: false,
//                       ),
//                       show: true,
//                       preventCurveOverShooting: false,
//                       //showingIndicators:[0,5,6],
//                       isCurved: true,
//                       isStepLineChart: false,
//                       isStrokeCapRound: false,
//                       isStrokeJoinRound: false,
//
//                       barWidth: 3.0,
//                       curveSmoothness: 0.25,
//                       preventCurveOvershootingThreshold: 10.0,
//                       lineChartStepData: LineChartStepData(stepDirection: 0),
//                       //shadow: Shadow(color: Colors.blue,offset: Offset(0,8)),
//                       color: !(chCtr.isInDanger) ? chCtr.chartLineNormalColor : chCtr.chartLineDangerColor,
//                       spots: flSpots,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }

/// history_listen
// Widget chartGraphHistory({Color? bgCol, int valueInterval = 50, String? dataName, List? dataList, List<String>? timeList, List<String>? valList, double? minVal, double? maxVal, double? width}) {
//   double minV = getMinValue(valList!);
//   double maxV = getMaxValue(valList!);
//
//   var ctr = chCtr;
//
//   return Column(
//     children: [
//       Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               onPressed: () async {
//                 await ctr.initHistoryValues('patients/${ctr.selectedServer}/bpm_history'); // shoiw delete dialog
//               },
//               icon: Icon(
//                 Icons.refresh,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//             Text(
//               'History'.tr,
//               style: TextStyle(fontSize: 24, color: Colors.white70),
//             ),
//             SizedBox(width: 5,),
//             Text(
//               '(${minV.toString()}, ${maxV.toString()})',
//               style: TextStyle(fontSize: 15, color: Colors.white70),
//             ),
//             IconButton(
//               onPressed: () async {
//                 await ctr.deleteHisDialog(dataName!, dataList!); // shoiw delete dialog
//               },
//               icon: Icon(
//                 Icons.close_fullscreen_outlined,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             )
//           ],
//         ),
//       ),
//       SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Container(
//           height: 100.h / 3,
//           width: 100.h * width!,
//           child: Padding(
//             padding: const EdgeInsets.only(right: 6.0, left: 0),
//             child: Container(
//               //color: Colors.grey[200],
//               child: LineChart(
//                 swapAnimationDuration: Duration(milliseconds: 40),
//                 swapAnimationCurve: Curves.linear,
//                 LineChartData(
//                   clipData: FlClipData.all(),
//                   // no overflow
//                   lineTouchData: LineTouchData(
//                       enabled: true,
//                       touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {},
//                       touchTooltipData: LineTouchTooltipData(
//                         tooltipBgColor: valuePopColor,
//                         tooltipRoundedRadius: 20.0,
//                         showOnTopOfTheChartBoxArea: false,
//                         fitInsideHorizontally: true,
//                         tooltipMargin: 50,
//                         tooltipHorizontalOffset: 20,
//                         fitInsideVertically: true,
//                         tooltipPadding: EdgeInsets.all(8.0),
//                         //maxContentWidth: 40,
//                         getTooltipItems: (touchedSpots) {
//                           return touchedSpots.map((LineBarSpot touchedSpot) {
//                               //gc.changeGazTappedValue(gc.dataPoints[touchedSpot.spotIndex].toString());
//                               const textStyle = TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.white,
//                               );
//                               return LineTooltipItem(
//                                 formatNumberAfterComma('${valList[touchedSpot.spotIndex]} bpm'),
//                                 textStyle,
//                               );
//                             },
//                           ).toList();
//                         },
//                       ),
//                       getTouchedSpotIndicator: (LineChartBarData barData, List<int> indicators) {
//                         return indicators.map(
//                               (int index) {
//                             final line = FlLine(color: Colors.white, strokeWidth: 2, dashArray: [2, 5]);
//                             return TouchedSpotIndicatorData(
//                               line,
//                               FlDotData(show: false),
//                             );
//                           },
//                         ).toList();
//                       },
//                       getTouchLineEnd: (_, __) => double.infinity),
//                   baselineY: 0,
//                   minY: minVal,
//                   maxY: maxVal,
//
//                   ///rangeAnnotations
//                   rangeAnnotations: RangeAnnotations(
//                     // verticalRangeAnnotations:[
//                     //   VerticalRangeAnnotation(x1: 1,x2: 2),
//                     //   VerticalRangeAnnotation(x1: 3,x2: 4)
//                     // ],
//                       horizontalRangeAnnotations: [
//                         //HorizontalRangeAnnotation(y1: 89,y2: 90,color: Colors.redAccent),
//                         // HorizontalRangeAnnotation(y1: 3,y2: 4),
//                         // HorizontalRangeAnnotation(y1: 5,y2: 6),
//                       ]),
//
//                   backgroundColor: bgCol ?? secondaryColor.withOpacity(0.3),
//
//                   /// backgound
//                   borderData: FlBorderData(
//                       border: const Border(
//                         // bottom: BorderSide(),
//                         // left: BorderSide(),
//                         // top: BorderSide(),
//                         //right: BorderSide(),
//                       )),
//                   gridData: FlGridData(show: false, horizontalInterval: 50, verticalInterval: 1),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     bottomTitles: AxisTitles(sideTitles: bottomTimeTitles(ctr.eachTimeHis, timeList!)),
//                     // time line
//                     leftTitles: AxisTitles(sideTitles: leftTitles(valueInterval)),
//                     // values line
//                     topTitles: AxisTitles(sideTitles: topTitles),
//                     rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   ),
//                   lineBarsData: [
//                     LineChartBarData(
//                       ///fill
//                       // belowBarData: BarAreaData(
//                       //     color: Colors.blue,
//                       //     //cutOffY: 0,
//                       //     //ap aplyCutOffY: true,
//                       //     spotsLine: BarAreaSpotsLine(
//                       //       show: true,
//                       //     ),
//                       //     show: true
//                       // ),
//                       dotData: FlDotData(
//                         show: false,
//                       ),
//                       show: true,
//                       preventCurveOverShooting: false,
//                       //showingIndicators:[0,5,6],
//                       isCurved: true,
//                       isStepLineChart: false,
//                       isStrokeCapRound: false,
//                       isStrokeJoinRound: false,
//
//                       barWidth: 3.0,
//                       curveSmoothness: 0.02,
//                       preventCurveOvershootingThreshold: 10.0,
//                       lineChartStepData: LineChartStepData(stepDirection: 0),
//                       //shadow: Shadow(color: Colors.blue,offset: Offset(0,8)),
//                       color: Colors.white,
//                       //spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
//
//                       spots: ctr.generateHistorySpots(valList),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }

/// history_listen
Widget chartGraphValues(
    {Color? bgCol,
    int valueInterval = 50,
    String? dataName,
    List? dataList,
    List<String>? timeList,
    List<double>? valList,
    double? width,
    double? minGraph,
    double? maxGraph,
    double? extraMinMax}) {

  double minValToShow = getDoubleMinValue(valList!); //- extraMinMax
  print('## chart min value: ${minGraph}');
  double maxValToShow = getDoubleMaxValue(valList); // + extraMinMax
  print('## chart max value: ${maxGraph}');

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
    child: Container(
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // IconButton(
                //   onPressed: () async {
                //     await ctr.initHistoryValues('patients/${ctr.selectedServer}/bpm_history'); // shoiw delete dialog
                //   },
                //   icon: Icon(
                //     Icons.refresh,
                //     color: Colors.white,
                //     size: 20,
                //   ),
                // ),
                Text(
                  dataName!,
                  style: TextStyle(fontSize: 24, color: Colors.white70),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '(${formatNumberAfterComma2(minValToShow)}, ${formatNumberAfterComma2(maxValToShow)})',
                  style: TextStyle(fontSize: 15, color: Colors.white70),
                ),
                // IconButton(
                //   onPressed: () async {
                //     await ctr.deleteHisDialog(dataName!, dataList!); // shoiw delete dialog
                //   },
                //   icon: Icon(
                //     Icons.close_fullscreen_outlined,
                //     color: Colors.white,
                //     size: 20,
                //   ),
                // )
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              height: 100.h / 3,
              width: 100.h * width!,
              child: Padding(
                padding: const EdgeInsets.only(right: 6.0, left: 0),
                child: Container(
                  //color: Colors.grey[200],
                  child: LineChart(
                    duration: Duration(milliseconds: 40),
                    curve: Curves.linear,
                    LineChartData(
                      clipData: FlClipData.all(),
                      // no overflow
                      lineTouchData: LineTouchData(
                          enabled: true,
                          touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {},
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: dialogsCol,
                            tooltipRoundedRadius: 20.0,
                            showOnTopOfTheChartBoxArea: false,
                            fitInsideHorizontally: true,
                            tooltipMargin: 50,
                            tooltipHorizontalOffset: 20,
                            fitInsideVertically: true,
                            tooltipPadding: EdgeInsets.all(8.0),
                            //maxContentWidth: 40,
                            getTooltipItems: (touchedSpots) {
                              const textStyle = TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              );
                              return [
                                LineTooltipItem(
                                  formatNumberAfterComma2(invCtr.totals[touchedSpots[1].spotIndex]),
                                    TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: totalCol,
                                    ),
                                ),
                                LineTooltipItem(//income
                                  formatNumberAfterComma2(valList[touchedSpots[0].spotIndex]),
                                  TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: winIncomeCol,
                                  ),
                                )
                              ];
                              // return touchedSpots.map((LineBarSpot touchedSpot) {
                              //     //gc.changeGazTappedValue(gc.dataPoints[touchedSpot.spotIndex].toString());
                              //     const textStyle = TextStyle(
                              //       fontSize: 10,
                              //       fontWeight: FontWeight.w700,
                              //       color: Colors.white,
                              //     );
                              //     return LineTooltipItem(
                              //       formatNumberAfterComma2(valList[touchedSpot.spotIndex]),
                              //       textStyle,
                              //     );
                              //   },
                              // ).toList();
                            },
                          ),
                          getTouchedSpotIndicator: (LineChartBarData barData, List<int> indicators) {
                            return indicators.map(
                              (int index) {
                                final line = FlLine(color: Colors.white, strokeWidth: 2, dashArray: [2, 5]);
                                return TouchedSpotIndicatorData(
                                  line,
                                  FlDotData(show: false),
                                );
                              },
                            ).toList();
                          },
                          getTouchLineEnd: (_, __) => double.infinity),
                      baselineY: 0,
                      minY: minGraph,
                      maxY: maxGraph,
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(sideTitles: bottomTimeTitles(eachTimeHis, timeList!)),
                        // time line
                        //leftTitles: AxisTitles(sideTitles: leftTitles(valueInterval)),
                        // values line
                        topTitles: AxisTitles(sideTitles: topTitles),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          ///fill
                          // belowBarData: BarAreaData(
                          //     color: Colors.blue,
                          //     //cutOffY: 0,
                          //     //ap aplyCutOffY: true,
                          //     spotsLine: BarAreaSpotsLine(
                          //       show: true,
                          //     ),
                          //     show: true
                          // ),
                          dotData: FlDotData(
                            show: false,
                          ),
                          show: true,
                          preventCurveOverShooting: false,
                          //showingIndicators:[0,5,6],
                          isCurved: true,
                          isStepLineChart: false,
                          isStrokeCapRound: false,
                          isStrokeJoinRound: false,

                          barWidth: 3.0,
                          curveSmoothness: 0.02,
                          preventCurveOvershootingThreshold: 10.0,
                          lineChartStepData: LineChartStepData(stepDirection: 0),
                          //shadow: Shadow(color: Colors.blue,offset: Offset(0,8)),
                          color: winIncomeCol,
                          //spots: points.map((point) => FlSpot(point.x, point.y)).toList(),

                          spots: generateHistorySpots(valList),
                        ),
                        LineChartBarData(
                          ///fill
                          // belowBarData: BarAreaData(
                          //     color: Colors.blue,
                          //     //cutOffY: 0,
                          //     //ap aplyCutOffY: true,
                          //     spotsLine: BarAreaSpotsLine(
                          //       show: true,
                          //     ),
                          //     show: true
                          // ),
                          dotData: FlDotData(
                            show: false,
                          ),
                          show: true,
                          preventCurveOverShooting: false,
                          //showingIndicators:[0,5,6],
                          isCurved: true,
                          isStepLineChart: false,
                          isStrokeCapRound: false,
                          isStrokeJoinRound: false,

                          barWidth: 3.0,
                          curveSmoothness: 0.02,
                          preventCurveOvershootingThreshold: 10.0,
                          lineChartStepData: LineChartStepData(stepDirection: 0),
                          //shadow: Shadow(color: Colors.blue,offset: Offset(0,8)),
                          color: totalCol,
                          //spots: points.map((point) => FlSpot(point.x, point.y)).toList(),

                          spots: generateHistorySpots(invCtr.totals),
                        ),
                      ],

                      ///rangeAnnotations
                      rangeAnnotations: RangeAnnotations(
                          // verticalRangeAnnotations:[
                          //   VerticalRangeAnnotation(x1: 1,x2: 2),
                          //   VerticalRangeAnnotation(x1: 3,x2: 4)
                          // ],
                          horizontalRangeAnnotations: [
                            HorizontalRangeAnnotation(y1: 0, y2: 50000, color: Colors.redAccent),
                            // HorizontalRangeAnnotation(y1: 3,y2: 4),
                            // HorizontalRangeAnnotation(y1: 5,y2: 6),
                          ]),

                      backgroundColor: bgCol ?? secondaryColor.withOpacity(0.3),

                      /// backgound
                      borderData: FlBorderData(
                          border: const Border(
                              // bottom: BorderSide(),
                              // left: BorderSide(),
                              // top: BorderSide(),
                              //right: BorderSide(),
                              )),
                      gridData: FlGridData(show: false, horizontalInterval: 50, verticalInterval: 1),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
