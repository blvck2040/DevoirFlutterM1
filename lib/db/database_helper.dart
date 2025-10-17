import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/course.dart';
import '../models/schedule.dart';
import '../models/teacher.dart';
import '../models/user.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'university_schedule.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT,
        email TEXT,
        dateNaissance TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE teachers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT,
        lastName TEXT,
        email TEXT,
        phone TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE courses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        teacherId INTEGER,
        FOREIGN KEY (teacherId) REFERENCES teachers(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE schedules (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        courseId INTEGER,
        date TEXT,
        startTime TEXT,
        endTime TEXT,
        room TEXT,
        FOREIGN KEY (courseId) REFERENCES courses(id)
      )
    ''');

    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    final teachers = [
      Teacher(firstName: 'Fatou', lastName: 'Ndiaye', email: 'f.ndiaye@univ.sn', phone: '770000001'),
      Teacher(firstName: 'Moussa', lastName: 'Ba', email: 'm.ba@univ.sn', phone: '770000002'),
    ];

    for (final teacher in teachers) {
      await db.insert('teachers', teacher.toMap());
    }

    final courses = [
      Course(
        name: 'Développement Mobile',
        description: 'Introduction à Flutter et aux architectures mobiles modernes.',
        teacherId: 1,
      ),
      Course(
        name: 'Base de Données',
        description: 'Modélisation relationnelle avancée et SQL.',
        teacherId: 2,
      ),
    ];

    for (final course in courses) {
      await db.insert('courses', course.toMap());
    }

    final schedules = [
      Schedule(
        courseId: 1,
        date: '2025-10-20',
        startTime: '08:00',
        endTime: '10:00',
        room: 'Salle A101',
      ),
      Schedule(
        courseId: 1,
        date: '2025-10-22',
        startTime: '10:00',
        endTime: '12:00',
        room: 'Salle A101',
      ),
      Schedule(
        courseId: 2,
        date: '2025-10-21',
        startTime: '14:00',
        endTime: '16:00',
        room: 'Salle B202',
      ),
    ];

    for (final schedule in schedules) {
      await db.insert('schedules', schedule.toMap());
    }

    await db.insert('users', const User(
      username: 'demo',
      password: 'demo123',
      email: 'demo@univ.sn',
      dateNaissance: '1999-01-01',
    ).toMap());
  }

  Future<int> createUser(User user) async {
    final db = await database;
    return db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUserByCredentials(String username, String password) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Course>> getCourses() async {
    final db = await database;
    final maps = await db.query('courses');
    return maps.map((map) => Course.fromMap(map)).toList();
  }

  Future<Course?> getCourseById(int id) async {
    final db = await database;
    final maps = await db.query(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Course.fromMap(maps.first);
    }
    return null;
  }

  Future<Teacher?> getTeacherById(int id) async {
    final db = await database;
    final maps = await db.query(
      'teachers',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Teacher.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Schedule>> getSchedules() async {
    final db = await database;
    final maps = await db.query('schedules', orderBy: 'date, startTime');
    return maps.map((map) => Schedule.fromMap(map)).toList();
  }

  Future<List<Schedule>> getSchedulesForCourse(int courseId) async {
    final db = await database;
    final maps = await db.query(
      'schedules',
      where: 'courseId = ?',
      whereArgs: [courseId],
      orderBy: 'date, startTime',
    );
    return maps.map((map) => Schedule.fromMap(map)).toList();
  }
}
