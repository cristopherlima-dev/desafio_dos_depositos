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
    // --- Dados MOCKADOS (hardcoded por enquanto; viram model/lógica depois) ---
    const double total = 1440.0;
    const double meta = 32000.0;
    final double progresso = total / meta; // 0.045 → ~4,5%
    final int percent = (progresso * 100).floor(); // 4

    // Valores em R$ como string fixa (sem intl ainda; formatação real vem depois).
    const String totalFmt = 'R\$ 1.440,00';
    const String metaFmt = 'R\$ 32.000,00';

    return Scaffold(
      body: SafeArea(
        // Corpo rolável: prepara o terreno pra lista de desafios (Item 5).
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // --- Linha do topo: badge + ações (novo desafio / configurações) ---
              Row(
                children: [
                  // Badge centralizado no espaço que sobra à esquerda dos ícones.
                  Expanded(
                    child: Center(
                      child: Container(
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
                    ),
                  ),

                  // Botão "+" (criar novo desafio) — sem ação real ainda
                  IconButton(
                    onPressed: () {
                      debugPrint('Criar novo desafio (ainda sem ação)');
                    },
                    icon: const Icon(Icons.add, size: 20),
                    tooltip: 'Criar novo desafio',
                    style: IconButton.styleFrom(
                      backgroundColor: _verde,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      minimumSize: const Size(36, 36),
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),

                  const SizedBox(width: 6),

                  // Engrenagem (configurações) — sem ação real ainda
                  IconButton(
                    onPressed: () {
                      debugPrint('Configurações (ainda sem ação)');
                    },
                    icon: const Icon(Icons.settings),
                    tooltip: 'Configurações',
                    color: Colors.grey.shade600,
                    style: IconButton.styleFrom(
                      minimumSize: const Size(40, 40),
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

              const SizedBox(height: 24),

              // --- Card de destaque: "Você já juntou" ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF00C896), Color(0xFF00A382)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rótulo
                    const Text(
                      'Você já juntou',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Valor grande
                    const Text(
                      totalFmt,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Barra de progresso (custom)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        height: 8,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            // Trilho (fundo translúcido)
                            Container(color: Colors.white24),
                            // Preenchimento (fração da largura, ancorado à esquerda)
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progresso,
                              child: Container(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Rodapé: percentual + meta
                    Text(
                      '$percent% da sua meta de $metaFmt',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
