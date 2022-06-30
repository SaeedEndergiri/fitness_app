import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/screens/add_food_screen.dart';
import 'package:fitness_app/screens/auth_screen.dart';
import 'package:fitness_app/screens/food_detail_screen.dart';
import 'package:fitness_app/screens/home_screen.dart';
import 'package:fitness_app/screens/tracker_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/foods.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Stream<User?> auth;
  @override
  void initState() {
    auth = FirebaseAuth.instance.authStateChanges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Foods(),
      child: MaterialApp(
        title: 'Flutter Fitness',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(primary: Colors.blue, onPrimary: Colors.white),
        ),
        home: StreamBuilder(
            stream: auth,
            builder: (ctx, userSnapshot) {
              if (userSnapshot.hasData) {
                return HomeScreen();
              }
              return AuthScreen();
            }),
        routes: {
          AddFoodScreen.routeName: (ctx) => AddFoodScreen(),
          FoodDetailScreen.routeName: (ctx) => FoodDetailScreen(),
          TrackerScreen.routeName: (ctx) => TrackerScreen(),
        },
      ),
    );
  }
}
