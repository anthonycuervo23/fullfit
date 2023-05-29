import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/infrastructure/services/key_value_storage_service_impl.dart';

final keyValueStorageProvider =
    Provider((ref) => KeyValueStorageServiceImplementation());
