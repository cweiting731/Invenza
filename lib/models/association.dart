class Association {
  String? email;
  String? phone;
  Association({this.email, this.phone});

  Map<String, dynamic> toJson() => {
    "email" : email,
    "phone" : phone
  };
}