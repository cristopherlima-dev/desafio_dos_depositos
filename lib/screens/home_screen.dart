import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Verde da marca (mesma seed do tema, em main.dart).
  static const Color _verde = Color(0xFF00C896);
  // Cinza-escuro do texto principal (traduz o "branco" do print p/ o light mode).
  static const Color _escuro = Color(0xFF1F2430);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // --- Linha do topo: badge centralizado + engrenagem à direita ---
              Stack(
                alignment: Alignment.center,
                children: [
                  // Badge "✨ Desafio Financeiro"
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      // 0x1F = ~12% de opacidade sobre o verde (const, sem withOpacity).
                      color: const Color(0x1F00C896),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      '💰 Desafio dos Depósitos',
                      style: TextStyle(
                        color: _verde,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  // Engrenagem (configurações) — sem ação real ainda
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        debugPrint('Configurações (ainda sem ação)');
                      },
                      icon: const Icon(Icons.settings),
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // --- Título com duas cores ---
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Junte dinheiro\n',
                      style: TextStyle(color: _escuro),
                    ),
                    TextSpan(
                      text: 'brincando',
                      style: TextStyle(color: _verde),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  height: 1.15,
                ),
              ),

              const SizedBox(height: 8),

              // --- Subtítulo ---
              Text(
                'quadrado marcado = depósito feito',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
