import 'package:click_gujrat/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Please Wait...",
            style: Get.theme.textTheme.subtitle2,
          ),
          const CircularProgressIndicator.adaptive(),
        ],
      ),
    );
  }
}