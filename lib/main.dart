import 'package:phase_2_project/services/AuthWrapper.dart';
import 'package:phase_2_project/services/auth.dart';
import 'package:phase_2_project/services/db.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phase_2_project/utils/theme/main_theme.dart';
import 'package:provider/provider.dart';
import 'package:phase_2_project/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<DatabaseService>(create: (_) => DatabaseService()),
      ],
      child: MaterialApp(
        title: 'CV Project',
        theme: cvTheme.lightTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}

