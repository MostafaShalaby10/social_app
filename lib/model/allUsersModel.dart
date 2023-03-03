class AllUsersModel {
  String? name;
  String? profileImage;

  AllUsersModel({this.name, this.profileImage});

  AllUsersModel.fromjson(Map<dynamic, dynamic> json) {

    name = json['name'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> tomap() {
    return {
      "name": name,
      "profileImage": profileImage,

    };
  }
}
