import 'package:dio/dio.dart';

class Api {
  static Dio? dio;

  static init() {
    dio = Dio(BaseOptions(
      // baseUrl: "https://fcm.googleapis.com/fcm/send",
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<Response> post({
    dynamic query,
    required String user,
    required  String title,
    required  String body,
  }) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': "key=AAAAMtwY0Pk:APA91bG4aqG4Im1IH0Xo4W-3PJvlLywAxVQZ8J4cy8eSM8dRYJ2VkE-NeIlDnW8oH4qAAt-CS3O9MwvGprNnB_QAgmDjINbE1eARpzyGTIrHNpv39jgyg8q7SbFe9NLjrNZUT79RHhv8",
    };
    return await dio!.post(
      "https://fcm.googleapis.com/fcm/send",
      data: {
        "to": user,
        "notification": {"title": title, "body": body, "sound": "default"},
        "android": {
          "priority": "HIGH",
          "notification": {
            "notification_priority": "PRIORITY_MAX",
            "sound": "default",
            "default_sound": true,
            "default_vibrate_timings": true,
            "default_light_settings": true
          }
        },
        "data": {
          "type": "order",
          "id": "87",
          "click_action": "FLUTTER_NOTIFICATION_CLICK"
        }
      },
      queryParameters: query,
    );
  }
}
