import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/domain/datasources/datasources.dart';
import 'package:fullfit_app/domain/entities/entities.dart';
import 'package:fullfit_app/infrastructure/datasources/datasources.dart';

final userProvider = StateNotifierProvider<PersonNotifier, PersonState>((ref) {
  final personDatasource = PersonDatasourceImpl();
  return PersonNotifier(personDatasource: personDatasource);
});

class PersonNotifier extends StateNotifier<PersonState> {
  final PersonDatasource _personDatasource;
  PersonNotifier({required personDatasource})
      : _personDatasource = personDatasource,
        super(PersonState());

  Future<void> setUser() async {
    await _personDatasource.getUserData();
    Person? person = _personDatasource.person;
    state = state.copyWith(person: person);
  }

  void clearUser() {
    state = state.copyWith(person: null);
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

  PersonState copyWith({Person? person}) {
    return PersonState(person: person ?? this.person);
  }
}
