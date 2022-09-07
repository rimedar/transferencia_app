import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transferencia_bancaria/src/providers/text_fiel_validator.dart';
import 'package:transferencia_bancaria/src/routes/routes.dart';
import 'package:transferencia_bancaria/src/providers/http_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HttpService(),
        ),
        ChangeNotifierProvider(
          create: (_) => TextFielValidator(),
        ),
      ],
      child: MaterialApp(
        title: 'Transferencias',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        routes: customRoutes,
        initialRoute: '/',
      ),
    );
  }
}
