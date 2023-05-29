// forzar a que la primera letra de una cadena sea mayuscula
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
