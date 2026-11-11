import 'package:flutter/material.dart';

import '../models/argumentos.dart';
import '../models/avaliacao.dart';
import '../models/banco.dart';
import '../models/consulta.dart';
import '../screens/banco_detalhe_screen.dart';
import '../screens/bancos_screen.dart';
import '../screens/conferir_empresa_screen.dart';
import '../screens/consulta_detalhe_screen.dart';
import '../screens/contatos_screen.dart';
import '../screens/historico_screen.dart';
import '../screens/home_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/questionario_screen.dart';
import '../screens/resultado_screen.dart';
import '../screens/splash_screen.dart';


class AppRotas {
  AppRotas._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const conferirEmpresa = '/conferir-empresa';
  static const questionario = '/questionario';
  static const resultado = '/resultado';
  static const bancos = '/bancos';
  static const bancoDetalhe = '/banco-detalhe';
  static const historico = '/historico';
  static const consultaDetalhe = '/consulta-detalhe';
  static const contatos = '/contatos';

  static Route<dynamic> gerarRota(RouteSettings settings) {
    final argumentos = settings.arguments;

    final Widget tela;
    switch (settings.name) {
      case splash:
        tela = const SplashScreen();
      case onboarding:
        tela = OnboardingScreen(abertoPelaHome: argumentos == true);
      case home:
        tela = const HomeScreen();
      case conferirEmpresa:
        tela = const ConferirEmpresaScreen();
      case questionario:
        tela = QuestionarioScreen(
          argumentos: argumentos is QuestionarioArgumentos
              ? argumentos
              : const QuestionarioArgumentos(),
        );
      case resultado:
        tela = ResultadoScreen(contexto: argumentos as ContextoAvaliacao);
      case bancos:
        tela = const BancosScreen();
      case bancoDetalhe:
        tela = BancoDetalheScreen(banco: argumentos as Banco);
      case historico:
        tela = const HistoricoScreen();
      case consultaDetalhe:
        tela = ConsultaDetalheScreen(consulta: argumentos as Consulta);
      case contatos:
        tela = const ContatosScreen();
      default:
        tela = const HomeScreen();
    }

    return MaterialPageRoute(builder: (_) => tela, settings: settings);
  }
}
