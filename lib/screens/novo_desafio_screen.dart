import 'package:flutter/material.dart';

class NovoDesafioScreen extends StatefulWidget {
  const NovoDesafioScreen({super.key});

  @override
  State<NovoDesafioScreen> createState() => _NovoDesafioScreenState();
}

class _NovoDesafioScreenState extends State<NovoDesafioScreen> {
  // Mesmas cores da HomeScreen (por ora duplicadas; centralizar depois).
  static const Color _escuro = Color(0xFF1F2430);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Sem cor de fundo própria: deixa o F5F6FA do tema aparecer.
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
        // A seta de voltar é inserida automaticamente pelo Navigator.
        iconTheme: const IconThemeData(color: _escuro),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(child: Text('Esqueleto da tela — conteúdo vem no 6b')),
        ),
      ),
    );
  }
}
