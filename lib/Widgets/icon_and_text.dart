import 'package:flutter/material.dart';
import 'package:click_gujrat/utils/Colors.dart';
import 'package:click_gujrat/Widgets/big_text.dart';
class IconAndText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  const IconAndText({Key? key, required this.icon, required this.text, required this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,color: iconColor,),
        BigText(text: text,color: AppColors.textColor,size: 15,),
      ],
    );
  }
}
