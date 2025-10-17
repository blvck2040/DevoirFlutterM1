import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../models/course.dart';
import 'course_detail_screen.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  static const routeName = '/courses';

  Future<List<Course>> _loadCourses() {
    return DatabaseHelper.instance.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes cours')),
      body: FutureBuilder<List<Course>>(
        future: _loadCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun cours disponible.'));
          }

          final courses = snapshot.data!;

          return ListView.separated(
            itemCount: courses.length,
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final course = courses[index];
              return Card(
                child: ListTile(
                  title: Text(course.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(course.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      CourseDetailScreen.routeName,
                      arguments: course,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
