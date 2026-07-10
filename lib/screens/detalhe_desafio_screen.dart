import 'package:flutter/material.dart';

class DetalheDesafioScreen extends StatefulWidget {
  /// Recebe o desafio a ser exibido. Ainda é um Map mockado — vira `Desafio`
  /// (model tipado) na fase de lógica.
  const DetalheDesafioScreen({super.key, required this.desafio});

  final Map<String, dynamic> desafio;

  @override
  State<DetalheDesafioScreen> createState() => _DetalheDesafioScreenState();
}

class _DetalheDesafioScreenState extends State<DetalheDesafioScreen> {
  static const Color _escuro = Color(0xFF1F2430);

  @override
  Widget build(BuildContext context) {
    // `widget.desafio` — o State acessa os dados do widget pelo prefixo `widget.`
    final String nome = widget.desafio['nome'] as String;
    final String emoji = widget.desafio['emoji'] as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '$emoji  $nome',
          style: const TextStyle(
            color: _escuro,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: _escuro),
      ),
      body: const SafeArea(
        child: Center(child: Text('Cabeçalho vem no 7b · Grade no 7c')),
      ),
    );
  }
}
