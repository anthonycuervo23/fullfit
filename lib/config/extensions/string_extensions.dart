extension StringExtension on String {
  // forzar a que la primera letra de una cadena sea mayuscula
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  //traducir genero (male o female) al español
  String translate() {
    switch (toUpperCase()) {
      case 'MALE':
        return 'Hombre';
      case 'FEMALE':
        return 'Mujer';
      default:
        return 'Hombre';
    }
  }
}
