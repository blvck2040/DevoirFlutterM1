import 'package:flutter/material.dart';

import 'db/database_helper.dart';
import 'models/course.dart';
import 'screens/course_detail_screen.dart';
import 'screens/course_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/schedule_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UniversityScheduleApp());
}

class UniversityScheduleApp extends StatelessWidget {
  const UniversityScheduleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseHelper.instance.database,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp(
          title: 'Emploi du temps',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F51B5)),
            useMaterial3: true,
          ),
          initialRoute: LoginScreen.routeName,
          routes: {
            LoginScreen.routeName: (context) => const LoginScreen(),
            RegisterScreen.routeName: (context) => const RegisterScreen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
            CourseListScreen.routeName: (context) => const CourseListScreen(),
            ScheduleScreen.routeName: (context) => const ScheduleScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == CourseDetailScreen.routeName) {
              final course = settings.arguments as Course;
              return MaterialPageRoute(
                builder: (context) => CourseDetailScreen(course: course),
              );
            }
            return null;
          },
        );
      },
    );
  }
}
