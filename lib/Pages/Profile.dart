import 'dart:io';

import 'package:click_gujrat/Services/AuthenticationService.dart';
import 'package:click_gujrat/Models/user_info_model.dart' as info;
import 'package:click_gujrat/Widgets/toaster.dart';
import 'package:click_gujrat/utils/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../Models/User.dart';
import '../Services/upload_file.dart';
import '../Widgets/image_picker_dialog.dart';
import 'edit_profile.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final imagePicker = ImagePicker();
  bool isvisible=false;
  File? _file;
  String _imagePath = "";
@override
  void initState() {
    if(Roles.roles==3){
      isvisible=true;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.buttonColor,
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
            Visibility(
              visible: isvisible,
              child: InkWell(
                onTap: (){
                  Get.to(() => const EditProfile());
                },
                child: Icon(Icons.edit),
              ),
            ),
          const SizedBox(width: 10,),

        ],
      ),
      body: StreamBuilder<info.UserInfo>(
        stream: AuthService().streamUserInfo(),
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return Column(
              children: [
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
                          child: snapshot.data!.image.isNotEmpty
                              ? CircleAvatar(
                                  radius: (100),
                                  backgroundColor: Colors.redAccent,
                                  backgroundImage: NetworkImage(
                                    snapshot.data!.image,
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
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Row(
                    //  crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.orangeAccent,
                        size: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        snapshot.data!.name,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Row(
                    //  crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.mail,
                        color: Colors.orangeAccent,
                        size: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        AuthService().getUser()!.email!,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Row(
                    //  crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      snapshot.data!.gender=="Male"?
                      Icon(
                        Icons.male,
                        color: Colors.orangeAccent,
                        size: 40,
                      ):Icon(
                        Icons.female,
                        color: Colors.orangeAccent,
                        size: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        snapshot.data!.gender,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: InkWell(
                    onTap: () {
                      context.read<AuthService>().signOut();
                      Toaster.showToast("Logout Successfully");
                    },
                    child: Row(
                      //s  crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Icon(
                          Icons.logout,
                          size: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: Text("Something went wrong..."),
          );
        },
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
      AuthService().updateUserInfo(path);
      _imagePath = path;
    }
  }
}
