

class AuthUserModel {
  String uid;

  AuthUserModel({required this.uid});

}

class ClientDetails{
  String? clientId;
  String? clientUsername;
  String? clientAvatar;
  String? clientFullname;
  String? clientLocation;

  ClientDetails({
        this.clientId,
        this.clientUsername,
        this.clientAvatar,
        this.clientFullname,
        this.clientLocation

       });

  ClientDetails.fromJson(Map<String, dynamic> json){

              clientId = json['uid'];
              clientUsername = json['username'];
              clientLocation = json['Location'];
              clientAvatar = json['profilePic'];
              clientFullname = json['name'];
  }

}

enum MediaType {
  image,
  video,
}

class UserMedia {
  final String url;
  final MediaType type;

  UserMedia({
    required this.url,
    required this.type,
  });
}


