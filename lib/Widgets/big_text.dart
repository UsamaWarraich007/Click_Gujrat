import 'package:click_gujrat/utils/dimentions.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overflow;

  BigText(
      {Key? key,
      this.color = const Color(0xffFFB72B),
      required this.text,
      this.size = 20,
      this.overflow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      style: GoogleFonts.roboto(
        textStyle: TextStyle(
          color: color,
          fontWeight: FontWeight.w400,
          fontSize: size,
        ),
      ),
    );
  }
}
