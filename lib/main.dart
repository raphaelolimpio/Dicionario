import 'package:dicionario/DS/Components/theme/Theme_Service.dart';
import 'package:dicionario/Service/favorite_service.dart';
import 'package:dicionario/Service/termo_service.dart';
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
        ChangeNotifierProvider(create: (context) => TermoService()),
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
            scaffoldBackgroundColor: backgroundColor,
            primaryColor: primaryColor,
            primaryColorDark: BlackTextColor,
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.grey[700]),
              hintStyle: TextStyle(color: Colors.grey[500]),
              filled: true,
              fillColor: Colors.black.withOpacity(0.04),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(width: 2),
              ),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: appBarColor,
              surfaceTintColor: Colors.transparent,
              iconTheme: IconThemeData(color: primaryColor),
              titleTextStyle: TextStyle(
                color: primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: appBarColor,
              selectedItemColor: primaryColor,
              unselectedItemColor: Colors.grey,
            ),
            textTheme: const TextTheme(
              titleMedium: TextStyle(color: Colors.black87),
              headlineMedium: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              bodyMedium: TextStyle(color: Colors.black54, height: 1.4),
              bodyLarge: TextStyle(
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
              bodySmall: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ), 
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: iconAtivoDark,
            scaffoldBackgroundColor: backGroudDarkColor,
            primaryColorDark: WhiteTextColor.withOpacity(0.8),

            appBarTheme: const AppBarTheme(
              backgroundColor: icondarkNuttonNavigation,
              surfaceTintColor: Colors.transparent,
              iconTheme: IconThemeData(color: WhiteIconColor),
              titleTextStyle: TextStyle(
                color: WhiteIconColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF1F1F1F),
              selectedItemColor: iconAtivoDark,
              unselectedItemColor: iconInAtivoDark,
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.grey[400]),
              hintStyle: TextStyle(color: Colors.grey[600]),
              filled: true,

              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),

                borderSide: BorderSide(color: iconAtivoDark, width: 2),
              ),
            ),
            textTheme: const TextTheme(
              titleMedium: TextStyle(color: Colors.white),
              headlineMedium: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              bodyMedium: TextStyle(color: Color(0xffA0A0A0), height: 1.4),
              bodyLarge: TextStyle(
                color: Color(0xffB0B3C0),
                fontStyle: FontStyle.italic,
              ),
              bodySmall: TextStyle(
                color: iconAtivoDark,
                fontWeight: FontWeight.bold,
              ), 
            ),
          ),
          themeMode: themeService.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
