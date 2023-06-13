enum FitnessGoal {
  loseWeight,
  improveBodyComposition,
  gainMuscle,
  increaseDefinitionMuscle,
}

extension FitnessGoalExtension on FitnessGoal {
  String get goal {
    switch (this) {
      case FitnessGoal.loseWeight:
        return 'Perder peso';
      case FitnessGoal.improveBodyComposition:
        return 'Mejorar composición corporal';
      case FitnessGoal.gainMuscle:
        return 'Ganar músculo';
      case FitnessGoal.increaseDefinitionMuscle:
        return 'Aumentar definición muscular';
      default:
        return 'Perder peso';
    }
  }
}

FitnessGoal stringToFitnessGoal(String input) => FitnessGoal.values.firstWhere(
      (element) => element.goal == input,
      orElse: () => FitnessGoal.loseWeight,
    );

List<FitnessGoal> stringListToFitnessGoalList(List<dynamic> inputList) {
  return inputList
      .map((input) => stringToFitnessGoal(input.toString()))
      .toList();
}
