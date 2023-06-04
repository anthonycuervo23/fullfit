import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/infrastructure/services/services.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'package:fullfit_app/presentation/widgets/widgets.dart';

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends ConsumerState<OnBoardingScreen>
    with AutomaticKeepAliveClientMixin {
  int stepCount = 0;
  bool hasBiometricSupport = false;
  bool hasLoggedWithEmailPassword = true;
  final List<_ScreenBuilder> _screens = [];
  PageController controller = PageController();

  //* Definimos los constructores de las pantallas y el orden en el que se muestran
  final List<_ScreenBuilder> _screensBuilders = [
    _ScreenBuilder(id: ScreenId.email, screen: const EmailScreen()),
    _ScreenBuilder(id: ScreenId.password, screen: const PasswordScreen()),
    _ScreenBuilder(id: ScreenId.userDetails, screen: const UserDetailsScreen()),
    _ScreenBuilder(id: ScreenId.biometric, screen: const BiometricScreen()),
    _ScreenBuilder(id: ScreenId.gender, screen: const GenderScreen()),
    _ScreenBuilder(id: ScreenId.age, screen: const AgeRangeScreen()),
    _ScreenBuilder(id: ScreenId.height, screen: const HeightScreen()),
    _ScreenBuilder(id: ScreenId.weight, screen: const WeightScreen()),
    _ScreenBuilder(
        id: ScreenId.fitnessLevel, screen: const FitnessLevelScreen()),
    _ScreenBuilder(id: ScreenId.fitnessGoal, screen: const FitnessGoalScreen()),
    _ScreenBuilder(
        id: ScreenId.trainingSpot, screen: const TrainingSpotScreen()),
    _ScreenBuilder(id: ScreenId.profilePic, screen: const ProfilePicScreen()),
    _ScreenBuilder(
        id: ScreenId.notifications, screen: const NotificationsScreen()),
  ];

  @override
  void initState() {
    super.initState();
    hasBiometricSupport = ref.read(authRepositoryProvider).hasBiometricSupport;
    hasLoggedWithEmailPassword =
        ref.read(authRepositoryProvider).hasLoggedWithEmailPassword;
    for (var screenBuilder in _screensBuilders) {
      if (screenBuilder.id == ScreenId.biometric && !hasBiometricSupport) {
        continue;
      }
      if (screenBuilder.id == ScreenId.password &&
          !hasLoggedWithEmailPassword) {
        continue;
      }
      if (screenBuilder.id == ScreenId.email && !hasLoggedWithEmailPassword) {
        continue;
      }
      _screens.add(screenBuilder);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    ref.listen(authProvider, (previous, next) async {
      if (next.errorMessage.isNotEmpty) {
        Alert.error(context, msg: next.errorMessage)
            .then((value) => context.go('/intro'));
      }
    });

    final authRepository = ref.read(authRepositoryProvider);
    final onboardingProvider = ref.read(onBoardingNotifierProvider);

    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StepProgressIndicator(
              totalSteps: _screens.length,
              currentStep: stepCount + 1,
              selectedColor: colors.primary,
              size: 8,
              unselectedColor: colors.onSurface.withOpacity(0.2),
            ),
            SizedBox(height: 24.h, width: double.infinity),
            TopIconRow(
              onBackPressed: () {
                if (stepCount >= 1) {
                  setState(() {
                    stepCount--;
                    controller.previousPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn);

                    isCurrentInputValid();
                  });
                } else {
                  if (context.canPop()) {
                    return context.pop();
                  }
                  context.go('/intro');
                }
              },
            ),
            Expanded(
              child: PageView.builder(
                  controller: controller,
                  itemCount: _screens.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _screens[index].screen;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22, right: 22, bottom: 19),
              child: CustomBigButton(
                onPressed: isCurrentInputValid()
                    ? () async {
                        FocusScope.of(context).unfocus();
                        if (stepCount != _screens.length - 1) {
                          final currentScreenId = _screens[stepCount].id;
                          if (currentScreenId == ScreenId.email) {
                            //check if email already exists
                            bool exists = await ref
                                .read(onBoardingNotifierProvider.notifier)
                                .emailAlreadyExists();

                            if (exists) {
                              return;
                            }
                          }

                          if (currentScreenId == ScreenId.biometric) {
                            authRepository.didLoggedOutOrFailedBiometricAuth =
                                false;
                            authRepository
                                .performBiometricAuthentication()
                                .then((didAuthenticate) {
                              if (didAuthenticate) {
                                KeyValueStorageServiceImplementation()
                                    .setKeyValue<bool>(
                                        hasBiometricLoginEnabledKey, true);
                                authRepository.saveCredentials(
                                    email: onboardingProvider.email.value,
                                    password:
                                        onboardingProvider.password.value);
                                setState(() {
                                  stepCount++;
                                  controller.animateToPage(stepCount,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeIn);
                                });
                              } else {
                                Alert.error(context,
                                    msg:
                                        'No se pudo realizar la autenticación biométrica');
                              }
                            });

                            return;
                          }
                          setState(() {
                            stepCount++;
                            controller.animateToPage(stepCount,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeIn);

                            isCurrentInputValid();
                          });
                        } else {
                          ref
                              .read(onBoardingNotifierProvider.notifier)
                              .onFormSubmitted();
                          // context.push('/ready-to-go');
                        }
                      }
                    : null,
                child: onboardingProvider.checkingEmail
                    ? Padding(
                        padding: EdgeInsets.all(8.0.w),
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Continuar'),
              ),
            ),
            Visibility(
              visible: _screens[stepCount].id == ScreenId.biometric ||
                  _screens[stepCount].id == ScreenId.notifications,
              child: TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  if (stepCount != _screens.length - 1) {
                    final currentScreenId = _screens[stepCount].id;
                    if (currentScreenId == ScreenId.biometric) {
                      authRepository.didLoggedOutOrFailedBiometricAuth = false;
                      KeyValueStorageServiceImplementation().setKeyValue<bool>(
                          hasBiometricLoginEnabledKey, false);
                    }
                    setState(() {
                      stepCount++;
                      controller.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn);

                      isCurrentInputValid();
                    });
                  } else {
                    ref
                        .read(onBoardingNotifierProvider.notifier)
                        .onFormSubmitted();
                    // context.push('/ready-to-go');
                  }
                },
                child: Text(
                  'Ahora no',
                  style: textStyles.bodyMedium?.copyWith(
                      fontSize: 16,
                      color: colors.primary,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isCurrentInputValid() {
    final onboardingProvider = ref.watch(onBoardingNotifierProvider);
    final currentScreenId = _screens[stepCount].id;
    switch (currentScreenId) {
      case ScreenId.email:
        return onboardingProvider.isEmailValid &&
            !onboardingProvider.checkingEmail;
      case ScreenId.password:
        return onboardingProvider.isPasswordValid;
      case ScreenId.userDetails:
        return onboardingProvider.isFirstNameValid &&
            onboardingProvider.isLastNameValid;
      case ScreenId.fitnessGoal:
        return !onboardingProvider.fitnessGoals.values.every((v) => v == false);
      case ScreenId.gender:
        return onboardingProvider.genderSelected != 0;
      case ScreenId.age:
        return onboardingProvider.ageRange != '';
      default:
        return true;
    }
  }
}

//* Modelo de screens
enum ScreenId {
  email,
  password,
  height,
  biometric,
  age,
  profilePic,
  fitnessLevel,
  fitnessGoal,
  trainingSpot,
  userDetails,
  weight,
  gender,
  notifications,
}

class _ScreenBuilder {
  final ScreenId id;
  final Widget screen;

  _ScreenBuilder({
    required this.id,
    required this.screen,
  });
}
