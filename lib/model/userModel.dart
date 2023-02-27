class UserModel {
  String? id;

  String? name;

  String? email;

  String? phone;

  String? photo;

  String? bio;

  UserModel({this.phone, this.email, this.name, this.id});

  UserModel.fromjson(Map<dynamic, dynamic> json) {
    email = json['email'];
    phone = json['phone'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> tomap() {
    return {
      "name": name,
      "id": id,
      "phone": phone,
      "email": email,
    };
  }
}
