class Ingredient {
  final int id;
  final String name;
  final String image;
  final String nameClean;
  final String amount;
  final String unit;

  const Ingredient({
    required this.id,
    required this.name,
    required this.nameClean,
    required this.image,
    required this.amount,
    required this.unit,
  });
}
