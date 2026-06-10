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
        version: 2, //Version mayor
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
              telefono TEXT,
              foto_negocio TEXT
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
              gmail_usuario TEXT,
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
          // Tabla de completados
          await db.execute('''
            CREATE TABLE tb_completados (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nombre_platillo TEXT,
              cantidad INTEGER,
              direccion TEXT,
              envio REAL
            )
          ''');
          
          // 🔸 NUEVO: Tabla para guardar los platillos favoritos vinculados al usuario
          await db.execute('''
            CREATE TABLE tb_favoritos (
              id_favorito INTEGER PRIMARY KEY AUTOINCREMENT,
              gmail_usuario TEXT,
              id_platillo INTEGER
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
  static Future<int> registrarNegocio(
    String gmail,
    String nombre,
    String tipo,
    String direccion,
    String telefono,
    String fotoNegocio) async {
  final db = await initDB();
  return await db.insert("tb_negocios", {
    "gmail_usuario": gmail,
    "nombre_negocio": nombre,
    "tipo_negocio": tipo,
    "direccion": direccion,
    "telefono": telefono,
    "foto_negocio": fotoNegocio, // 👈 guardamos la ruta de la foto
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
    String gmail,
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
    "gmail_usuario": gmail,
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

// Insertar en completados
static Future<int> registrarCompletado(
    String platillo,
    int cantidad,
    String direccion,
    double envio) async {
  final db = await initDB();
  return await db.insert("tb_completados", {
    "nombre_platillo": platillo,
    "cantidad": cantidad,
    "direccion": direccion,
    "envio": envio,
  });
}

// Obtener completados
static Future<List<Map<String, dynamic>>> obtenerCompletados() async {
  final db = await initDB();
  return await db.query("tb_completados");
}

// Eliminar pedido de tb_pedidos
static Future<int> eliminarPedido(int id) async {
  final db = await initDB();
  return await db.delete("tb_pedidos", where: "id = ?", whereArgs: [id]);
}

// 🔸 NUEVO: Verificar si la contraseña actual es correcta
  static Future<bool> verificarContrasena(String gmail, String password) async {
    final db = await initDB();
    final res = await db.query(
      "tb_datos",
      where: "gmail = ? AND contraseña = ?",
      whereArgs: [gmail, password],
    );
    return res.isNotEmpty;
  }

  // 🔸 NUEVO: Actualizar los datos del usuario
  static Future<int> actualizarUsuario(String oldGmail, String newName, String newGmail, String newPassword) async {
    final db = await initDB();
    return await db.update(
      "tb_datos",
      {
        "nombre": newName,
        "gmail": newGmail,
        "contraseña": newPassword
      },
      where: "gmail = ?",
      whereArgs: [oldGmail],
    );
  }

  // 🔸 NUEVO: Dar o quitar favorito (Toggle)
  static Future<void> alternarFavorito(String gmail, int idPlatillo) async {
    final db = await initDB();
    // Verificamos si ya existe
    final existe = await db.query(
      "tb_favoritos",
      where: "gmail_usuario = ? AND id_platillo = ?",
      whereArgs: [gmail, idPlatillo],
    );

    if (existe.isNotEmpty) {
      // Si ya existía, lo quitamos (Quitamos el corazón)
      await db.delete(
        "tb_favoritos",
        where: "gmail_usuario = ? AND id_platillo = ?",
        whereArgs: [gmail, idPlatillo],
      );
    } else {
      // Si no existía, lo agregamos (Damos corazón)
      await db.insert("tb_favoritos", {
        "gmail_usuario": gmail,
        "id_platillo": idPlatillo,
      });
    }
  }

  // 🔸 NUEVO: Verificar si un platillo específico tiene favorito por este usuario
  static Future<bool> esFavorito(String gmail, int idPlatillo) async {
    final db = await initDB();
    final res = await db.query(
      "tb_favoritos",
      where: "gmail_usuario = ? AND id_platillo = ?",
      whereArgs: [gmail, idPlatillo],
    );
    return res.isNotEmpty;
  }

  // 🔸 NUEVO: Obtener la lista completa de platillos que son favoritos del usuario
  static Future<List<Map<String, dynamic>>> obtenerPlatillosFavoritos(String gmail) async {
    final db = await initDB();
    // Hacemos un INNER JOIN para traernos la información completa del platillo usando el ID guardado
    return await db.rawQuery('''
      SELECT p.* FROM tb_platillos p
      INNER JOIN tb_favoritos f ON p.id = f.id_platillo
      WHERE f.gmail_usuario = ?
    ''', [gmail]);
  }

  // 🔸 NUEVO: Buscar platillos por coincidencia de nombre
  static Future<List<Map<String, dynamic>>> buscarPlatillos(String consulta) async {
    final db = await initDB();
    return await db.query(
      "tb_platillos",
      where: "nombre_platillo LIKE ?",
      whereArgs: ['%$consulta%'],
    );
  }

  // 🔸 NUEVO: Obtener el historial de pedidos de un usuario en específico
  static Future<List<Map<String, dynamic>>> obtenerPedidosPorUsuario(String gmail) async {
    final db = await initDB();
    return await db.query(
      "tb_pedidos",
      where: "gmail_usuario = ?",
      whereArgs: [gmail],
    );
  }

  // --- MÉTODOS DE NEGOCIOS ---
  static Future<List<Map<String, dynamic>>> obtenerNegocios() async {
    final db = await initDB();
    return await db.query("tb_negocios");
  }

  // --- MÉTODOS DE NEGOCIOS ---
  static Future<List<Map<String, dynamic>>> buscarNegocios(String consulta) async {
    final db = await initDB();
    return await db.query(
     "tb_negocios",
     where: "nombre_negocio LIKE ?",
     whereArgs: ['%$consulta%'],
    );
  }

  // --- MÉTODOS DE FAVORITOS DE NEGOCIOS ---
  static Future<List<Map<String, dynamic>>> obtenerNegociosFavoritos(String gmail) async {
    final db = await initDB();
    return await db.rawQuery('''
    SELECT n.* FROM tb_negocios n
    INNER JOIN tb_favoritos f ON n.id = f.id_platillo
    WHERE f.gmail_usuario = ?
  ''', [gmail]);
  }



}