import 'package:cloud_firestore/cloud_firestore.dart';

class Comments {
  final List<Message> comment;
  final String postId;
  final List<Rating> ratings;
  String? id;

  Comments({
    required this.ratings,
    required this.comment,
    required this.postId,
  }) : id = "";

  Comments.fromFirestore(
    DocumentSnapshot<Object?> snapshot,
    SnapshotOptions? options,
  )   : comment = List<Message>.from(snapshot["comment"].map((x) => Message.fromMap(x))),
        ratings = List<Rating>.from(snapshot["ratings"].map((x) => Rating.fromMap(x))),
        postId = snapshot["postId"];

  Map<String, dynamic> toFirestore() => {
    "comment": List<dynamic>.from(comment.map((x) => x.toFirestore())),
    "postId": postId,
    "ratings": List<dynamic>.from(ratings.map((e) => e.toFirestore())),
  };

  int getRatingAverage() {
    double result = ratings.map((m) => m.rating).reduce((a, b) => a + b) / ratings.length;
    return result.round();
  }
}

class Message {
  final String message;
  String? image;
  final String name;
  final String uid;
  final bool liked;
  List<String> likedUid;
  double likes;

  Message({
    required this.message,
    required this.name,
    required this.uid,
    this.image,
    required this.liked,
    required this.likedUid,
    required this.likes,
  });

  factory Message.fromMap(Map<String, dynamic> map) => Message(
      message: map["message"],
      name: map["name"],
      uid: map["uid"],
      liked: map["liked"],
      likes: map["likes"],
    image: map["image"],
    likedUid: List<String>.from(map['likedUid']),
  );

  Map<String, dynamic> toFirestore() => {
    "message" : message,
    "name" : name,
    "uid" : uid,
    "liked" : liked,
    "likes" : likes,
    "image" : image,
    "likedUid" : List<dynamic>.from(likedUid),
  };

  /*int getRateCount() {
    int count = 0;
    for (Rating rating in ratings) {
      count++;
    }
    return count;
  }*/


}

class Rating {
  final String uid;
  final double rating;

  Rating({
    required this.uid,
    required this.rating,
  });

  factory Rating.fromMap(Map<String, dynamic> map) => Rating(
    uid: map["uid"],
    rating: map["rating"],
  );

  Map<String, dynamic> toFirestore() => {
    "uid": uid,
    "rating": rating,
  };
}
