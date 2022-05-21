import 'package:click_gujrat/Widgets/toaster.dart';
import 'package:click_gujrat/utils/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showForgotDialog() async {
  final emailController = TextEditingController();
  final emailFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  Get.defaultDialog(
    barrierDismissible: false,
    title: "Forgot Password",
    content: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
                "Enter your registered email to receive the link and reset your password or contact our support"),
            const SizedBox(
              height: 16,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.send,
                controller: emailController,
                focusNode: emailFocus,
                keyboardType: TextInputType.emailAddress,
                validator: (email) {
                  if (GetUtils.isNullOrBlank(email)! || !GetUtils.isEmail(email!)) {
                    return "Enter valid email";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xfff1c40f), width: 2.0),
                    ),
                  border: OutlineInputBorder(),
                    hintText: "e.g example@gmail.com"),
              ),
            ),
          ],
        ),
      ),
    ),
    cancelTextColor: AppColors.buttonColor,
    buttonColor: AppColors.buttonColor,
    confirmTextColor: AppColors.white,
    onConfirm: () async {
      if (!_formKey.currentState!.validate()) return;
      _formKey.currentState!.save();
      Get.focusScope!.unfocus();
      Get.back();
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
        Toaster.showToast("Password reset email sent");
      } on FirebaseAuthException catch (e) {
        Get.log(e.toString());
        Toaster.showToast(e.message!);
      }
    },
    textCancel: "Back",
    textConfirm: "Send",
    onCancel: () {},
  );
}