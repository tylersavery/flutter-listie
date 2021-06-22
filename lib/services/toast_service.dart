import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listie/theme.dart';

class ToastService {
  static success(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: ThemeColors.success,
      textColor: Colors.white,
    );
  }

  static error(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: ThemeColors.danger,
      textColor: Colors.white,
    );
  }
}
