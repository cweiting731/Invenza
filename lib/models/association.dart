class Association {
  String? email;
  String? phone;
  Association({this.email, this.phone});

  Map<String, dynamic> toJson() => {
    "email" : email,
    "phone" : phone
  };
  factory Association.fromJson(Map<String, dynamic> json) {
    return Association(
      email: json['email'],
      phone: json['phone'],
    );
  }
}