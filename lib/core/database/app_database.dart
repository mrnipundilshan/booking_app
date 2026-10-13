import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  const AppDatabase._();

  static const _name = 'booking_app.db';
  static const version = 1;

  static Future<Database> open() async {
    return openDatabase(
      join(await getDatabasesPath(), _name),
      version: version,
      onCreate: onCreate,
    );
  }

  static Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bookings (
        id TEXT PRIMARY KEY,
        providerId TEXT NOT NULL,
        customerName TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        date TEXT NOT NULL,
        timeSlot TEXT NOT NULL,
        estimatedHours INTEGER NOT NULL,
        description TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');
  }
}
