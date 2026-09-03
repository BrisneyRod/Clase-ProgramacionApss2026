import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int contador = 0;

  void incrementar() {
    setState(() {
      contador++;
    });
  }

  void disminuir() {
    setState(() {
      contador--;
    });
  }

  void reiniciar() {
    setState(() {
      contador = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 35),

                // IMAGEN DEL GATO
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1573865526739-10659fec78a5',
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                          width: 140,
                          height: 140,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 48,
                          ),
                        ),
                  ),
                ),

                const SizedBox(height: 25),

                // BOTÓN RESET
                ElevatedButton(
                  onPressed: reiniciar,
                  child: const Text('Reset', style: TextStyle(fontSize: 16)),
                ),

                const SizedBox(height: 25),

                // TEXTO CONTADOR
                const Text(
                  'Contador',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 5),

                // NÚMERO
                Text(
                  '$contador',
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                // BOTONES - Y +
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 60,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: disminuir,
                          child: const Text(
                            '-',
                            style: TextStyle(fontSize: 26),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: 60,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: incrementar,
                          child: const Text(
                            '+',
                            style: TextStyle(fontSize: 26),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // BOTÓN INFERIOR
                ElevatedButton(
                  onPressed: null,
                  child: const Text('Botón', style: TextStyle(fontSize: 16)),
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
