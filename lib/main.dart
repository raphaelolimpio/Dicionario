import 'package:dicionario/DS/page/Page.dart';
import 'package:dicionario/Service/favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoriteService(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PageHome(),
      ),
    ),
  );
}
