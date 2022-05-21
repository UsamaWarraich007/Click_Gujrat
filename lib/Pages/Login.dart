import 'package:click_gujrat/Pages/SignUp.dart';
import 'package:click_gujrat/Services/AuthenticationService.dart';
import 'package:click_gujrat/Widgets/loading_spinner.dart';
import 'package:click_gujrat/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/User.dart';
import 'Home/main_home.dart';
import 'forgot_dialog.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  State<MyLogin> createState() => _MyLoginState();
}

const color = Color(0xFFB74093);

class _MyLoginState extends State<MyLogin> {
  final AuthService _auth = AuthService();
  FocusNode emailNode = FocusNode(), passwordNode = FocusNode();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.amber,
          image: DecorationImage(
              image: AssetImage('assets/login_background.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      margin: const EdgeInsets.only(top: 130, left: 35),
                      child: const Text(
                        'Login',
                        style:
                            TextStyle(color: Color(0xfff1c40f), fontSize: 33),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.only(top: 0, left: 35),
                      child: const Text(
                        'Please Sign in to Continue',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 35, left: 35),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: email,
                        focusNode: emailNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (text) => Get.focusScope!.requestFocus(passwordNode),
                        validator: (email) {
                          if (email == null || email.trim().isEmpty) {
                            return "email can't be empty";
                          } else if (!GetUtils.isEmail(email)) {
                            return "enter valid email";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            prefixIcon:
                            const Icon(Icons.mail, color: Color(0xfff1c40f)),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Email',
                            floatingLabelStyle:
                            const TextStyle(color: Color(0xfff1c40f)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xfff1c40f), width: 2.0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 35, left: 35),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (text) async => await login(),
                        validator: (password) {
                          if (password == null || password.trim().isEmpty) {
                            return "enter password";
                          } else if (password.length < 6) {
                            return "password must be 6 characters";
                          }
                          return null;
                        },
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                            prefixIcon:
                            const Icon(Icons.lock, color: Color(0xfff1c40f)),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'password',
                            floatingLabelStyle:
                            const TextStyle(color: Color(0xfff1c40f)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xfff1c40f), width: 2.0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    ),
                    //forget password
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.only(right: 35),
                        child: const TextButton(
                            onPressed: showForgotDialog,
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                              ),
                            )),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: const Color(0xfff1c40f),
                          ),
                          margin: const EdgeInsets.only(right: 35),
                          child: Row(
                            children: [
                              TextButton(
                                  onPressed: () async => await login(),
                                  child: const Text(
                                    'LogIn',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  )),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ],
                          )),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 145),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const MySignUp()));
                            }, child: const Text('Sign Up', style: TextStyle(color: Colors.white),))
                          ],
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),),
    );
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    Get.focusScope!.unfocus();
    // showDialog(context: context, builder: (context) => const LoadingSpinner(), barrierDismissible: false);
    Get.dialog(const LoadingSpinner(), barrierDismissible: false);
    UserModel? result = await _auth.signIn(
      email.text.trim(),
      password.text.trim(),
    );
    // Navigator.pop(context);
    Get.back();
    if (result == null) {
      debugPrint(result.toString());
      return;
    }

    Get.offNamed(AppRoutes.wrapper);
  }
}
