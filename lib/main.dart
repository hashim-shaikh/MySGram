import 'dart:io';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:foap/api_handler/apis/auth_api.dart';
import 'package:foap/controllers/story/story_controller.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foap/controllers/live/live_users_controller.dart';
import 'package:foap/helper/imports/reel_imports.dart';
import 'package:foap/screens/login_sign_up/ask_to_follow.dart';
import 'package:foap/screens/post/content_creator_view.dart';
import 'package:foap/screens/settings_menu/help_support_contorller.dart';
import 'package:foap/screens/settings_menu/mercadopago_payment_controller.dart';
import 'package:foap/util/constant_util.dart';

import 'components/giphy/src/l10n/l10n.dart';
import 'components/reply_chat_cells/post_gift_controller.dart';
import 'components/smart_text_field.dart';
import 'controllers/chat_and_call/voip_controller.dart';
import 'controllers/clubs/clubs_controller.dart';
import 'controllers/misc/faq_controller.dart';
import 'package:foap/screens/dashboard/dashboard_screen.dart';
import 'package:foap/screens/login_sign_up/splash_screen.dart';
import 'package:foap/screens/settings_menu/settings_controller.dart';
import 'package:foap/util/shared_prefs.dart';
import 'package:camera/camera.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:overlay_support/overlay_support.dart';

import 'components/post_card_controller.dart';
import 'controllers/misc/gift_controller.dart';
import 'controllers/misc/misc_controller.dart';
import 'controllers/misc/users_controller.dart';
import 'controllers/notification/notifications_controller.dart';
import 'controllers/post/add_post_controller.dart';
import 'controllers/chat_and_call/agora_call_controller.dart';
import 'controllers/live/agora_live_controller.dart';
import 'controllers/chat_and_call/chat_detail_controller.dart';
import 'controllers/chat_and_call/chat_history_controller.dart';
import 'controllers/chat_and_call/chat_room_detail_controller.dart';
import 'controllers/chat_and_call/select_user_group_chat_controller.dart';
import 'controllers/home/home_controller.dart';
import 'controllers/live/live_history_controller.dart';
import 'controllers/story/highlights_controller.dart';
import 'controllers/tv/live_tv_streaming_controller.dart';
import 'controllers/auth/login_controller.dart';
import 'controllers/misc/map_screen_controller.dart';
import 'controllers/podcast/podcast_streaming_controller.dart';
import 'controllers/post/post_controller.dart';
import 'controllers/profile/profile_controller.dart';
import 'controllers/misc/request_verification_controller.dart';
import 'controllers/misc/subscription_packages_controller.dart';
import 'helper/device_info.dart';
import 'helper/languages.dart';
import 'manager/db_manager.dart';
import 'manager/deep_link_manager.dart';
import 'manager/location_manager.dart';
import 'manager/notification_manager.dart';
import 'manager/player_manager.dart';
import 'manager/socket_manager.dart';
import 'firebase_options.dart';



class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

late List<CameraDescription> cameras;
bool isLaunchedFromCallNotification = false;
bool isAnyPageInStack = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  HttpOverrides.global = MyHttpOverrides();

  await Firebase.initializeApp(
    name: AppConfigConstants.appName,
    options: DefaultFirebaseOptions.currentPlatform,
  ).whenComplete(() {
    print('initializeApp completed');
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  DeviceInfoManager.collectDeviceInfo();
  DeepLinkManager.init();

  String? token = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
  if (token != null) {
    SharedPrefs().setVoipToken(token);
  }

  AutoOrientation.portraitAutoMode();

  isDarkMode = await SharedPrefs().isDarkMode();
  Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);

  Get.put(PlayerManager());
  Get.put(UsersController());
  Get.put(GiftController());
  Get.put(MiscController());
  Get.put(DashboardController());
  Get.put(UserProfileManager());
  Get.put(ClubsController());

  Get.put(PlayerManager());
  Get.put(SettingsController());
  Get.put(SubscriptionPackageController());
  Get.put(AgoraCallController());
  Get.put(VoipController());

  Get.put(AgoraLiveController());
  Get.put(LoginController());
  Get.put(HomeController());
  Get.put(PostController());
  Get.put(PostCardController());
  Get.put(AddPostController());
  Get.put(ChatDetailController());
  Get.put(ProfileController());
  Get.put(ChatHistoryController());
  Get.put(ChatRoomDetailController());
  Get.put(TvStreamingController());
  Get.put(LocationManager());
  Get.put(MapScreenController());
  Get.put(LiveHistoryController());
  Get.put(RequestVerificationController());
  Get.put(FAQController());
  Get.put(LiveUserController());
  Get.put(PostGiftController());
  Get.put(MercadappagoPaymentController());
  Get.put(HelpSupportController());
  Get.put(PodcastStreamingController());
  Get.put(SelectUserForGroupChatController());
  Get.put(AppStoryController());
  Get.put(SmartTextFieldController());
  Get.put(ReelsController());
  Get.put(CreateReelController());
  Get.put(CameraControllerService());
  Get.put(HighlightsController());
  Get.put(NotificationController());

  setupServiceLocator();

  final UserProfileManager userProfileManager = Get.find();
  String? authKey = await SharedPrefs().getAuthorizationKey();

  if (authKey != null) {
    await userProfileManager.refreshProfile();
  }

  final SettingsController settingsController = Get.find();
  await settingsController.getSettings();

  NotificationManager().initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await getIt<DBManager>().createDatabase();

  if (userProfileManager.isLogin == true) {
    AuthApi.updateFcmToken();
  }

  dynamic data = await SharedPrefs().getCallNotificationData();

  if (data != null && userProfileManager.user.value != null) {
    isLaunchedFromCallNotification = true;
    getIt<SocketManager>().connect();
    performActionOnCallNotificationBanner(data, true, true);
  } else {
    runApp(Phoenix(
        child: const SocialifiedApp(
          startScreen: SplashScreen(),
        )));
  }
}

class SocialifiedApp extends StatefulWidget {
  final Widget startScreen;

  const SocialifiedApp({Key? key, required this.startScreen}) : super(key: key);

  @override
  State<SocialifiedApp> createState() => _SocialifiedAppState();
}

class _SocialifiedAppState extends State<SocialifiedApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: FutureBuilder<Locale>(
            future: SharedPrefs().getLocale(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GetMaterialApp(
                  translations: Languages(),
                  locale: snapshot.data!,
                  // locale: const Locale('pt',/ 'BR'),
                  fallbackLocale: const Locale('en', 'US'),
                  debugShowCheckedModeBanner: false,
                  // navigatorKey: navigationKey,
                  home: widget.startScreen,
                  builder: EasyLoading.init(),
                  // theme: AppTheme.lightTheme,
                  // darkTheme: AppTheme.darkTheme,
                  themeMode: ThemeMode.dark,
                  // localizationsDelegates: context.localizationDelegates,
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    // GlobalCupertinoLocalizations.delegate,
                    // Add this line
                    GiphyGetUILocalizations.delegate,
                  ],
                  supportedLocales: const <Locale>[
                    Locale('hi', 'US'),
                    Locale('en', 'SA'),
                    Locale('ar', 'SA'),
                    Locale('tr', 'SA'),
                    Locale('ru', 'SA'),
                    Locale('es', 'SA'),
                    Locale('fr', 'SA'),
                    Locale('pt', 'BR')
                  ],
                );
              } else {
                return Container();
              }
            }));
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  print('message.data ${message.data}');
  Get.put(DashboardController());
  Get.put(UserProfileManager());
  Get.put(SettingsController());
  Get.put(AgoraCallController());
  Get.put(VoipController());

  NotificationManager().parseNotificationMessage(message.data);
}






// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
//
// final GetIt sl = GetIt.instance;
//
// void setup() {
//   sl.registerLazySingleton<DBManager>(() => DBManager());
//   print("DBManager registered");
// }
//
//
// late List<CameraDescription> cameras;
// late CameraController cameraController;
// bool isAnyPageInStack = false;
// bool isLaunchedFromCallNotification = true;
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize the cameras first
//   cameras = await availableCameras();
//   if (cameras.isEmpty) {
//     print("No cameras available");
//     return;
//   }
//
//   // Initialize the CameraController with the first available camera (you can change this to the desired camera)
//   cameraController = CameraController(
//     cameras[0], // You can choose the front or back camera here
//     ResolutionPreset.high,
//   );
//
//   try {
//     await cameraController.initialize();
//   } catch (e) {
//     print("Error initializing camera: $e");
//     return;
//   }
//
//   HttpOverrides.global = MyHttpOverrides();
//
//   await Firebase.initializeApp(
//     name: AppConfigConstants.appName,
//     options: DefaultFirebaseOptions.currentPlatform,
//   ).whenComplete(() {
//     print('initializeApp completed');
//   });
//
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   DeviceInfoManager.collectDeviceInfo();
//   DeepLinkManager.init();
//
//   String? token = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
//   if (token != null) {
//     SharedPrefs().setVoipToken(token);
//   }
//
//   AutoOrientation.portraitAutoMode();
//
//   isDarkMode = await SharedPrefs().isDarkMode();
//   Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
//
//   // Other initializations
//   initializeOtherServices();
//   setup();
//   runApp(Phoenix(child: const SocialifiedApp(startScreen: AskToFollow())));
// }
//
// // Function to initialize other services and controllers (as per your existing code)
// void initializeOtherServices() {
//   Get.put(PlayerManager());
//   Get.put(UsersController());
//   Get.put(GiftController());
//   Get.put(MiscController());
//   Get.put(DashboardController());
//   Get.put(UserProfileManager());
//   Get.put(ClubsController());
//
//   Get.put(PlayerManager());
//   Get.put(SettingsController());
//   Get.put(SubscriptionPackageController());
//   Get.put(AgoraCallController());
//   Get.put(VoipController());
//
//   Get.put(AgoraLiveController());
//   Get.put(LoginController());
//   Get.put(HomeController());
//   Get.put(PostController());
//   Get.put(PostCardController());
//   Get.put(AddPostController());
//   Get.put(ChatDetailController());
//   Get.put(ProfileController());
//   Get.put(ChatHistoryController());
//   Get.put(ChatRoomDetailController());
//   Get.put(TvStreamingController());
//   Get.put(LocationManager());
//   Get.put(MapScreenController());
//   Get.put(LiveHistoryController());
//   Get.put(RequestVerificationController());
//   Get.put(FAQController());
//   Get.put(LiveUserController());
//   Get.put(PostGiftController());
//   Get.put(MercadappagoPaymentController());
//   Get.put(HelpSupportController());
//   Get.put(PodcastStreamingController());
//   Get.put(SelectUserForGroupChatController());
//   Get.put(AppStoryController());
//   Get.put(SmartTextFieldController());
//   Get.put(ReelsController());
//   Get.put(CreateReelController());
//   Get.put(CameraControllerService());
//   Get.put(HighlightsController());
//   Get.put(NotificationController());
//
//   // Add other services/controllers as needed
// }
//
// class SocialifiedApp extends StatefulWidget {
//   final Widget startScreen;
//
//   const SocialifiedApp({Key? key, required this.startScreen}) : super(key: key);
//
//   @override
//   State<SocialifiedApp> createState() => _SocialifiedAppState();
// }
//
// class _SocialifiedAppState extends State<SocialifiedApp> {
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return OverlaySupport.global(
//       child: FutureBuilder<Locale>(
//         future: SharedPrefs().getLocale(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return GetMaterialApp(
//               translations: Languages(),
//               locale: snapshot.data!,
//               fallbackLocale: const Locale('en', 'US'),
//               debugShowCheckedModeBanner: false,
//               home: widget.startScreen,
//               builder: EasyLoading.init(),
//               themeMode: ThemeMode.dark,
//               localizationsDelegates: [
//                 GlobalMaterialLocalizations.delegate,
//                 GlobalWidgetsLocalizations.delegate,
//                 GiphyGetUILocalizations.delegate,
//               ],
//               supportedLocales: const [
//                 Locale('hi', 'US'),
//                 Locale('en', 'SA'),
//                 Locale('ar', 'SA'),
//                 Locale('tr', 'SA'),
//                 Locale('ru', 'SA'),
//                 Locale('es', 'SA'),
//                 Locale('fr', 'SA'),
//                 Locale('pt', 'BR'),
//               ],
//             );
//           } else {
//             return Container();
//           }
//         },
//       ),
//     );
//   }
// }
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // This function is triggered when the app is in the background or terminated
//   print('Handling a background message: ${message.data}');
//
//   // If you're using other Firebase services like Firestore or Realtime Database, you need to ensure initialization
//   // await Firebase.initializeApp();
//
//   // You can perform background tasks like showing notifications or processing the message here
//   // For example, handle call notifications or message data here
//   // Call your app's services to handle the notification
// }