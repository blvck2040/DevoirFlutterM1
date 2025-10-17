class Course {
  final int? id;
  final String name;
  final String description;
  final int teacherId;

  const Course({
    this.id,
    required this.name,
    required this.description,
    required this.teacherId,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'teacherId': teacherId,
      };

  factory Course.fromMap(Map<String, dynamic> map) => Course(
        id: map['id'] as int?,
        name: map['name'] as String,
        description: map['description'] as String,
        teacherId: map['teacherId'] as int,
      );
}
