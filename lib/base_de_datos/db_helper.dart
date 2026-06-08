import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  static Future<Database> initDB() async {
    // Inicialización para Windows/Linux
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    var databasesPath = await databaseFactory.getDatabasesPath();
    String path = join(databasesPath, "Usuarios.db");

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          // Tabla de usuarios
          await db.execute('''
            CREATE TABLE tb_datos (
              nombre TEXT,
              gmail TEXT,
              contraseña TEXT,
              foto_perfil TEXT
            )
          ''');

          // Tabla de negocios (vendedores)
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

          // Tabla de platillos publicados
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
          // Tabla de repartidores
          await db.execute('''
            CREATE TABLE tb_repartidor (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              gmail_usuario TEXT,
              num_licencia TEXT,
              ordenes INTEGER,
              completadas INTEGER
            )
          ''');
          // Tabla de pedidos
          await db.execute('''
            CREATE TABLE tb_pedidos (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nombre_platillo TEXT,
              cantidad INTEGER,
              direccion TEXT,
              telefono TEXT,
              notas TEXT,
              subtotal REAL,
              envio REAL,
              total REAL
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS tb_repartidor (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                gmail_usuario TEXT,
                num_licencia TEXT,
                ordenes INTEGER,
                completadas INTEGER
              )
            ''');
          }
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
  static Future<int> insertarPlatillo(String gmail, String nombre, String descripcion, double precio, String imagen, String categoria) async {
    final db = await initDB();
    return await db.insert("tb_platillos", {
      "gmail_usuario": gmail,
      "nombre_platillo": nombre,
      "descripcion": descripcion,
      "precio": precio,
      "imagen": imagen,
    });
  }

  // Platillos de un usuario específico
  static Future<List<Map<String, dynamic>>> obtenerPlatillosPorUsuario(String gmail) async {
    final db = await initDB();
    return await db.query(
      "tb_platillos",
      where: "gmail_usuario = ?",
      whereArgs: [gmail],
    );
  }

  // Obtener todos los platillos publicados
  static Future<List<Map<String, dynamic>>> getPlatillos() async {
    final db = await initDB();
    return await db.query("tb_platillos");
  }

  // Eliminar un platillo
  static Future<int> eliminarPlatillo(int id) async {
    final db = await initDB();
    return await db.delete(
      "tb_platillos",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Actualizar un platillo
  static Future<int> actualizarPlatillo(int id, String nombre, String descripcion, double precio, String imagen, String categoria) async {
    final db = await initDB();
    return await db.update(
      "tb_platillos",
      {
        "nombre_platillo": nombre,
        "descripcion": descripcion,
        "precio": precio,
        "imagen": imagen,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<int> actualizarFotoPerfil(String gmail, String rutaImagen) async {
    final db = await initDB();
    return await db.update(
      'tb_datos',
      {'foto_perfil': rutaImagen},
      where: 'gmail = ?',
      whereArgs: [gmail],
    );
  }

  // --- MÉTODOS DE REPARTIDOR ---
  static Future<int> registrarRepartidor(
      String gmail, String licencia, int ordenes, int completadas) async {
    final db = await initDB();
    return await db.insert("tb_repartidor", {
      "gmail_usuario": gmail,
      "num_licencia": licencia,
      "ordenes": ordenes,
      "completadas": completadas,
    });
  }

  static Future<List<Map<String, dynamic>>> obtenerRepartidores() async {
    final db = await initDB();
    return await db.query("tb_repartidor");
  }

  static Future<Map<String, dynamic>?> obtenerRepartidorPorUsuario(
      String gmail) async {
    final db = await initDB();
    final res = await db.query(
      "tb_repartidor",
      where: "gmail_usuario = ?",
      whereArgs: [gmail],
    );
    return res.isNotEmpty ? res.first : null;
  }

  static Future<int> actualizarRepartidor(
      int id, int ordenes, int completadas) async {
    final db = await initDB();
    return await db.update(
      "tb_repartidor",
      {
        "ordenes": ordenes,
        "completadas": completadas,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }
  // --- MÉTODOS DE PEDIDOS ---
static Future<int> registrarPedido(
    String platillo,
    int cantidad,
    String direccion,
    String telefono,
    String notas,
    double subtotal,
    double envio,
    double total) async {
  final db = await initDB();
  return await db.insert("tb_pedidos", {
    "nombre_platillo": platillo,
    "cantidad": cantidad,
    "direccion": direccion,
    "telefono": telefono,
    "notas": notas,
    "subtotal": subtotal,
    "envio": envio,
    "total": total,
  });
}

static Future<List<Map<String, dynamic>>> obtenerPedidos() async {
  final db = await initDB();
  return await db.query("tb_pedidos");
}

}