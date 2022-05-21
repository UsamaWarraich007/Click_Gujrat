import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const ImagePickerBottomSheet({Key? key, required this.onCameraTap, required this.onGalleryTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: <Widget>[
              const Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, left: 8),
                    child: Text('Choose Action', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, top: 8,),
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      onPressed: Get.back,
                      backgroundColor: Get.theme.primaryColor,
                      mini: true,
                      child: const Icon(Icons.close, color: Colors.white),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(
              Icons.camera_alt,
            ),
            title: const Text("Camera"),
            onTap: onCameraTap,
          ),
          ListTile(
            leading: const Icon(
              Icons.image,
            ),
            title: const Text("Gallery"),
            onTap: onGalleryTap,
          ),
        ],
      ),
    );
  }
}
