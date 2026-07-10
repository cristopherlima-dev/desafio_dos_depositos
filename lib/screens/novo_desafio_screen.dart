import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Formata o número digitado com separador de milhar: 3000 → 3.000
class _MilharInputFormatter extends TextInputFormatter {
  static const int _maxDigitos = 9; // até 999.999.999

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitos = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitos.isEmpty) return const TextEditingValue();

    if (digitos.length > _maxDigitos) {
      digitos = digitos.substring(0, _maxDigitos);
    }
    final int numero = int.parse(digitos);

    final String texto = _comMilhar(numero);
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }

  static String _comMilhar(int numero) {
    final String s = numero.toString();
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}

/// Os três modos de distribuição dos valores entre os quadrados.
enum ModoDistribuicao {
  iguais('Valores iguais', 'Todos os quadrados valem o mesmo'),
  progressivo('Valores progressivos', 'Começa baixo e vai subindo'),
  aleatorio('Valores aleatórios', 'Sorteados uma vez, na criação');

  const ModoDistribuicao(this.titulo, this.descricao);
  final String titulo;
  final String descricao;
}

class NovoDesafioScreen extends StatefulWidget {
  const NovoDesafioScreen({super.key});

  @override
  State<NovoDesafioScreen> createState() => _NovoDesafioScreenState();
}

class _NovoDesafioScreenState extends State<NovoDesafioScreen> {
  static const Color _verde = Color(0xFF00C896);
  static const Color _escuro = Color(0xFF1F2430);
  static const Color _borda = Color(0xFFE6E8EE);

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

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

  // --- Novos estados do 6d ---
  int _quadrados = 100;
  ModoDistribuicao _modo = ModoDistribuicao.iguais;

  @override
  void dispose() {
    _nomeController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  OutlineInputBorder _borda_({Color cor = _borda, double largura = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: cor, width: largura),
    );
  }

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

  Widget _buildOpcaoEmoji(String emoji) {
    final bool selecionado = emoji == _emojiSelecionado;

    return GestureDetector(
      onTap: () => setState(() => _emojiSelecionado = emoji),
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

  /// Botão de quantidade (100 ou 200). Expandido pra dividir a largura.
  Widget _buildOpcaoQuadrados(int quantidade) {
    final bool selecionado = quantidade == _quadrados;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _quadrados = quantidade),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selecionado ? _verde : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selecionado ? _verde : _borda,
              width: selecionado ? 2 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$quantidade',
            style: TextStyle(
              color: selecionado ? Colors.white : _escuro,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// Card de modo de distribuição, com título, descrição e "bolinha" de rádio.
  Widget _buildOpcaoModo(ModoDistribuicao modo) {
    final bool selecionado = modo == _modo;

    return GestureDetector(
      onTap: () => setState(() => _modo = modo),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Selecionado: fundo verde bem clarinho (não chapado, pra não competir
          // com o texto). Mesma técnica ARGB do badge da Home.
          color: selecionado ? const Color(0x1400C896) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selecionado ? _verde : _borda,
            width: selecionado ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Bolinha de rádio desenhada na mão (2 círculos concêntricos).
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selecionado ? _verde : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: selecionado
                  ? Container(
                      width: 11,
                      height: 11,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: _verde,
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    modo.titulo,
                    style: const TextStyle(
                      color: _escuro,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    modo.descricao,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
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

              // --- Quantidade de quadrados ---
              _rotulo('Quantidade de quadrados'),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildOpcaoQuadrados(100),
                  const SizedBox(width: 12),
                  _buildOpcaoQuadrados(200),
                ],
              ),

              const SizedBox(height: 24),

              // --- Modo de distribuição ---
              _rotulo('Modo de distribuição'),
              const SizedBox(height: 12),
              ...ModoDistribuicao.values.map(_buildOpcaoModo),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
