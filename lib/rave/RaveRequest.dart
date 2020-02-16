part of 'RaveApi.dart';

class RaveRequest {
  final Response response;
  RaveRequest(this.response);

  int get statusCode => response.statusCode;
  String get status =>
      RaveModel(items: jsonDecode(response.body)).getString(REQUEST_STATUS);

  String get message =>
      RaveModel(items: jsonDecode(response.body)).getString(REQUEST_MESSAGE);

  String get sStatus =>
      RaveModel(items: jsonDecode(response.body)).getString(REQUEST_S_STATUS);

  String get sMessage =>
      RaveModel(items: jsonDecode(response.body)).getString(REQUEST_S_MESSAGE);

  RaveModel get raveModel =>
      RaveModel(items: jsonDecode(response.body)["data"]);
  RaveModel get altRaveModel => RaveModel(
      items: Map<int, String>.from(jsonDecode(response.body)["data"].asMap()));

  validateRequest(
      {Function(String message, dynamic data) onSuccessful,
      Function(String) onError}) {
    if (statusCode == 200 &&
        ((status.isEmpty ? sStatus : status) == STATUS_SUCCESS ||
            (status.isEmpty ? sStatus : status) == STATUS_SUCCESSFUL)) {
      return onSuccessful(message.isEmpty ? sMessage : message,
          jsonDecode(response.body)["data"]);
    }
    print(response.body);
    return onError(message.isEmpty ? sMessage : message);
  }
}
