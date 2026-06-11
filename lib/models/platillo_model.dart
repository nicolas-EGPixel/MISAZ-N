class Platillo {
  // Atributos privados/finales (Encapsulamiento de datos)
  final int? id;
  final String gmailUsuario;
  final String nombrePlatillo;
  final String descripcion;
  final double precio;
  final String imagen;
  final String? categoria;

  // 1. Constructor con encapsulamiento
  Platillo({
    this.id,
    required this.gmailUsuario,
    required this.nombrePlatillo,
    required this.descripcion,
    required this.precio,
    required this.imagen,
    this.categoria,
  });

  // 2. Método de traducción: De Mapa (SQLite) a Objeto POO (Factory Constructor)
  factory Platillo.fromMap(Map<String, dynamic> map) {
    return Platillo(
      id: map['id'],
      gmailUsuario: map['gmail_usuario'] ?? '',
      nombrePlatillo: map['nombre_platillo'] ?? '',
      descripcion: map['descripcion'] ?? '',
      precio: (map['precio'] as num).toDouble(),
      imagen: map['imagen'] ?? '',
      categoria: map['categoria'],
    );
  }

  // 3. Método de traducción: De Objeto POO a Mapa (para insertar en la Base de Datos)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'gmail_usuario': gmailUsuario,
      'nombre_platillo': nombrePlatillo,
      'descripcion': descripcion,
      'precio': precio,
      'imagen': imagen,
      'categoria': categoria,
    };
  }
}