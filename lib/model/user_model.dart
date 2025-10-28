class UserModel {
  String? uid;
  String? firstName;
  String? lastName;
  String? email;
  String? password;

  UserModel({
    this.uid = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
  });

  Map<String, dynamic> toJson(String uid) {
    return {
      'uid': uid,
      'firstName': firstName?.trim(),
      'lastName': lastName?.trim(),
      'email': email?.trim(),
      'createdAt': DateTime.now(),
    };
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? '';
    firstName = json['firstName'] ?? '';
    lastName = json['lastName'] ?? '';
    email = json['email'] ?? '';
    password = '';
  }
}
