import 'package:click_gujrat/Widgets/big_text.dart';
import 'package:click_gujrat/utils/Colors.dart';
import 'package:click_gujrat/utils/dimentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpandableText extends StatefulWidget {
  final String text;

  const ExpandableText({Key? key, required this.text}) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > 50) {
      firstHalf = widget.text.substring(0, 50);
      secondHalf = widget.text.substring(50, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: secondHalf.isEmpty
          ? BigText(text: firstHalf)
          : Column(
              children: [
                if (!hiddenText)
                  ConstrainedBox(
                    constraints: const BoxConstraints(),
                    child: BigText(
                      size: 15,
                      color: Colors.black38,
                      text: firstHalf,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                if (hiddenText)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 50),
                    child: BigText(
                      text: widget.text,
                      size: 15,
                      color: Colors.black38,
                    ),
                  ),
                InkWell(
                  onTap: () {
                    setState(() {
                      hiddenText = !hiddenText;
                    });
                  },
                  child: hiddenText
                      ? Row(
                          children: [
                            BigText(
                              text: "Show More",
                              size: 15,
                              color: AppColors.yellow,
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.yellow,
                            )
                          ],
                        )
                      : Row(
                          children: [
                            BigText(
                              text: "Less More",
                              size: 15,
                              color: AppColors.yellow,
                            ),
                            const Icon(
                              Icons.arrow_drop_up,
                              color: AppColors.yellow,
                            )
                          ],
                        ),
                )
              ],
            ),
    );
  }
}
