class User {
  String? username;
  String? name;
  String? phoneno;
  String? email;
  String? password;
  String? credit;

  User({
    required this.username, 
    required this.name,
    required this.phoneno,
    required this.email,
    required this.password,
    required this.credit});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    name = json['name'];
    phoneno = json['phoneno'];
    email = json['email'];
    password = json['password'];
    credit = json['credit'];
  } 
}