import 'package:flutter/material.dart';
import 'novo_desafio_screen.dart';

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
  // Borda suave e trilho da barra (tons claros, combinam com o fundo F5F6FA).
  static const Color _borda = Color(0xFFE6E8EE);
  static const Color _trilho = Color(0xFFECEEF3);

  // --- Lista MOCKADA de desafios (hardcoded; vira model + estado depois) ---
  static const List<Map<String, dynamic>> _desafios = [
    {
      'emoji': '📱',
      'nome': 'Assinatura Anual',
      'feitos': 0,
      'quadrados': 100,
      'atual': 0.0,
      'meta': 400.0,
      'atualFmt': 'R\$ 0,00',
      'metaFmt': 'R\$ 400,00',
    },
    {
      'emoji': '💰',
      'nome': 'Reserva 10k',
      'feitos': 1,
      'quadrados': 200,
      'atual': 50.0,
      'meta': 10000.0,
      'atualFmt': 'R\$ 50,00',
      'metaFmt': 'R\$ 10.000,00',
    },
    {
      'emoji': '🎁',
      'nome': 'Macbook Air 13"',
      'feitos': 2,
      'quadrados': 200,
      'atual': 160.0,
      'meta': 16000.0,
      'atualFmt': 'R\$ 160,00',
      'metaFmt': 'R\$ 16.000,00',
    },
    {
      'emoji': '📲',
      'nome': 'Iphone 16 256GB',
      'feitos': 41,
      'quadrados': 200,
      'atual': 1230.0,
      'meta': 6000.0,
      'atualFmt': 'R\$ 1.230,00',
      'metaFmt': 'R\$ 6.000,00',
    },
  ];

  /// Monta um card de desafio a partir de um item mockado da lista.
  Widget _buildCardDesafio(Map<String, dynamic> d) {
    // Leitura "às cegas": se errar o nome da chave, só quebra em execução.
    final double atual = d['atual'] as double;
    final double meta = d['meta'] as double;
    final double progresso = meta == 0 ? 0 : atual / meta;
    final int percent = (progresso * 100).floor();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borda),
      ),
      child: Column(
        children: [
          // --- Linha 1: emoji + nome/quadrados + ações ---
          Row(
            children: [
              // Quadradinho verde com o emoji
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _verde,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  d['emoji'] as String,
                  style: const TextStyle(fontSize: 24),
                ),
              ),

              const SizedBox(width: 12),

              // Nome + contagem de quadrados
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d['nome'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _escuro,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${d['feitos']}/${d['quadrados']} quadrados marcados',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Editar / excluir — sem ação real ainda
              IconButton(
                onPressed: () {
                  debugPrint('Editar "${d['nome']}" (ainda sem ação)');
                },
                icon: const Icon(Icons.edit_outlined, size: 20),
                tooltip: 'Editar',
                color: Colors.grey.shade500,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                onPressed: () {
                  debugPrint('Excluir "${d['nome']}" (ainda sem ação)');
                },
                icon: const Icon(Icons.delete_outline, size: 20),
                tooltip: 'Excluir',
                color: Colors.grey.shade500,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),

          const SizedBox(height: 14),

          // --- Linha 2: percentual + valores ---
          Row(
            children: [
              Text(
                '$percent%',
                style: const TextStyle(
                  color: _escuro,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${d['atualFmt']} / ${d['metaFmt']}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // --- Linha 3: barra de progresso (mesma técnica do card verde) ---
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 8,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(color: _trilho),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progresso,
                    child: Container(color: _verde),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- Dados MOCKADOS do card de destaque ---
    const double total = 1440.0;
    const double meta = 32000.0;
    final double progresso = total / meta; // 0.045 → ~4,5%
    final int percent = (progresso * 100).floor(); // 4

    const String totalFmt = 'R\$ 1.440,00';
    const String metaFmt = 'R\$ 32.000,00';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // --- Linha do topo: badge + ações ---
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
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
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NovoDesafioScreen(),
                        ),
                      );
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
                    const Text(
                      'Você já juntou',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      totalFmt,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        height: 8,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Container(color: Colors.white24),
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

              // --- Lista de desafios (mockada) ---
              ..._desafios.map(_buildCardDesafio),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
