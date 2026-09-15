import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'video_page.dart';

void main() => runApp(const MyApp());

// La API devuelve los partidos dentro de "response".
Future<List<dynamic>> cargarPartidos({http.Client? client}) async {
  final uri = Uri.parse('https://www.scorebat.com/video-api/v3/');
  final respuesta = await (client != null ? client.get(uri) : http.get(uri))
      .timeout(const Duration(seconds: 20));
  if (respuesta.statusCode != 200) {
    throw Exception('Error al consultar ScoreBat');
  }
  final datos = jsonDecode(respuesta.body);
  if (datos is! Map || datos['response'] is! List) {
    throw const FormatException('Respuesta inesperada');
  }
  return (datos['response'] as List).whereType<Map<String, dynamic>>().toList();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Fútbol · ScoreBat',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      useMaterial3: true,
    ),
    home: const PartidosPage(),
  );
}

class PartidosPage extends StatefulWidget {
  const PartidosPage({super.key, this.cargar = cargarPartidos});
  final Future<List<dynamic>> Function() cargar;

  @override
  State<PartidosPage> createState() => _PartidosPageState();
}

class _PartidosPageState extends State<PartidosPage> {
  late Future<List<dynamic>> _partidos;

  @override
  void initState() {
    super.initState();
    _partidos = widget.cargar();
  }

  void _actualizar() {
    setState(() {
      _partidos = widget.cargar();
    });
  }

  String _fecha(dynamic valor) {
    final fecha = DateTime.tryParse(valor?.toString() ?? '')?.toLocal();
    if (fecha == null) return 'Fecha no disponible';
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Fútbol · ScoreBat'),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      actions: [
        IconButton(
          onPressed: _actualizar,
          tooltip: 'Actualizar',
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: SafeArea(
      child: FutureBuilder<List<dynamic>>(
        future: _partidos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      'No se pudieron cargar los partidos.\n'
                      'Comprueba tu conexión e inténtalo de nuevo.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _actualizar,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }
          final partidos = (snapshot.data ?? []).take(5).toList();
          if (partidos.isEmpty) {
            return const Center(child: Text('No hay partidos disponibles.'));
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: partidos.length,
                itemBuilder: (context, index) {
                  final partido = partidos[index];
                  final imagen = partido['thumbnail'] as String? ?? '';
                  final videos = partido['videos'] as List? ?? [];
                  final urlVideo = obtenerUrlVideo(videos);
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (imagen.isNotEmpty)
                          Image.network(
                            imagen,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(
                                  height: 100,
                                  child: Icon(Icons.sports_soccer, size: 48),
                                ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                partido['title'] ?? 'Partido sin nombre',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(partido['competition'] ?? 'Sin competición'),
                              const SizedBox(height: 4),
                              Text(_fecha(partido['date'])),
                              const SizedBox(height: 8),
                              Text('Videos disponibles: ${videos.length}'),
                              const SizedBox(height: 8),
                              FilledButton.icon(
                                onPressed: urlVideo == null
                                    ? null
                                    : () => Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) => VideoPage(
                                            titulo: partido['title'] ?? 'Video',
                                            url: urlVideo,
                                          ),
                                        ),
                                      ),
                                icon: const Icon(Icons.play_circle_outline),
                                label: Text(
                                  urlVideo == null ? 'Sin video' : 'Ver video',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    ),
  );
}
