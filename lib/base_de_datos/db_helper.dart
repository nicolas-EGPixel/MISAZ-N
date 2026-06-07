import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  static Future<Database> initDB() async {
    // 🔹 RECUPERAMOS LA CONFIGURACIÓN DE WINDOWS DE TU COMPAÑERO
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    var databasesPath = await databaseFactory.getDatabasesPath();
    String path = join(databasesPath, "Usuarios.db");

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          // Tablas de usuarios
          await db.execute('''
            CREATE TABLE tb_datos (
              nombre TEXT,
              gmail TEXT,
              contraseña TEXT
            )
          ''');

          // Nueva tabla para los datos del negocio del vendedor
          await db.execute('''
            CREATE TABLE tb_negocios (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              gmail_usuario TEXT,
              nombre_negocio TEXT,
              tipo_negocio TEXT,
              direccion TEXT,
              telefono TEXT
            )
          ''');

          // Nueva tabla para almacenar los platillos publicados
          await db.execute('''
            CREATE TABLE tb_platillos (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              gmail_usuario TEXT,
              nombre_platillo TEXT,
              descripcion TEXT,
              precio REAL,
              imagen TEXT
            )
          ''');
        },
      ),
    );
  }

  // --- MÉTODOS DE USUARIO ---
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

  static Future<int> eliminarUsuario(String gmail) async {
    final db = await initDB();
    return await db.delete(
      'tb_datos',
      where: 'gmail = ?',
      whereArgs: [gmail],
    );
  }

  // --- MÉTODOS DE VENDEDOR / NEGOCIOS ---
  static Future<int> registrarNegocio(String gmail, String nombre, String tipo, String direccion, String telefono) async {
    final db = await initDB();
    return await db.insert("tb_negocios", {
      "gmail_usuario": gmail,
      "nombre_negocio": nombre,
      "tipo_negocio": tipo,
      "direccion": direccion,
      "telefono": telefono,
    });
  }

  static Future<bool> esVendedor(String gmail) async {
    final db = await initDB();
    final res = await db.query(
      "tb_negocios",
      where: "gmail_usuario = ?",
      whereArgs: [gmail],
    );
    return res.isNotEmpty;
  }

  // --- MÉTODOS DE PLATILLOS ---
  static Future<int> insertarPlatillo(String gmail, String nombre, String descripcion, double precio, String imagen) async {
    final db = await initDB();
    return await db.insert("tb_platillos", {
      "gmail_usuario": gmail,
      "nombre_platillo": nombre,
      "descripcion": descripcion,
      "precio": precio,
      "imagen": imagen,
    });
  }

  // --- MÉTODOS PARA LEER PLATILLOS ---
  static Future<List<Map<String, dynamic>>> obtenerPlatillosPorUsuario(String gmail) async {
    final db = await initDB();
    return await db.query(
      "tb_platillos",
      where: "gmail_usuario = ?",
      whereArgs: [gmail],
    );
  }
}