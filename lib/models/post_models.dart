// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class PostModel {
//   late final String id;
//   late final String postText;
//   late final String uid;
//   late final String userImage;
//   late final String postImage;
//   late final String dateTime;
//   late final int likesCount;
//   late final int commentsCount;
//   // default constructor
//   PostModel({
//     required this.uid,
//     required this.id,
//     required this.postText,
//     required this.userImage,
//     required this.postImage,
//     required this.dateTime,
//     required this.likesCount,
//     required this.commentsCount,
//
//   });
//
//   // for post creation
//   PostModel.withoutId({
//     required this.uid,
//     required this.postText,
//     required this.userImage,
//     required this.postImage,
//     required this.dateTime,
//
//   });
//   // when we read data from firebase this will be used for converting DocumentSnapshot to model object
//   PostModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}){
//     Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
//     id=documentSnapshot.id;
//     uid=data['uid']??"";
//     postText=data["postText"];
//     postImage=data["postImage"]??"";
//     userImage=data["userImage"];
//     likesCount=data["likesCount"]??0;
//     commentsCount=data["commentsCount"]??0;
//     dateTime=data["dateTime"]??DateTime.now().toString();
//   }
//
//   // this will be used to convert PostModelNew.withoutId to Map<String,dynamic>
//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['uid'] = uid;
//     data['postText'] = postText;
//     data['postImage'] = postImage;
//     data['userImage'] = userImage;
//     data['dateTime'] = dateTime;
//     return data;
//   }
//
// }



class postModel {
  postModel({
    required this.username,
    required this.posttext,
    required this.datetimepost,
    required this.id,
    required this.uid,
    required this.postImageUrl,
    required this.userImageUrl,
    required this.likes,
    required this.likecount,
    required this.commentcount,

  });
  late final String username;
  late final String posttext;
  late final String datetimepost;
  late final String id;
  late final String uid;
  late final String postImageUrl;
  late final String userImageUrl;
  late final List likes;
  late final int likecount;
  late final int commentcount;

  postModel.fromJson(Map<String, dynamic> doc,String docId){
    username = doc['username']??"";
    posttext = doc['posttext']??"";
    datetimepost = doc['datetimepost']??"";
    uid = doc['uid']??"";
    postImageUrl =doc['postImageUrl']??"";
    userImageUrl =doc['userImageUrl']??"";
    id=docId;
    likes = doc["likes"]??[];
    likecount = doc["likeCount"]??0;
    commentcount = doc["commentCount"]??0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['posttext'] = posttext;
    _data['datetimepost'] = datetimepost;
    _data['uid'] = uid;
    _data['id']=id;
    _data['postImageUrl']=postImageUrl;
    _data['userImageUrl']=userImageUrl;

    _data['likes']=likes;
    _data['likeCount']=likecount;
    _data['commentCount']=commentcount;
    return _data;
  }
}




