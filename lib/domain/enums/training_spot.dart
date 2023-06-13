enum TrainingSpot {
  gym,
  home,
  outdoor,
}

extension TrainingSpotExtension on TrainingSpot {
  String get spot {
    switch (this) {
      case TrainingSpot.gym:
        return 'Gimnasio';
      case TrainingSpot.home:
        return 'Casa';
      case TrainingSpot.outdoor:
        return 'Aire libre';
      default:
        return 'Gimnasio';
    }
  }
}

TrainingSpot stringToTrainingSpot(String input) =>
    TrainingSpot.values.firstWhere(
      (element) => element.spot == input,
      orElse: () => TrainingSpot.gym,
    );
