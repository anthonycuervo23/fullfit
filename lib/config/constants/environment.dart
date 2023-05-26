import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnv() async {
    await dotenv.load(fileName: ".env");
  }

  static String twitterRedirectUri =
      dotenv.env['TWITTER_REDIRECT_URI'] ?? 'URI no configurada.';
  static String twitterApiKey =
      dotenv.env['TWITTER_API_KEY'] ?? 'Twitter API Key no configurada.';
  static String twitterApiSecret =
      dotenv.env['TWITTER_API_SECRET'] ?? 'Twitter API Secret no configurada.';
}
