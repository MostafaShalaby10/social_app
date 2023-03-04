class MessageModel {
  String? senderId;
  String? receiverId;

  String? date;

  String? text;

  MessageModel({
    this.text,
    this.date,
    this.receiverId,
    this.senderId,
  });

  MessageModel.fromjson(Map<dynamic, dynamic> json) {
    text = json['text'];
    date = json['date'];
    receiverId = json['receiverId'];
    senderId = json['senderId'];
  }

  Map<String, dynamic> tomap() {
    return {
      "text": text,
      "date": date,
      "receiverId": receiverId,
      "senderId": senderId,
    };
  }
}
