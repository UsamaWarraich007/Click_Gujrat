import 'package:flutter/material.dart';

import '../Models/comment_model.dart';

class LikesComments with ChangeNotifier {
  int _avg = 0;
  int _comments = 0;

  int get avg => _avg;

  int get comments => _comments;

  void setAvg(int value) {
    _avg = value;
    notifyListeners();
  }

  void update(List<Comments> _comments) {
    if (_comments.isNotEmpty) {
      setComments(_comments.first.comment.length);
      setAvg(_comments.first.getRatingAverage());
    }
  }

  void updateValues(Comments _comments) {
      setComments(_comments.comment.length);
      setAvg(_comments.getRatingAverage());
  }

  void setComments(int value) {
    _comments = value;
    notifyListeners();
  }
}