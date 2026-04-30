import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayagsync_app/core/constants/app_route.dart';
import 'package:hayagsync_app/core/router/app_router.dart';
import 'package:hayagsync_app/firebase_options.dart';
import 'package:hayagsync_app/providers/auth_provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBGHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel notificationChannel =
    AndroidNotificationChannel(
      'incident_channel',
      'Incident Notifications',
      description: 'Notifications for incident updates',
      importance: Importance.max,
    );

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBGHandler);

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings settings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(settings: settings);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(notificationChannel);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('====== FCM RECEIVED ======');
      print('TITLE: ${message.notification?.title}');
      print('BODY: ${message.notification?.body}');
      print('DATA: ${message.data}');

      await flutterLocalNotificationsPlugin.show(
        id: message.hashCode,
        title: message.notification?.title ?? 'Notification',
        body: message.notification?.body ?? '',
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'incident_channel',
            'Incident Notifications',
            channelDescription: 'Notifications for incident updates',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (mounted) {
        context.go(AppRoute.inbox);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    final router = createRouter(authState);

    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
