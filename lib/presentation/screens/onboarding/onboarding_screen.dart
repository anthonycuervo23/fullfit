import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'package:fullfit_app/presentation/widgets/widgets.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  int stepCount = 0;
  List<int> screens = List.generate(10, (index) => index, growable: false);
  PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              totalSteps: screens.length,
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
                  itemCount: screens.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return const EmailScreen();
                      case 1:
                        return const PasswordScreen();
                      case 2:
                        return const BiometricScreen();
                      case 3:
                        return const ProfilePicScreen();
                      case 4:
                        return const FitnessLevelScreen();
                      case 5:
                        return const FitnessGoalScreen();
                      case 6:
                        return const TrainingSpotScreen();
                      case 7:
                        return const UserSizesFormScreen();
                      case 8:
                        return const GenderScreen();
                      case 9:
                        return const NotificationsScreen();
                      default:
                        return Container();
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22, right: 22, bottom: 19),
              child: CustomBigButton(
                child: const Text('Continuar'),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (stepCount != 9) {
                    setState(() {
                      stepCount++;
                      controller.animateToPage(stepCount,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                    });
                  } else {
                    context.push('/ready-to-go');
                  }
                },
              ),
            ),
            Visibility(
              visible: stepCount == 2 || stepCount == 9,
              child: TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (stepCount != 10) {
                    setState(() {
                      stepCount++;
                      controller.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                    });
                  } else {
                    context.push('/ready-to-go');
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
}
