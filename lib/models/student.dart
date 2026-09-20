class Student {
  final int? id;
  final String name;
  final String className;

  Student({this.id, required this.name, required this.className});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'className': className};
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      className: map['className'],
    );
  }
}
