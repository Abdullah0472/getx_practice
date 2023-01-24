class commentModel {
  commentModel({
    required this.username,
    required this.commenttext,
    required this.datetimecomment,
    required this.id,
    required this.uid,
    required this.datetimepostid,
    required this.commentImageUrl,
    required this.userImageUrl,

  });
  late final String username;
  late final String commenttext;
  late final String datetimecomment;
  late final String id;
  late final String uid;
  late final String postid;
  late final String datetimepostid;
  late final String commentImageUrl;
  late final String userImageUrl;
  commentModel.fromJson(Map<String, dynamic> doc,String docId){
    username = doc['username']??"";
    commenttext = doc['commenttext']??"";
    datetimecomment = doc['datetimecomment']??"";
    uid = doc['uid']??"";
    postid =doc['postid']??"";
    datetimepostid =doc['datetimepostid']??"";
    commentImageUrl =doc['commentImageUrl']??"";
    userImageUrl =doc['userImageUrl']??"";
    id=docId;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['commenttext'] = commenttext;
    _data['datetimecomment'] = datetimecomment;
    _data['uid'] = uid;
    _data['id']=id;
    _data['postid']=postid;
    _data['datetimepostid']=datetimepostid;
    _data['commentImageurl']=commentImageUrl;
    _data['userImageUrl']=userImageUrl;

    return _data;
  }
}
