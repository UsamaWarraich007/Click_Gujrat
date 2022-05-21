import 'package:click_gujrat/Pages/AddPlace.dart';
import 'package:click_gujrat/Services/location_services.dart';
import 'package:click_gujrat/Widgets/big_text.dart';
import 'package:click_gujrat/Widgets/icon_and_text.dart';
import 'package:click_gujrat/utils/Colors.dart';
import 'package:click_gujrat/utils/dimentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../Models/place_model.dart';
import '../../Models/user_info_model.dart';
import '../../Services/AuthenticationService.dart';
import '../../Services/fcm_notification.dart';

class AdminHomeTab extends StatefulWidget {
  const AdminHomeTab({Key? key}) : super(key: key);

  @override
  _AdminHomeTabState createState() => _AdminHomeTabState();
}

class _AdminHomeTabState extends State<AdminHomeTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80, bottom: 30),
            child: Center(
              child: BigText(
                text: "Approve Places",
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
          StreamProvider<List<Place>?>.value(
            value: LocationServices().fetchPlacesAsStream(),
            initialData: const [],
            builder: (context, widget) => Consumer<List<Place>?>(
              builder: (context, value, child) => ListView.builder(
                itemCount: value!.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Place place = value[index];
                  return Container(
                    margin: EdgeInsets.only(
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      bottom: Dimensions.height10,
                    ),
                    child: GestureDetector(
                      onLongPress: () {
                        Get.defaultDialog(
                          title: "Confirmation",
                          middleText: "Are you sure to delete this place?",
                          onConfirm: () {
                            LocationServices().removePlace(place.id!);
                            Get.back();
                          },
                          textConfirm: "Yes",
                          textCancel: "No",
                        );
                      },
                      child: Row(
                        children: [
                          //image section
                          Container(
                            height: Dimensions.listViewImgSize,
                            width: Dimensions.listViewImgSize,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius20),
                                color: Colors.white38,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(place.homeImage),
                                )),
                          ),
                          //text
                          Expanded(
                            child: Container(
                              height: Dimensions.listViewConSize,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight:
                                      Radius.circular(Dimensions.radius20),
                                  bottomRight:
                                      Radius.circular(Dimensions.radius20),
                                ),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: Dimensions.width10,
                                    right: Dimensions.width10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        BigText(text: place.title),
                                        InkWell(
                                          onTap: place.isApproved
                                              ? null
                                              : () async {
                                                  var _userInfo =
                                                      await AuthService()
                                                          .getAData(2);
                                                  place.isApproved = true;
                                                  LocationServices()
                                                      .updatePlace(
                                                          place, place.id!);
                                                  for (UserInfo user
                                                      in _userInfo) {
                                                    await FCMNotificationService()
                                                        .sendNotificationToUser(
                                                            fcmToken:
                                                                user.token,
                                                            title:
                                                                "Click Gurat",
                                                            body:
                                                                "New place added, please check it and give the feedback");
                                                  }
                                                },
                                          child: place.isApproved
                                              ? const Icon(
                                                  Icons.check_box,
                                                  color: Colors.green,
                                                )
                                              : const Icon(Icons
                                                  .check_box_outline_blank),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dimensions.width10,
                                    ),
                                    BigText(
                                      text: place.description,
                                      size: 15,
                                      color: AppColors.textColor,
                                    ),
                                    SizedBox(
                                      height: Dimensions.width10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FutureBuilder<String>(
                                            future: place.getDistance(),
                                            builder: (_, snapshot) {
                                              if (snapshot.hasData && snapshot.data != null) {
                                                return IconAndText(
                                                    icon: Icons.location_on,
                                                    text: "${snapshot.data}Km",
                                                    iconColor:
                                                    AppColors.green);
                                              }
                                              return const IconAndText(
                                                  icon: Icons.location_on,
                                                  text: "0Km",
                                                  iconColor:
                                                  AppColors.green);
                                            }
                                                ),
                                        IconAndText(
                                            icon: Icons.access_time_sharp,
                                            text: place.remainingTime(),
                                            iconColor: AppColors.yellow),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
