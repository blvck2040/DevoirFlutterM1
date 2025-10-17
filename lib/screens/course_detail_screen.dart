import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../models/course.dart';
import '../models/schedule.dart';
import '../models/teacher.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key, required this.course});

  static const routeName = '/course_detail';

  final Course course;

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Future<Teacher?> _teacherFuture;
  late Future<List<Schedule>> _scheduleFuture;

  @override
  void initState() {
    super.initState();
    _teacherFuture = DatabaseHelper.instance.getTeacherById(widget.course.teacherId);
    if (widget.course.id != null) {
      _scheduleFuture = DatabaseHelper.instance.getSchedulesForCourse(widget.course.id!);
    } else {
      _scheduleFuture = Future.value(const <Schedule>[]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.course.name)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(widget.course.description),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<Teacher?>(
              future: _teacherFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final teacher = snapshot.data;
                if (teacher == null) {
                  return const Card(
                    child: ListTile(
                      title: Text('Enseignant non disponible'),
                    ),
                  );
                }
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                    title: Text(teacher.fullName),
                    subtitle: Text('${teacher.email}\nTel: ${teacher.phone}'),
                    isThreeLine: true,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Créneaux horaires',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<Schedule>>(
              future: _scheduleFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final schedules = snapshot.data ?? [];
                if (schedules.isEmpty) {
                  return const Text('Aucun créneau planifié.');
                }
                return Column(
                  children: schedules
                      .map(
                        (schedule) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.schedule),
                            title: Text('${schedule.date} • ${schedule.startTime} - ${schedule.endTime}'),
                            subtitle: Text('Salle ${schedule.room}'),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
