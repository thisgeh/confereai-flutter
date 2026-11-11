import 'package:flutter/material.dart';

import 'core/app_rotas.dart';
import 'core/app_tema.dart';
import 'repositories/preferencias_repository.dart';


class ConfereAiApp extends StatefulWidget {
  const ConfereAiApp({super.key});

  
  static ConfereAiAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<ConfereAiAppState>();
  }

  @override
  State<ConfereAiApp> createState() => ConfereAiAppState();
}

class ConfereAiAppState extends State<ConfereAiApp> {
  static const escalaNormal = 1.0;
  static const escalaGrande = 1.25;

  final _preferencias = PreferenciasRepository();
  double _escalaFonte = escalaNormal;

  bool get letraGrande => _escalaFonte > escalaNormal;

  @override
  void initState() {
    super.initState();
    _carregarEscala();
  }

  Future<void> _carregarEscala() async {
    final escala = await _preferencias.escalaFonte();
    if (!mounted) return;
    setState(() => _escalaFonte = escala);
  }

  Future<void> alternarTamanhoLetra() async {
    setState(() {
      _escalaFonte = letraGrande ? escalaNormal : escalaGrande;
    });
    await _preferencias.salvarEscalaFonte(_escalaFonte);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ConfereAí',
      debugShowCheckedModeBanner: false,
      theme: AppTema.claro,
      initialRoute: AppRotas.splash,
      onGenerateRoute: AppRotas.gerarRota,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(_escalaFonte),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
