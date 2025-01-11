import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_traffic_control_app/services/auth_service.dart';
import 'package:smart_traffic_control_app/services/hive_service.dart';
import 'package:smart_traffic_control_app/shared/router.dart';

import 'constants/style_constants.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await HiveService().initHive();

  runApp(const ProviderScope(child: SmartTrafficApp()));
}

class SmartTrafficApp extends ConsumerWidget {
  const SmartTrafficApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return MaterialApp(
      title: 'SmartTraffic',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
      theme:
          ThemeData(primarySwatch: Colors.deepOrange, fontFamily: fontFamily),
      // darkTheme: ThemeData.dark(),
      home: AuthService.initialRouting(ref),
      // home: LoginPage(),
    );
  }
}
