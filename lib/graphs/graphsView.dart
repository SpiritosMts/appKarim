
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
        ],
      ),
    );
  }

}
