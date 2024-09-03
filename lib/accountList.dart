class AccountLists {
  late num status;
  late String message;
  late List<UserLis?> accounts;
  late List<UserLis?> senderaccounts;

  AccountLists(
      {required this.status, required this.message, required this.accounts});

  AccountLists.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] ?? '';
    if (json['receivers'] != null) {
      accounts = <UserLis?>[];
      json['receivers'].forEach((v) {
        accounts.add(UserLis?.fromJson(v));
      });
    }
     if (json['senders'] != null) {
      senderaccounts = <UserLis?>[];
      json['senders'].forEach((v) {
        senderaccounts.add(UserLis?.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.accounts != null) {
      data['receivers'] = accounts.map((v) => v?.toJson()).toList();
    }
    if (this.senderaccounts != null) {
      data['senders'] = senderaccounts.map((v) => v?.toJson()).toList();
    }
    return data;
  }
}

class UserLis {
  late int id;
  late String account_name;
  late String email;
  late String type;
  late String? phone;

  UserLis({
    required this.id,
    required this.email,
    required this.account_name,
    required this.type,
    required this.phone,
  });

  UserLis.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    email = json['email'] ?? '';
    account_name = json['name'] ?? '';
    type = json['type'] ?? '';
    phone = json['phone'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.account_name;
     data['type'] = this.type;
      data['phone'] = this.phone;
    return data;
  }
}
