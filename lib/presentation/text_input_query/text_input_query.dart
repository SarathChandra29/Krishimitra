
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_response_card.dart';
import './widgets/loading_animation.dart';
import './widgets/query_suggestion_chips.dart';
import './widgets/text_input_field.dart';

class TextInputQuery extends StatefulWidget {
  const TextInputQuery({Key? key}) : super(key: key);

  @override
  State<TextInputQuery> createState() => _TextInputQueryState();
}

class _TextInputQueryState extends State<TextInputQuery> {
  final TextEditingController _queryController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  bool _isLoading = false;
  bool _isPlaying = false;
  String? _aiResponse;
  DateTime? _responseTimestamp;

  // Mock AI responses for different query types
  final Map<String, String> _mockResponses = {
    "పంట వ్యాధులు":
        """మీ పంటలో ఆకులు పసుపు రంగులోకి మారడం వివిధ కారణాల వల్ల కావచ్చు:

1. **పోషకాహార లోపం**: నత్రజని లేకపోవడం వల్ల ఆకులు పసుపు రంగులోకి మారతాయి
2. **నీటి లోపం**: తగినంత నీరు లేకపోవడం వల్ల కూడా ఇలా జరుగుతుంది
3. **వ్యాధులు**: ఫంగల్ లేదా బ్యాక్టీరియల్ ఇన్ఫెక్షన్లు

**పరిష్కారం**:
- మట్టి పరీక్ష చేయించండి
- సమతుల్య ఎరువులు వేయండి
- సరైన నీటిపారుదల చేయండి
- అవసరమైతే ఫంగిసైడ్ స్ప్రే చేయండి""",
    "ఎరువులు": """సరైన ఎరువుల వాడకం పంట దిగుబడి పెరుగుటకు చాలా ముఖ్యం:

**ప్రాథమిక ఎరువులు**:
1. **యూరియా** - నత్రజని కోసం
2. **డిఎపి** - భాస్వరం కోసం  
3. **పొటాష్** - పొటాషియం కోసం

**వేయవలసిన సమయం**:
- విత్తనాల వేసిన 15-20 రోజుల తర్వాత మొదటి డోస్
- 45 రోజుల తర్వాత రెండవ డోస్
- పువ్వులు వచ్చే సమయంలో మూడవ డోస్

**సలహా**: మట్టి పరీక్ష ఆధారంగా ఎరువుల మోతాదు నిర్ణయించండి""",
    "వాతావరణం": """వర్షాకాలంలో పంటల రక్షణ చాలా ముఖ్యం:

**ముందస్తు జాగ్రత్తలు**:
1. **డ్రైనేజ్**: పొలంలో నీరు నిలవకుండా కాలువలు తవ్వండి
2. **మల్చింగ్**: మొక్కల చుట్టూ గడ్డిని వేయండి
3. **స్టేకింగ్**: పొడవైన మొక్కలకు ఆధారం ఇవ్వండి

**వర్షం తర్వాత**:
- ఫంగిసైడ్ స్ప్రే చేయండి
- అదనపు నీటిని తొలగించండి
- మట్టిని గట్టిగా అయిపోకుండా చూసుకోండి

**హెచ్చరిక**: భారీ వర్షాలు వస్తే పంటలను ప్లాస్టిక్ షీట్లతో కప్పండి""",
    "కీటకాలు": """కీటకాల నుండి పంటల రక్షణ కోసం సమగ్ర విధానం అవలంబించండి:

**సహజ పద్ధతులు**:
1. **నీమ్ ఆయిల్**: సహజ కీటక నాశిని
2. **ట్రాప్ క్రాప్స్**: కీటకాలను ఆకర్షించే పంటలు వేయండి
3. **బయో ఏజెంట్లు**: ట్రైకోగ్రామా కార్డులు వాడండి

**రసాయన నియంత్రణ**:
- అవసరమైతే మాత్రమే పురుగుమందులు వాడండి
- సిఫారసు చేసిన మోతాదులో మాత్రమే వాడండి
- స్ప్రే చేసిన తర్వాత సేఫ్టీ పీరియడ్ పాటించండి

**సలహా**: కీటకాలను గుర్తించి, వాటికి తగిన చికిత్స చేయండి"""
  };

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onSuggestionTap(String query) {
    setState(() {
      _queryController.text = query;
    });
    _focusNode.requestFocus();
    _scrollToBottom();
  }

  void _onVoiceToText() {
    // Mock voice to text functionality
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "వాయిస్ ఇన్‌పుట్ ఫీచర్ త్వరలో అందుబాటులోకి వస్తుంది",
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _submitQuery() async {
    if (_queryController.text.trim().isEmpty || _isLoading) return;

    final query = _queryController.text.trim();

    setState(() {
      _isLoading = true;
      _aiResponse = null;
    });

    _focusNode.unfocus();
    _scrollToBottom();

    // Mock AI processing delay
    await Future.delayed(Duration(seconds: 2));

    // Generate mock response based on query content
    String response = _generateMockResponse(query);

    setState(() {
      _isLoading = false;
      _aiResponse = response;
      _responseTimestamp = DateTime.now();
    });

    // Provide haptic feedback for successful response
    HapticFeedback.mediumImpact();

    _scrollToBottom();

    // Auto-save to history (mock functionality)
    _saveToHistory(query, response);
  }

  String _generateMockResponse(String query) {
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('పసుపు') ||
        lowerQuery.contains('వ్యాధి') ||
        lowerQuery.contains('ఆకులు')) {
      return _mockResponses["పంట వ్యాధులు"]!;
    } else if (lowerQuery.contains('ఎరువు') ||
        lowerQuery.contains('యూరియా') ||
        lowerQuery.contains('పోషకాలు')) {
      return _mockResponses["ఎరువులు"]!;
    } else if (lowerQuery.contains('వర్షం') ||
        lowerQuery.contains('వాతావరణం') ||
        lowerQuery.contains('వాతావరణ')) {
      return _mockResponses["వాతావరణం"]!;
    } else if (lowerQuery.contains('కీటకాలు') ||
        lowerQuery.contains('పురుగులు') ||
        lowerQuery.contains('పెస్ట్')) {
      return _mockResponses["కీటకాలు"]!;
    } else {
      return """మీ ప్రశ్నకు సమాధానం:

మీరు అడిగిన ప్రశ్న గురించి వివరంగా చెప్పాలంటే, వ్యవసాయంలో ఇలాంటి సమస్యలు సాధారణంగా కనిపిస్తాయి. 

**సాధారణ సలహాలు**:
1. మట్టి పరీక్ష చేయించండి
2. సమతుల్య ఎరువులు వాడండి  
3. సరైన నీటిపారుదల చేయండి
4. కీటకాలను క్రమం తప్పకుండా పరిశీలించండి

**మరింత సహాయం కోసం**:
- స్థానిక వ్యవసాయ అధికారిని సంప్రదించండి
- నిపుణుల సలహా తీసుకోండి

మీకు మరేదైనా సందేహాలు ఉంటే, దయచేసి మరింత వివరంగా అడగండి.""";
    }
  }

  void _saveToHistory(String query, String response) {
    // Mock save to history functionality
    print(
        "Saving to history: Query - $query, Response - ${response.substring(0, 50)}...");
  }

  void _onTextToSpeech() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    HapticFeedback.selectionClick();

    // Mock text to speech functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isPlaying ? "ఆడియో ప్లే అవుతోంది..." : "ఆడియో ఆపబడింది",
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 1),
      ),
    );

    // Auto stop after 3 seconds (mock)
    if (_isPlaying) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
    }
  }

  void _onShare() {
    HapticFeedback.lightImpact();

    final shareText = "కృషి మిత్ర సలహా:\n\n${_aiResponse ?? ''}";

    // Mock share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "సమాధానం షేర్ చేయబడింది",
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  bool get _canSubmit => _queryController.text.trim().isNotEmpty && !_isLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 2,
        shadowColor:
            AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              "మీ ప్రశ్న అడగండి",
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/query-history'),
            icon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Welcome message
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CustomIconWidget(
                              iconName: 'agriculture',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "కృషి మిత్రకు స్వాగతం!",
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  "మీ వ్యవసాయ సమస్యలకు తెలుగులో సమాధానాలు పొందండి",
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Suggestion chips
                    QuerySuggestionChips(
                      onSuggestionTap: _onSuggestionTap,
                    ),

                    SizedBox(height: 2.h),

                    // Text input field
                    TextInputField(
                      controller: _queryController,
                      onVoiceToText: _onVoiceToText,
                      isLoading: _isLoading,
                      maxLength: 500,
                    ),

                    SizedBox(height: 3.h),

                    // Loading animation
                    if (_isLoading) ...[
                      LoadingAnimation(),
                      SizedBox(height: 4.h),
                    ],

                    // AI Response
                    if (_aiResponse != null && _responseTimestamp != null) ...[
                      AiResponseCard(
                        response: _aiResponse!,
                        timestamp: _responseTimestamp!,
                        onTextToSpeech: _onTextToSpeech,
                        onShare: _onShare,
                        isPlaying: _isPlaying,
                      ),
                      SizedBox(height: 4.h),
                    ],

                    // Bottom spacing for keyboard
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),

            // Submit button
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow
                        .withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _canSubmit ? _submitQuery : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _canSubmit
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.12),
                  foregroundColor: _canSubmit
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.38),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: _canSubmit ? 2 : 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading) ...[
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        "ప్రాసెస్ అవుతోంది...",
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ] else ...[
                      CustomIconWidget(
                        iconName: 'send',
                        color: _canSubmit
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.38),
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        "ప్రశ్న పంపండి",
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: _canSubmit
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.38),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
