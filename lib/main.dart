import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:news_case/helpers/auth_helper_data.dart';
import 'package:news_case/helpers/theme_color_data.dart';
import 'package:news_case/screens/article_detail_page_screen.dart';
import 'package:news_case/screens/favorite_article_page_screen.dart';
import 'package:news_case/screens/home_page_screen.dart';
import 'package:news_case/screens/settings_page_screen.dart';
import 'package:news_case/screens/signin_page_screen.dart';
import 'package:news_case/screens/signup_page_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // ignore: avoid_print
  print('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeColorData().createSharedPrefObj();
  await Locales.init(['en', 'us', 'tr']);
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeColorData>(
          create: (BuildContext context) => ThemeColorData(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  final _routes = {
    "/homePageScreen": (context) => const HomePageScreen(),
    "/settingsPageScreen": (context) => const SettingsPageScreen(),
    "/signinPageScreen": (context) => const SignInPageScreen(),
    "/signupPageScreen": (context) => const SignUpPageScreen(),
    "/articleDetailPageScreen": (context) => const ArticleDetailScreenPage(),
    "/favoriteArticlePageScreen": (context) =>
        const FavoriteArticlePageScreen(),
  };

  getUserInfo() async {
    userIsLoggedIn = await HelperFunctions.getUserLoggedInSharedPreference();
    setState(() {});
  }

  @override
  void initState() {
    SharedPreferences.getInstance();
    getUserInfo();
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        /*Navigator.pushNamed(context, '/message',arguments: MessageArguments(message, true));*/
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // ignore: avoid_print
      print('A new onMessageOpenedApp event was published!');
      /*Navigator.pushNamed(context, '/message',
          arguments: MessageArguments(message, true));*/
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeColorData>(context, listen: false).loadThemeSharedPref();

    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        locale: locale,
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeColorData>(context).getThemeColor,
        routes: _routes,
        initialRoute: userIsLoggedIn ? "/homePageScreen" : "/signinPageScreen",
      ),
    );
  }
}
