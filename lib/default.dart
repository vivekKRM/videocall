class DefaultResponse {
  late int status;
  late String message;
  late String? token;

  DefaultResponse(
      {required this.status,
      required this.message,
      required this.token});

  DefaultResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] ?? '';
    token = json['token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
     data['token'] = this.token ?? '';
    return data;
  }
}