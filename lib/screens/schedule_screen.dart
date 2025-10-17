import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/database_helper.dart';
import '../models/course.dart';
import '../models/schedule.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  static const routeName = '/schedule';

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late Future<List<_ScheduleWithCourse>> _scheduleFuture;

  @override
  void initState() {
    super.initState();
    _scheduleFuture = _loadSchedules();
  }

  Future<List<_ScheduleWithCourse>> _loadSchedules() async {
    final schedules = await DatabaseHelper.instance.getSchedules();
    final List<_ScheduleWithCourse> result = [];
    for (final schedule in schedules) {
      final course = await DatabaseHelper.instance.getCourseById(schedule.courseId);
      if (course != null) {
        result.add(_ScheduleWithCourse(schedule: schedule, course: course));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon emploi du temps')),
      body: FutureBuilder<List<_ScheduleWithCourse>>(
        future: _scheduleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(child: Text('Aucun créneau planifié.'));
          }

          final grouped = <String, List<_ScheduleWithCourse>>{};
          for (final item in items) {
            grouped.putIfAbsent(item.schedule.date, () => []).add(item);
          }

          final sortedDates = grouped.keys.toList()..sort();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final date = sortedDates[index];
              final daySchedules = grouped[date]!;
              final formattedDate = DateFormat.yMMMMEEEEd().format(DateTime.parse(date));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...daySchedules.map(
                    (item) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.class_rounded),
                        title: Text(item.course.name),
                        subtitle: Text(
                          '${item.schedule.startTime} - ${item.schedule.endTime}\nSalle ${item.schedule.room}',
                        ),
                        isThreeLine: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _ScheduleWithCourse {
  const _ScheduleWithCourse({required this.schedule, required this.course});

  final Schedule schedule;
  final Course course;
}
