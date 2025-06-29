import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WindowListener {
  bool _isHoverClose = false;
  bool _isHoverMinimize = false;
  bool _isHoverMaximize = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _init();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  void _init() async {
    await windowManager.setResizable(true);
    await windowManager.setSize(const Size(1200, 768));
    await windowManager.setMinimumSize(const Size(600, 400));
    await windowManager.center();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2427),
      body: Column(
        children: [
          Container(
            height: 30,
            color: const Color(0xFF1E2E32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/vidora_ic.png",
                        width: 15,
                        height: 15,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Vidora",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _WindowControlButton(
                      icon: Icons.minimize,
                      isHovered: _isHoverMinimize,
                      onHover: (hover) =>
                          setState(() => _isHoverMinimize = hover),
                      onPressed: () => windowManager.minimize(),
                    ),
                    FutureBuilder<bool>(
                      future: windowManager.isMaximized(),
                      builder: (context, snapshot) {
                        return _WindowControlButton(
                          icon: snapshot.data == true
                              ? Icons.filter_none
                              : Icons.crop_square,
                          isHovered: _isHoverMaximize,
                          onHover: (hover) =>
                              setState(() => _isHoverMaximize = hover),
                          onPressed: () async {
                            if (await windowManager.isMaximized()) {
                              await windowManager.unmaximize();
                            } else {
                              await windowManager.maximize();
                            }
                          },
                        );
                      },
                    ),
                    // Close Button
                    _WindowControlButton(
                      icon: Icons.close,
                      isHovered: _isHoverClose,
                      onHover: (hover) => setState(() => _isHoverClose = hover),
                      onPressed: () => windowManager.close(),
                      isCloseButton: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Home Screen Content",
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WindowControlButton extends StatelessWidget {
  final IconData icon;
  final bool isHovered;
  final Function(bool) onHover;
  final VoidCallback onPressed;
  final bool isCloseButton;

  const _WindowControlButton({
    required this.icon,
    required this.isHovered,
    required this.onHover,
    required this.onPressed,
    this.isCloseButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 30,
      child: MouseRegion(
        onEnter: (_) => onHover(true),
        onExit: (_) => onHover(false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            color: isHovered
                ? isCloseButton
                      ? const Color(0xFF2D3F44)
                      : const Color(0xFF2D3F44)
                : Colors.transparent,
            child: Center(
              child: Icon(
                icon,
                size: 15,
                color: isHovered && isCloseButton
                    ? const Color(0xFF64929D)
                    : const Color(0xFF64929D),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
