import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class FocusTimer extends StatefulWidget {
  const FocusTimer({Key? key}) : super(key: key);

  @override
  _FocusTimerState createState() => _FocusTimerState();
}

class _FocusTimerState extends State<FocusTimer> with WidgetsBindingObserver {
  bool _focusFullScreen = false;
  int _focusSeconds = 0;
  Timer? _focusTimer;
  bool _focusRunning = false;
  bool _isBreak = false;
  int _breakSeconds = 5 * 60;
  int _breakInitial = 5 * 60;
  int _sessionsCompleted = 0;
  int _totalFocusTime = 0;
  Color _ambientColor = Colors.black;
  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  bool _autoBreakEnabled = true;
  double _progress = 0.0;

  final List<int> _presets = [15, 25, 45, 60];
  final List<Color> _ambientColors = [
    Colors.black,
    const Color(0xFF1A237E),
    const Color(0xFF1B5E20),
    const Color(0xFF4A148C),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _focusRunning) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  void _startFocusTimer() {
    if (_hapticEnabled) {
      HapticFeedback.mediumImpact();
    }
    if (_soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
    setState(() => _focusRunning = true);
    _focusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _focusSeconds++;
        _progress = _focusSeconds / (_presets[1] * 60);
        if (_progress > 1.0) _progress = 1.0;
      });
    });
  }

  void _stopFocusTimer() {
    if (_hapticEnabled) {
      HapticFeedback.lightImpact();
    }
    _focusTimer?.cancel();
    setState(() => _focusRunning = false);
  }

  void _resetFocusTimer() {
    if (_hapticEnabled) {
      HapticFeedback.heavyImpact();
    }
    _focusTimer?.cancel();
    setState(() {
      _focusSeconds = 0;
      _progress = 0.0;
      _focusRunning = false;
      _isBreak = false;
    });
  }

  void _startBreakTimer() {
    setState(() {
      _isBreak = true;
      _focusSeconds = 0;
      _progress = 0.0;
    });
    _startFocusTimer();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(_isBreak ? 'Break Complete!' : 'Focus Session Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_isBreak 
              ? 'Time to get back to work!'
              : 'Great job! You\'ve completed another focus session.'),
            const SizedBox(height: 16),
            Text('Total Focus Time: ${_focusSeconds ~/ 60} minutes'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (_isBreak) {
                _resetFocusTimer();
              } else if (_autoBreakEnabled) {
                _startBreakTimer();
              } else {
                _resetFocusTimer();
              }
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _toggleFocusFullScreen() {
    if (_hapticEnabled) {
      HapticFeedback.lightImpact();
    }
    setState(() {
      _focusFullScreen = !_focusFullScreen;
      if (_focusFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });
  }

  void _setAmbientColor(Color color) {
    if (_hapticEnabled) {
      HapticFeedback.selectionClick();
    }
    setState(() => _ambientColor = color);
  }

  String _formatTime(int seconds) {
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return h == '00' ? '$m:$s' : '$h:$m:$s';
  }

  Future<bool> _onWillPop() async {
    if (!_focusRunning) return true;
    
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Active Session'),
        content: const Text('You have an active focus session. Do you want to end it?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              _stopFocusTimer();
              Navigator.pop(context, true);
            },
            child: const Text('END SESSION'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onDoubleTap: _toggleFocusFullScreen,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: _ambientColor,
          child: Stack(
            children: [
              // Back Button
              if (!_focusFullScreen)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () async {
                      if (await _onWillPop()) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              // Progress indicator
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _isBreak ? Colors.green : Colors.white,
                  ),
                ),
              ),
              // Timer display
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isBreak)
                      const Text(
                        'Break Time',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 20),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _focusFullScreen ? 90 : 64,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            blurRadius: 16,
                            color: Colors.white.withOpacity(0.2),
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Text(_formatTime(_focusSeconds)),
                    ),
                  ],
                ),
              ),
              if (!_focusFullScreen) ...[
                // Timer presets
                Positioned(
                  top: 32,
                  left: 0,
                  right: 0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: _presets.map((minutes) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(
                              '$minutes min',
                              style: const TextStyle(fontSize: 12),
                            ),
                            selected: _focusSeconds == 0 && !_focusRunning,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _focusSeconds = minutes * 60;
                                  _progress = 0.0;
                                });
                              }
                            },
                            backgroundColor: Colors.white10,
                            selectedColor: Colors.white24,
                            labelStyle: const TextStyle(color: Colors.white),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                // Ambient color options
                Positioned(
                  top: 80,
                  right: 12,
                  child: Column(
                    children: _ambientColors.map((color) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: GestureDetector(
                          onTap: () => _setAmbientColor(color),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _ambientColor == color
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Control buttons
                Positioned(
                  bottom: 32,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              _focusRunning ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: _focusRunning ? _stopFocusTimer : _startFocusTimer,
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 24),
                          IconButton(
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: _resetFocusTimer,
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              _soundEnabled ? Icons.volume_up : Icons.volume_off,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() => _soundEnabled = !_soundEnabled);
                            },
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                          ),
                          IconButton(
                            icon: Icon(
                              _hapticEnabled ? Icons.vibration : Icons.vibration_outlined,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() => _hapticEnabled = !_hapticEnabled);
                            },
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                          ),
                          IconButton(
                            icon: Icon(
                              _autoBreakEnabled ? Icons.timer : Icons.timer_outlined,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() => _autoBreakEnabled = !_autoBreakEnabled);
                            },
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                          ),
                        ],
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