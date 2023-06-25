/// show loading (while verifying user account)

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'myUi.dart';
import 'myVoids.dart';
import 'styles.dart';

class FirebaseControl extends StatefulWidget {
  const FirebaseControl({Key? key}) : super(key: key);

  @override
  State<FirebaseControl> createState() => _FirebaseControlState();
}

class _FirebaseControlState extends State<FirebaseControl> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
