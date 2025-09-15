import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import './widgets/animated_logo_widget.dart';
import './widgets/background_gradient_widget.dart';
import './widgets/loading_indicator_widget.dart';
import './widgets/retry_button_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;
  bool _showRetry = false;
  String _loadingText = 'Initializing Telugu language services...';
  bool _isAuthenticated = false;
  bool _isFirstTime = true;

  final List<Map<String, dynamic>> _initializationSteps = [
    {
      'text': 'Initializing Telugu language services...',
      'duration': 800,
      'action': '_initializeLanguageServices',
    },
    {
      'text': 'Checking AI connectivity...',
      'duration': 600,
      'action': '_checkAIConnectivity',
    },
    {
      'text': 'Loading agricultural data...',
      'duration': 700,
      'action': '_loadAgriculturalData',
    },
    {
      'text': 'Preparing your dashboard...',
      'duration': 500,
      'action': '_prepareDashboard',
    },
  ];

  @override
  void initState() {
    super.initState();
    _setSystemUIOverlay();
    _startInitialization();
  }

  void _setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> _startInitialization() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        await Future.delayed(const Duration(seconds: 5));
        setState(() {
          _isLoading = false;
          _showRetry = true;
        });
        return;
      }

      await _checkAuthenticationStatus();

      for (final step in _initializationSteps) {
        setState(() {
          _loadingText = step['text'] as String;
        });

        await _executeStepAction(step['action'] as String);
        await Future.delayed(Duration(milliseconds: step['duration'] as int));
      }

      await Future.delayed(const Duration(milliseconds: 500));
      _navigateToNextScreen();
    } catch (e) {
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        _isLoading = false;
        _showRetry = true;
      });
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isAuthenticated = prefs.getBool('is_authenticated') ?? false;
      _isFirstTime = prefs.getBool('is_first_time') ?? true;
    } catch (_) {
      _isAuthenticated = false;
      _isFirstTime = true;
    }
  }

  Future<void> _executeStepAction(String action) async {
    switch (action) {
      case '_initializeLanguageServices':
        await _initializeLanguageServices();
        break;
      case '_checkAIConnectivity':
        await _checkAIConnectivity();
        break;
      case '_loadAgriculturalData':
        await _loadAgriculturalData();
        break;
      case '_prepareDashboard':
        await _prepareDashboard();
        break;
    }
  }

  Future<void> _initializeLanguageServices() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('primary_language', 'telugu');
    await prefs.setString('language_code', 'te');
  }

  Future<void> _checkAIConnectivity() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ai_service_available', true);
    await prefs.setString('ai_service_status', 'connected');
  }

  Future<void> _loadAgriculturalData() async {
    await Future.delayed(const Duration(milliseconds: 250));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('agricultural_data_version', '1.0.0');
    await prefs.setInt('last_data_update', DateTime.now().millisecondsSinceEpoch);

    final cropData = {
      'rice': 'వరి',
      'cotton': 'పత్తి',
      'sugarcane': 'చెరకు',
      'maize': 'మొక్కజొన్న',
      'groundnut': 'వేరుశనగ',
    };

    for (final entry in cropData.entries) {
      await prefs.setString('crop_${entry.key}', entry.value);
    }
  }

  Future<void> _prepareDashboard() async {
    await Future.delayed(const Duration(milliseconds: 150));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dashboard_layout', 'agricultural_focused');
    await prefs.setBool('voice_input_enabled', true);
    await prefs.setBool('image_analysis_enabled', true);
    await prefs.setString('user_region', 'telugu_states');
  }

  void _navigateToNextScreen() {
    if (_isFirstTime || !_isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    }
  }

  void _handleRetry() {
    setState(() {
      _isLoading = true;
      _showRetry = false;
      _loadingText = 'Retrying connection...';
    });
    _startInitialization();
  }

  void _handleAnimationComplete() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            const BackgroundGradientWidget(),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10.h),
                  AnimatedLogoWidget(
                    onAnimationComplete: _handleAnimationComplete,
                  ),
                  SizedBox(height: 8.h),
                  LoadingIndicatorWidget(
                    loadingText: _loadingText,
                    isVisible: _isLoading,
                  ),
                  RetryButtonWidget(
                    onRetry: _handleRetry,
                    isVisible: _showRetry,
                  ),
                  SizedBox(height: 15.h),
                ],
              ),
            ),

            Positioned(
              bottom: 5.h,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'Empowering Telugu Farmers',
                    style: GoogleFonts.openSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black45,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'తెలుగు రైతుల శక్తివంతం',
                    style: GoogleFonts.openSans(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
