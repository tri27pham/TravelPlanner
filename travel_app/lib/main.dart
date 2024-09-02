import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/viewmodels/home_viewmodel.dart';
import 'package:travel_app/viewmodels/route_viewmodel.dart';
import 'package:travel_app/views/home_view.dart';
import 'views/login_view.dart';
import 'views/welcome_page_view.dart';
import 'views/route_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/viewmodels/welcome_viewmodel.dart';
import 'package:travel_app/viewmodels/profile_viewmodel.dart';
import 'package:travel_app/models/AppState.dart';
import 'app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => WelcomeViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(
            create: (_) =>
                RoutePlannerViewModel()), // Added RoutePlannerViewModel here
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access RoutePlannerViewModel's navigatorKey using Provider
    final navigatorKey =
        Provider.of<RoutePlannerViewModel>(context).navigatorKey;

    return MaterialApp(
      navigatorKey:
          navigatorKey, // Use the navigatorKey from the RoutePlannerViewModel
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/welcome': (context) => WelcomePage(),
        '/home': (context) => HomeView(),
        '/route': (context) => RoutePlanner(),
        '/app': (context) => App(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}
