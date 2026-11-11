import 'package:confereai/models/nivel_risco.dart';
import 'package:confereai/models/pergunta_golpe.dart';
import 'package:confereai/widgets/card_pergunta.dart';
import 'package:confereai/widgets/estados.dart';
import 'package:confereai/widgets/semaforo_risco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget envolver(Widget filho) {
  return MaterialApp(home: Scaffold(body: SingleChildScrollView(child: filho)));
}

void main() {
  testWidgets('SemaforoRisco mostra o título do nível', (tester) async {
    await tester.pumpWidget(envolver(const SemaforoRisco(nivel: NivelRisco.alto)));

    expect(find.text(NivelRisco.alto.titulo), findsOneWidget);
  });

  testWidgets('EstadoErro chama a função ao tocar em "Tentar novamente"',
      (tester) async {
    
    var tentativas = 0;
    await tester.pumpWidget(envolver(
      EstadoErro(mensagem: 'Sem internet', onTentarNovamente: () => tentativas++),
    ));

  
    await tester.tap(find.text('Tentar novamente'));
    await tester.pump();

  
    expect(find.text('Sem internet'), findsOneWidget);
    expect(tentativas, 1);
  });

  testWidgets('CardPergunta informa a resposta escolhida', (tester) async {
    bool? resposta;
    await tester.pumpWidget(envolver(
      CardPergunta(
        numero: 1,
        pergunta: PerguntasGolpe.todas.first,
        resposta: null,
        onResponder: (valor) => resposta = valor,
      ),
    ));

    await tester.tap(find.text('Sim'));
    expect(resposta, isTrue);

    await tester.tap(find.text('Não'));
    expect(resposta, isFalse);
  });
}
