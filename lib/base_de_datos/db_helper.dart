import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  static Future<Database> initDB() async {
    // Ya inicializaste sqflite_common_ffi en main.dart
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "Usuarios.db");

    // Si no existe la base, se crea automáticamente con la tabla tb_datos
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tb_datos (
            nombre TEXT,
            gmail TEXT,
            contraseña TEXT
          )
        ''');
      },
    );
  }

  static Future<int> insertUsuario(String nombre, String gmail, String password) async {
    final db = await initDB();
    return await db.insert("tb_datos", {
      "nombre": nombre,
      "gmail": gmail,
      "contraseña": password,
    });
  }

  static Future<Map<String, dynamic>?> login(String gmail, String password) async {
    final db = await initDB();
    final res = await db.query(
      "tb_datos",
      where: "gmail = ? AND contraseña = ?",
      whereArgs: [gmail, password],
    );
    return res.isNotEmpty ? res.first : null;
  }
}