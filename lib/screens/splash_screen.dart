import 'package:flutter/material.dart';

import '../core/app_cores.dart';
import '../core/app_rotas.dart';
import '../repositories/preferencias_repository.dart';
import '../widgets/logo_confereai.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.repositorio,
    this.duracao = const Duration(seconds: 2),
  });

  final PreferenciasRepository? repositorio;
  final Duration duracao;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    final repositorio = widget.repositorio ?? PreferenciasRepository();

    final resultados = await Future.wait<Object?>([
      repositorio.onboardingVisto(),
      Future<void>.delayed(widget.duracao),
    ]);
    final onboardingVisto = resultados.first as bool;

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      onboardingVisto ? AppRotas.home : AppRotas.onboarding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.primaria,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const LogoConfereAi(tamanho: 130),
              ),
              const SizedBox(height: 28),
              const Text(
                'ConfereAí',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Confira antes de pagar',
                style: TextStyle(fontSize: 20, color: Colors.white70),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
