import 'package:click_gujrat/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Toaster {
  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      textColor: AppColors.white,
      backgroundColor: AppColors.textColor,
      timeInSecForIosWeb: 1,
      fontSize: 16.0,
    );
  }

  static SnackbarController showSnackBar(String message) {
    final snack = Get.snackbar(
      "",
      message,
      titleText: const Text("", style: TextStyle(fontSize: 0, height: 0, ), softWrap: false,),
      messageText: Text(message, style: const TextStyle(color: Colors.white,),),
      colorText: Colors.white,
      backgroundColor: Colors.black87,
      snackPosition: SnackPosition.BOTTOM,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      margin: EdgeInsets.only(bottom: Get.height / 2),
    );
    return snack;
  }
}
