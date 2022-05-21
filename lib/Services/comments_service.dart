import 'package:click_gujrat/Models/comment_model.dart';
import 'package:click_gujrat/Services/likes_comments.dart';
import 'package:click_gujrat/Services/location_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../Models/place_model.dart';
import 'api_services.dart';

class CommentsServices extends ChangeNotifier {
  final Api _api = Api(path: "comments");

  Stream<List<Comments>?> fetchCommentsAsStream(String postId) {
    return _api.streamCommentsDataCollection(postId).map((data) => commentListFromSnapshot(data));
  }

  List<Comments>? commentListFromSnapshot(QuerySnapshot snapshot) {
    var doc = snapshot.docs;
    return doc.map((doc2) {
      Comments comments = Comments.fromFirestore(doc2, SnapshotOptions());
      comments.id = doc2.id;
      LikesComments().updateValues(comments);
      return comments;
    }).toList();
  }

  Future<List<Comments>> fetchComments(String postId) async {
    var result = await _api.getDataCollectionWithId(postId);
    List<Comments> comments = result.docs
        .map((doc) => Comments.fromFirestore(doc, SnapshotOptions()))
        .toList();
    notifyListeners();
    return comments;
  }

  Future removePlace(String id) async {
    await _api.removeDocument(id);
    notifyListeners();
    return;
  }

  Future updateComment(Comments data, String id) async {
    await _api.updateDocument(data.toFirestore(), id);
    Place place = await LocationServices().getPlaceById(data.postId);
    place.commentsCount = data.comment.length;
    place.likes = data.getRatingAverage();
    await LocationServices().updatePlace(place, place.id!);
    notifyListeners();
    return;
  }

  Future addComments(Comments data) async {
    print("Starting");
    var result = await _api.addDocument(data.toFirestore());
    Place place = await LocationServices().getPlaceById(data.postId);
    place.commentsCount = data.comment.length;
    place.likes = data.getRatingAverage();
    await LocationServices().updatePlace(place, place.id!);
    print("end");
    notifyListeners();
    return result;
  }
}