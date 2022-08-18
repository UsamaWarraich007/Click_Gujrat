import 'package:badges/badges.dart';
import 'package:click_gujrat/Models/User.dart';
import 'package:click_gujrat/Models/comment_model.dart';
import 'package:click_gujrat/Services/AuthenticationService.dart';
import 'package:click_gujrat/Services/location_services.dart';
import 'package:click_gujrat/Widgets/big_text.dart';
import 'package:click_gujrat/Widgets/feedback_delete_dialog.dart';
import 'package:click_gujrat/Widgets/icon_and_text.dart';
import 'package:click_gujrat/Widgets/location_dialog.dart';
import 'package:click_gujrat/Widgets/rating_dialog.dart';
import 'package:click_gujrat/utils/Colors.dart';
import 'package:click_gujrat/utils/dimentions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:readmore/readmore.dart';
import '../../Models/place_model.dart';
import '../../Services/comments_service.dart';
import '../../Services/fcm_notification.dart';


class PlaceDetail extends StatefulWidget {
  final String id;

  const PlaceDetail({Key? key, required this.id}) : super(key: key);
  @override
  _PlaceDetailState createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail> {
  final User _user = AuthService().getUser()!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Place>(
        stream: LocationServices().streamPlaceById(widget.id),
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Place place = snapshot.data!;
            return Stack(
              children: [
                Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.maxFinite,
                      height: Dimensions.placeDetailImgSize,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(place.homeImage))),
                    )),
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
                          color: AppColors.white.withOpacity(0.5),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: AppColors.textColor,
                        ),
                      ),
                    )),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: Dimensions.placeDetailImgSize - 20,
                  child: Container(
                    padding: EdgeInsets.only(
                        top: Dimensions.height20,
                        left: Dimensions.width20,
                        right: Dimensions.width20),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                        color: Colors.white),
                    child: ListView(
                      children: [
                        Column(
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () => Get.dialog(
                                      LocationDialog(latLng: place.latLng!)),
                                  child: FutureBuilder<String>(
                                    future: place.getDistance(),
                                    builder: (context, snapshot) => IconAndText(
                                        icon: Icons.location_on,
                                        text: "${snapshot.data}km",
                                        iconColor: AppColors.green),
                                  ),
                                ),
                                IconAndText(
                                    icon: Icons.access_time_sharp,
                                    text: place.remainingTime(),
                                    iconColor: AppColors.yellow),
                              ],
                            ),
                            SizedBox(
                              height: Dimensions.height10,
                            ),
                            BigText(
                              text: "Information",
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: Dimensions.height15,
                            ),
                            ReadMoreText(
                              place.description,
                              trimLines: 1,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black38,
                              ),
                              colorClickableText: AppColors.yellow,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              moreStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.yellow,
                              ),
                            ),
                            SizedBox(
                              height: 155,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: place.images!.length,
                                itemBuilder: (context, index) {
                                  List<String> images = [];
                                  for (dynamic image in place.images!) {
                                    images.add(image);
                                  }
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        right: 10, top: 20),
                                    width: 120,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(images[index]),
                                        )),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.height20,
                            ),
                            Row(
                              children: [
                                BigText(
                                  text: "Comments",
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: Dimensions.width10,
                                ),
                                BigText(
                                  text: place.commentsCount.toString(),
                                  color: Colors.black38,
                                ),
                                SizedBox(
                                  width: Dimensions.width10,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.dialog(
                                      MyRatingDialog(
                                        initRating: 1.0,
                                        onCancel: () {},
                                        onConfirm: (response) async {
                                          await createComment(
                                              response, widget.id);
                                        },
                                      ),
                                    );
                                  },
                                  child: BigText(
                                    text: "Feedback",
                                    size: 17,
                                    color: AppColors.orange,
                                  ),
                                ),
                              ],
                            ),
                            StreamProvider<List<Comments>?>.value(
                              value: CommentsServices()
                                  .fetchCommentsAsStream(widget.id),
                              initialData: const [],
                              builder: (context, child) =>
                                  Consumer<List<Comments>?>(
                                builder: (context, value, child) {
                                  if (value == null || value.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return ListView.builder(
                                    itemCount: value.first.comment.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, subIndex) {
                                      Message message = value.first.comment[subIndex];
                                      if (Roles.roles == 3) {
                                        return Badge(
                                          padding: const EdgeInsets.all(1),
                                          badgeColor: Colors.white,
                                          elevation: 0,
                                          toAnimate: false,
                                          borderRadius: BorderRadius.circular(8),
                                          position: const BadgePosition(top: 0, end: 0),
                                          badgeContent: GestureDetector(
                                            onTap: () {
                                              final reason = TextEditingController();
                                              final _formKey = GlobalKey<FormState>();
                                              Get.dialog(FeedbackDeleteDialog(reason: reason, formKey: _formKey, onConfirm: () async {
                                                if(!_formKey.currentState!.validate()) return;
                                                _formKey.currentState!.save();
                                                FocusScope.of(context).unfocus();
                                                var _userInfo = await AuthService().getUserInfo(uid: message.uid);
                                                Get.back();
                                                await FCMNotificationService().sendNotificationToUser(
                                                    fcmToken: _userInfo.token,
                                                    title: "Click Gujrat",
                                                    body: "Dear ${_userInfo.name}, \nYour feedback is deleted and reason is ${reason.text}");

                                                value.first.comment.remove(message);
                                                updatedComment(value.first);
                                              },));
                                            },
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 20,
                                              color: AppColors.buttonColor,
                                            ),
                                          ),
                                          child: ListTile(
                                            dense: true,
                                            leading: Container(
                                              height: 50.0,
                                              width: 50.0,
                                              decoration: const BoxDecoration(
                                                  color: AppColors.orange,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(50))),
                                              child: message.image != null
                                                  ? CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage: NetworkImage(
                                                      message.image!))
                                                  : const CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage: AssetImage(
                                                      "assets/user.png")),
                                            ),
                                            title: Text(message.name),
                                            subtitle: Text(message.message),
                                            trailing: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (Roles.roles != 3)
                                                if (message.likedUid
                                                    .contains(_user.uid))
                                                  GestureDetector(
                                                    onTap: () async {
                                                      var _userInfo = await AuthService().getUserInfo(uid: _user.uid);
                                                      await FCMNotificationService().sendNotificationToUser(
                                                          fcmToken: _userInfo.token,
                                                          title: "Click Gujrat",
                                                          body: "${_userInfo.name} was unliked your feedback");
                                                      message.likedUid
                                                          .remove(_user.uid);
                                                      updatedComment(value.first);
                                                    },
                                                    child: const Icon(
                                                      Icons.favorite,
                                                      color: Colors.pinkAccent,
                                                    ),
                                                  )
                                                else
                                                  GestureDetector(
                                                    onTap: () async {
                                                      var _userInfo = await AuthService().getUserInfo(uid: _user.uid);
                                                      await FCMNotificationService().sendNotificationToUser(
                                                          fcmToken: _userInfo.token,
                                                          title: "Click Gujrat",
                                                          body: "${_userInfo.name} was liked your feedback.");
                                                      message.likedUid
                                                          .add(_user.uid);
                                                      updatedComment(value.first);
                                                    },
                                                    child: const Icon(
                                                      Icons.favorite_border,
                                                      color: Colors.amberAccent,
                                                    ),
                                                  ),

                                                if (message.likedUid.isNotEmpty)
                                                  Text(message.likedUid.length
                                                      .toString()),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      return ListTile(
                                        dense: true,
                                        leading: Container(
                                          height: 50.0,
                                          width: 50.0,
                                          decoration: const BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          child: message.image != null
                                              ? CircleAvatar(
                                              radius: 50,
                                              backgroundImage: NetworkImage(
                                                  message.image!))
                                              : const CircleAvatar(
                                              radius: 50,
                                              backgroundImage: AssetImage(
                                                  "assets/user.png")),
                                        ),
                                        title: Text(message.name),
                                        subtitle: Text(message.message),
                                        trailing: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // if (message.uid == _user.uid)
                                            if (message.likedUid
                                                .contains(_user.uid))
                                              GestureDetector(
                                                onTap: () {
                                                  message.likedUid
                                                      .remove(_user.uid);
                                                  updatedComment(value.first);
                                                },
                                                child: const Icon(
                                                  Icons.favorite,
                                                  color: Colors.pinkAccent,
                                                ),
                                              )
                                            else
                                              GestureDetector(
                                                onTap: () {
                                                  message.likedUid
                                                      .add(_user.uid);
                                                  updatedComment(value.first);
                                                },
                                                child: const Icon(
                                                  Icons.favorite_border,
                                                  color: Colors.amberAccent,
                                                ),
                                              ),

                                            if (message.likedUid.isNotEmpty)
                                              Text(message.likedUid.length
                                                  .toString()),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: Text(snapshot.error.toString()),
          );
        },
      ),
    );
  }

  void updatedComment(Comments comment) {
    CommentsServices().updateComment(comment, comment.id!);
  }

  Future<void> createComment(
      RatingDialogResponse response, String postId) async {
    var userInfo = await AuthService().getUserInfo();
    List<Comments> comments = await CommentsServices().fetchComments(postId);
    Message message = Message(
        message: response.comment,
        name: userInfo.name,
        image: userInfo.image,
        uid: _user.uid,
        likedUid: [],
        liked: true,
        likes: response.rating);
    Rating rating = Rating(rating: response.rating, uid: _user.uid);
    if (comments.isEmpty) {
      Comments comment = Comments(
        postId: postId,
        comment: [
          message,
        ],
        ratings: [
          rating,
        ],
      );
      CommentsServices().addComments(comment);
    } else {
      comments.first.comment.add(message);
      comments.first.ratings.add(rating);
      CommentsServices().addComments(comments.first);
    }
  }
}
