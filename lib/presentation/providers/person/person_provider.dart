import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/domain/repositories/repositories.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

final personProvider =
    StateNotifierProvider<PersonNotifier, PersonState>((ref) {
  final personRepository = ref.watch(personRepositoryProvider);
  return PersonNotifier(personRepository: personRepository);
});

class PersonNotifier extends StateNotifier<PersonState> {
  final PersonRepository _personRepository;
  PersonNotifier({required personRepository})
      : _personRepository = personRepository,
        super(PersonState());

  Future<void> setUser() async {
    await _personRepository.getUserData();
    Person? person = _personRepository.person;
    state = state.copyWith(person: person);
  }

  void clearUser() {
    state = state.copyWith(clear: true);
  }

  Person? get user => state.person;

  bool get isUserLoggedIn => state.person != null;

  //update user data
  void updateUserData(Person person) {
    state = state.copyWith(person: person);
  }
}

class PersonState {
  final Person? person;
  PersonState({this.person});

  PersonState copyWith({Person? person, bool clear = false}) {
    return PersonState(person: clear ? null : person ?? this.person);
  }
}
