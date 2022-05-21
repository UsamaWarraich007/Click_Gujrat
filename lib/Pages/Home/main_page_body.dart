import 'package:click_gujrat/Services/location_services.dart';
import 'package:click_gujrat/Widgets/search_dialog.dart';
import 'package:click_gujrat/utils/dimentions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:click_gujrat/utils/Colors.dart';
import 'package:click_gujrat/Widgets/big_text.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:click_gujrat/Widgets/icon_and_text.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../Models/place_model.dart';

class MainPageBody extends StatefulWidget {
  const MainPageBody({Key? key}) : super(key: key);

  @override
  _MainPageBodyState createState() => _MainPageBodyState();
}

class _MainPageBodyState extends State<MainPageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  final RxList<Place> _places = RxList<Place>();
  var _crruPagevalue = 0.0;
  double _scaleFactor = 0.8;
  var _height = Dimensions.pageViewContainer;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _crruPagevalue = pageController.page!;
        //print(_crruPagevalue.toString());
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("Dispose");
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _context = context.watch<LocationServices>().fetchApprovedPlacesAsStream();
    return SingleChildScrollView(
      child: Column(
        children: [
          //Text and searchbar
          Container(
            margin: const EdgeInsets.only(top: 45, bottom: 15),
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    BigText(
                      text: "Click Gujrat",
                      size: 30,
                    ),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () {
                      Get.dialog(SearchDialog(places: _places.value));
                    },
                    child: const Icon(
                      Icons.search,
                      color: AppColors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.yellow,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          //slider section
          SizedBox(
            height: Dimensions.pageView,
            child: Consumer<List<Place>?>(
              builder: (context, value, child) {
                List<String> categories = [];
                for (Place place in value!) {
                  categories.add(place.category);
                }
                List<String> categoryList = categories.toSet().toList();
                return PageView.builder(
                  controller: pageController,
                  itemCount: categoryList.length,
                  itemBuilder: (context, position) {
                    String category = categoryList[position];
                    return StreamProvider<List<Place>?>.value(
                      value: LocationServices().searchPlacesAsStream(category: category),
                      initialData: const [],
                      builder: (context, child) =>
                          Consumer<List<Place>?>(
                            builder: (context, value, child) {
                              List<Place> places = [];
                              if (value != null && value.isNotEmpty) {
                                if (value.length > 1) {
                                  for (Place place in value) {
                                    places.add(place);
                                  }
                                  places.sort((a, b) => a.likes.compareTo(b.likes));
                                  Place place = places.last;
                                  return _buildPageItem(place);
                                } else {
                                  return _buildPageItem(value.first);
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                    );
                  },
                );
              },
            ),
          ),
          //Dots
          DotsIndicator(
            dotsCount: 5,
            position: _crruPagevalue,
            decorator: DotsDecorator(
              activeColor: AppColors.yellow,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
          //popular text
          SizedBox(
            height: Dimensions.height30,
          ),
          Container(
            margin: EdgeInsets.only(left: Dimensions.width30),
            child: Row(
              children: [BigText(text: "Popular")],
            ),
          ),
          //List Of places
          Consumer<List<Place>?>(
              builder: (context, value, child) => ListView.builder(
                  itemCount: value!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    _places.assignAll(value);
                    Place place = value[index];
                    return Container(
                      margin: EdgeInsets.only(
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        bottom: Dimensions.height10,
                      ),
                      child: Row(
                        children: [
                          //image section
                          Container(
                            height: Dimensions.listViewImgSize,
                            width: Dimensions.listViewImgSize,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radius20),
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
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BigText(text: place.title),
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
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        // const IconAndText(
                                        //     icon: Icons.circle_sharp,
                                        //     text: "Normal",
                                        //     iconColor: AppColors.orange),
                                        FutureBuilder<String>(
                                            future: place.getDistance(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.data != null) {
                                                return IconAndText(
                                                    icon: Icons.location_on,
                                                    text:
                                                    "${snapshot.data}Km",
                                                    iconColor:
                                                    AppColors.green);
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
                            ),
                          )
                        ],
                      ),
                    );
                  })),
        ],
      ),
    );
  }

  Widget _buildPageItem(Place place) {
    // Matrix4 matrix=new Matrix4.identity();
    // if(index==_crruPagevalue.floor()){
    //   var currScale=1-(_crruPagevalue-index)*(1-_scaleFactor);
    //   var currTrans=_height*(1-currScale)/2;
    //   matrix=Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    // }
    // else if(index==_crruPagevalue.floor()+1){
    //   var currScale=_scaleFactor-(_crruPagevalue-index+1)*(1-_scaleFactor);
    //   var currTrans=_height*(1-currScale)/2;
    //   matrix=Matrix4.diagonal3Values(1, currScale, 1);
    //   matrix=Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    // }
    // else if(index==_crruPagevalue.floor()-1){
    //   var currScale=1-(_crruPagevalue-index)*(1-_scaleFactor);
    //   var currTrans=_height*(1-currScale)/2;
    //   matrix=Matrix4.diagonal3Values(1, currScale, 1);
    //   matrix=Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    // }
    // else{
    //   var currScale=0.8;
    //   matrix=Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, _height*(1-_scaleFactor)/2, 1);
    // }

    return Stack(
      children: [
        Container(
          height: Dimensions.pageViewContainer,
          margin: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              color: AppColors.orange,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(place.homeImage),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: Dimensions.pageViewTextContainer,
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFe8e8e8),
                    blurRadius: 5.0,
                    offset: Offset(0, 7),
                  )
                ]),
            child: Container(
              padding: EdgeInsets.only(
                  left: 15, right: 15, top: Dimensions.height15),
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
                        text: "${place.likes}.0",
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder<String>(
                        future: place.getDistance(),
                        builder: (context, snapshot) {
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
                        },
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
    );
  }
}
