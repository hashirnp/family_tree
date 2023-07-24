import 'package:family_tree/Screens/home_screen.dart';
import 'package:family_tree/Service/dbname_provider.dart';
import 'package:family_tree/model/Family%20Name%20Model/family_name_model.dart';
import 'package:family_tree/model/family_model/family_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'model/family_model/next.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(FamilyNameModelAdapter().typeId)) {
    Hive.registerAdapter(FamilyNameModelAdapter());
  }
  if (!Hive.isAdapterRegistered(FamilyModelAdapter().typeId)) {
    Hive.registerAdapter(FamilyModelAdapter());
  }
  if (!Hive.isAdapterRegistered(NextAdapter().typeId)) {
    Hive.registerAdapter(NextAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DbNameProvider(),
      child: MaterialApp(
        title: 'Flutter Graphite',
        theme: ThemeData(
          textTheme: GoogleFonts.montserratTextTheme(),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
              .copyWith(background: Colors.white),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
