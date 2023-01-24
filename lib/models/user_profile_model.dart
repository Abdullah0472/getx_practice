import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  UserProfileModel({
    required this.createdAt,
    required this.firstName,
    required this.imageUrl,
    required this.lastSeen,
    required this.updatedAt,
    required this.metadata,
    required this.id,
    required this.profileImageUrl,
    required this.coverImageUrl,
  });
  late final Timestamp createdAt;
  late final String firstName;
  late final String id;
  late final String imageUrl;
  late final Timestamp lastSeen;
  late final Timestamp updatedAt;
  late final Metadata metadata;
  late final String profileImageUrl;
  late final String coverImageUrl;

  UserProfileModel.fromJson(Map<String, dynamic> json,String docId){
    id=docId;
    createdAt = json['createdAt']??"";
    firstName = json['firstName']??"";
    imageUrl = json['imageUrl']??"";
    lastSeen = json['lastSeen']??"";
    updatedAt = json['updatedAt']??"";
    profileImageUrl = json['profileImageUrl']??"";
    coverImageUrl = json['coverImageUrl']??"";
    metadata = Metadata.fromJson(json['metadata']??{});
  }
  UserProfileModel.fromDocumentSnapshot({required DocumentSnapshot snapshot}){
    Map<String,dynamic> json=snapshot.data() as Map<String,dynamic>;
    id=snapshot.id;
    createdAt = json['createdAt']??"";
    firstName = json['firstName']??"";
    imageUrl = json['imageUrl']??"";
    lastSeen = json['lastSeen']??"";
    updatedAt = json['updatedAt']??"";
    profileImageUrl = json['profileImageUrl']??"";
    coverImageUrl = json['coverImageUrl']??"";
    metadata = Metadata.fromJson(json['metadata']);
  }
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['createdAt'] = createdAt;
    _data['firstName'] = firstName;
    _data['imageUrl'] = imageUrl;
    _data['lastSeen'] = lastSeen;
    _data['updatedAt'] = updatedAt;
    _data['metadata'] = metadata.toJson();
    _data['profileImageUrl'] = profileImageUrl;
    _data['coverImageUrl'] = coverImageUrl;
    _data['id']=id;
    return _data;
  }
}

class Metadata {
  Metadata({
    required this.name,
    required this.email,
    required this.password,
    required this.uid,
    // required this.lat,
    // required this.lng,
    // required this.phoneNo,
  });
  late final String name;
  late final String email;
  late final String password;
  late final String uid;
  // late final String lat;
  // late final String lng;
  // late final String phoneNo;

  Metadata.fromJson(Map<String, dynamic> json){
    name = json['name']??"";
    email = json['email']??"";
    password = json['password']??"";
    uid = json['uid']??"";
    // gender = json['gender']??"";
    // lat = json['lat']??"";
    // lng = json['lng']??"";
    // phoneNo = json['phoneNo']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['email'] = email;
    _data['password'] = password;
    _data['uid'] = uid;
    // _data['gender'] = gender;
    // _data['lat'] = lat;
    // _data['lng'] = lng;
    // _data['phoneNo'] = phoneNo;
    return _data;
  }
}
