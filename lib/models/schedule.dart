class Schedule {
  final int? id;
  final int courseId;
  final String date; // YYYY-MM-DD
  final String startTime; // HH:MM
  final String endTime; // HH:MM
  final String room;

  const Schedule({
    this.id,
    required this.courseId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.room,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'courseId': courseId,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'room': room,
      };

  factory Schedule.fromMap(Map<String, dynamic> map) => Schedule(
        id: map['id'] as int?,
        courseId: map['courseId'] as int,
        date: map['date'] as String,
        startTime: map['startTime'] as String,
        endTime: map['endTime'] as String,
        room: map['room'] as String,
      );
}
