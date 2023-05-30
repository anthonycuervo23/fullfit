import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fullfit_app/config/config.dart';
import 'package:fullfit_app/infrastructure/services/services.dart';
import 'package:fullfit_app/presentation/widgets/widgets.dart';

class GlobalConfig {
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await KeyValueStorageServiceImplementation.loadPreferences();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await Environment.initEnv();
    CustomLoader();
  }

  static TransitionBuilder materialAppBuilder({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(
            context,
            Overlay(initialEntries: [
              OverlayEntry(builder: (BuildContext context) {
                return FlutterEasyLoading(key: GlobalKey(), child: child);
              }),
            ]));
      } else {
        return Overlay(initialEntries: [
          OverlayEntry(builder: (BuildContext context) {
            return FlutterEasyLoading(key: GlobalKey(), child: child);
          }),
        ]);
      }
    };
  }
}
