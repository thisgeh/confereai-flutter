import 'package:url_launcher/url_launcher.dart';

import '../core/formatadores.dart';


class LigacaoService {
  Future<bool> ligar(String telefone) async {
    final numero = Formatadores.somenteNumeros(telefone);
    if (numero.isEmpty) return false;

    try {
      return await launchUrl(Uri(scheme: 'tel', path: numero));
    } catch (_) {
      return false;
    }
  }
}
