import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common_functions.dart';

showSnackbar(String msg, [Color color = Colors.red, int duration = 2]) {
  ScaffoldMessenger.of(navigatorKey.currentContext!).hideCurrentSnackBar();
  ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
    SnackBar(
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Text(
          msg,
          softWrap: true,
          style: Theme.of(bContext).textTheme.bodyMedium!.copyWith(
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: Duration(seconds: duration),
      dismissDirection: DismissDirection.down,
      margin: const EdgeInsets.only(
        // bottom: _mediaQuery.size.height * 0.8,
        bottom: 40,
        right: 20,
        left: 20,
      ),
    ),
  );
}
