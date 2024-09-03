class LoginResponse {
  late int status;
  late String message;
  late String token;
  late Result? data;

  LoginResponse(
      {required this.status,
      required this.message,
       required this.token,
      required this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] ?? '';
     token = json['token'] ?? '';
    data = json['user'] != null ? new Result.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
     data['token'] = this.token;
    if (this.data != null) {
      data['user'] = this.data?.toJson();
    }
    return data;
  }
}

class Result {
  late int id;
  late String name;

  Result({
    required this.id,
    required this.name,
  });

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;

    return data;
  }
}
