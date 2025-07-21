import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../components/control_panel.dart';
import '../components/sidebar.dart';
import '../components/window_controls.dart';
import '../components/player_controls.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WindowListener, SingleTickerProviderStateMixin {
  bool _isHoverClose = false;
  bool _isHoverMinimize = false;
  bool _isHoverMaximize = false;
  bool _sidebarVisible = false;
  int _activeSidebarIndex = 0;

  late AnimationController _sidebarController;
  late Animation<double> _sidebarAnimation;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _init();
    _sidebarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _sidebarAnimation = CurvedAnimation(
      parent: _sidebarController,
      curve: Curves.easeInOut,
    );
    if (_sidebarVisible) {
      _sidebarController.value = 1.0;
    } else {
      _sidebarController.value = 0.0;
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _sidebarController.dispose();
    super.dispose();
  }

  void _init() async {
    await windowManager.setResizable(true);
    await windowManager.setSize(const Size(1200, 768));
    await windowManager.setMinimumSize(const Size(600, 400));
    await windowManager.center();
  }

  void _toggleSidebar() {
    setState(() {
      _sidebarVisible = !_sidebarVisible;
      if (_sidebarVisible) {
        _sidebarController.forward();
      } else {
        _sidebarController.reverse();
      }
    });
  }

  void _onSidebarItemTap(int index) {
    setState(() {
      _activeSidebarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2427),
      body: Stack(
        children: [
          Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: Listener(
                  behavior: HitTestBehavior.translucent,
                  onPointerDown: (event) {
                    if (event.kind == PointerDeviceKind.mouse &&
                        event.buttons == kSecondaryMouseButton) {
                      _showContextMenu(context, event.position);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/vidora_ic.png",
                            width: 80,
                            height: 80,
                            color: Colors.white.withOpacity(0.15),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Vidora",
                            style: TextStyle(
                              fontSize: 48,
                              color: Colors.white.withOpacity(0.15),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const PlayerControls(),
            ],
          ),
          AnimatedBuilder(
            animation: _sidebarAnimation,
            builder: (context, child) {
              return Positioned(
                top: 30, // below top bar
                left: -250 + 250 * _sidebarAnimation.value,
                bottom: 0,
                child: FadeTransition(opacity: _sidebarAnimation, child: child),
              );
            },
            child: Sidebar(
              onItemTap: _onSidebarItemTap,
              activeIndex: _activeSidebarIndex,
            ),
          ),
          Positioned(
            top: 38,
            left: _sidebarVisible ? 260 : 10,
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 350),
              child: GestureDetector(
                onTap: _toggleSidebar,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2E32),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    _sidebarVisible
                        ? Icons.arrow_back_ios_new
                        : Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 30,
      color: const Color(0xFF1E2E32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Image.asset("assets/vidora_ic.png", width: 15, height: 15),
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
              WindowControlButton(
                icon: Icons.minimize,
                isHovered: _isHoverMinimize,
                onHover: (hover) => setState(() => _isHoverMinimize = hover),
                onPressed: () => windowManager.minimize(),
              ),
              FutureBuilder<bool>(
                future: windowManager.isMaximized(),
                builder: (context, snapshot) {
                  return WindowControlButton(
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
              WindowControlButton(
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
    );
  }
}

// this is use for context menu
void _showContextMenu(BuildContext context, Offset position) async {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  await showMenu(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromLTWH(position.dx, position.dy, 0, 0),
      Offset.zero & overlay.size,
    ),
    color: const Color.fromARGB(255, 34, 59, 65),

    items: [
      const PopupMenuItem(
        height: 30,
        child: SizedBox(
          width: 180,
          child: Text(
            "Open File(s)",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(95, 244, 244, 244),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        value: "open_files",
      ),
      const PopupMenuItem(
        height: 30,
        child: SizedBox(
          width: 180,
          child: Text(
            "Open",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(95, 244, 244, 244),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        value: "open",
      ),
      const PopupMenuItem(
        height: 30,
        child: SizedBox(
          width: 180,
          child: Text(
            "Video",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(95, 244, 244, 244),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        value: "video",
      ),
      const PopupMenuItem(
        height: 30,
        child: SizedBox(
          width: 180,
          child: Text(
            "Audio",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(95, 244, 244, 244),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        value: "audio",
      ),
      const PopupMenuItem(
        height: 30,
        child: SizedBox(
          width: 180,
          child: Text(
            "Filters",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(95, 244, 244, 244),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        value: "filters",
      ),
      const PopupMenuItem(
        height: 30,
        child: SizedBox(
          width: 180,
          child: Text(
            "Skins",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(95, 244, 244, 244),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        value: "skins",
      ),
      const PopupMenuItem(
        height: 30,
        child: SizedBox(
          width: 180,
          child: Text(
            "Preferences",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(95, 244, 244, 244),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        value: "preferences",
      ),
      const PopupMenuItem(
        height: 30,
        child: SizedBox(
          width: 180,
          child: Text(
            "Settings",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(95, 244, 244, 244),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        value: "settings",
      ),
      const PopupMenuItem(
        height: 30,
        child: SizedBox(
          width: 180,
          child: Text(
            "About",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(95, 244, 244, 244),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        value: "about",
      ),
      const PopupMenuItem(
        height: 30,
        child: SizedBox(
          width: 180,
          child: Text(
            "Exit",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(95, 244, 244, 244),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        value: "exit",
      ),
    ],
  );
}
