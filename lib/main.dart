import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:project_collaboration_app/config/dependencies.dart';
import 'package:project_collaboration_app/config/hive_adapters.dart';
import 'package:project_collaboration_app/firebase_options.dart';
import 'package:project_collaboration_app/config/routing/router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GoogleSignIn.instance.initialize(
    serverClientId:
        '925752366644-92fuln9a8sheehrnf0bpl0cle87clk2m.apps.googleusercontent.com',
  );
  await Hive.initFlutter();
  addHiveAdapters();
  runApp(
    MultiRepositoryProvider(
      providers: repositoryProviders,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = router(context.read());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}
