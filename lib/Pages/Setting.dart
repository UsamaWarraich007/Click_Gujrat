import 'package:click_gujrat/Models/User.dart';
import 'package:click_gujrat/Pages/ContactUs.dart';
import 'package:click_gujrat/Pages/edit_profile.dart';
import 'package:click_gujrat/Services/AuthenticationService.dart';
import 'package:click_gujrat/Services/fcm_notification.dart';
import 'package:click_gujrat/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/user_info_model.dart';


class MySettings extends StatefulWidget {

  const MySettings({Key? key}) : super(key: key);

  @override
  State<MySettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  RxBool isSwitched = RxBool(false);
  RxBool notification = RxBool(false);
  var textValue = 'Switch is OFF';
  void toggleSwitch(bool value) {

    if(isSwitched.value == false)
    {
      setState(() {
        isSwitched(true);
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    }
    else
    {
      setState(() {
        isSwitched(false);
        textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  void toggleNotification(bool value) async {
    var _userInfo = await AuthService().getAData(3);
    if(!notification.value) {
      for (UserInfo user in _userInfo) {
        await FCMNotificationService().sendNotificationToUser(
            fcmToken: user.token,
            title: "Click Gujrat",
            body: "New place added, please check and approve it");
      }
      notification(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(Roles.roles);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.buttonColor,
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20,),
          Row(
            children: const [
              SizedBox(width: 20,),
              Text('Account', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),),
            ],
          ),
          const SizedBox(height: 10,),
          GestureDetector(
            onTap: () {
              Get.to(() => const EditProfile());
            },
            child: Row(
              children: const [
                SizedBox(width: 20,),
                Icon(Icons.person, color: AppColors.buttonColor,),
                SizedBox(width: 20,),
                Text('Edit Profile', style: TextStyle(
                  fontSize: 20,
                  color: AppColors.buttonColor,
                ),),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          // Row(
          //   children: const [
          //     SizedBox(width: 20,),
          //     Text('Notification', style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 26,
          //     ),),
          //   ],
          // ),
          // const SizedBox(height: 10,),
          // if (Roles.roles == 1)
          // Padding(
          //   padding: const EdgeInsets.only(left: 17),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const Text('New Place Added', style: TextStyle(
          //         fontSize: 26,
          //       ),),
          //       Obx(() => Switch(
          //         onChanged: toggleNotification,
          //         value: notification.value,
          //         activeColor: Colors.blue,
          //         activeTrackColor: Colors.yellow,
          //         inactiveThumbColor: Colors.redAccent,
          //         inactiveTrackColor: Colors.orange,
          //       )),
          //     ],
          //   ),
          // ),
          // if (Roles.roles == 2)
          // Padding(
          //   padding: const EdgeInsets.only(left: 17),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //
          //       const Text('Likes My Comment', style: TextStyle(
          //         fontSize: 26,
          //       ),),
          //
          //       Obx(() => Switch(
          //         onChanged: toggleSwitch,
          //         value: isSwitched.value,
          //         activeColor: Colors.blue,
          //         activeTrackColor: Colors.yellow,
          //         inactiveThumbColor: Colors.redAccent,
          //         inactiveTrackColor: Colors.orange,
          //       )),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 20,),
          Row(
            children: const [
              SizedBox(width: 20,),
              Text('Get help', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),),
            ],
          ),
          const SizedBox(height: 10,),
          InkWell(
            onTap: (){
              Navigator.push(context,  MaterialPageRoute(builder: (context)=> const ContactPage()));
            },
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 20,),
                const Text('Contact Us', style: TextStyle(
                  fontSize: 20,
                ),),
                SizedBox(width: Get.width *1.2/2,),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ],
      ),
    );
  }
}