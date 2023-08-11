
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_manager/bindings.dart';
import '../_manager/charts/chartsUi.dart';
import '../_manager/myVoids.dart';
import '../_manager/styles.dart';

class GraphsView extends StatefulWidget {const GraphsView({super.key});

  @override
  State<GraphsView> createState() => _GraphsViewState();
}

class _GraphsViewState extends State<GraphsView> {

  Widget prop({IconData? icon, String? title, String? value}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 16,
        ),
        SizedBox(width: 9),
        Text(
          '${title!} :',
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        SizedBox(
          width: 13,
        ),
        Text(
          value!,
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // _animationController = AnimationController(
    //   duration: Duration(seconds: 1),
    //   vsync: this, // Provide the TickerProvider
    // );
    // _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!);
  }
  @override
  void dispose() {
    //animation!.dispose();
    super.dispose();
  }

  List<double> graphValues = [158.4,120.4,200.4,85.4,800.4,500.4];
  List<String> graphTimes = ['hi','nisan','yare','sae','yfe','ye',];
  /// /////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: appBarUnderline(),
        title: Text('graphic study'.tr),
      ),

      body: Column(
        children: [
          SizedBox(
            height: 80.h,
            child: (invCtr.incomes.isNotEmpty) ? chartGraphValues(
              valueInterval: 20,
              dataName: 'Août 2023 ',
              dataList: [],
              // list { 'time':25, 'value':147 }
              timeList: invCtr.dates,
              //list [25,26 ..] // X
              valList: invCtr.incomes,
              //list [147,144 ..] // Y
             // minGraph: getDoubleMinValue(invCtr.incomes) - 500,
              minGraph: -2500000,
              //maxGraph: (getDoubleMaxValue(invCtr.totals) + 500).toInt().toDouble(),
              maxGraph: 25000000,
              extraMinMax: 300.0,
              width: 1,//multiplied by 100.w
            )
                : Center(
              child: Text('no charts data saved yet'.tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.indieFlower(
                    textStyle: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.w700),
                  )),
            ),
          ),
        ],
      ),
    );
  }

}
