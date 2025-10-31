import 'package:dicionario/DS/Components/theme/Theme_Service.dart';
import 'package:dicionario/DS/page/Page.dart';
import 'package:dicionario/Service/favorite_service.dart';
import 'package:dicionario/Splash_Screen/Splash_Screen.dart';
import 'package:dicionario/shared/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoriteService()),
        ChangeNotifierProvider(create: (context) => ThemeService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF5F5F5),
            primaryColor: appBarColor,

            appBarTheme: const AppBarTheme(
              backgroundColor: appBarColor,
              iconTheme: IconThemeData(color: WhiteIconColor),
              titleTextStyle: TextStyle(
                color: WhiteIconColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: appBarColor,
              selectedItemColor: WhiteIconColor,
              unselectedItemColor: BlackIconColor,
            ),
            textTheme: const TextTheme(
              titleMedium: TextStyle(color: Colors.black87),
              headlineMedium: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              bodyMedium: TextStyle(color: Colors.black54, height: 1.4),
              bodyLarge: TextStyle(
                color: Colors.black87,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF1F1F1F),
            scaffoldBackgroundColor: const Color(0xFF121212),

            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1F1F1F),
              iconTheme: IconThemeData(color: WhiteIconColor),
              titleTextStyle: TextStyle(color: WhiteIconColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xff1f1f1f),
              selectedItemColor: WhiteIconColor,
              unselectedItemColor: Colors.grey,
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.grey[400]),
              hintStyle: TextStyle(color:Colors.grey[600]),
            ),
            textTheme: const TextTheme(
              titleMedium: TextStyle(color: Colors.white), 
              headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              bodyMedium: TextStyle(color: Colors.white70, height: 1.4), 
              bodyLarge: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
            ),
          ),
          themeMode: themeService.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
