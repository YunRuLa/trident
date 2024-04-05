class Courses {
  String id;
  String name;
  String time;
  String intro;
  String professor_id;

  Courses({
    required this.id,
    required this.name,
    required this.time,
    required this.intro,
    required this.professor_id
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'intro': intro,
      'professor_id': professor_id
    };
  }

  factory Courses.fromMap(Map<String, dynamic> map) {
    return Courses(
      id: map['id'],
      name: map['name'],
      time: map['time'],
      intro: map['intro'],
      professor_id: map['professor_id'],
    );
  }
}