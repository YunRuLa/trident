class Enrollment {
  String id;
  String student_id;
  String course_id;

  Enrollment({
    required this.id,
    required this.student_id,
    required this.course_id
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': student_id,
      'course_id': course_id
    };
  }

  factory Enrollment.fromMap(Map<String, dynamic> map) {
    return Enrollment(
      id: map['id'],
      student_id: map['student_id'],
      course_id: map['course_id'],
    );
  }
}