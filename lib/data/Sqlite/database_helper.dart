import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:qrcode/model/history_model.dart';

class DatabaseHelper {
  late Database _database;

  Future<void> initializeDatabase() async {
    print(await getDatabasesPath());
    final String path = join(
      await getDatabasesPath(),
      'HistoryQr.db',
    );

    _database = await openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE created_history(Id INTEGER PRIMARY KEY AUTOINCREMENT, Type TEXT, Datetime TEXT, Content TEXT)',
        );
        db.execute(
          'CREATE TABLE scanned_history(Id INTEGER PRIMARY KEY AUTOINCREMENT, Type TEXT, Datetime TEXT, Content TEXT)',
        );
      },
      version: 1,
    );
    print('Database initialized');
  }

  Stream<HistoryItem> readCreated() async* {
    if (!await databaseExists(_database.path)) {
      throw Exception('Database does not exist');
    }

    final List<Map<String, dynamic>> maps =
        await _database.query('created_history');
    for (Map<String, dynamic> map in maps) {
      yield HistoryItem.fromMap(map);
    }
  }

  Stream<HistoryItem> readScanned() async* {
    if (!await databaseExists(_database.path)) {
      throw Exception('Database does not exist');
    }

    final List<Map<String, dynamic>> maps =
        await _database.query('scanned_history');
    for (Map<String, dynamic> map in maps) {
      yield HistoryItem.fromMap(map);
    }
  }

  Future<void> insertCreated(HistoryItem historyItem) async {
    if (!await databaseExists(_database.path)) {
      throw Exception('Database does not exist');
    }

    await _database.insert(
      'created_history',
      historyItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertScanned(HistoryItem historyItem) async {
    if (!await databaseExists(_database.path)) {
      throw Exception('Database does not exist');
    }

    await _database.insert(
      'scanned_history',
      historyItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCreated(DateTime dateTime) async {
    if (!await databaseExists(_database.path)) {
      throw Exception('Database does not exist');
    }

    await _database.delete('created_history',
        where: "Datetime = ?", whereArgs: [dateTime.toString()]);
  }

  Future<void> deleteScaned(DateTime dateTime) async {
    if (!await databaseExists(_database.path)) {
      throw Exception('Database does not exist');
    }

    await _database.delete('scanned_history',
        where: "Datetime = ?", whereArgs: [dateTime.toString()]);
  }
}
