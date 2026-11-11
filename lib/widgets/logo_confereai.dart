import 'package:flutter/material.dart';


class LogoConfereAi extends StatelessWidget {
  const LogoConfereAi({super.key, this.tamanho = 120});

  static const caminho = 'assets/images/logo.png';

  final double tamanho;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      caminho,
      width: tamanho,
      height: tamanho,
      fit: BoxFit.contain,
      semanticLabel: 'Logo do ConfereAí',
    );
  }
}
