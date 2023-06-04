import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/infrastructure/repositories/auth_repository_impl.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final storageService = ref.read(keyValueStorageProvider);

  return AuthRepositoryImpl(storageService: storageService);
});
