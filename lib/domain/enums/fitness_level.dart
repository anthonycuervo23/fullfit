enum FitnessLevel {
  veryLow,
  low,
  moderate,
  good,
  veryGood,
  excellent,
}

extension FitnessLevelExtension on FitnessLevel {
  String get level {
    switch (this) {
      case FitnessLevel.veryLow:
        return 'Muy baja';
      case FitnessLevel.low:
        return 'Baja';
      case FitnessLevel.moderate:
        return 'Moderada';
      case FitnessLevel.good:
        return 'Buena';
      case FitnessLevel.veryGood:
        return 'Muy buena';
      case FitnessLevel.excellent:
        return 'Excelente';
      default:
        return 'Muy bajo';
    }
  }

  String get description {
    switch (this) {
      case FitnessLevel.veryLow:
        return 'Raramente hago ejercicio o actividad física.';
      case FitnessLevel.low:
        return 'Ocasionalmente hago ejercicios ligeros.';
      case FitnessLevel.moderate:
        return 'Realizo alguna forma de ejercicio regularmente.';
      case FitnessLevel.good:
        return 'Hago ejercicio frecuentemente e intensivamente.';
      case FitnessLevel.veryGood:
        return 'Participo en ejercicios o deportes de alta intensidad.';
      case FitnessLevel.excellent:
        return 'Participo regularmente en deportes competitivos y ejercicios de alta intensidad.';
      default:
        return 'Raramente hago ejercicio o actividad física.';
    }
  }

  String get title {
    switch (this) {
      case FitnessLevel.veryLow:
        return 'Intensidad Muy Baja';
      case FitnessLevel.low:
        return 'Intensidad Baja';
      case FitnessLevel.moderate:
        return 'Intensidad Media';
      case FitnessLevel.good:
        return 'Buena Intensidad';
      case FitnessLevel.veryGood:
        return 'Muy Buena Intensidad';
      case FitnessLevel.excellent:
        return 'Excelente Intensidad';
      default:
        return 'Intensidad Muy Baja';
    }
  }
}

FitnessLevel stringToFitnessLevel(String input) =>
    FitnessLevel.values.firstWhere(
      (element) => element.name == input,
      orElse: () => FitnessLevel.veryLow,
    );
