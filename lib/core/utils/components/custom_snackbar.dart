import 'package:another_flushbar/flushbar.dart';
import 'package:chat_app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simplified_text_widget/simplified_text_widget.dart';

class CustomSnackbar {
  static success(BuildContext context, {required String message}) {
    return Flushbar(
      backgroundColor: Colors.green,
      animationDuration: .new(seconds: 1),
      borderRadius: .circular(12),
      flushbarStyle: .FLOATING,
      messageText: Text14(message, color: AppColors.light),
      isDismissible: true,
      duration: .new(seconds: 2),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    ).show(context);
  }
}
