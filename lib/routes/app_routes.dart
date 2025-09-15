import 'package:flutter/material.dart';
import '../presentation/voice_input_query/voice_input_query.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/image_upload_analysis/image_upload_analysis.dart';
import '../presentation/text_input_query/text_input_query.dart';
import '../presentation/query_history/query_history.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String voiceInputQuery = '/voice-input-query';
  static const String splash = '/splash-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String imageUploadAnalysis = '/image-upload-analysis';
  static const String textInputQuery = '/text-input-query';
  static const String queryHistory = '/query-history';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    voiceInputQuery: (context) => const VoiceInputQuery(),
    splash: (context) => const SplashScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    imageUploadAnalysis: (context) => const ImageUploadAnalysis(),
    textInputQuery: (context) => const TextInputQuery(),
    queryHistory: (context) => const QueryHistory(),
    // TODO: Add your other routes here
  };
}
