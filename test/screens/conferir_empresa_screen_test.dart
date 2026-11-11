import 'dart:convert';

import 'package:confereai/core/app_tema.dart';
import 'package:confereai/screens/conferir_empresa_screen.dart';
import 'package:confereai/services/brasil_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';


void usarTelaAlta(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Widget criarTela(http.Client cliente) {
  return MaterialApp(
    theme: AppTema.claro,
    home: ConferirEmpresaScreen(api: BrasilApiService(client: cliente)),
  );
}

void main() {
  testWidgets('estado inicial mostra a orientação', (tester) async {
    await tester.pumpWidget(criarTela(MockClient((_) async => http.Response('', 200))));

    expect(find.text('Pronto para conferir'), findsOneWidget);
  });

  testWidgets('CNPJ inválido mostra erro de validação', (tester) async {
    await tester.pumpWidget(criarTela(MockClient((_) async => http.Response('', 200))));

    await tester.enterText(find.byKey(const Key('campo_cnpj')), '11111111111111');
    await tester.tap(find.text('Conferir agora'));
    await tester.pump();

    expect(find.text('Esse CNPJ não é válido. Confira os números.'), findsOneWidget);
  });

  testWidgets('sucesso mostra os dados da empresa', (tester) async {
    // Arrange
    usarTelaAlta(tester);
    final cliente = MockClient((_) async {
      return http.Response.bytes(
        utf8.encode(jsonEncode({
          'cnpj': '19131243000197',
          'razao_social': 'OPEN KNOWLEDGE BRASIL',
          'descricao_situacao_cadastral': 'ATIVA',
          'data_inicio_atividade': '2013-10-03',
        })),
        200,
      );
    });
    await tester.pumpWidget(criarTela(cliente));

    
    await tester.enterText(find.byKey(const Key('campo_cnpj')), '19131243000197');
    await tester.tap(find.text('Conferir agora'));
    await tester.pumpAndSettle();

    expect(find.text('OPEN KNOWLEDGE BRASIL'), findsOneWidget);
    expect(find.text('Situação: ATIVA'), findsOneWidget);
  });

  testWidgets('erro mostra mensagem e botão para tentar novamente',
      (tester) async {
    usarTelaAlta(tester);
    await tester.pumpWidget(
      criarTela(MockClient((_) async => http.Response('{}', 404))),
    );

    await tester.enterText(find.byKey(const Key('campo_cnpj')), '19131243000197');
    await tester.tap(find.text('Conferir agora'));
    await tester.pumpAndSettle();

    expect(find.text('Algo deu errado'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsOneWidget);
  });
}
