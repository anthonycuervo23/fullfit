import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/infrastructure/repositories/auth_repository_impl.dart';

final authRepositoryProvider =
    Provider<AuthRepositoryImpl>((ref) => AuthRepositoryImpl());
