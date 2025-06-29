import 'package:flutter/material.dart';
import 'package:vidora_player_v1/screens/home_screen.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(600, 400),
    minimumSize: Size(600, 400),
    maximumSize: Size(600, 400),
    center: true,
    title: "Vidora Player",
    titleBarStyle: TitleBarStyle.hidden,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setResizable(false);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;
  String _loadingText = "Loading Assets...";

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() async {
    await _animateProgress(0.55, duration: const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));

    await _animateProgress(0.81, duration: const Duration(seconds: 1));
    await Future.delayed(const Duration(seconds: 3));

    await _animateProgress(0.93, duration: const Duration(seconds: 1));
    await Future.delayed(const Duration(seconds: 3));

    await _animateProgress(1.0, duration: const Duration(seconds: 1));

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _animateProgress(
    double target, {
    required Duration duration,
  }) async {
    final start = _progress;
    final startTime = DateTime.now().millisecondsSinceEpoch;

    while (_progress < target) {
      final elapsed = DateTime.now().millisecondsSinceEpoch - startTime;
      setState(() {
        _progress =
            start +
            (target - start) *
                (elapsed / duration.inMilliseconds).clamp(0.0, 1.0);
        _loadingText = _getLoadingText(_progress);
      });
      await Future.delayed(const Duration(milliseconds: 16));
    }
  }

  String _getLoadingText(double progress) {
    if (progress < 0.55) return "Initializing...";
    if (progress < 0.81) return "Loading assets...";
    if (progress < 0.93) return "Finalizing...";
    return "Almost ready...";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2427),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const SizedBox(height: 50),
            Image.asset(
              "assets/vidora_main_logo.png",
              width: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 5),
            const Text(
              "Feel the Flow of Vision.",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6C8A94),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _loadingText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFFA5C5CE),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: const Color(0xFF2C3A3F),
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFFA5C5CE),
                      ),
                      minHeight: 2,
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
