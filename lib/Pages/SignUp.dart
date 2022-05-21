import 'package:click_gujrat/Pages/Login.dart';
import 'package:click_gujrat/Widgets/loading_spinner.dart';
import 'package:click_gujrat/Widgets/toaster.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Models/User.dart';
import '../Services/AuthenticationService.dart';

class MySignUp extends StatefulWidget {
  const MySignUp({Key? key}) : super(key: key);

  @override
  State<MySignUp> createState() => _MySignUpState();
}

class _MySignUpState extends State<MySignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final nameFocus = FocusNode(),
      emailFocus = FocusNode(),
      passwordFocus = FocusNode(),
      conformFocus = FocusNode();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm = TextEditingController();
  String _gender = '';
  int _role = 0;

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    username.dispose();
    password.dispose();
    confirm.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.amber,
        image: DecorationImage(
            image: AssetImage('assets/login_background.png'),
            fit: BoxFit.cover),
      ),
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
                    margin: const EdgeInsets.only(top: 80, left: 35),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(color: Colors.black, fontSize: 33),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 35, left: 35),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: username,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      focusNode: nameFocus,
                      validator: (name) {
                        if (name == null || name.trim().isEmpty) {
                          return "name can't be empty";
                        }
                        return null;
                      },
                      onFieldSubmitted: (name) =>
                          Get.focusScope!.requestFocus(emailFocus),
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person,
                              color: Color(0xfff1c40f)),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          labelText: 'User Name',
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
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 35, left: 35),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      focusNode: emailFocus,
                      validator: (email) {
                        if (email == null || email.trim().isEmpty) {
                          return "email can't be empty";
                        } else if (!GetUtils.isEmail(email)) {
                          return "enter valid email";
                        }
                        return null;
                      },
                      onFieldSubmitted: (name) =>
                          Get.focusScope!.requestFocus(passwordFocus),
                      controller: email,
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
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 35, left: 35),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      focusNode: passwordFocus,
                      validator: (password) {
                        if (password == null ||
                            password.trim().length < 6) {
                          return "password must be 6 characters or greater then 6";
                        }
                        return null;
                      },
                      onFieldSubmitted: (name) =>
                          Get.focusScope!.requestFocus(conformFocus),
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.lock, color: Color(0xfff1c40f)),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          labelText: 'Password',
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
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 35, left: 35),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      focusNode: conformFocus,
                      controller: confirm,
                      validator: (confirm) {
                        if (confirm == null ||
                            confirm.trim().length < 6) {
                          return "password must be 6 characters or greater then 6";
                        }
                        if (confirm != password.text) {
                          return "password not matched";
                        }
                        return null;
                      },
                      onFieldSubmitted: (name) => Get.focusScope!.unfocus(),
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.lock, color: Color(0xfff1c40f)),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          labelText: 'Confirm Password',
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
                  Container(
                    padding: const EdgeInsets.only(right: 35, left: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Row(
                            children: const [
                              Expanded(
                                child: Text(
                                  'Gender',
                                  style: TextStyle(
                                    color: Color(0xfff1c40f),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio(
                                  value: 'Male',
                                  groupValue: _gender,
                                  activeColor: const Color(0xfff1c40f),
                                  onChanged: (val) {
                                    setState(() {
                                      debugPrint(val.toString());
                                      _gender = val.toString();
                                    });
                                  }),
                              const Expanded(
                                child: Text('Male'),
                              ),
                            ],
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio(
                                  value: 'Female',
                                  groupValue: _gender,
                                  activeColor: const Color(0xfff1c40f),
                                  onChanged: (val) {
                                    setState(() {
                                      debugPrint(val.toString());
                                      _gender = val.toString();
                                    });
                                  }),
                              const Expanded(
                                child: Text('Female'),
                              ),
                            ],
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 35, left: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Row(
                            children: const [
                              Expanded(
                                child: Text(
                                  'Type',
                                  style: TextStyle(
                                    color: Color(0xfff1c40f),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio<int>(
                                  value: 1,
                                  groupValue: _role,
                                  activeColor: const Color(0xfff1c40f),
                                  onChanged: (val) {
                                    setState(() {
                                      debugPrint(val.toString());
                                      _role = val!;
                                      Roles.roles = _role;
                                    });
                                  }),
                              const Expanded(
                                child: Text('Owner'),
                              ),
                            ],
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio<int>(
                                  value: 2,
                                  groupValue: _role,
                                  activeColor: const Color(0xfff1c40f),
                                  onChanged: (val) {
                                    setState(() {
                                      debugPrint(val.toString());
                                      _role = val!;
                                      Roles.roles = _role;
                                    });
                                  }),
                              const Expanded(
                                child: Text("User"),
                              ),
                            ],
                          ),
                          flex: 1,
                        ),
                      ],
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
                                onPressed: () async => await signUp(),
                                child: const Text(
                                  'SignUp',
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
                      margin: const EdgeInsets.only(top: 125),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MyLogin()));
                              },
                              child: const Text(
                                'SignIn',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signUp() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    Get.focusScope!.unfocus();

    if (_gender.isEmpty) {
      Toaster.showToast("Please select gender.");
      return;
    }

    if (_role == 0) {
      Toaster.showToast("Please select account type.");
      return;
    }
    // showDialog(context: context, builder: (context) => const LoadingSpinner(), barrierDismissible: false);
    Get.dialog(const LoadingSpinner(), barrierDismissible: false);
    UserModel? result = await _auth.signUp(
        username.text, email.text.trim(), password.text.trim(), _gender);
    Get.back();
    // Navigator.pop(context);
    if (result == null) {
      debugPrint("not signup");
      return;
    }
    Toaster.showToast("Sign Up Successfully");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const MyLogin(),
        //MobileSignUpScreen()
      ),
    );
  }
}
