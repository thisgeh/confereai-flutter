import 'package:shared_preferences/shared_preferences.dart';


class PreferenciasRepository {
  static const chaveOnboardingVisto = 'onboarding_visto';
  static const chaveEscalaFonte = 'escala_fonte';

  Future<bool> onboardingVisto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(chaveOnboardingVisto) ?? false;
  }

  Future<void> salvarOnboardingVisto(bool visto) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(chaveOnboardingVisto, visto);
  }

  Future<double> escalaFonte() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(chaveEscalaFonte) ?? 1.0;
  }

  Future<void> salvarEscalaFonte(double escala) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(chaveEscalaFonte, escala);
  }
}
