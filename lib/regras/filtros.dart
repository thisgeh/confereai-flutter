import '../models/banco.dart';
import '../models/consulta.dart';
import '../models/nivel_risco.dart';
import 'texto_util.dart';


class FiltroBancos {
  FiltroBancos._();

  static List<Banco> filtrar(List<Banco> bancos, String termo) {
    final busca = termo.trim();
    if (busca.isEmpty) return bancos;

    final somenteNumeros = RegExp(r'^\d+$').hasMatch(busca);

    if (somenteNumeros) {
      
      final codigo = int.parse(busca.length > 3 ? busca.substring(0, 3) : busca);
      return bancos.where((b) => b.codigo == codigo).toList();
    }

    final termoNormalizado = TextoUtil.normalizar(busca);

    return bancos.where((b) {
      final nomes = TextoUtil.normalizar('${b.nome} ${b.nomeCompleto}');
      return nomes.contains(termoNormalizado);
    }).toList();
  }


  static List<Banco> ordenar(List<Banco> bancos) {
    final copia = [...bancos];
    copia.sort((a, b) {
      if (a.codigo == null && b.codigo == null) return a.nome.compareTo(b.nome);
      if (a.codigo == null) return 1;
      if (b.codigo == null) return -1;
      return a.codigo!.compareTo(b.codigo!);
    });
    return copia;
  }
}


enum FiltroConsulta {
  todas('Todas'),
  alto('Perigo'),
  medio('Atenção'),
  baixo('Seguras'),
  confiaveis('Confiáveis');

  const FiltroConsulta(this.rotulo);
  final String rotulo;
}

class FiltroHistorico {
  FiltroHistorico._();

  static List<Consulta> filtrar(List<Consulta> consultas, FiltroConsulta filtro) {
    switch (filtro) {
      case FiltroConsulta.todas:
        return consultas;
      case FiltroConsulta.alto:
        return consultas.where((c) => c.nivel == NivelRisco.alto).toList();
      case FiltroConsulta.medio:
        return consultas.where((c) => c.nivel == NivelRisco.medio).toList();
      case FiltroConsulta.baixo:
        return consultas.where((c) => c.nivel == NivelRisco.baixo).toList();
      case FiltroConsulta.confiaveis:
        return consultas.where((c) => c.confiavel).toList();
    }
  }
}
