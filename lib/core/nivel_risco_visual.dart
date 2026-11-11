import 'package:flutter/material.dart';

import '../models/nivel_risco.dart';
import 'app_cores.dart';


extension NivelRiscoVisual on NivelRisco {
  Color get cor {
    switch (this) {
      case NivelRisco.baixo:
        return AppCores.riscoBaixo;
      case NivelRisco.medio:
        return AppCores.riscoMedio;
      case NivelRisco.alto:
        return AppCores.riscoAlto;
    }
  }

  Color get corFundo {
    switch (this) {
      case NivelRisco.baixo:
        return AppCores.fundoRiscoBaixo;
      case NivelRisco.medio:
        return AppCores.fundoRiscoMedio;
      case NivelRisco.alto:
        return AppCores.fundoRiscoAlto;
    }
  }

  IconData get icone {
    switch (this) {
      case NivelRisco.baixo:
        return Icons.check_circle;
      case NivelRisco.medio:
        return Icons.warning_amber_rounded;
      case NivelRisco.alto:
        return Icons.dangerous;
    }
  }
}
