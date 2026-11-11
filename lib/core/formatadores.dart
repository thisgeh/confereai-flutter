
class Formatadores {
  Formatadores._();

  static String data(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
  }


  static String dataHora(DateTime data) {
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');
    return '${Formatadores.data(data)} às $hora:$minuto';
  }


  static String tempoDesde(DateTime inicio, DateTime agora) {
    final dias = agora.difference(inicio).inDays;

    if (dias <= 0) return 'hoje';
    if (dias == 1) return 'há 1 dia';
    if (dias < 60) return 'há $dias dias';

    final meses = dias ~/ 30;
    if (dias < 365) return 'há $meses meses';

    final anos = dias ~/ 365;
    return anos == 1 ? 'há 1 ano' : 'há $anos anos';
  }


  static String somenteNumeros(String valor) {
    return valor.replaceAll(RegExp(r'\D'), '');
  }
}
