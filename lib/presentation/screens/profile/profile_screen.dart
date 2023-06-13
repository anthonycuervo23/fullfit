import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDark = ref.watch(themeNotifierProvider).isDarkMode;
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    final person = ref.watch(personProvider).person;
    final authNotifier = ref.watch(authProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
              onPressed: () =>
                  ref.read(themeNotifierProvider.notifier).toggleDarkMode(),
              icon: Icon(isDark
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                      width: 120.w,
                      height: 120.h,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                              image: NetworkImage(person?.profilePic ??
                                  'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png')))),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: colors.primary),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(person?.fullName ?? '', style: textStyles.titleMedium),
              Text(person?.email ?? '', style: textStyles.bodyMedium),
              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200.w,
                child: FilledButton(
                  onPressed: () {},
                  child: const Text('Edit Profile'),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              _ProfileMenuWidget(
                title: "Push Notifications",
                icon: Icons.notifications,
                isSwitch: true,
                value: true,
                onChanged: (value) {},
              ),
              _ProfileMenuWidget(
                title: "Biometric Authentication",
                icon: Icons.fingerprint,
                isSwitch: true,
                value: true,
                onChanged: (value) {},
              ),
              // ProfileMenuWidget(
              //     title: "Language", icon: Icons.offline_bolt, onPress: () {}),
              const Divider(),
              const SizedBox(height: 10),
              _ProfileMenuWidget(
                  title: "Information", icon: Icons.info, onPress: () {}),
              _ProfileMenuWidget(
                  title: "Logout",
                  icon: Icons.logout,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    //TODO: mostrar dialogo para confirmar logout
                    Alert.promtWithOptions(context,
                        title: 'Are you sure you want to logout?',
                        onConfirm: () => authNotifier.logout(),
                        onCancel: () {});
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuWidget extends StatelessWidget {
  const _ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    this.onPress,
    this.onChanged,
    this.isSwitch = false,
    this.endIcon = true,
    this.value = false,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback? onPress;
  final bool endIcon;
  final Color? textColor;
  final bool isSwitch;
  final bool value;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    final textSyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return ListTile(
      onTap: isSwitch ? null : onPress,
      leading: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: colors.primary.withOpacity(0.1),
        ),
        child: Icon(icon, color: colors.primary),
      ),
      title: Text(title,
          style: textSyles.bodyMedium!
              .copyWith(color: textColor, fontSize: 16.sp)),
      trailing: endIcon && !isSwitch
          ? Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 18.0, color: Colors.grey))
          : isSwitch
              ? Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: colors.primary,
                )
              : null,
    );
  }
}
