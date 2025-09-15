import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/ai_response_widget.dart';
import './widgets/loading_animation_widget.dart';
import './widgets/recording_button_widget.dart';
import './widgets/transcription_display_widget.dart';
import './widgets/voice_waveform_widget.dart';

class VoiceInputQuery extends StatefulWidget {
  const VoiceInputQuery({Key? key}) : super(key: key);

  @override
  State<VoiceInputQuery> createState() => _VoiceInputQueryState();
}

class _VoiceInputQueryState extends State<VoiceInputQuery>
    with TickerProviderStateMixin {
  // Audio recording
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isProcessing = false;
  bool _hasPermission = false;
  String? _audioPath;
  Timer? _recordingTimer;
  Timer? _amplitudeTimer;
  double _currentAmplitude = 0.0;
  int _recordingDuration = 0;

  // UI States
  String _transcribedText = '';
  String _aiResponse = '';
  bool _showTranscription = false;
  bool _showActionButtons = false;
  bool _showAiResponse = false;
  bool _showLoadingAnimation = false;
  bool _isPlayingResponse = false;

  // Mock data for AI responses
  final List<Map<String, dynamic>> _mockAiResponses = [
    {
      "query_type": "crop_disease",
      "response":
          "మీ పంట ఆకులపై కనిపిస్తున్న మచ్చలు ఆకుల మచ్చ వ్యాధి (Leaf Spot Disease) లక్షణాలు. దీనిని నివారించడానికి: 1) వారానికి రెండుసార్లు కాపర్ సల్ఫేట్ స్ప్రే చేయండి 2) ప్రభావిత ఆకులను తొలగించి కాల్చండి 3) మొక్కల మధ్య దూరం పెంచండి 4) నీటిపారుదల తగ్గించండి. 15 రోజుల్లో మెరుగుదల కనిపిస్తుంది."
    },
    {
      "query_type": "fertilizer",
      "response":
          "మీ పంటకు ఇప్పుడు నత్రజని ఎరువు అవసరం. ఎకరానికి 50 కిలోల యూరియా వేయండి. వర్షం రాకముందే వేసి మట్టిలో కలపండి. అలాగే 25 కిలోల పొటాష్ కూడా వేయండి. 20 రోజుల తర్వాత మరోసారి 25 కిలోల యూరియా వేయండి. ఇలా చేస్తే మంచి దిగుబడి వస్తుంది."
    },
    {
      "query_type": "weather",
      "response":
          "వచ్చే వారం వర్షాలు రావచ్చు. కాబట్టి: 1) పంటలకు స్ప్రే చేయకండి 2) ఎరువులు వేయకండి 3) కోత పనులు ఆపండి 4) డ్రైనేజీ వ్యవస్థ సిద్ధం చేయండి 5) కూరగాయలను కవర్ చేయండి. వర్షం ఆగిన తర్వాత 2-3 రోజులు వేచి పనులు మొదలుపెట్టండి."
    },
    {
      "query_type": "general",
      "response":
          "మీ వ్యవసాయ సమస్యకు సమాధానం: సేంద్రీయ పద్ధతులను అనుసరించండి. నేల పరీక్ష చేయించుకోండి. సరైన విత్తనాలు ఎంచుకోండి. నీటి నిర్వహణ జాగ్రత్తగా చేయండి. కీటకాలను సహజ పద్ధతులతో నియంత్రించండి. మీ స్థానిక వ్యవసాయ అధికారిని సంప్రదించండి."
    }
  ];

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _amplitudeTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    setState(() {
      _hasPermission = status.isGranted;
    });
  }

  Future<void> _startRecording() async {
    if (!_hasPermission) {
      await _requestMicrophonePermission();
      if (!_hasPermission) return;
    }

    try {
      final directory = await getTemporaryDirectory();
      final path =
          '${directory.path}/voice_query_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );

      setState(() {
        _isRecording = true;
        _audioPath = path;
        _recordingDuration = 0;
        _showTranscription = false;
        _showActionButtons = false;
        _showAiResponse = false;
        _transcribedText = '';
        _aiResponse = '';
      });

      // Provide haptic feedback
      HapticFeedback.mediumImpact();

      // Start recording timer (30 seconds max)
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordingDuration++;
        });
        if (_recordingDuration >= 30) {
          _stopRecording();
        }
      });

      // Start amplitude simulation for waveform
      _amplitudeTimer =
          Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          _currentAmplitude = Random().nextDouble() * 0.8 + 0.2;
        });
      });
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stop();
      _recordingTimer?.cancel();
      _amplitudeTimer?.cancel();

      setState(() {
        _isRecording = false;
        _currentAmplitude = 0.0;
        _isProcessing = true;
      });

      // Provide haptic feedback
      HapticFeedback.lightImpact();

      // Simulate speech-to-text processing
      await _processAudioToText();
    } catch (e) {
      print('Error stopping recording: $e');
      setState(() {
        _isRecording = false;
        _isProcessing = false;
      });
    }
  }

  Future<void> _processAudioToText() async {
    // Simulate speech-to-text conversion delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock transcription based on recording duration
    final List<String> mockTranscriptions = [
      'నా పంట ఆకులపై తెల్లని మచ్చలు కనిపిస్తున్నాయి. ఏమి చేయాలి?',
      'వరిపంటకు ఎంత ఎరువు వేయాలి?',
      'వచ్చే వారం వర్షం రాబోతుందని వింటున్నాను. ఏమి జాగ్రత్తలు తీసుకోవాలి?',
      'నేల పరీక్ష ఎలా చేయించుకోవాలి?',
      'సేంద్రీయ వ్యవసాయం ఎలా చేయాలి?',
    ];

    final transcription =
        mockTranscriptions[Random().nextInt(mockTranscriptions.length)];

    setState(() {
      _isProcessing = false;
      _transcribedText = transcription;
      _showTranscription = true;
      _showActionButtons = true;
    });
  }

  Future<void> _submitQuery() async {
    if (_transcribedText.isEmpty) return;

    setState(() {
      _showLoadingAnimation = true;
      _showActionButtons = false;
    });

    // Simulate AI processing delay
    await Future.delayed(const Duration(seconds: 3));

    // Get mock AI response
    final response =
        _mockAiResponses[Random().nextInt(_mockAiResponses.length)];

    setState(() {
      _showLoadingAnimation = false;
      _aiResponse = response['response'] as String;
      _showAiResponse = true;
    });

    // Auto-play response after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _playAiResponse();
    });
  }

  void _reRecord() {
    setState(() {
      _transcribedText = '';
      _showTranscription = false;
      _showActionButtons = false;
      _showAiResponse = false;
      _aiResponse = '';
    });
  }

  void _playAiResponse() {
    // Simulate text-to-speech playback
    setState(() {
      _isPlayingResponse = true;
    });

    // Simulate playback duration based on text length
    final playbackDuration = Duration(
      seconds: (_aiResponse.length / 10).ceil().clamp(3, 15),
    );

    Timer(playbackDuration, () {
      if (mounted) {
        setState(() {
          _isPlayingResponse = false;
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlayingResponse = !_isPlayingResponse;
    });

    if (!_isPlayingResponse) {
      // Simulate pause
    } else {
      // Simulate resume
      _playAiResponse();
    }
  }

  void _replayResponse() {
    _playAiResponse();
  }

  void _handleRecordingButtonTap() {
    if (_isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        elevation: 2,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 6.w,
          ),
        ),
        title: Text(
          'వాయిస్ ఇన్‌పుట్',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/query-history'),
            icon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            children: [
              SizedBox(height: 4.h),

              // Instructions
              if (!_showAiResponse && !_showLoadingAnimation) ...[
                Container(
                  width: 85.w,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'record_voice_over',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 8.w,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _isRecording
                            ? 'మాట్లాడుతూ ఉండండి... (${30 - _recordingDuration}s)'
                            : 'మైక్రోఫోన్ బటన్ నొక్కి మీ వ్యవసాయ ప్రశ్న అడగండి',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6.h),
              ],

              // Recording Button
              if (!_showAiResponse && !_showLoadingAnimation) ...[
                RecordingButtonWidget(
                  isRecording: _isRecording,
                  isProcessing: _isProcessing,
                  onTap: _handleRecordingButtonTap,
                ),
                SizedBox(height: 4.h),
              ],

              // Voice Waveform
              if (!_showAiResponse && !_showLoadingAnimation) ...[
                VoiceWaveformWidget(
                  isRecording: _isRecording,
                  amplitude: _currentAmplitude,
                ),
                SizedBox(height: 4.h),
              ],

              // Transcription Display
              TranscriptionDisplayWidget(
                transcribedText: _transcribedText,
                isVisible: _showTranscription,
              ),

              if (_showTranscription) SizedBox(height: 3.h),

              // Action Buttons
              ActionButtonsWidget(
                isVisible: _showActionButtons,
                onReRecord: _reRecord,
                onSubmit: _submitQuery,
                isSubmitEnabled: _transcribedText.isNotEmpty,
              ),

              if (_showActionButtons) SizedBox(height: 4.h),

              // Loading Animation
              LoadingAnimationWidget(
                isVisible: _showLoadingAnimation,
              ),

              if (_showLoadingAnimation) SizedBox(height: 4.h),

              // AI Response
              AiResponseWidget(
                responseText: _aiResponse,
                isVisible: _showAiResponse,
                isPlaying: _isPlayingResponse,
                onPlayPause: _togglePlayPause,
                onReplay: _replayResponse,
              ),

              if (_showAiResponse) SizedBox(height: 4.h),

              // New Query Button
              if (_showAiResponse) ...[
                SizedBox(
                  width: 80.w,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _transcribedText = '';
                        _aiResponse = '';
                        _showTranscription = false;
                        _showActionButtons = false;
                        _showAiResponse = false;
                        _showLoadingAnimation = false;
                        _isPlayingResponse = false;
                      });
                    },
                    icon: CustomIconWidget(
                      iconName: 'add',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 5.w,
                    ),
                    label: Text(
                      'కొత్త ప్రశ్న అడగండి',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
              ],

              // Permission message
              if (!_hasPermission) ...[
                Container(
                  width: 85.w,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'mic_off',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 8.w,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'మైక్రోఫోన్ అనుమతి అవసరం',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'వాయిస్ రికార్డింగ్ కోసం మైక్రోఫోన్ అనుమతి ఇవ్వండి',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 2.h),
                      ElevatedButton(
                        onPressed: _requestMicrophonePermission,
                        child: Text('అనుమతి ఇవ్వండి'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.error,
                          foregroundColor:
                              AppTheme.lightTheme.colorScheme.onError,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
