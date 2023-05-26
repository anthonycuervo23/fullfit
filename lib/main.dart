import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'config/config.dart';

void main() async {
  GlobalConfig.init();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
        builder: GlobalConfig.materialAppBuilder(),
        scaffoldMessengerKey: GlobalConfig.scaffoldMessengerKey,
        routerConfig: appRouter,
      ),
    );
  }
}
