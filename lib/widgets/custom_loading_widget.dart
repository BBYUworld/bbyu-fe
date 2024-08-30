import 'package:flutter/material.dart';
import 'dart:async';

class CustomLoadingWidget extends StatefulWidget {
  final List<String> loadingTexts;
  final String imagePath;
  final Duration textRotationDuration;
  final Duration totalDuration;

  const CustomLoadingWidget({
    Key? key,
    required this.loadingTexts,
    required this.imagePath,
    this.textRotationDuration = const Duration(seconds: 3),
    this.totalDuration = const Duration(seconds: 13),
  }) : super(key: key);

  @override
  _CustomLoadingWidgetState createState() => _CustomLoadingWidgetState();
}

class _CustomLoadingWidgetState extends State<CustomLoadingWidget> {
  double _progress = 0.0;
  int _currentTextIndex = 0;
  Timer? _textTimer;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _startTextRotation();
    _startProgressAnimation();
  }

  void _startTextRotation() {
    _textTimer = Timer.periodic(widget.textRotationDuration, (timer) {
      if (mounted) {
        setState(() {
          _currentTextIndex = (_currentTextIndex + 1) % widget.loadingTexts.length;
        });
      }
    });
  }

  void _startProgressAnimation() {
    final updateInterval = Duration(milliseconds: 100);
    final stepValue = 1 / (widget.totalDuration.inMilliseconds / updateInterval.inMilliseconds);

    _progressTimer = Timer.periodic(updateInterval, (timer) {
      if (mounted) {
        setState(() {
          if (_progress < 1.0) {
            _progress += stepValue;
          } else {
            _progressTimer?.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _textTimer?.cancel();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            widget.imagePath,
            width: 150,
            height: 150,
          ),
          SizedBox(height: 40),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3182F6)),
            strokeWidth: 5,
          ),
          SizedBox(height: 40),
          Text(
            widget.loadingTexts[_currentTextIndex],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            '${(_progress * 100).toInt()}%',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF3182F6)),
          ),
        ],
      ),
    );
  }
}