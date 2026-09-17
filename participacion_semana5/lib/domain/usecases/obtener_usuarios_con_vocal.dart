import '../entities/usuario.dart';
import '../repositories/usuario_repository.dart';

class ObtenerUsuariosConVocal {
  final UsuarioRepository _repository;

  const ObtenerUsuariosConVocal(this._repository);

  Future<List<Usuario>> call() async {
    final usuarios = await _repository.obtener();
    final vocalInicial = RegExp(r'^[aeiou]', caseSensitive: false);

    return usuarios
        .where((usuario) => vocalInicial.hasMatch(usuario.nombre))
        .toList();
  }
}
