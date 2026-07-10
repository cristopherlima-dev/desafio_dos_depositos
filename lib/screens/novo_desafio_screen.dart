import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Formata o número digitado com separador de milhar: 3000 → 3.000
///
/// Só cuida do separador. O "R$ " é desenhado pelo campo (prefixText),
/// então o usuário nunca consegue apagá-lo sem querer.
class _MilharInputFormatter extends TextInputFormatter {
  static const int _maxDigitos = 9; // até 999.999.999

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 1. Joga fora tudo que não é dígito (inclusive os pontos antigos).
    String digitos = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // 2. Campo vazio: deixa vazio (senão o usuário não consegue apagar tudo).
    if (digitos.isEmpty) return const TextEditingValue();

    // 3. Trava o tamanho e remove zeros à esquerda ("007" → "7").
    if (digitos.length > _maxDigitos) {
      digitos = digitos.substring(0, _maxDigitos);
    }
    final int numero = int.parse(digitos);

    // 4. Reinsere os pontos e joga o cursor pro fim.
    final String texto = _comMilhar(numero);
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }

  /// 3000 → "3.000" · 1234567 → "1.234.567"
  static String _comMilhar(int numero) {
    final String s = numero.toString();
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      // Ponto a cada 3 dígitos contados da direita pra esquerda.
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}

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

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  // Valor total em REAIS inteiros (sem centavos). Vira centavos na fase de lógica.
  int _valorEmReais = 0;

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

  String _emojiSelecionado = '💰';

  @override
  void dispose() {
    _nomeController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  /// Borda padrão dos campos (evita repetir o OutlineInputBorder 3x por campo).
  OutlineInputBorder _borda_({Color cor = _borda, double largura = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: cor, width: largura),
    );
  }

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

  /// Rótulo padrão das seções do formulário.
  Widget _rotulo(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        color: _escuro,
        fontSize: 15,
        fontWeight: FontWeight.w600,
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
              _rotulo('Nome do desafio'),
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
                  border: _borda_(),
                  enabledBorder: _borda_(),
                  focusedBorder: _borda_(cor: _verde, largura: 2),
                ),
              ),

              const SizedBox(height: 8),

              // --- Seleção de ícone ---
              _rotulo('Escolha um ícone'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _emojis.map(_buildOpcaoEmoji).toList(),
              ),

              const SizedBox(height: 24),

              // --- Campo: valor total ---
              _rotulo('Valor total'),
              const SizedBox(height: 8),
              TextField(
                controller: _valorController,
                keyboardType: TextInputType.number,
                inputFormatters: [_MilharInputFormatter()],
                style: const TextStyle(
                  color: _escuro,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (texto) {
                  // Guarda o número puro. Sem setState: nada na tela depende
                  // dele ainda. A validação em tempo real chega na fase de lógica.
                  final digitos = texto.replaceAll(RegExp(r'[^0-9]'), '');
                  _valorEmReais = digitos.isEmpty ? 0 : int.parse(digitos);
                  debugPrint('Valor: $_valorEmReais');
                },
                decoration: InputDecoration(
                  prefixText: 'R\$ ',
                  prefixStyle: const TextStyle(
                    color: _escuro,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  hintText: '0',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  helperText: 'Somente valores inteiros, sem centavos',
                  helperStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: _borda_(),
                  enabledBorder: _borda_(),
                  focusedBorder: _borda_(cor: _verde, largura: 2),
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
