import 'package:click_gujrat/Services/location_services.dart';
import 'package:click_gujrat/Widgets/big_text.dart';
import 'package:click_gujrat/Widgets/icon_and_text.dart';
import 'package:click_gujrat/utils/Colors.dart';
import 'package:click_gujrat/utils/dimentions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/place_model.dart';
import '../PlaceInfo/place_detail.dart';

class AdminDiscover extends StatefulWidget {
  const AdminDiscover({Key? key}) : super(key: key);

  @override
  _AdminDiscoverState createState() => _AdminDiscoverState();
}

class _AdminDiscoverState extends State<AdminDiscover> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Place>?>.value(
      value: LocationServices().fetchPlacesAsStream(),
      initialData: const [],
      builder: (context, child) => Consumer<List<Place>?>(
        builder: (context, value, child) {
          if (value == null || value.isEmpty) {
            return Center(child: BigText(text: "Places not found.", size: 20,),);
          }
          List<String> categories = [];
          for (Place place in value) {
            categories.add(place.category);
          }
          List<String> categoryList = categories.toSet().toList();
          return ListView.builder(
            itemCount: categoryList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              String category = categoryList[index];
              var items = LocationServices()
                  .searchPlacesAsStream(category: category);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Resturent
                  Container(
                    padding: const EdgeInsets.only(left: 15, top: 30, bottom: 20),
                    child: BigText(
                        text: category, size: 25, color: Colors.black),
                  ),
                  StreamProvider<List<Place>?>.value(
                    value: items,
                    initialData: const [],
                    builder:  (context, child) => Consumer<List<Place>?>(
                      builder: (context, value, child) {
                        if (value == null || value.isEmpty) {
                          return Center(child: BigText(text: "Places not found.", size: 20,),);
                        }
                        return SizedBox(
                          height: 260,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: value.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              Place place = value[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => PlaceDetail(id: place.id!)));
                                },
                                child: Card(
                                  margin: const EdgeInsets.only(left: 10, top: 20),
                                  elevation: 7,
                                  child: Column(
                                    children: [
                                      //image
                                      Container(
                                        width: 250,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          // borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(place.homeImage),
                                            )),
                                      ),
                                      //all text
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: Dimensions.height15,
                                            bottom: 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            BigText(text: place.title),
                                            SizedBox(
                                              height: Dimensions.height10,
                                            ),
                                            Row(
                                              children: [
                                                Wrap(
                                                  children: List.generate(
                                                      5,
                                                          (index) => const Icon(
                                                        Icons.star,
                                                        color: AppColors.yellow,
                                                        size: 15,
                                                      )),
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                BigText(
                                                  text: "${place.likes.toString()}.0",
                                                  size: 15,
                                                  color: AppColors.textColor,
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                BigText(
                                                  text: place.commentsCount.toString(),
                                                  size: 15,
                                                  color: AppColors.textColor,
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                BigText(
                                                  text: "Comments",
                                                  size: 15,
                                                  color: AppColors.textColor,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: Dimensions.height20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                const IconAndText(
                                                    icon: Icons.circle_sharp,
                                                    text: "Normal",
                                                    iconColor: AppColors.orange),
                                                FutureBuilder<String>(future: place.getDistance(),builder: (context, snapshot) {
                                                  if (snapshot.hasData && snapshot.data != null) {
                                                    return IconAndText(
                                                        icon: Icons.location_on,
                                                        text: "${snapshot.data}Km",
                                                        iconColor: AppColors.green);
                                                  }
                                                  return const IconAndText(
                                                      icon: Icons.location_on,
                                                      text: "0Km",
                                                      iconColor: AppColors.green);
                                                }),
                                                IconAndText(
                                                    icon: Icons.access_time_sharp,
                                                    text: place.remainingTime(),
                                                    iconColor: AppColors.yellow),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
