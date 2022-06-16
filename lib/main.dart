import 'package:fitness_app/screens/add_food_screen.dart';
import 'package:fitness_app/screens/home_screen.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
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
        home: HomeScreen(),
        routes: {
          AddFoodScreen.routeName: (ctx) => AddFoodScreen(),
        },
      ),
    );
  }
}
