import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/history_item.dart';
import 'screens/entry_screen.dart';
import 'services/ai_service.dart';
import 'theme/app_colors.dart';

import 'providers/localization_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Error loading .env file: $e');
  }

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(HistoryItemAdapter());
  await Hive.openBox<HistoryItem>('historyBox');

  runApp(
    MultiProvider(
      providers: [
        Provider<AiService>(create: (_) => AiService()),
        ChangeNotifierProvider<LocalizationProvider>(
          create: (_) => LocalizationProvider(),
        ),
      ],
      child: const PromptlyApp(),
    ),
  );
}

class PromptlyApp extends StatelessWidget {
  const PromptlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Promptly',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.bgDark,
        textTheme: GoogleFonts.spaceGroteskTextTheme(
          ThemeData.dark().textTheme,
        ),
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.surfaceDark,
        ),
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark, // Enforcing dark mode as per design
      home: const EntryScreen(),
    );
  }
}
