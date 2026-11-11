import 'package:confereai/models/consulta.dart';
import 'package:confereai/models/contato_confianca.dart';
import 'package:confereai/models/nivel_risco.dart';
import 'package:confereai/repositories/contatos_repository.dart';
import 'package:confereai/repositories/historico_repository.dart';
import 'package:confereai/repositories/preferencias_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Consulta criarConsulta(String id) {
  return Consulta(
    id: id,
    tipo: TipoConsulta.golpe,
    titulo: 'Consulta $id',
    nivel: NivelRisco.baixo,
    pontuacao: 0,
    data: DateTime(2026, 11, 9),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // SharedPreferences em memória para os testes.
    SharedPreferences.setMockInitialValues({});
  });

  group('PreferenciasRepository', () {
    test('onboarding começa como não visto', () async {
      expect(await PreferenciasRepository().onboardingVisto(), isFalse);
    });

    test('deve salvar a opção "Não mostrar novamente"', () async {
      final repositorio = PreferenciasRepository();

      await repositorio.salvarOnboardingVisto(true);

      expect(await repositorio.onboardingVisto(), isTrue);
    });
  });

  group('HistoricoRepository', () {
    late HistoricoRepository repositorio;

    setUp(() {
      repositorio = HistoricoRepository();
    });

    test('consulta mais recente deve ficar no topo', () async {
      await repositorio.adicionar(criarConsulta('1'));
      await repositorio.adicionar(criarConsulta('2'));

      final consultas = await repositorio.listar();

      expect(consultas.map((c) => c.id), ['2', '1']);
    });

    test('atualizar deve marcar a consulta como confiável', () async {
      final consulta = criarConsulta('1');
      await repositorio.adicionar(consulta);

      await repositorio.atualizar(consulta.copyWith(confiavel: true));

      expect((await repositorio.listar()).single.confiavel, isTrue);
    });

    test('remover deve apagar só a consulta escolhida', () async {
      await repositorio.adicionar(criarConsulta('1'));
      await repositorio.adicionar(criarConsulta('2'));

      await repositorio.remover('1');

      expect((await repositorio.listar()).single.id, '2');
    });

    test('histórico deve guardar no máximo 50 consultas', () async {
      for (var i = 0; i < 55; i++) {
        await repositorio.adicionar(criarConsulta('$i'));
      }

      expect((await repositorio.listar()).length, HistoricoRepository.limite);
    });
  });

  group('ContatosRepository', () {
    test('primeiro contato cadastrado é o principal', () async {
      final repositorio = ContatosRepository();

      await repositorio.adicionar(
        const ContatoConfianca(id: '1', nome: 'Ana', telefone: '11999990000'),
      );
      await repositorio.adicionar(
        const ContatoConfianca(id: '2', nome: 'Beto', telefone: '11988880000'),
      );

      expect((await repositorio.principal())?.nome, 'Ana');
    });

    test('definirPrincipal deve mover o contato para o topo', () async {
      final repositorio = ContatosRepository();
      await repositorio.adicionar(
        const ContatoConfianca(id: '1', nome: 'Ana', telefone: '11999990000'),
      );
      await repositorio.adicionar(
        const ContatoConfianca(id: '2', nome: 'Beto', telefone: '11988880000'),
      );

      await repositorio.definirPrincipal('2');

      expect((await repositorio.principal())?.nome, 'Beto');
    });
  });
}
