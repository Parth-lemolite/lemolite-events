import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lemolite_events/view/leads_screen/view.dart';
import 'package:lemolite_events/view/screens/landing_screen.dart';
import 'package:lemolite_events/view/screens/login_leads_page.dart';
import 'package:lemolite_events/view/screens/payment_failure_screen.dart';
import 'package:lemolite_events/view/screens/payment_success_screen.dart';
import 'package:lemolite_events/view/screens/product_inquiry_flow.dart';
import 'package:lemolite_events/view/screens/service_request_flow.dart';
import 'package:lemolite_events/view/screens/success_screen.dart';

import 'controller/app_controller.dart';
import 'models/enums.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'n"AI"robi BizTech',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      navigatorObservers: [
        GetObserver(),
      ],
      navigatorKey: Get.key,
      getPages: [
        GetPage(name: '/', page: () => const MainScreen()),
        GetPage(
          name: '/leadLogin',
          page: () => const LoginPage(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/success',
          page: () => const SuccessScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/getLeads',
          page: () => LeadsScreenPage(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/succsess',
          page: () => PaymentSuccessScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/failure',
          page: () => PaymentFailureScreen(),
          transition: Transition.fadeIn,
        ),
      ],
      theme: ThemeData(
        primaryColor: const Color(0xFF2EC4F3),
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2EC4F3),
          secondary: const Color(0xFFBFD633),
          tertiary: const Color(0xFF2EC4B6),
          surface: Colors.grey.shade500,
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.montserrat(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F1C35),
            letterSpacing: -0.5,
          ),
          displayMedium: GoogleFonts.montserrat(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F1C35),
          ),
          headlineLarge: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F1C35),
          ),
          headlineMedium: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F1C35),
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF404B69),
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF404B69),
          ),
          labelLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2EC4F3), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8E99B7),
          ),
          labelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF404B69),
          ),
          floatingLabelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2EC4F3),
          ),
          errorStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFE53935),
          ),
          prefixIconColor: const Color(0xFF404B69),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
            minimumSize: const Size(double.infinity, 54),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white.withValues(alpha: 0.9),
          surfaceTintColor: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          titleTextStyle: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F1C35),
          ),
          iconTheme: const IconThemeData(color: Color(0xFF0F1C35)),
        ),
      ),
      home: const MainScreen(),
      builder: EasyLoading.init(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppController());
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Obx(
          () => controller.isSubmitted.value
              ? const SuccessScreen()
              : controller.selectedFlowType.value == null
                  ? const LandingScreen()
                  : controller.selectedFlowType.value == FlowType.service
                      ? const ServiceRequestFlow()
                      : const ProductInquiryFlow(),
        ),
      ),
    );
  }
}


