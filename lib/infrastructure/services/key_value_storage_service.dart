const String emailKey = 'email_key';

const String nameKey = 'name_key';

const String lastnameKey = 'last_name_key';

const String hasBiometricLoginEnabledKey = "has_biometric_login_enabled_key";

const String hasSeenNutritionDialogKey = "has_seen_nutrition_dialog_key";

const String isRegisteredForPushNotificationsKey =
    "is_registered_for_push_notifications_key";

const String didLoggedOutOrFailedBiometricAuthKey =
    "did_logged_out_or_failed_biometric_auth_key";

const String loginTypeKey = 'login_type_key';

const String isOnboardingCompletedKey = 'is_onboarding_completed_key';

const String mealPlanDateKey = 'meal_plan_date_key';

abstract class KeyValueStorageService {
  const KeyValueStorageService();
  void setKeyValue<T>(String key, T value);
  T? getValue<T>(String key);
  Future<bool> removeKey(String key);
}
