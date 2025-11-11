import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vault/constants/app_color.dart';
import 'package:vault/screens/main_screen.dart';
import 'package:vault/widgets/v_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "Vault",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 68,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            //
            Align(
              alignment: Alignment.centerRight,
              child: AnimatedContainer(
                curve: Curves.bounceIn,
                alignment: Alignment.centerRight,
                duration: Duration(milliseconds: 300),
                width: 366.5,
                height: 366.5,
                child: Image(
                  image: AssetImage('assets/images/Shape1.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Animate(
                  effects: [
                    ShimmerEffect(duration: Duration(microseconds: 30)),
                  ],
                  child: Text(
                    "Jump start your\ncrypto portfolio",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                      letterSpacing: 1,
                      wordSpacing: 5,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Take your investment portfolio\nto next level",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: VaultButton(
                ontap:
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    ),
                child: Center(
                  child: Text(
                    "Get Started",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
