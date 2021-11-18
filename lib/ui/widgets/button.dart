import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playstore_todo/core/helpers/theme.dart';
class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const AppButton({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ,
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 12.h, horizontal: 17.w),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
