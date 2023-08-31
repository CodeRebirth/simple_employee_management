import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'employee_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE employees(
            id INTEGER PRIMARY KEY,
            empName TEXT,
            role TEXT,
            joining_date TEXT,
            ending_date TEXT
          )
        ''');

        await db.execute('''
        CREATE TABLE deleted_employees(
          id INTEGER PRIMARY KEY,
          empName TEXT,
          role TEXT,
          joining_date TEXT,
          ending_date TEXT
        )
      ''');
      },
    );
  }

  Future<void> moveEmployeeToDeletedTable(int id) async {
    final db = await database;
    final employee = await db.query('employees', where: 'id = ?', whereArgs: [id]);
    print(employee);
    if (employee.isNotEmpty) {
      final employeeData = Map<String, dynamic>.from(employee.first);
      print(employeeData);
      int originalId = employeeData["id"];
      employeeData.remove('id');
      await db.insert('deleted_employees', employeeData);
      await db.delete('employees', where: 'id = ?', whereArgs: [originalId]);
    }
  }

  Future<int> insertEmployee(Map<String, dynamic> employee) async {
    final db = await database;
    return await db.insert('employees', employee);
  }

  Future<void> undoDelete(String name) async {
    final db = await database;
    final deletedEmployee = await db.query('deleted_employees', where: 'empName = ?', whereArgs: [name]);
    if (deletedEmployee.isNotEmpty) {
      final employeeData = Map<String, dynamic>.from(deletedEmployee.first);
      employeeData.remove('id');
      await db.insert('employees', employeeData);
      await db.delete('deleted_employees', where: 'empName = ?', whereArgs: [name]);
    }
  }

  Future<List<Map<String, dynamic>>> getAllEmployees() async {
    final db = await database;
    return await db.query('employees');
  }

  Future<int> deleteEmployee(int id) async {
    final db = await database;
    return await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateEmployee(Map<String, dynamic> employee, int empId) async {
    final db = await database;
    final id = empId;

    return await db.update(
      'employees',
      employee,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllData() async {
    final db = await database;

    // Delete all records from the 'employees' table
    await db.delete('employees');

    // Delete all records from the 'deleted_employees' table
    await db.delete('deleted_employees');
  }
}
