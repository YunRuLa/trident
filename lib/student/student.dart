class Students {
  String id;
  String name;
  String account;
  String password;

  Students({
    required this.id,
    required this.name,
    required this.account,
    required this.password
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'account': account,
      'password': password
    };
  }

  factory Students.fromMap(Map<String, dynamic> map) {
    return Students(
      id: map['id'],
      name: map['name'],
      account: map['account'],
      password: map['password'],
    );
  }
}