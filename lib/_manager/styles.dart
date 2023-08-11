

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


// Depricated
const Color primaryColor = Color(0xFF0097A7);
const Color secondaryColor = Color(0xFFB2EBF2);
const Color introBackColor = Color(0xFFCCF6FB);
const Color accentColor = Color(0xFF006064);
const Color accentColor0   = Color(0xFF024855);
const Color customColor1 = Color(0xFF0F8D9C);
const Color appbarColor  = Color(0xFF096C7A);
const MaterialColor customColor = MaterialColor(
  0xFF024855,
  <int, Color>{
    50: Color(0xFFD4ECE8),
    100: Color(0xFFA8DAD2),
    200: Color(0xFF7DBCB9),
    300: Color(0xFF519E9F),
    400: Color(0xFF297D85),
    500: Color(0xFF006764),
    600: Color(0xFF005C57),
    700: Color(0xFF004E4A),
    800: Color(0xFF00403D),
    900: Color(0xFF002A28),
  },
);
// /////////////////////////
final MaterialColor blueSwatch = MaterialColor(0xFF569AEA, {
  50: Color(0xFFD6E9FC),
  100: Color(0xFFADCDF9),
  200: Color(0xFF84B0F7),
  300: Color(0xFF5A94F4),
  400: Color(0xFF3177F2),
  500: Color(0xFF0E5AEA), // This is the primary color
  600: Color(0xFF0C52E2),
  700: Color(0xFF0A4AD9),
  800: Color(0xFF083FD0),
  900: Color(0xFF0531C1),
});
final MaterialColor greenSwatch = MaterialColor(0xFF42756B, {
  50: Color(0xFFB0CEC9),
  100: Color(0xFF8EAFA8),
  200: Color(0xFF6C9087),
  300: Color(0xFF4A7166),
  400: Color(0xFF295245),
  500: Color(0xFF42756B), // This is the primary color
  600: Color(0xFF1B5842),
  700: Color(0xFF174F3B),
  800: Color(0xFF134731),
  900: Color(0xFF0F3D28),
});
final MaterialColor brownSwatch = MaterialColor(0xFF6B3A0A, {
  50: Color(0xFFF4E9DF),
  100: Color(0xFFE8D3BF),
  200: Color(0xFFD0A882),
  300: Color(0xFFB97D45),
  400: Color(0xFFA56120),
  500: Color(0xFF6B3A0A), // This is the primary color
  600: Color(0xFF623408),
  700: Color(0xFF592E07),
  800: Color(0xFF502605),
  900: Color(0xFF3E1C03),
});


const Color accentColor1   = Color(0xFF569AEA);
const Color cstmButtonBorderCol   = accentColor1;
const Color cstmButtonFillCol   = accentColor1;

//const Color dialogsCol = Colors.blueGrey.shade500;
//const Color dialogsCol = Color(0XFF16254b)  ;

const Color dialogsCol = Color(0XFF1b2c57)  ;
const Color dialogButtonCol   = accentColor1;
const Color dialogButtonTextCol   = Colors.white;
const Color dialogTitleCol   = Colors.white;

const Color winIncomeCol   = Colors.greenAccent;
const Color errorColor   = Colors.redAccent;
const Color looseIncomeCol  = Colors.red;
const Color totalCol  = Colors.lightBlueAccent;

 Color activeCardBorder = Colors.lightBlueAccent;
const Color normalCardBorder   = Colors.white38;

 Color appBarUnderlineColor  = blueSwatch[200]!;
const Color settingIconColor  = Colors.blue;
const Color cardColor  = Color(0x88147193);
const Color dividerColor  = Colors.white;


const blueColHex = Color(0Xff0a1227);
const blueColHex2 = Color(0XFF16254b);
const chartValuesColor = Colors.white;
const valuePopColor = Colors.greenAccent;

const hintPrimColor = Color(0X60569AEA);


/// //////////////// LIGHT /////////////////////////////////////////////////////////////////////////
/// //////////////// LIGHT /////////////////////////////////////////////////////////////////////////
/// //////////////// LIGHT /////////////////////////////////////////////////////////////////////////
ThemeData customLightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: blueColHex,
  dialogBackgroundColor: Colors.white38,
  primarySwatch: greenSwatch,
  unselectedWidgetColor: Colors.white24,

  //drawer background col
  canvasColor: blueColHex,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  tabBarTheme: TabBarTheme(
    unselectedLabelColor: Colors.white38,
    labelColor: Colors.white,
    indicatorColor: Colors.white,

    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        color: Colors.white, // Color of the tab indicator
        width: 3.0, // Thickness of the indicator
      ),
      insets: EdgeInsets.only(bottom: 8), // Distance from the bottom of the TabBar
    ),
  ),

  listTileTheme: ListTileThemeData(
    iconColor: blueSwatch,
  ),

  iconTheme: IconThemeData(
      color: blueSwatch
  ),
  // cardColor: hintYellowColHex4,
  //
  // cardTheme: CardTheme(
  //   color: hintYellowColHex4,
  //   //surfaceTintColor: Colors.greenAccent
  // ),
  //unselected checkbox
  //disabledColor: Colors.redAccent,
  inputDecorationTheme:  InputDecorationTheme(
    contentPadding:  EdgeInsets.only(top: 0,bottom: 15),


    disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: hintPrimColor,
          width: 1,
        )),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: hintPrimColor,
          width: 1,
        )),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: greenSwatch, width: 2),
    ),
  ),
  dividerColor: Colors.white,

  hintColor: hintPrimColor,

  textTheme: textThemeGlob.apply(
    decoration: TextDecoration.none,
    decorationColor: Colors.white,
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  colorScheme: ColorScheme.fromSwatch(
    //with copywith
    // primary: yellowCol,
    // secondary: yellowCol,
    // outline: yellowCol
    //no copyWith
    accentColor: greenSwatch,
    backgroundColor: blueColHex,
    primarySwatch: greenSwatch,
  ).copyWith(secondary: greenSwatch),
  appBarTheme:  AppBarTheme(
    iconTheme: IconThemeData(color: blueSwatch[200]!), // 1
    backgroundColor: blueColHex,
    centerTitle: true,

    titleTextStyle: GoogleFonts.almarai(
        textStyle: const TextStyle(fontSize: 20),
        color: blueSwatch[200]!
    ),
  ),
  primaryColor: greenSwatch,


  buttonTheme:  ButtonThemeData(
    buttonColor: greenSwatch,
    disabledColor: Colors.grey,
  ),
);
/// //////////////// DARK /////////////////////////////////////////////////////////////////////////
/// //////////////// DARK /////////////////////////////////////////////////////////////////////////
/// //////////////// DARK /////////////////////////////////////////////////////////////////////////
ThemeData customDarkTheme = ThemeData(
  appBarTheme: const AppBarTheme(color: Colors.redAccent),
  //accentColor: Colors.red,
  brightness: Brightness.dark,
  primaryColor: Colors.amber,
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.amber,
    disabledColor: Colors.grey,
  ),
);
/// ##########################################################################
/// ##########################################################################

final myTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  //backgroundColor: Colors.white,
  primarySwatch: blueSwatch,

);

TextStyle highlightStyle = TextStyle(
  fontSize: 14.0,
  color: Colors.transparent,
  decoration: TextDecoration.underline,
  fontWeight: FontWeight.w500,
  shadows: [Shadow(color: Colors.red, offset: Offset(0, -1))],
  decorationColor: Colors.red,
  decorationThickness: 1,
  decorationStyle: TextDecorationStyle.solid,
);
TextStyle bodyStyle = TextStyle(
  fontSize: 14.0,
  color: Colors.black,
);

ButtonStyle borderStyle({Color color = dialogButtonCol}){
  return TextButton.styleFrom(
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    shape: RoundedRectangleBorder(
        side:  BorderSide(color: color, width: 2, style: BorderStyle.solid), borderRadius: BorderRadius.circular(100)),
  );
}
ButtonStyle filledStyle({Color color = dialogButtonCol}){
  return TextButton.styleFrom(
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    backgroundColor: color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
  );
}

Color getRandomColor() {
  final Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}
Color getRandomColor1() {
  final Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1.0,

  );
}


appBarUnderline(){
  return PreferredSize(
      preferredSize: Size.fromHeight(4.0),
      child: Container(
        color: appBarUnderlineColor,
        height: 2.0,
      ));
}


final TextTheme textThemeGlob = TextTheme(
  headline1: GoogleFonts.almarai(fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  headline2: GoogleFonts.almarai(fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  headline3: GoogleFonts.almarai(fontSize: 48, fontWeight: FontWeight.w400),
  headline4: GoogleFonts.almarai(fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headline5: GoogleFonts.almarai(fontSize: 24, fontWeight: FontWeight.w400),
  headline6: GoogleFonts.almarai(fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  subtitle1: GoogleFonts.almarai(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  subtitle2: GoogleFonts.almarai(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyText1: GoogleFonts.almarai(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: GoogleFonts.almarai(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  button: GoogleFonts.almarai(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  caption: GoogleFonts.almarai(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: GoogleFonts.almarai(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

