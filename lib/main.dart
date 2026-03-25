import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'providers/habit_provider.dart';
import 'providers/gem_provider.dart';
import 'providers/user_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'repositories/local/local_auth_repository.dart';
import 'repositories/local/local_habit_repository.dart';
import 'repositories/local/local_gem_repository.dart';
import 'repositories/local/local_location_repository.dart';
import 'repositories/local/local_friend_repository.dart';
import 'providers/location_provider.dart';
import 'providers/friend_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Initialize repositories
  final prefs = await SharedPreferences.getInstance();
  final authRepo = LocalAuthRepository(prefs);
  final habitRepo = await LocalHabitRepository.create();
  final gemRepo = await LocalGemRepository.create(prefs);
  final locationRepo = await LocalLocationRepository.create();
  final friendRepo = await LocalFriendRepository.create();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider(authRepo)),
        ChangeNotifierProvider(create: (_) => HabitProvider(habitRepo)),
        ChangeNotifierProvider(create: (_) => GemProvider(gemRepo)),
        ChangeNotifierProvider(create: (_) => LocationProvider(locationRepo)),
        ChangeNotifierProvider(create: (_) => FriendProvider(friendRepo, 'local_user')),
      ],
      child: const EverydayGemApp(),
    ),
  );
}
