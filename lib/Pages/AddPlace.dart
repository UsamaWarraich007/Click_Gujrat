import 'dart:io';
import 'package:badges/badges.dart';
import 'package:click_gujrat/Services/AuthenticationService.dart';
import 'package:click_gujrat/Widgets/toaster.dart';
import 'package:click_gujrat/utils/Colors.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:click_gujrat/Models/place_model.dart';
import 'package:click_gujrat/Services/location_services.dart';
import 'package:click_gujrat/Services/upload_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../Models/user_info_model.dart';
import '../Services/fcm_notification.dart';
import '../Widgets/image_picker_dialog.dart';
import '../Widgets/loading_spinner.dart';
import 'map/add_location.dart';

class AddPlace extends StatefulWidget {
  const AddPlace({Key? key, this.place}) : super(key: key);
  final Place? place;

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final nameController = TextEditingController(),
      descriptionController = TextEditingController(),
      categoryController = TextEditingController(),
      locationController = TextEditingController();
  bool enable = true;
  LatLng? _latLng;
  final nameFocus = FocusNode();
  final imagePicker = ImagePicker();
  List<String> imagesPath = [];
  final storageRef = FirebaseStorage.instance.ref();
  File? _file;
  DateTime? oTime, cTime;
  String? _category;
  bool _isLoading = false, _isUploading = false;
  final _formKey = GlobalKey<FormState>();
  String _imagePath = "", openingTime = '', closingTime = '';
  final List<String> _categories = [
    "Restaurants",
    "Hospitals",
    "Hostels",
    "Universities",
    "Colleges",
    "Schools",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Information'),
        centerTitle: true,
        backgroundColor: AppColors.buttonColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Badge(
                  padding: const EdgeInsets.all(1),
                  badgeColor: Colors.white,
                  elevation: 0,
                  toAnimate: false,
                  shape: BadgeShape.square,
                  borderRadius: BorderRadius.circular(8),
                  position: const BadgePosition(bottom: 0, end: 0),
                  badgeContent: GestureDetector(
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
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 30,
                      color: AppColors.buttonColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (_isLoading)
                        Expanded(
                          child: Container(
                            height: 200,
                            width: Get.width,
                            color: AppColors.white,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.buttonColor,
                                strokeWidth: 6.0,
                              ),
                            ),
                          ),
                        ),
                      if (_file == null && !_isLoading)
                        Expanded(
                          child: Container(
                            height: 200,
                            color: AppColors.buttonColor.withOpacity(0.2),
                            child: const Icon(Icons.image),
                          ),
                        ),
                      if (_file != null && !_isLoading)
                        Expanded(
                            child: Container(
                          width: Get.width,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(_file!.path),
                            ),
                          ),
                        )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Add Place Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: nameController,
                  focusNode: nameFocus,
                  maxLength: 30,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (text) {
                    if (GetUtils.isNullOrBlank(text)!) {
                      return "Name can't be empty";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Add Category',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Select Category"),
                  validator: (category) {
                    if (GetUtils.isNullOrBlank(category)!) {
                      return "Category can't be empty";
                    }
                    return null;
                  },
                  value: _category,
                  items: _categories.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: widget.place != null
                      ? null
                      : (_) {
                          setState(() {
                            _category = _;
                          });
                        },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: const [
                    Text(
                      'Timing',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (openingTime.isEmpty)
                      TextButton(
                          onPressed: () {
                            DatePicker.showTime12hPicker(context,
                                showTitleActions: true, onChanged: (date) {
                              print('change $date in time zone ' +
                                  date.timeZoneOffset.inHours.toString());
                            },
                                onConfirm: addOpeningTime,
                                currentTime: DateTime.now());
                          },
                          child: const Text(
                            'Opening Time',
                            style: TextStyle(color: AppColors.buttonColor),
                          )),
                    if (openingTime.isNotEmpty)
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(openingTime),
                            GestureDetector(
                              onTap: removeOpenTime,
                              child: const Icon(
                                Icons.cancel,
                                color: AppColors.buttonColor,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (closingTime.isEmpty)
                      TextButton(
                        onPressed: () {
                          DatePicker.showTime12hPicker(context,
                              showTitleActions: true, onChanged: (date) {
                            print('change $date in time zone ' +
                                date.timeZoneOffset.inHours.toString());
                          },
                              onConfirm: addClosingTime,
                              currentTime: DateTime.now());
                        },
                        child: const Text(
                          'Closing Time',
                          style: TextStyle(color: AppColors.buttonColor),
                        ),
                      ),
                    if (closingTime.isNotEmpty)
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(closingTime),
                            GestureDetector(
                              onTap: removeCloseTime,
                              child: const Icon(
                                Icons.cancel,
                                size: 16,
                                color: AppColors.buttonColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Add Location',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    var result = await Navigator.push<LatLng?>(context, MaterialPageRoute<LatLng?>(
                            builder: (_) => const AddLocation()));
                    if (result != null) {
                      List<Placemark> placeMarks =
                          await placemarkFromCoordinates(
                              result.latitude, result.longitude);
                      Placemark placeMark = placeMarks.first;
                      locationController.text =
                          "${placeMark.name!}, ${placeMark.street!}, ${placeMark.subLocality!}, ${placeMark.locality!}";
                      _latLng = result;
                    }
                  },
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (location) {
                      if (GetUtils.isNullOrBlank(location)!) {
                        return "Location can't be empty";
                      }
                      return null;
                    },
                    enabled: false,
                    controller: locationController,
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.add_location_alt_outlined),
                        border: OutlineInputBorder(),
                        hintText: ''),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Add Images',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                if (imagesPath.isNotEmpty || _isUploading)
                  SizedBox(
                    height: 155,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _isUploading ? imagesPath.length + 1 : imagesPath.length,
                      itemBuilder: (context, index) {
                        if (_isUploading && index == imagesPath.length+1) {
                          return Container(
                            margin: const EdgeInsets.only(right: 10, top: 20),
                            width: 120,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const CircularProgressIndicator(color: AppColors.buttonColor, strokeWidth: 6.0),
                          );
                        }
                        String _image = imagesPath[index];
                        return Badge(
                          padding: const EdgeInsets.all(1),
                          badgeColor: Colors.white,
                          elevation: 0,
                          toAnimate: false,
                          // shape: BadgeShape.square,
                          borderRadius: BorderRadius.circular(8),
                          position: const BadgePosition(top: 15, end: 10),
                          badgeContent: GestureDetector(
                            onTap: () => setState(() => imagesPath.remove(_image)),
                            child: const Icon(
                              Icons.cancel,
                              size: 30,
                              color: AppColors.buttonColor,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10, top: 20),
                            width: 120,
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(_image),
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.buttonColor,
                        ),
                        onPressed: () async {
                          List<XFile>? images = await imagePicker.pickMultiImage();
                          // print(images?.length);
                          // print(imagesPath.length);
                          // if (images != null) {
                          //  if(images.length>2||imagesPath.length>2){
                          //     Get.defaultDialog(
                          //         title: "Pic limitation",
                          //         middleText: "Plz select images less then or equal to Ten ",
                          //         //titleStyle: TextStyle(color: Colors.white),
                          //         //middleTextStyle: TextStyle(color: Colors.white),
                          //         textConfirm: "Ok",
                          //         onConfirm: Get.back,
                          //       //  textCancel: "Cancel",
                          //         //cancelTextColor: Colors.white,
                          //         //confirmTextColor: Colors.white,
                          //         //buttonColor: Colors.red,
                          //         //barrierDismissible: false,
                          //       //  radius: 50,
                          //     );
                          //   }
                          //   else {
                              addFiles(images);
                             //}

                            // images.clear();
                          //}
                        },
                        child: const Text(
                          'Add files',
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (description) {
                    if (GetUtils.isNullOrBlank(description)!) {
                      return "Description can't be empty";
                    }
                    return null;
                  },
                  maxLines: 10,
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Enter all the information about your place here',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.buttonColor,
                          ),
                          onPressed: onSubmit,
                          child: const Text('submit'))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();

    if (_imagePath.isEmpty) {
      Toaster.showToast("Select main image");
      return;
    }

    if (openingTime.isEmpty) {
      Toaster.showToast("Select opening time");
      return;
    }

    if (closingTime.isEmpty) {
      Toaster.showToast("Select closing time");
      return;
    }

    if (widget.place != null) {
      Place place = Place(
        description: descriptionController.text,
        title: nameController.text,
        latLng: _latLng!,
        uid: widget.place!.uid,
        commentsCount: widget.place!.commentsCount,
        likes: widget.place!.likes,
        address: locationController.text,
        category: widget.place!.category,
        close: closingTime,
        date: DateFormat().format(DateTime.now()),
        homeImage: _imagePath,
        //userlist: widget.place?.userlist ?? [],
        images: imagesPath,
        isApproved: widget.place!.isApproved,
        openTime: openingTime,
        token: widget.place!.token,
      );
      await context
          .read<LocationServices>()
          .updatePlace(place, widget.place!.id!);
    } else {
      Place place = Place(
        description: descriptionController.text,
        title: nameController.text,
        latLng: _latLng!,
        address: locationController.text,
        uid: AuthService().getUser()!.uid,
        category: _category!,
        close: closingTime,
        likes: 0,
        //userlist: [],
        commentsCount: 0,
        date: DateFormat().format(DateTime.now()),
        homeImage: _imagePath,
        images: imagesPath,
        isApproved: false,
        openTime: openingTime,
        token: "",
      );
      await context.read<LocationServices>().addPlace(place);
      var _userInfo = await AuthService().getAData(3);
        for (UserInfo user in _userInfo) {
          await FCMNotificationService().sendNotificationToUser(
              fcmToken: user.token,
              title: "Click Gujrat",
              body: "New place added, please check and approve it");
        }
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    if (widget.place != null) {
      updateUi();
    }
    super.initState();
  }

  void updateUi() {
    nameController.text = widget.place!.title;
    descriptionController.text = widget.place!.description;
    _category = widget.place!.category;
    locationController.text = widget.place!.address;
    _imagePath = widget.place!.homeImage;
    openingTime = widget.place!.openTime;
    closingTime = widget.place!.close;
    imagesPath = widget.place!.images!;
    _latLng = widget.place!.latLng;
    _file = File(widget.place!.homeImage);
    enable = false;
    setState(() {});
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage!)),
    );
  }

  void uploadImage(String path) {
    _file = File(path);
    if (!mounted) return;
    setState(() => _isLoading = true);
    uploadFile(_file!, true);
  }

  void addOpeningTime(DateTime date) {
    setState(() {
      oTime = date;
      openingTime = DateFormat.jm().format(date);
    });
  }

  void addClosingTime(DateTime date) {
    setState(() {
      cTime = date;
      closingTime = DateFormat.jm().format(date);
    });
  }

  void removeOpenTime() {
    setState(() {
      oTime = null;
      openingTime = '';
    });
  }

  void removeCloseTime() {
    setState(() {
      cTime = null;
      closingTime = '';
    });
  }

  Future<void> uploadFile(File file, bool isHomeImage) async {
    String path = await UploadFile().uploadFile(file, isHomeImage);
    if (path.isEmpty) return;
    if (!mounted) return;
    if (isHomeImage) {
      setState(() {
        _imagePath = path;
        _file = File(path);
        _isLoading = false;
      });
    } else {
      setState(() => imagesPath.add(path));
    }
  }

  void addFiles(List<XFile>? xFiles) {
    if (!mounted) return;
    setState(() => _isUploading = true);
    for (XFile xFile in xFiles!) {
      File file = File(xFile.path);
      uploadFile(file, false);
    }
    if (!mounted) return;
    setState(() => _isUploading = false);
  }
}
