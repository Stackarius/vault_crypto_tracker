import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/provider/chart_provider.dart';
import 'package:vault/provider/favorite_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/onboarding_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CryptoProvider()),
        //
        ChangeNotifierProvider(create: (_) => ChartProvider()),
      ],
      child: MaterialApp(
        title: 'VAULT',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0F0F0F),
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}
