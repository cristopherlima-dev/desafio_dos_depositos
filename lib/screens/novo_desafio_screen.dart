import 'package:flutter/material.dart';

class NovoDesafioScreen extends StatefulWidget {
  const NovoDesafioScreen({super.key});

  @override
  State<NovoDesafioScreen> createState() => _NovoDesafioScreenState();
}

class _NovoDesafioScreenState extends State<NovoDesafioScreen> {
  // Mesmas cores da HomeScreen (por ora duplicadas; centralizar depois).
  static const Color _verde = Color(0xFF00C896);
  static const Color _escuro = Color(0xFF1F2430);
  static const Color _borda = Color(0xFFE6E8EE);

  // Controla o texto digitado no campo de nome.
  final TextEditingController _nomeController = TextEditingController();

  // Opções de ícone. Uma lista simples de emojis.
  static const List<String> _emojis = [
    '💰',
    '🎯',
    '📱',
    '💻',
    '🎁',
    '✈️',
    '🏠',
    '🚗',
    '🎓',
    '💍',
    '🏖️',
    '📚',
  ];

  // Estado da seleção: começa com um default (nunca fica vazio).
  String _emojiSelecionado = '💰';

  @override
  void dispose() {
    // Libera o controller quando a tela sai da árvore. Sem isso, vaza memória.
    _nomeController.dispose();
    super.dispose();
  }

  /// Monta um quadradinho de emoji selecionável.
  Widget _buildOpcaoEmoji(String emoji) {
    final bool selecionado = emoji == _emojiSelecionado;

    return GestureDetector(
      onTap: () {
        setState(() {
          _emojiSelecionado = emoji;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: selecionado ? _verde : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selecionado ? _verde : _borda,
            width: selecionado ? 2 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(emoji, style: const TextStyle(fontSize: 26)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Novo desafio',
          style: TextStyle(
            color: _escuro,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: _escuro),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // --- Campo: nome do desafio ---
              const Text(
                'Nome do desafio',
                style: TextStyle(
                  color: _escuro,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nomeController,
                maxLength: 30,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(color: _escuro, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Ex: Reserva de emergência',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: _borda),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: _borda),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: _verde, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // --- Seleção de ícone ---
              const Text(
                'Escolha um ícone',
                style: TextStyle(
                  color: _escuro,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _emojis.map(_buildOpcaoEmoji).toList(),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
