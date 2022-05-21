import 'package:click_gujrat/Services/comments_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/comment_model.dart';
import '../utils/Colors.dart';
import 'big_text.dart';

class LikeCommentWidget extends StatelessWidget {
  const LikeCommentWidget({
    Key? key,
    required this.postId,
    required this.isComment,
  }) : super(key: key);
  final String postId;
  final bool isComment;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Comments>?>.value(
      value: CommentsServices().fetchCommentsAsStream(postId),
      initialData: const [],
      builder: (context, child) => Consumer<List<Comments>?>(
        builder: (context, value, child) {
          if (value != null && !isComment) {
            return Row(
              children: [

              ],
            );
          } else if (value == null && !isComment) {
            return Row(
              children: [
                BigText(
                  text: "0",
                  size: 15,
                  color: AppColors.textColor,
                ),
                const SizedBox(
                  width: 6,
                ),
                BigText(
                  text: "0",
                  size: 15,
                  color: AppColors.textColor,
                ),
              ],
            );
          }
          else {
            return BigText(
              text: "0",
              color: Colors.black38,
            );
          }
        },
      ),
    );
  }
}
