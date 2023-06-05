class RecipeResponse {
  final bool? vegetarian;
  final bool? vegan;
  final bool? glutenFree;
  final bool? dairyFree;
  final bool? veryHealthy;
  final bool? cheap;
  final bool? veryPopular;
  final bool? sustainable;
  final bool? lowFodmap;
  final int? weightWatcherSmartPoints;
  final String? gaps;
  final int? preparationMinutes;
  final int? cookingMinutes;
  final int? aggregateLikes;
  final int? healthScore;
  final String? creditsText;
  final String? license;
  final String? sourceName;
  final double? pricePerServing;
  final List<ExtendedIngredient>? extendedIngredients;
  final int id;
  final String? title;
  final int? readyInMinutes;
  final int? servings;
  final String? sourceUrl;
  final String? image;
  final String? imageType;
  final String? summary;
  final List<String>? cuisines;
  final List<String>? dishTypes;
  final List<String>? diets;
  final List<dynamic>? occasions;
  final String? instructions;
  final List<AnalyzedInstruction>? analyzedInstructions;
  final dynamic originalId;
  final String? spoonacularSourceUrl;

  RecipeResponse({
    required this.vegetarian,
    required this.vegan,
    required this.glutenFree,
    required this.dairyFree,
    required this.veryHealthy,
    required this.cheap,
    required this.veryPopular,
    required this.sustainable,
    required this.lowFodmap,
    required this.weightWatcherSmartPoints,
    required this.gaps,
    required this.preparationMinutes,
    required this.cookingMinutes,
    required this.aggregateLikes,
    required this.healthScore,
    required this.creditsText,
    required this.license,
    required this.sourceName,
    required this.pricePerServing,
    required this.extendedIngredients,
    required this.id,
    required this.title,
    required this.readyInMinutes,
    required this.servings,
    required this.sourceUrl,
    required this.image,
    required this.imageType,
    required this.summary,
    required this.cuisines,
    required this.dishTypes,
    required this.diets,
    required this.occasions,
    required this.instructions,
    required this.analyzedInstructions,
    this.originalId,
    required this.spoonacularSourceUrl,
  });

  factory RecipeResponse.fromJson(Map<String, dynamic> json) => RecipeResponse(
        vegetarian: json["vegetarian"],
        vegan: json["vegan"],
        glutenFree: json["glutenFree"],
        dairyFree: json["dairyFree"],
        veryHealthy: json["veryHealthy"],
        cheap: json["cheap"],
        veryPopular: json["veryPopular"],
        sustainable: json["sustainable"],
        lowFodmap: json["lowFodmap"],
        weightWatcherSmartPoints: json["weightWatcherSmartPoints"],
        gaps: json["gaps"],
        preparationMinutes: json["preparationMinutes"],
        cookingMinutes: json["cookingMinutes"],
        aggregateLikes: json["aggregateLikes"],
        healthScore: json["healthScore"],
        creditsText: json["creditsText"],
        license: json["license"],
        sourceName: json["sourceName"],
        pricePerServing: json["pricePerServing"]?.toDouble(),
        extendedIngredients: List<ExtendedIngredient>.from(
            json["extendedIngredients"]
                .map((x) => ExtendedIngredient.fromJson(x))),
        id: json["id"],
        title: json["title"],
        readyInMinutes: json["readyInMinutes"],
        servings: json["servings"],
        sourceUrl: json["sourceUrl"],
        image: json["image"],
        imageType: json["imageType"],
        summary: json["summary"],
        cuisines: List<String>.from(json["cuisines"].map((x) => x)),
        dishTypes: List<String>.from(json["dishTypes"].map((x) => x)),
        diets: List<String>.from(json["diets"].map((x) => x)),
        occasions: List<dynamic>.from(json["occasions"].map((x) => x)),
        instructions: json["instructions"],
        analyzedInstructions: List<AnalyzedInstruction>.from(
            json["analyzedInstructions"]
                .map((x) => AnalyzedInstruction.fromJson(x))),
        originalId: json["originalId"],
        spoonacularSourceUrl: json["spoonacularSourceUrl"],
      );
}

class AnalyzedInstruction {
  final String? name;
  final List<Step>? steps;

  AnalyzedInstruction({
    required this.name,
    required this.steps,
  });

  factory AnalyzedInstruction.fromJson(Map<String, dynamic> json) =>
      AnalyzedInstruction(
        name: json["name"],
        steps: List<Step>.from(json["steps"].map((x) => Step.fromJson(x))),
      );
}

class Step {
  final int? number;
  final String? step;
  final List<Ent>? ingredients;
  final List<Ent>? equipment;
  final Length? length;

  Step({
    required this.number,
    required this.step,
    required this.ingredients,
    required this.equipment,
    this.length,
  });

  factory Step.fromJson(Map<String, dynamic> json) => Step(
        number: json["number"],
        step: json["step"],
        ingredients:
            List<Ent>.from(json["ingredients"].map((x) => Ent.fromJson(x))),
        equipment:
            List<Ent>.from(json["equipment"].map((x) => Ent.fromJson(x))),
        length: json["length"] == null ? null : Length.fromJson(json["length"]),
      );
}

class Ent {
  final int? id;
  final String? name;
  final String? localizedName;
  final String? image;
  final Length? temperature;

  Ent({
    required this.id,
    required this.name,
    required this.localizedName,
    required this.image,
    this.temperature,
  });

  factory Ent.fromJson(Map<String, dynamic> json) => Ent(
        id: json["id"],
        name: json["name"],
        localizedName: json["localizedName"],
        image: json["image"],
        temperature: json["temperature"] == null
            ? null
            : Length.fromJson(json["temperature"]),
      );
}

class Length {
  final double? number;
  final String? unit;

  Length({
    required this.number,
    required this.unit,
  });

  factory Length.fromJson(Map<String, dynamic> json) => Length(
        number: double.tryParse(json["number"]?.toString() ?? '0.0'),
        unit: json["unit"],
      );
}

class ExtendedIngredient {
  final int id;
  final String? aisle;
  final String? image;
  final String? consistency;
  final String? name;
  final String? nameClean;
  final String? original;
  final String? originalName;
  final double? amount;
  final String? unit;
  final List<String>? meta;
  final Measures? measures;

  ExtendedIngredient({
    required this.id,
    required this.aisle,
    this.image,
    required this.consistency,
    required this.name,
    this.nameClean,
    required this.original,
    required this.originalName,
    required this.amount,
    required this.unit,
    required this.meta,
    required this.measures,
  });

  factory ExtendedIngredient.fromJson(Map<String, dynamic> json) =>
      ExtendedIngredient(
        id: json["id"],
        aisle: json["aisle"],
        image: json["image"],
        consistency: json["consistency"],
        name: json["name"],
        nameClean: json["nameClean"],
        original: json["original"],
        originalName: json["originalName"],
        amount: json["amount"]?.toDouble(),
        unit: json["unit"],
        meta: List<String>.from(json["meta"].map((x) => x)),
        measures: Measures.fromJson(json["measures"]),
      );
}

class Measures {
  final Metric? us;
  final Metric? metric;

  Measures({
    required this.us,
    required this.metric,
  });

  factory Measures.fromJson(Map<String, dynamic> json) => Measures(
        us: Metric.fromJson(json["us"]),
        metric: Metric.fromJson(json["metric"]),
      );
}

class Metric {
  final double? amount;
  final String? unitShort;
  final String? unitLong;

  Metric({
    required this.amount,
    required this.unitShort,
    required this.unitLong,
  });

  factory Metric.fromJson(Map<String, dynamic> json) => Metric(
        amount: json["amount"]?.toDouble(),
        unitShort: json["unitShort"],
        unitLong: json["unitLong"],
      );
}
