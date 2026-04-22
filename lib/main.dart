import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/service_locator.dart';
import 'core/storage/storage_service.dart';
import 'core/routing/app_router.dart'; // <-- Import the router
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  final storageService = StorageService();
  await storageService.init();
  setupLocator(storageService);
  
  runApp(
    const ProviderScope(
      child: SaveTrackApp(),
    ),
  );
}

class SaveTrackApp extends StatelessWidget {
  const SaveTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Change MaterialApp to MaterialApp.router
    return MaterialApp.router(
      title: 'SaveTrack',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.tealAccent,
          brightness: Brightness.dark,
        ),
      ),
      // Replace 'home' with router config
      routerConfig: appRouter, 
    );
  }
}