class Student {
  int id;
  String name;
  String course;
  Student({this.id, this.name, this.course});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'course': course};
  }

  @override
  String toString() {
    return '{id: $id, name: $name, course: $course}';
  }

  int getId() {
    return id;
  }

  String getName() {
    return name;
  }

  String getCourse() {
    return course;
  }
}
