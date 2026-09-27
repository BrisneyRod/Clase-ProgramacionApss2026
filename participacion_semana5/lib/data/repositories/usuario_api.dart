import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';

class UsuarioApi implements UsuarioRepository {
  @override
  Future<List<Usuario>> obtener() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/users'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Error HTTP ${response.statusCode}');
    }

    final datos = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

    return datos.cast<Map<String, dynamic>>().map((usuario) {
      return Usuario(
        id: usuario['id'] as int,
        nombre: usuario['name'] as String,
        email: usuario['email'] as String,
      );
    }).toList();
  }
}
