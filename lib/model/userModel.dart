class UserModel {
  String? id;

  String? name;

  String? email;

  String? phone;
  dynamic token;

  String? coverImage;
  String? profileImage;

  String? bio;
  UserModel({this.phone, this.email, this.name, this.id , this.coverImage, this.profileImage, this.bio  , this.token});

  UserModel.fromjson(Map<dynamic, dynamic> json) {
    email = json['email'];
    phone = json['phone'];
    id = json['id'];
    name = json['name'];
    coverImage = json['coverImage'];
    profileImage = json['profileImage'];
    bio = json['bio'];
    token = json['token'];
  }

  Map<String, dynamic> tomap() {
    return {
      "name": name,
      "id": id,
      "phone": phone,
      "email": email,
      "coverImage": coverImage,
      "profileImage": profileImage,
      "bio": bio,
      "token": token,
    };
  }
}
