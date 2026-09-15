import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/parser.dart' as html;

// El video viene como un iframe HTML, no como un archivo MP4.
Uri? obtenerUrlVideo(List<dynamic> videos) {
  for (final video in videos) {
    if (video is! Map || video['embed'] is! String) continue;
    final src = html
        .parse(video['embed'] as String)
        .querySelector('iframe')
        ?.attributes['src'];
    final url = Uri.tryParse(src ?? '');
    if (url != null && url.scheme == 'https' && url.host.isNotEmpty) {
      return url;
    }
  }
  return null;
}

class VideoPage extends StatefulWidget {
  const VideoPage({super.key, required this.titulo, required this.url});

  final String titulo;
  final Uri url;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool _error = false;
  int _intento = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.titulo)),
    body: SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Pulsa reproducir para ver el video disponible.'),
          ),
          Expanded(
            child: _error
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('No se pudo cargar el video.'),
                        TextButton(
                          onPressed: () => setState(() {
                            _error = false;
                            _intento++;
                          }),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                : InAppWebView(
                    key: ValueKey(_intento),
                    initialUrlRequest: URLRequest(
                      url: WebUri(widget.url.toString()),
                    ),
                    initialSettings: InAppWebViewSettings(
                      javaScriptEnabled: true,
                      allowsInlineMediaPlayback: true,
                      iframeAllow: 'autoplay; fullscreen',
                      iframeAllowFullscreen: true,
                    ),
                    onReceivedError: (controller, request, error) {
                      if (mounted && request.isForMainFrame == true) {
                        setState(() => _error = true);
                      }
                    },
                    onReceivedHttpError: (controller, request, response) {
                      if (mounted && request.isForMainFrame == true) {
                        setState(() => _error = true);
                      }
                    },
                  ),
          ),
        ],
      ),
    ),
  );
}
