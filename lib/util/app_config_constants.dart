import '../helper/color_extension.dart';
import '../helper/imports/common_import.dart';
import '../screens/settings_menu/settings_controller.dart';
import 'constant_util.dart';

final SettingsController settingsController = Get.find();

class AppConfigConstants {
  // Name of app
  static String appName = 'MySgram';

  static String currentVersion = '2.3';
  static const liveAppLink = 'https://www.google.com/';

  static String appTagline = 'Share your day activity with friends';
  static const googleMapApiKey = 'your_google_api_key';

  static const restApiBaseUrl = 'https://mygram.in/api/web/v1/';

  static const socketApiBaseUrl = "http://mygram.in:5000/";

  // Chat encryption key -- DO NOT CHANGE THIS
  static const encryptionKey = 'bbC2H19lkVbQDfakxcrtNMQdd0FloLyw';

  // enable encryption -- DO NOT CHANGE THIS
  static const int enableEncryption = 1;

  // chat version
  static const int chatVersion = 1;

  // is demo app
  static const bool isDemoApp = false;

  // parameters for delete chat
  static const secondsInADay = 86400;
  static const secondsInThreeDays = 259200;
  static const secondsInSevenDays = 604800;
  static const liveBattleConfirmationWaitTime = 30;
}

class DesignConstants {
  static double horizontalPadding = 24;
}

class AppColorConstants {
  static Color themeColor = settingsController.setting.value == null
      ? Colors.green :Colors.blue;
      // : HexColor.fromHex(settingsController.setting.value!.themeColor!);

  static Color get backgroundColor => isDarkMode
      ? HexColor.fromHex(
          settingsController.setting.value?.bgColorForDarkTheme ??
              '202020')
      : HexColor.fromHex(
          settingsController.setting.value?.bgColorForLightTheme ??
              'FFFFFF');

  static Color get cardColor =>
      isDarkMode ? HexColor.fromHex('636e72') : HexColor.fromHex('dfe6e9');

  static Color get dividerColor => isDarkMode
      ? const Color(0xFFFFFFFF).withOpacity(0.4)
      : Colors.grey.withOpacity(0.7);

  static Color get borderColor => isDarkMode
      ? Colors.white.withOpacity(0.9)
      : Colors.grey.withOpacity(0.2);

  static Color get disabledColor => isDarkMode
      ? Colors.grey.withOpacity(0.2)
      : Colors.grey.withOpacity(0.2);

  static Color get shadowColor => isDarkMode
      ? Colors.white.withOpacity(0.2)
      : Colors.black.withOpacity(0.2);

  // static Color get inputFieldBackgroundColor =>
  //     isDarkMode ? const Color(0xFF212121) : const Color(0xFF212121);

  static Color get iconColor =>
      isDarkMode ? Colors.white : const Color(0xFF212121);

  static Color get inputFieldTextColor =>
      isDarkMode ? const Color(0xFFFAFAFA) : const Color(0xFF212121);

  static Color get inputFieldPlaceholderTextColor => isDarkMode
      ? const Color(0xFFFAFAFA).lighten()
      : const Color(0xFF212121).darken();

  static Color get red => isDarkMode ? Colors.black : Colors.black;

  static Color get green => isDarkMode ? Colors.green : Colors.green;

  // text colors

  static Color get mainTextColor => isDarkMode
      ? settingsController.setting.value == null
          ? Colors.white
          : HexColor.fromHex(
              settingsController.setting.value!.textColorForDarkTheme!)
      : settingsController.setting.value == null
          ? Colors.black
          : HexColor.fromHex(
              settingsController.setting.value!.textColorForLightTheme!);

  // static Color get mainTextColor => isDarkMode
  //     ? settingsController.setting.value == null
  //         ? Colors.white.withOpacity(0.8)
  //         : HexColor.fromHex(
  //                 settingsController.setting.value!.textColorForDarkTheme!)
  //             .withOpacity(0.8)
  //     : settingsController.setting.value == null
  //         ? Colors.black.withOpacity(0.8)
  //         : HexColor.fromHex(
  //                 settingsController.setting.value!.textColorForLightTheme!)
  //             .withOpacity(0.8);
  //
  // static Color get mainTextColor => isDarkMode
  //     ? settingsController.setting.value == null
  //         ? Colors.white.withOpacity(0.7)
  //         : HexColor.fromHex(
  //                 settingsController.setting.value!.textColorForDarkTheme!)
  //             .withOpacity(0.7)
  //     : settingsController.setting.value == null
  //         ? Colors.black.withOpacity(0.7)
  //         : HexColor.fromHex(
  //                 settingsController.setting.value!.textColorForLightTheme!)
  //             .withOpacity(0.7);

  static Color get subHeadingTextColor => isDarkMode
      ? settingsController.setting.value == null
          ? const Color(0xFF34495e)
          : HexColor.fromHex(
                  settingsController.setting.value!.textColorForDarkTheme!)
              .withOpacity(0.8)
      : settingsController.setting.value == null
          ? const Color(0xFFecf0f1)
          : HexColor.fromHex(settingsController
                  .setting.value!.textColorForLightTheme!)
              .withOpacity(0.8);
}

class DatingProfileConstants {
  static List<String> genders = ['Male', 'Female', 'Other'];
  static List<String> colors = ['Black', 'White', 'Brown'];
  static List<String> religions = [
    'Christians',
    'Muslims',
    'Hindus',
    'Buddhists',
    'Sikhs',
    'Jainism',
    'Judaism'
  ];
  static List<String> maritalStatus = ['Single', 'Married', 'Divorced'];
  static List<String> drinkHabits = [
    'Regular',
    'Planning to quit',
    'Socially'
  ];
}
