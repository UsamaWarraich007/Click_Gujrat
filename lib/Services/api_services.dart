import 'package:cloud_firestore/cloud_firestore.dart';

class Api {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;
  late CollectionReference ref;

  Api({required this.path}) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.get() ;
  }

  Future<QuerySnapshot> getDataCollectionWithId(String postId) {
    return ref.where("postId", isEqualTo: postId).get() ;
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Stream<QuerySnapshot> streamDataCollectionByUID(String uid) {
    return ref.where("uid", isEqualTo: uid).snapshots();
  }

  Stream<QuerySnapshot<Object?>> streamApprovedDataCollection() {
    return ref.where("isApproved", isEqualTo: true).snapshots();
  }

  Stream<QuerySnapshot<Object?>> streamApprovedDataCollectionByUID(String uid) {
    return ref.where("isApproved", isEqualTo: true).where("uid", isEqualTo: uid).snapshots();
  }

  Stream<QuerySnapshot<Object?>> streamApprovedCategoryDataCollection(String category) {
    return ref.where("isApproved", isEqualTo: true).where("category", isEqualTo: category).snapshots();
  }

  Stream<QuerySnapshot<Object?>> streamSearchByTitle(String title) {
    return ref.where("isApproved", isEqualTo: true).where("title", isGreaterThanOrEqualTo: title, isLessThan: title + "z").snapshots();
  }

  Stream<QuerySnapshot<Object?>> streamSearchByCategory(String category) {
    return ref.where("isApproved", isEqualTo: true).where("category", isGreaterThanOrEqualTo: category, isLessThan: category + "z").snapshots();
  }

  Stream<QuerySnapshot<Object?>> streamSearchByCategoryByUID(String category, String uid) {
    return ref.where("uid", isEqualTo: uid).where("category", isGreaterThanOrEqualTo: category, isLessThan: category + "z").snapshots();
  }

  Stream<QuerySnapshot<Object?>> streamSearchBoth(String category, String title) {
    return ref.where("isApproved", isEqualTo: true).where("category", isGreaterThanOrEqualTo: category, isLessThan: category + "z").where("title", isGreaterThanOrEqualTo: title, isLessThan: title + "z").snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }

  Stream<DocumentSnapshot<Object?>> streamDocumentById(String id) {
    return ref.doc(id).snapshots();
  }

  Future<void> removeDocument(String id){
    return ref.doc(id).delete();
  }
  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }

  Future<void> updateDocument(Map data , String id) {
    return ref.doc(id).set(data);
  }

  Stream<QuerySnapshot> streamCommentsDataCollection(String postId) {
    return ref.where("postId", isEqualTo: postId).snapshots() ;
  }

  Future<QuerySnapshot<Object?>> adminDataCollection(int role) async {
    return await ref.where("role", isEqualTo: role).get().then((value) => value);
  }
}