import 'dart:io';

import 'package:click_gujrat/Models/User.dart';
import 'package:click_gujrat/Services/AuthenticationService.dart';
import 'package:click_gujrat/utils/dimentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Models/user_info_model.dart';
import '../Services/DatabaseServices.dart';
import '../Services/upload_file.dart';
import '../Widgets/image_picker_dialog.dart';
import '../Widgets/loading_spinner.dart';
import '../Widgets/toaster.dart';
import '../utils/Colors.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final imagePicker = ImagePicker();
  File? _file;
  String _imagePath = "";

  final nameFocus = FocusNode(),
      emailFocus = FocusNode();
     // passwordFocus = FocusNode(),
    //  newPasswordFocus = FocusNode(),
     // confirmFocus = FocusNode();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
 // final TextEditingController _passwordController = TextEditingController();
 // final TextEditingController _newPasswordController = TextEditingController();
 // final TextEditingController _repeatPasswordController =TextEditingController();
  String _gender = '';

  @override
  void dispose() {
    email.dispose();
    username.dispose();
   // _passwordController.dispose();
   // _newPasswordController.dispose();
   // _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    updateUI();
  }

  void updateUI() async {
    print(AuthService().getUser()!.email!);
    UserInfo _userInfo = await AuthService().getUserInfo();
    username.text = _userInfo.name;
    _gender = _userInfo.gender;
    email.text = AuthService().getUser()!.email!;
    _imagePath = _userInfo.image;
    Roles.roles = _userInfo.role;
    setState(() {});
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
        body: Stack(
          children: [
            ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        height: 200,
                        width: Get.width / 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                right: 0,
                                child: _imagePath.isNotEmpty
                                    ? CircleAvatar(
                                        radius: (100),
                                        backgroundColor: Colors.redAccent,
                                        backgroundImage: NetworkImage(
                                          _imagePath,
                                        ),
                                      )
                                    : const CircleAvatar(
                                        radius: (100),
                                        backgroundColor: Colors.redAccent,
                                        backgroundImage:
                                            AssetImage("assets/user.png"),
                                      ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: AppColors.buttonColor,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 40,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  onTap: () => Get.bottomSheet(
                                    ImagePickerBottomSheet(
                                      onCameraTap: () async {
                                        var image = await imagePicker.pickImage(
                                            source: ImageSource.camera);
                                        if (image != null) {
                                          // print(image.path);
                                          Get.back();
                                          uploadImage(image.path);
                                        }
                                      },
                                      onGalleryTap: () async {
                                        var image = await imagePicker.pickImage(
                                            source: ImageSource.gallery);
                                        if (image != null) {
                                          Get.back();
                                          uploadImage(image.path);
                                          // print(image.path);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
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
                        height: 30,
                      ),
                      // Container(
                      //   padding: const EdgeInsets.only(right: 35, left: 35),
                      //   child: TextFormField(
                      //     autovalidateMode: AutovalidateMode.onUserInteraction,
                      //     controller: email,
                      //     keyboardType: TextInputType.emailAddress,
                      //     textInputAction: TextInputAction.next,
                      //     focusNode: emailFocus,
                      //     validator: (email) {
                      //       if (email == null || email.trim().isEmpty) {
                      //         return "email can't be empty";
                      //       }
                      //       return null;
                      //     },
                      //     onFieldSubmitted: (name) =>
                      //         Get.focusScope!.requestFocus(emailFocus),
                      //     decoration: InputDecoration(
                      //         prefixIcon: const Icon(Icons.email,
                      //             color: Color(0xfff1c40f)),
                      //         fillColor: Colors.grey.shade100,
                      //         filled: true,
                      //         labelText: 'Email',
                      //         floatingLabelStyle:
                      //         const TextStyle(color: Color(0xfff1c40f)),
                      //         focusedBorder: const OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //               color: Color(0xfff1c40f), width: 2.0),
                      //         ),
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10),
                      //         )),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 30,
                      ),
                      // Container(
                      //   padding: const EdgeInsets.only(right: 35, left: 35),
                      //   child: TextFormField(
                      //     autovalidateMode: AutovalidateMode.onUserInteraction,
                      //     keyboardType: TextInputType.visiblePassword,
                      //     textInputAction: TextInputAction.next,
                      //     onFieldSubmitted: (name) => Get.focusScope!.requestFocus(newPasswordFocus),
                      //     controller: _passwordController,
                      //     obscureText: true,
                      //     validator: (password) {
                      //       if (password == null || password.isEmpty) {
                      //         return "Enter your current password";
                      //       } else if (password.trim().length < 6) {
                      //         return "password must be 6 characters or greater then 6";
                      //       }
                      //       return null;
                      //     },
                      //     decoration: InputDecoration(
                      //         prefixIcon: const Icon(Icons.lock,
                      //             color: Color(0xfff1c40f)),
                      //         fillColor: Colors.grey.shade100,
                      //         filled: true,
                      //         labelText: 'Current Password',
                      //         floatingLabelStyle:
                      //             const TextStyle(color: Color(0xfff1c40f)),
                      //         focusedBorder: const OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //               color: Color(0xfff1c40f), width: 2.0),
                      //         ),
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10),
                      //         )),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //   padding: const EdgeInsets.only(right: 35, left: 35),
                      //   child: TextFormField(
                      //     autovalidateMode: AutovalidateMode.onUserInteraction,
                      //     keyboardType: TextInputType.visiblePassword,
                      //     textInputAction: TextInputAction.done,
                      //     focusNode: newPasswordFocus,
                      //     controller: _newPasswordController,
                      //     validator: (newPassword) {
                      //       if (newPassword == null || newPassword.isEmpty) {
                      //         return "Enter your new password";
                      //       } else if (newPassword.trim().length < 6) {
                      //         return "password must be 6 characters or greater then 6";
                      //       }
                      //       return null;
                      //     },
                      //     onFieldSubmitted: (name) => Get.focusScope!.unfocus(),
                      //     obscureText: true,
                      //     decoration: InputDecoration(
                      //         prefixIcon: const Icon(Icons.lock,
                      //             color: Color(0xfff1c40f)),
                      //         fillColor: Colors.grey.shade100,
                      //         filled: true,
                      //         labelText: 'New Password',
                      //         floatingLabelStyle:
                      //             const TextStyle(color: Color(0xfff1c40f)),
                      //         focusedBorder: const OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //               color: Color(0xfff1c40f), width: 2.0),
                      //         ),
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10),
                      //         )),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //   padding: const EdgeInsets.only(right: 35, left: 35),
                      //   child: TextFormField(
                      //     autovalidateMode: AutovalidateMode.onUserInteraction,
                      //     keyboardType: TextInputType.visiblePassword,
                      //     textInputAction: TextInputAction.done,
                      //     focusNode: confirmFocus,
                      //     controller: _repeatPasswordController,
                      //     validator: (confirm) {
                      //       if (confirm == null || confirm.isEmpty) {
                      //         return "Please confirm your password";
                      //       } else if (confirm.trim().length < 6) {
                      //         return "password must be 6 characters or greater then 6";
                      //       }
                      //       if (confirm != _newPasswordController.text) {
                      //         return "Password not matched";
                      //       }
                      //       return null;
                      //     },
                      //     onFieldSubmitted: (name) => Get.focusScope!.unfocus(),
                      //     obscureText: true,
                      //     decoration: InputDecoration(
                      //         prefixIcon: const Icon(Icons.lock,
                      //             color: Color(0xfff1c40f)),
                      //         fillColor: Colors.grey.shade100,
                      //         filled: true,
                      //         labelText: 'Confirm Password',
                      //         floatingLabelStyle:
                      //             const TextStyle(color: Color(0xfff1c40f)),
                      //         focusedBorder: const OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //               color: Color(0xfff1c40f), width: 2.0),
                      //         ),
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10),
                      //         )),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
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
                      SizedBox(
                        height: Dimensions.height15,
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
                                    onPressed: () async => await update(),
                                    child: const Text(
                                      'Update',
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
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
                left: Dimensions.width15,
                top: 30,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.buttonColor,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      color: AppColors.white,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void uploadImage(String path) {
    setState(() {
      _file = File(path);
    });
    uploadFile(_file!, true);
  }

  Future<void> uploadFile(File file, bool isHomeImage) async {
    String path = await UploadFile().uploadFile(file, isHomeImage);
    if (path.isEmpty) return;
    if (isHomeImage) {
      setState(() => _imagePath = path);
    }
  }

  Future<void> update() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    Get.focusScope!.unfocus();
    // if (!await validateCurrentPassword(_passwordController.text)) {
    //   Toaster.showToast("Current password not valid, please check it and try again.");
    //   return;
    // }

    if (_gender.isEmpty) {
      Toaster.showToast("Please select gender.");
      return;
    }
    Get.dialog(const LoadingSpinner(), barrierDismissible: false);
   // await AuthService().updatePassword(_newPasswordController.text);
    var result = await AuthService().updateProfile(username.text, _gender, _imagePath);
    Get.back();
    print(result);
    if (!result) {
      debugPrint("no updated");
      return;
    }
    Toaster.showToast("Update Successfully");
    Get.back();
  }

  Future<bool> validateCurrentPassword(String password) async {
    return await AuthService().validatePassword(password);
  }
}
