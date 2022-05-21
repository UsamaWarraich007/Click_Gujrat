import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';

class MyRatingDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final Function(RatingDialogResponse) onConfirm;
  final double initRating;
  const MyRatingDialog({Key? key, required this.initRating, required this.onCancel, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingDialog(
      initialRating: initRating,
      starSize: 30,
      // your app's name?
      title: const Text(
        'Click Gujrat',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: const Text(
        'Tap a star to set your rating. Add more description here if you want.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
      // your app's logo?
      image: const FlutterLogo(size: 100),
      submitButtonText: 'Submit',
      commentHint: 'Write your comments here...',
      onCancelled: onCancel,
      onSubmitted: onConfirm,
    );
  }
}
