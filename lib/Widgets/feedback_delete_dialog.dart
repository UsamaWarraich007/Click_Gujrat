import 'package:click_gujrat/Widgets/big_text.dart';
import 'package:click_gujrat/utils/Colors.dart';
import 'package:click_gujrat/utils/dimentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackDeleteDialog extends StatelessWidget {
  const FeedbackDeleteDialog({
    Key? key,
    required this.onConfirm,
    required this.reason,
    required this.formKey,
  }) : super(key: key);

  final VoidCallback onConfirm;
  final TextEditingController reason;
  final GlobalKey formKey;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: BigText(text: "Delete Feedback"),
      content: Form(
        key: formKey,
        child: SizedBox(
          height: Get.height / 4,
          width: Get.width * 3 / 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              BigText(
                text: "Reason",
                size: 15,
                color: AppColors.buttonColor,
              ),
              SizedBox(
                height: Dimensions.height10,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (val) {},
                minLines: 4,
                maxLines: 6,
                controller: reason,
                validator: (text) {
                  if (GetUtils.isNullOrBlank(text)!) {
                    return "Can't be empty";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: "write reason here.....",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            primary: AppColors.buttonColor,
          ),
          onPressed: Get.back,
          child: const Text("Back"),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          child: const Text("Delete"),
          style: ElevatedButton.styleFrom(
            primary: AppColors.buttonColor,
          ),
        ),
      ],
    );
  }
}
