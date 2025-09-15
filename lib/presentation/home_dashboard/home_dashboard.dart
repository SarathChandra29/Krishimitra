import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/custom_icon_widget.dart';
import './widgets/action_card_widget.dart';
import './widgets/greeting_weather_widget.dart';
import './widgets/network_status_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/seasonal_tips_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  int _currentTabIndex = 0;
  bool _isConnected = true;
  bool _isAiServiceAvailable = true;
  bool _isRefreshing = false;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  // Mock data
  final String _farmerName = "రాజేష్";
  final String _location = "వరంగల్, తెలంగాణ";
  final String _temperature = "28°C";
  final String _weatherCondition = "ఎండ";
  final String _weatherIcon = "https://openweathermap.org/img/wn/01d@2x.png";

  final List<Map<String, dynamic>> _recentQueries = [
    {
      "id": 1,
      "type": "image",
      "question": "ఈ ఆకులపై మచ్చలు ఎందుకు వచ్చాయి?",
      "timestamp": "2 గంటల క్రితం",
      "imageUrl":
      "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 2,
      "type": "voice",
      "question": "వరి పంటకు ఎంత నీరు అవసరం?",
      "timestamp": "5 గంటల క్రితం",
      "imageUrl": null,
    },
    {
      "id": 3,
      "type": "text",
      "question": "మిరపకాయ పంటలో తెగుళ్లు ఎలా నివారించాలి?",
      "timestamp": "1 రోజు క్రితం",
      "imageUrl": null,
    },
  ];

  final List<Map<String, dynamic>> _seasonalTips = [
    {
      "id": 1,
      "title": "వరి నాట్లు వేయడానికి సరైన సమయం",
      "description":
      "వర్షాకాలంలో వరి నాట్లు వేయడానికి జూన్ నుండి జూలై వరకు సరైన సమయం. మంచి నాణ్యత గల విత్తనాలు ఎంచుకోండి.",
      "icon": "grass",
      "category": "వరి సాగు",
    },
    {
      "id": 2,
      "title": "కపాసు పంటలో తెగుళ్ల నివారణ",
      "description":
      "కపాసు పంటలో గులాబీ పురుగు మరియు తెల్ల ఈగ నుండి రక్షించడానికి సేంద్రీయ పురుగుమందులు వాడండి.",
      "icon": "bug_report",
      "category": "తెగుళ్ల నియంత్రణ",
    },
    {
      "id": 3,
      "title": "మట్టి పరీక్ష ప్రాముఖ్యత",
      "description":
      "పంట వేయడానికి ముందు మట్టి పరీక్ష చేయించి, అవసరమైన పోషకాలను తెలుసుకోండి.",
      "icon": "science",
      "category": "మట్టి నిర్వహణ",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkConnectivity();
    _checkAiServiceStatus();
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
    _fabAnimationController.forward();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> _checkAiServiceStatus() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isAiServiceAvailable = _isConnected;
    });
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);

    HapticFeedback.lightImpact();

    await Future.delayed(const Duration(seconds: 2));
    await _checkConnectivity();
    await _checkAiServiceStatus();

    setState(() => _isRefreshing = false);
  }

  void _navigateToTextInput() {
    Navigator.pushNamed(context, '/text-input-query');
  }

  void _navigateToVoiceInput() {
    Navigator.pushNamed(context, '/voice-input-query');
  }

  void _navigateToImageUpload() {
    Navigator.pushNamed(context, '/image-upload-analysis');
  }

  void _navigateToHistory() {
    Navigator.pushNamed(context, '/query-history');
  }

  void _handleQuickVoiceRecording() {
    HapticFeedback.mediumImpact();
    _navigateToVoiceInput();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: theme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    GreetingWeatherWidget(
                      farmerName: _farmerName,
                      location: _location,
                      temperature: _temperature,
                      weatherCondition: _weatherCondition,
                      weatherIcon: _weatherIcon,
                    ),
                    NetworkStatusWidget(
                      isConnected: _isConnected,
                      isAiServiceAvailable: _isAiServiceAvailable,
                    ),
                    SeasonalTipsWidget(tips: _seasonalTips),
                    SizedBox(height: 2.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        'మీ సహాయకుడు',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    ActionCardWidget(
                      title: 'ప్రశ్న అడగండి',
                      subtitle: 'టెక్స్ట్ ద్వారా మీ వ్యవసాయ సందేహాలు అడగండి',
                      iconName: 'text_fields',
                      backgroundColor: theme.colorScheme.surface,
                      iconColor: theme.colorScheme.primary,
                      onTap: _navigateToTextInput,
                    ),
                    ActionCardWidget(
                      title: 'వాయిస్ ప్రశ్న',
                      subtitle: 'మాట్లాడి మీ ప్రశ్నలను అడగండి',
                      iconName: 'mic',
                      backgroundColor: Colors.purple.withOpacity(0.1),
                      iconColor: Colors.purple,
                      onTap: _navigateToVoiceInput,
                    ),
                    ActionCardWidget(
                      title: 'ఆకుల విశ్లేషణ',
                      subtitle: 'ఫోటో తీసి పంట వ్యాధులను గుర్తించండి',
                      iconName: 'camera_alt',
                      backgroundColor: Colors.green.withOpacity(0.1),
                      iconColor: Colors.green,
                      onTap: _navigateToImageUpload,
                    ),
                    SizedBox(height: 2.h),
                    RecentActivityWidget(
                      recentQueries: _recentQueries,
                      onViewAll: _navigateToHistory,
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() => _currentTabIndex = index);
          if (index == 1) _navigateToHistory();
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.colorScheme.surface,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.black54,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color:
              _currentTabIndex == 0 ? theme.colorScheme.primary : Colors.black54,
              size: 24,
            ),
            label: 'హోమ్',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'history',
              color:
              _currentTabIndex == 1 ? theme.colorScheme.primary : Colors.black54,
              size: 24,
            ),
            label: 'చరిత్ర',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color:
              _currentTabIndex == 2 ? theme.colorScheme.primary : Colors.black54,
              size: 24,
            ),
            label: 'ప్రొఫైల్',
          ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimation.value,
            child: FloatingActionButton(
              onPressed: _handleQuickVoiceRecording,
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              elevation: 6,
              child: CustomIconWidget(
                iconName: 'mic',
                color: Colors.white,
                size: 28,
              ),
            ),
          );
        },
      ),
    );
  }
}
