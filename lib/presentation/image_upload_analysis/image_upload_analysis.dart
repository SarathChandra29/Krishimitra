
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/analysis_loading_widget.dart';
import './widgets/analysis_results_widget.dart';
import './widgets/camera_preview_widget.dart';
import './widgets/image_preview_widget.dart';

class ImageUploadAnalysis extends StatefulWidget {
  const ImageUploadAnalysis({Key? key}) : super(key: key);

  @override
  State<ImageUploadAnalysis> createState() => _ImageUploadAnalysisState();
}

class _ImageUploadAnalysisState extends State<ImageUploadAnalysis> {
  // Camera related variables
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;

  // Image processing variables
  XFile? _capturedImage;
  String? _processedImagePath;

  // UI state variables
  bool _isLoading = false;
  bool _showResults = false;
  Map<String, dynamic>? _analysisResults;

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();

  // Mock analysis data for demonstration
  final List<Map<String, dynamic>> _mockAnalysisResults = [
    {
      "isHealthy": false,
      "confidence": 0.87,
      "diagnosis": "Bacterial Leaf Spot (Xanthomonas campestris)",
      "symptoms": [
        "Dark brown spots with yellow halos on leaf surface",
        "Irregular shaped lesions spreading across the leaf",
        "Yellowing around affected areas indicating bacterial infection"
      ],
      "treatments": [
        "Remove and destroy affected leaves immediately to prevent spread",
        "Apply copper-based fungicide spray every 7-10 days",
        "Improve air circulation around plants by proper spacing",
        "Avoid overhead watering - water at soil level instead",
        "Apply neem oil solution as organic treatment alternative"
      ],
      "severity": "Moderate",
      "urgency": "High - Treat within 2-3 days"
    },
    {
      "isHealthy": true,
      "confidence": 0.94,
      "diagnosis": "Healthy Leaf",
      "symptoms": [],
      "treatments": [
        "Continue current care routine",
        "Maintain proper watering schedule",
        "Ensure adequate sunlight exposure",
        "Apply balanced fertilizer monthly"
      ],
      "severity": "None",
      "urgency": "None"
    },
    {
      "isHealthy": false,
      "confidence": 0.79,
      "diagnosis": "Powdery Mildew (Erysiphe cichoracearum)",
      "symptoms": [
        "White powdery coating on leaf surface",
        "Yellowing and curling of affected leaves",
        "Stunted growth in severely affected areas"
      ],
      "treatments": [
        "Spray with baking soda solution (1 tsp per quart water)",
        "Apply sulfur-based fungicide in early morning",
        "Increase air circulation and reduce humidity",
        "Remove affected leaves and dispose properly",
        "Apply preventive milk spray (1:10 ratio with water)"
      ],
      "severity": "Mild to Moderate",
      "urgency": "Medium - Treat within a week"
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) {
        _showPermissionDeniedDialog();
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _showNoCameraDialog();
        return;
      }

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first,
            )
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first,
            );

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
      );

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      _showCameraErrorDialog();
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        await _cameraController!.setFlashMode(FlashMode.auto);
      }
    } catch (e) {
      // Silently handle unsupported features
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || kIsWeb) return;

    try {
      final newFlashMode = _isFlashOn ? FlashMode.off : FlashMode.torch;
      await _cameraController!.setFlashMode(newFlashMode);

      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      // Flash not supported on this device
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      // Add haptic feedback
      HapticFeedback.mediumImpact();

      final XFile photo = await _cameraController!.takePicture();

      setState(() {
        _capturedImage = photo;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to capture photo. Please try again.');
    }
  }

  Future<void> _selectFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _capturedImage = image;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to select image from gallery.');
    }
  }

  Future<void> _cropImage() async {
    if (_capturedImage == null) return;

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _capturedImage!.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Leaf Image',
            toolbarColor: AppTheme.lightTheme.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Leaf Image',
            aspectRatioLockEnabled: false,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _capturedImage = XFile(croppedFile.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to crop image.');
    }
  }

  Future<void> _analyzeLeaf() async {
    if (_capturedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate AI analysis with realistic delay
      await Future.delayed(Duration(seconds: 3));

      // Randomly select a mock result for demonstration
      final randomIndex =
          DateTime.now().millisecond % _mockAnalysisResults.length;
      final selectedResult = _mockAnalysisResults[randomIndex];

      setState(() {
        _analysisResults = selectedResult;
        _isLoading = false;
        _showResults = true;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Analysis failed. Please try again.');
    }
  }

  void _retakePhoto() {
    setState(() {
      _capturedImage = null;
      _showResults = false;
      _analysisResults = null;
    });
  }

  void _shareResults() {
    // Implement sharing functionality
    _showSuccessSnackBar('Analysis shared successfully!');
  }

  void _saveToHistory() {
    // Implement save to history functionality
    _showSuccessSnackBar('Analysis saved to history!');
    Navigator.pushNamed(context, '/query-history');
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Camera Permission Required'),
        content: Text(
            'Please grant camera permission to capture leaf images for analysis.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showNoCameraDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('No Camera Available'),
        content: Text(
            'No camera found on this device. Please use the gallery option to select an image.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCameraErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Camera Error'),
        content: Text(
            'Failed to initialize camera. Please try again or use gallery option.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen during analysis
    if (_isLoading && _capturedImage != null) {
      return Scaffold(
        body: AnalysisLoadingWidget(
          imagePath: _capturedImage!.path,
        ),
      );
    }

    // Show results screen
    if (_showResults && _analysisResults != null && _capturedImage != null) {
      return Scaffold(
        body: AnalysisResultsWidget(
          imagePath: _capturedImage!.path,
          analysisData: _analysisResults!,
          onShare: _shareResults,
          onSaveToHistory: _saveToHistory,
        ),
      );
    }

    // Show image preview screen
    if (_capturedImage != null) {
      return Scaffold(
        body: ImagePreviewWidget(
          imagePath: _capturedImage!.path,
          onRetake: _retakePhoto,
          onAnalyze: _analyzeLeaf,
          onCrop: _cropImage,
        ),
      );
    }

    // Show camera preview screen
    return Scaffold(
      body: Stack(
        children: [
          // Camera preview or initialization screen
          _isCameraInitialized
              ? CameraPreviewWidget(
                  cameraController: _cameraController,
                  isFlashOn: _isFlashOn,
                  onFlashToggle: _toggleFlash,
                  onCapture: _capturePhoto,
                  onGallery: _selectFromGallery,
                )
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Initializing Camera...',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        ElevatedButton(
                          onPressed: _selectFromGallery,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.lightTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'photo_library',
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text('Select from Gallery'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
