import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/infrastructure/services/services.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class UserDetailsScreen extends ConsumerStatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  UserDetailsScreenState createState() => UserDetailsScreenState();
}

class UserDetailsScreenState extends ConsumerState<UserDetailsScreen> {
  String? name;
  String? lastName;
  @override
  void initState() {
    super.initState();

    name = ref.read(keyValueStorageProvider).getValue<String>(nameKey);
    lastName = ref.read(keyValueStorageProvider).getValue<String>(lastnameKey);

    //validate initial values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final onBoardingProvider = ref.read(onBoardingNotifierProvider.notifier);
      onBoardingProvider.validateInitialValues(name, lastName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final onBoardingProvider = ref.read(onBoardingNotifierProvider);
    final onBoardingNotifier = ref.read(onBoardingNotifierProvider.notifier);
    // final storageProvider = ref.read(keyValueStorageProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 90.h),
              child: Text(
                'Datos personales',
                style: textStyles.titleMedium,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.h),
              child: CustomTextFormField(
                initialValue: name,
                errorMessage: onBoardingProvider.firstName.errorMessage,
                hint: 'Ingresa tu nombre',
                onChanged: onBoardingNotifier.onFirstNameChanged,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.h),
              child: CustomTextFormField(
                initialValue: lastName,
                errorMessage: onBoardingProvider.lastName.errorMessage,
                hint: 'Ingresa tu apellido',
                onChanged: onBoardingNotifier.onLastNameChanged,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(55, 8.0, 55, 32),
              child: Text(
                'Con tus datos podremos brindar un servicio mas personalizado.',
                textAlign: TextAlign.center,
                style: textStyles.bodyMedium?.copyWith(
                  color: colors.onBackground.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
