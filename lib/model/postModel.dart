class PostModel {
  String? id;
  String? name;
  String? photo;
  String? postPhoto;
  String? dateTime;
  String? text;


  PostModel({this.photo, this.postPhoto, this.name, this.id , this.dateTime , this.text});

  PostModel.fromjson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    postPhoto = json['postPhoto'];
    dateTime = json['dateTime'];
    text = json['text'];
  }

  Map<String, dynamic> tomap() {
    return {
      "name": name,
      "id": id,
      "dateTime": dateTime,
      "postPhoto": postPhoto,
      "photo": photo,
      "text": text,

    };
  }
}
