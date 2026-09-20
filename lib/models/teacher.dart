class Teacher {
  final int? id;
  final String name;

  Teacher({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(id: map['id'], name: map['name']);
  }
}
