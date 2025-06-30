// import 'package:flutter/material.dart';
// import 'package:window_manager/window_manager.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with WindowListener {
//   bool _isHoverClose = false;
//   bool _isHoverMinimize = false;
//   bool _isHoverMaximize = false;

//   @override
//   void initState() {
//     super.initState();
//     windowManager.addListener(this);
//     _init();
//   }

//   @override
//   void dispose() {
//     windowManager.removeListener(this);
//     super.dispose();
//   }

//   void _init() async {
//     await windowManager.setResizable(true);
//     await windowManager.setSize(const Size(1200, 768));
//     await windowManager.setMinimumSize(const Size(600, 400));
//     await windowManager.center();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A2427),
//       body: Column(
//         children: [
//           Container(
//             height: 30,
//             color: const Color(0xFF1E2E32),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 12),
//                   child: Row(
//                     children: [
//                       Image.asset(
//                         "assets/vidora_ic.png",
//                         width: 15,
//                         height: 15,
//                       ),
//                       const SizedBox(width: 8),
//                       const Text(
//                         "Vidora",
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     _WindowControlButton(
//                       icon: Icons.minimize,
//                       isHovered: _isHoverMinimize,
//                       onHover: (hover) =>
//                           setState(() => _isHoverMinimize = hover),
//                       onPressed: () => windowManager.minimize(),
//                     ),
//                     FutureBuilder<bool>(
//                       future: windowManager.isMaximized(),
//                       builder: (context, snapshot) {
//                         return _WindowControlButton(
//                           icon: snapshot.data == true
//                               ? Icons.filter_none
//                               : Icons.crop_square,
//                           isHovered: _isHoverMaximize,
//                           onHover: (hover) =>
//                               setState(() => _isHoverMaximize = hover),
//                           onPressed: () async {
//                             if (await windowManager.isMaximized()) {
//                               await windowManager.unmaximize();
//                             } else {
//                               await windowManager.maximize();
//                             }
//                           },
//                         );
//                       },
//                     ),
//                     // Close Button
//                     _WindowControlButton(
//                       icon: Icons.close,
//                       isHovered: _isHoverClose,
//                       onHover: (hover) => setState(() => _isHoverClose = hover),
//                       onPressed: () => windowManager.close(),
//                       isCloseButton: true,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Center(
//               child: Text(
//                 "Home Screen Content",
//                 style: Theme.of(
//                   context,
//                 ).textTheme.headlineMedium?.copyWith(color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _WindowControlButton extends StatelessWidget {
//   final IconData icon;
//   final bool isHovered;
//   final Function(bool) onHover;
//   final VoidCallback onPressed;
//   final bool isCloseButton;

//   const _WindowControlButton({
//     required this.icon,
//     required this.isHovered,
//     required this.onHover,
//     required this.onPressed,
//     this.isCloseButton = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 46,
//       height: 30,
//       child: MouseRegion(
//         onEnter: (_) => onHover(true),
//         onExit: (_) => onHover(false),
//         cursor: SystemMouseCursors.click,
//         child: GestureDetector(
//           onTap: onPressed,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 100),
//             color: isHovered
//                 ? isCloseButton
//                       ? const Color(0xFF2D3F44)
//                       : const Color(0xFF2D3F44)
//                 : Colors.transparent,
//             child: Center(
//               child: Icon(
//                 icon,
//                 size: 15,
//                 color: isHovered && isCloseButton
//                     ? const Color(0xFF64929D)
//                     : const Color(0xFF64929D),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:window_manager/window_manager.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with WindowListener, SingleTickerProviderStateMixin {
//   bool _isHoverClose = false;
//   bool _isHoverMinimize = false;
//   bool _isHoverMaximize = false;
//   bool _sidebarVisible = false;
//   int _activeSidebarIndex = 0;

//   late AnimationController _sidebarController;
//   late Animation<double> _sidebarAnimation;

//   @override
//   void initState() {
//     super.initState();
//     windowManager.addListener(this);
//     _init();
//     _sidebarController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 350),
//     );
//     _sidebarAnimation = CurvedAnimation(
//       parent: _sidebarController,
//       curve: Curves.easeInOut,
//     );
//     if (_sidebarVisible) {
//       _sidebarController.value = 1.0;
//     } else {
//       _sidebarController.value = 0.0;
//     }
//   }

//   @override
//   void dispose() {
//     windowManager.removeListener(this);
//     _sidebarController.dispose();
//     super.dispose();
//   }

//   void _init() async {
//     await windowManager.setResizable(true);
//     await windowManager.setSize(const Size(1200, 768));
//     await windowManager.setMinimumSize(const Size(600, 400));
//     await windowManager.center();
//   }

//   void _toggleSidebar() {
//     setState(() {
//       _sidebarVisible = !_sidebarVisible;
//       if (_sidebarVisible) {
//         _sidebarController.forward();
//       } else {
//         _sidebarController.reverse();
//       }
//     });
//   }

//   void _onSidebarItemTap(int index) {
//     setState(() {
//       _activeSidebarIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A2427),
//       body: Stack(
//         children: [
//           // Main content
//           Positioned.fill(
//             child: Column(
//               children: [
//                 _buildTopBar(),
//                 Expanded(
//                   child: Row(
//                     children: [
//                       // Animated Sidebar
//                       AnimatedBuilder(
//                         animation: _sidebarAnimation,
//                         builder: (context, child) {
//                           return FadeTransition(
//                             opacity: _sidebarAnimation,
//                             child: SlideTransition(
//                               position: Tween<Offset>(
//                                 begin: const Offset(-1, 0),
//                                 end: Offset.zero,
//                               ).animate(_sidebarAnimation),
//                               child: child,
//                             ),
//                           );
//                         },
//                         child: _Sidebar(
//                           onCollapse: _toggleSidebar,
//                           expanded: _sidebarVisible,
//                           activeIndex: _activeSidebarIndex,
//                           onItemTap: _onSidebarItemTap,
//                         ),
//                       ),
//                       // Main area
//                       Expanded(
//                         child: Center(
//                           child: AnimatedOpacity(
//                             opacity: _sidebarVisible ? 1.0 : 0.7,
//                             duration: const Duration(milliseconds: 350),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.asset(
//                                   "assets/vidora_ic.png",
//                                   width: 80,
//                                   height: 80,
//                                   color: Colors.white.withOpacity(0.15),
//                                 ),
//                                 const SizedBox(width: 6),
//                                 Text(
//                                   "Vidora",
//                                   style: TextStyle(
//                                     fontSize: 48,
//                                     color: Colors.white.withOpacity(0.15),
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Toggle button (z-index above all)
//           Positioned(
//             top: 38,
//             left: _sidebarVisible ? 210 : 10,
//             child: AnimatedOpacity(
//               opacity: 1.0,
//               duration: const Duration(milliseconds: 350),
//               child: GestureDetector(
//                 onTap: _toggleSidebar,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF1E2E32),
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.15),
//                         blurRadius: 6,
//                         offset: const Offset(2, 2),
//                       ),
//                     ],
//                   ),
//                   padding: const EdgeInsets.all(6),
//                   child: Icon(
//                     _sidebarVisible
//                         ? Icons.arrow_back_ios_new
//                         : Icons.arrow_forward_ios,
//                     color: Colors.white70,
//                     size: 18,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTopBar() {
//     return Container(
//       height: 30,
//       color: const Color(0xFF1E2E32),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 12),
//             child: Row(
//               children: [
//                 Image.asset("assets/vidora_ic.png", width: 15, height: 15),
//                 const SizedBox(width: 8),
//                 const Text(
//                   "Vidora",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             children: [
//               _WindowControlButton(
//                 icon: Icons.minimize,
//                 isHovered: _isHoverMinimize,
//                 onHover: (hover) => setState(() => _isHoverMinimize = hover),
//                 onPressed: () => windowManager.minimize(),
//               ),
//               FutureBuilder<bool>(
//                 future: windowManager.isMaximized(),
//                 builder: (context, snapshot) {
//                   return _WindowControlButton(
//                     icon: snapshot.data == true
//                         ? Icons.filter_none
//                         : Icons.crop_square,
//                     isHovered: _isHoverMaximize,
//                     onHover: (hover) =>
//                         setState(() => _isHoverMaximize = hover),
//                     onPressed: () async {
//                       if (await windowManager.isMaximized()) {
//                         await windowManager.unmaximize();
//                       } else {
//                         await windowManager.maximize();
//                       }
//                     },
//                   );
//                 },
//               ),
//               _WindowControlButton(
//                 icon: Icons.close,
//                 isHovered: _isHoverClose,
//                 onHover: (hover) => setState(() => _isHoverClose = hover),
//                 onPressed: () => windowManager.close(),
//                 isCloseButton: true,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _Sidebar extends StatelessWidget {
//   final VoidCallback onCollapse;
//   final bool expanded;
//   final int activeIndex;
//   final Function(int) onItemTap;

//   const _Sidebar({
//     required this.onCollapse,
//     required this.expanded,
//     required this.activeIndex,
//     required this.onItemTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 200,
//       height: double.infinity,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           stops: [0.07, 0.24, 0.58, 0.83],
//           colors: [
//             Color(0xFF213232),
//             Color(0xFF273E3E),
//             Color(0xFF273E3E),
//             Color(0xFF202F2F),
//           ],
//         ),
//         boxShadow: [
//           BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 0)),
//         ],
//       ),
//       child: Column(
//         children: [
//           const SizedBox(height: 38),
//           _SidebarItem(
//             icon: Icons.home_outlined,
//             label: "Home",
//             selected: activeIndex == 0,
//             onTap: () => onItemTap(0),
//           ),
//           _SidebarItem(
//             icon: Icons.explore_outlined,
//             label: "Browse",
//             selected: activeIndex == 1,
//             onTap: () => onItemTap(1),
//           ),
//           _SidebarItem(
//             icon: Icons.queue_music_outlined,
//             label: "Playlist",
//             selected: activeIndex == 2,
//             onTap: () => onItemTap(2),
//           ),
//           _SidebarItem(
//             icon: Icons.library_books_outlined,
//             label: "Library",
//             selected: activeIndex == 3,
//             onTap: () => onItemTap(3),
//           ),
//           _SidebarItem(
//             icon: Icons.favorite_border,
//             label: "Favorite",
//             selected: activeIndex == 4,
//             onTap: () => onItemTap(4),
//           ),
//           const Spacer(),
//         ],
//       ),
//     );
//   }
// }

// class _SidebarItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   const _SidebarItem({
//     required this.icon,
//     required this.label,
//     this.selected = false,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final Color selectedBg = const Color(0xFF2A4B4B).withOpacity(0.55);
//     final Color selectedColor = Colors.white;
//     final Color unselectedColor = const Color(0xFF8CAAB3);

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(8),
//         onTap: onTap,
//         child: Container(
//           decoration: BoxDecoration(
//             color: selected ? selectedBg : Colors.transparent,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//           child: Row(
//             children: [
//               Icon(
//                 icon,
//                 color: selected ? selectedColor : unselectedColor,
//                 size: 22,
//               ),
//               const SizedBox(width: 16),
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: selected ? selectedColor : unselectedColor,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _WindowControlButton extends StatelessWidget {
//   final IconData icon;
//   final bool isHovered;
//   final Function(bool) onHover;
//   final VoidCallback onPressed;
//   final bool isCloseButton;

//   const _WindowControlButton({
//     required this.icon,
//     required this.isHovered,
//     required this.onHover,
//     required this.onPressed,
//     this.isCloseButton = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 46,
//       height: 30,
//       child: MouseRegion(
//         onEnter: (_) => onHover(true),
//         onExit: (_) => onHover(false),
//         cursor: SystemMouseCursors.click,
//         child: GestureDetector(
//           onTap: onPressed,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 100),
//             color: isHovered
//                 ? isCloseButton
//                       ? const Color(0xFF2D3F44)
//                       : const Color(0xFF2D3F44)
//                 : Colors.transparent,
//             child: Center(
//               child: Icon(
//                 icon,
//                 size: 15,
//                 color: isHovered && isCloseButton
//                     ? const Color(0xFF64929D)
//                     : const Color(0xFF64929D),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

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
  bool _sidebarVisible = false; // Start minimized
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
          // Main content (logo always centered)
          Column(
            children: [
              _buildTopBar(),
              Expanded(
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
            ],
          ),
          // Sidebar overlays content
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
            child: _Sidebar(
              onCollapse: _toggleSidebar,
              expanded: _sidebarVisible,
              activeIndex: _activeSidebarIndex,
              onItemTap: _onSidebarItemTap,
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
              _WindowControlButton(
                icon: Icons.minimize,
                isHovered: _isHoverMinimize,
                onHover: (hover) => setState(() => _isHoverMinimize = hover),
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
    );
  }
}

class _Sidebar extends StatelessWidget {
  final VoidCallback onCollapse;
  final bool expanded;
  final int activeIndex;
  final Function(int) onItemTap;

  const _Sidebar({
    required this.onCollapse,
    required this.expanded,
    required this.activeIndex,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: MediaQuery.of(context).size.height - 30,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.07, 0.24, 0.58, 0.83],
          colors: [
            Color(0xFF213232),
            Color(0xFF273E3E),
            Color(0xFF273E3E),
            Color(0xFF202F2F),
          ],
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 0)),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          _SidebarItem(
            icon: Icons.home_outlined,
            label: "Home",
            selected: activeIndex == 0,
            onTap: () => onItemTap(0),
          ),
          _SidebarItem(
            icon: Icons.explore_outlined,
            label: "Browse",
            selected: activeIndex == 1,
            onTap: () => onItemTap(1),
          ),
          _SidebarItem(
            icon: Icons.queue_music_outlined,
            label: "Playlist",
            selected: activeIndex == 2,
            onTap: () => onItemTap(2),
          ),
          _SidebarItem(
            icon: Icons.library_books_outlined,
            label: "Library",
            selected: activeIndex == 3,
            onTap: () => onItemTap(3),
          ),
          _SidebarItem(
            icon: Icons.favorite_border,
            label: "Favorite",
            selected: activeIndex == 4,
            onTap: () => onItemTap(4),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color selectedBg = const Color(0xFF2A4B4B).withOpacity(0.55);
    final Color selectedColor = Colors.white;
    final Color unselectedColor = const Color(0xFF8CAAB3);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? selectedBg : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? selectedColor : unselectedColor,
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: selected ? selectedColor : unselectedColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
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
