import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color blue = Color(0xff4e5ae8);
const Color yellow = Color(0xffffb746);
const Color pink = Color(0xffff4667);
const Color white = Colors.white;
const primaryColor = blue;
const Color darkGreyColor = Color(0xff121212);
Color darkHeaderColor = const Color(0xff424242);
class Themes{
  static final light = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: primaryColor,
    brightness: Brightness.light
  );

  static final dark = ThemeData(
    backgroundColor: darkGreyColor,
    primaryColor: darkGreyColor,
    brightness: Brightness.dark
  );
}

 TextStyle subHeadingStyle = GoogleFonts.lato(
  textStyle:  TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.grey.withOpacity(.4) : Colors.grey,
  ),
);

TextStyle headingStyle = GoogleFonts.lato(
  textStyle:  TextStyle(
    fontSize: 26.sp,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.white : Colors.black
  ),
);

TextStyle titleStyle = GoogleFonts.lato(
  textStyle:  TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ),
);

TextStyle subTitleStyle = GoogleFonts.lato(
  textStyle:  TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[400],
  ),
);