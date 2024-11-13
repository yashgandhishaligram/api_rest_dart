import 'package:api_rest_dart/src/utils/extensions.dart';

class BaseResponseEntity<T> {
  bool? success;
  String? message;
  T? data;

  BaseResponseEntity({
    required this.success,
    required this.message,
    this.data,
  });

  BaseResponseEntity.fromJson(dynamic json) {
    success = json["Success"];
    message = json["Message"];
    data = json['Data'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Success'] = success;
    map['Message'] = message;
    map['Data'] = data;
    return map.filterNulls();
  }
}
