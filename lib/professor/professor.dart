class Professor {
  String professorId;
  String name;
  String title;
  String account;
  String password;
  String imagePath;
  bool showCourse;

  Professor({
    required this.professorId,
    required this.name,
    required this.title,
    required this.account,
    required this.password,
    required this.imagePath,
    required this.showCourse,
  });

  Map<String, dynamic> toMap() {
    return {
      'professor_id': professorId,
      'name': name,
      'title': title,
      'account': account,
      'password': password,
      'image_path': imagePath,
      'show_course': showCourse ? 1 : 0,
    };
  }

  factory Professor.fromMap(Map<String, dynamic> map) {
    return Professor(
      professorId: map['professor_id'],
      name: map['name'],
      title: map['title'],
      account: map['account'],
      password: map['password'],
      imagePath: map['image_path'],
      showCourse: map['show_course'] == 1 ? true : false,
    );
  }
}