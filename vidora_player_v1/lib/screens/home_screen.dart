// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:window_manager/window_manager.dart';
// import '../components/control_panel.dart';
// import '../components/sidebar.dart';
// import '../components/window_controls.dart';
// import '../components/player_controls.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
// import 'dart:io';

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

//   // MediaKit variables
//   late Player _player;
//   late VideoController _videoController;
//   bool _isMediaLoaded = false;
//   String? _currentFilePath;

//   // Player state
//   bool _isPlaying = false;
//   double _volume = 1.0;
//   double _volumeBeforeMute = 1.0;
//   bool _isMuted = false;
//   Duration _position = Duration.zero;
//   Duration _duration = Duration.zero;
//   bool _dragging = false;

//   late AnimationController _sidebarController;
//   late Animation<double> _sidebarAnimation;

//   @override
//   void initState() {
//     super.initState();

//     MediaKit.ensureInitialized();
//     _player = Player(
//       configuration: PlayerConfiguration(
//         muted: _isMuted,
//       ),
//     );
//     _videoController = VideoController(_player);

//     // Setup player listeners
//     _player.stream.playing.listen((event) {
//       if (mounted) setState(() => _isPlaying = event);
//     });

//     _player.stream.volume.listen((event) {
//       if (mounted) setState(() => _volume = event);
//     });

//     // _player.streams.volume.listen((volume) {
//     //   if (mounted) setState(() => _isMuted = volume == 0);
//     // });

//     _player.stream.position.listen((event) {
//       if (!_dragging && mounted) setState(() => _position = event);
//     });

//     _player.stream.duration.listen((event) {
//       if (mounted) setState(() => _duration = event);
//     });

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
//     _player.dispose();
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

//   Future<void> _openFiles() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         allowMultiple: false,
//         type: FileType.video,
//         allowedExtensions: ['mp4', 'avi', 'mov', 'mkv', 'mp3', 'wav', 'aac'],
//       );
//       if (result != null && result.files.single.path != null) {
//         _loadMediaFile(result.files.single.path!);
//       }
//     } catch (e) {
//       print("Error picking files: $e");
//     }
//   }

//   void _loadMediaFile(String filePath) async {
//     setState(() {
//       _currentFilePath = filePath;
//       _isMediaLoaded = false;
//     });

//     await _player.open(Media(filePath));

//     setState(() {
//       _isMediaLoaded = true;
//     });
//   }

//   // Player control methods
//   void _handlePlayPause(bool play) {
//     if (play) {
//       _player.play();
//     } else {
//       _player.pause();
//     }
//   }

//   void _handleVolumeChanged(double value) {
//   print("Volume changed: $value");
//   setState(() {
//     _volume = value;
//     if (value == 0) {
//       print("Volume is zero, muting");
//       _volumeBeforeMute = _volume; // Store the current volume before muting
//       _player.setVolume(0);
//       _isMuted = true;
//     } else {
//       print("Volume is above zero, unmuting");
//       if (_isMuted) _isMuted = false;
//       _volumeBeforeMute = value; // Store the current volume before muting
//       _isMuted = false;
//       _player.setVolume(value);
//     }
//   });
//   _player.setVolume(value);
// }

//   void _handleMuteToggle(bool mute) {
//     print("Mute toggled: $mute");
//     if(_isMuted){
//        _player.setVolume(1.0);
//     }else{
//       _player.setVolume(0.0);
//     }
//     _isMuted = !_isMuted;
//   }

//   void _handleSeek(Duration position) {
//     _player.seek(position);
//   }

//   void _handlePrevious() {
//     if (_position.inSeconds > 3) {
//       _player.seek(Duration.zero);
//     } else {
//       // Implement previous track logic
//     }
//   }

//   void _handleNext() {
//     // Implement next track logic
//   }

//   void _handleOpenPlaylist() {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: const Color(0xFF1E2E32),
//         child: Container(
//           width: 400,
//           height: 500,
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               const Text('Playlist', style: TextStyle(color: Colors.white)),
//               const SizedBox(height: 16),
//               Expanded(
//                 child: _currentFilePath != null
//                     ? ListView(
//                         children: [
//                           ListTile(
//                             title: Text(
//                               _currentFilePath!.split('/').last,
//                               style: const TextStyle(color: Colors.white70),
//                             ),
//                             onTap: () {
//                               Navigator.pop(context);
//                               _loadMediaFile(_currentFilePath!);
//                             },
//                           ),
//                         ],
//                       )
//                     : const Center(
//                         child: Text(
//                           'No media loaded',
//                           style: TextStyle(color: Colors.white70),
//                         ),
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _handleOpenSettings() {
//     print("Open Settings");
//   }

//   // Context menu
//   Future<void> _showContextMenu(BuildContext context, Offset position) async {
//     final RenderBox overlay =
//         Overlay.of(context).context.findRenderObject() as RenderBox;
//     final String? selectedValue = await showMenu(
//       context: context,
//       position: RelativeRect.fromRect(
//         Rect.fromLTWH(position.dx, position.dy, 0, 0),
//         Offset.zero & overlay.size,
//       ),
//       color: const Color.fromARGB(255, 34, 59, 65),

//       items: [
//         const PopupMenuItem(
//           height: 30,
//           child: SizedBox(
//             width: 180,
//             child: Text(
//               "Open File(s)",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color.fromARGB(95, 244, 244, 244),
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//           value: "open_files",
//         ),
//         const PopupMenuItem(
//           height: 30,
//           child: SizedBox(
//             width: 180,
//             child: Text(
//               "Open",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color.fromARGB(95, 244, 244, 244),
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//           value: "open",
//         ),
//         const PopupMenuItem(
//           height: 30,
//           child: SizedBox(
//             width: 180,
//             child: Text(
//               "Video",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color.fromARGB(95, 244, 244, 244),
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//           value: "video",
//         ),
//         const PopupMenuItem(
//           height: 30,
//           child: SizedBox(
//             width: 180,
//             child: Text(
//               "Audio",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color.fromARGB(95, 244, 244, 244),
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//           value: "audio",
//         ),
//         const PopupMenuItem(
//           height: 30,
//           child: SizedBox(
//             width: 180,
//             child: Text(
//               "Filters",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color.fromARGB(95, 244, 244, 244),
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//           value: "filters",
//         ),
//         const PopupMenuItem(
//           height: 30,
//           child: SizedBox(
//             width: 180,
//             child: Text(
//               "Skins",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color.fromARGB(95, 244, 244, 244),
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//           value: "skins",
//         ),
//         const PopupMenuItem(
//           height: 30,
//           child: SizedBox(
//             width: 180,
//             child: Text(
//               "Preferences",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color.fromARGB(95, 244, 244, 244),
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//           value: "preferences",
//         ),
//         const PopupMenuItem(
//           height: 30,
//           child: SizedBox(
//             width: 180,
//             child: Text(
//               "Settings",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color.fromARGB(95, 244, 244, 244),
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//           value: "settings",
//         ),
//         const PopupMenuItem(
//           height: 30,
//           child: SizedBox(
//             width: 180,
//             child: Text(
//               "About",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color.fromARGB(95, 244, 244, 244),
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//           value: "about",
//         ),
//         const PopupMenuItem(
//           height: 30,
//           child: SizedBox(
//             width: 180,
//             child: Text(
//               "Exit",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color.fromARGB(95, 244, 244, 244),
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//           value: "exit",
//         ),
//       ],
//     );

//     if (selectedValue == "open_files") {
//       _openFiles();
//     } else if (selectedValue == "exit") {
//       await windowManager.close();
//     } else {
//       print("Selected: $selectedValue");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A2427),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               _buildTopBar(),
//               Expanded(
//                 child: _isMediaLoaded
//                     ? Video(
//                         controller: _videoController,
//                         controls: NoVideoControls,
//                         fill: Colors.transparent,
//                       )
//                     : Listener(
//                         behavior: HitTestBehavior.translucent,
//                         onPointerDown: (event) {
//                           if (event.kind == PointerDeviceKind.mouse &&
//                               event.buttons == kSecondaryMouseButton) {
//                             _showContextMenu(context, event.position);
//                           }
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(0),
//                           child: Center(
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
//               ),
//               PlayerControls(
//                 player: _player,
//                 isPlaying: _isPlaying,
//                 volume: _volume,
//                 isMuted: _isMuted,
//                 position: _position,
//                 duration: _duration,
//                 onPlayPause: _handlePlayPause,
//                 onVolumeChanged: _handleVolumeChanged,
//                 onMuteToggle: _handleMuteToggle,
//                 onSeek: _handleSeek,
//                 onPrevious: _handlePrevious,
//                 onNext: _handleNext,
//                 onOpenPlaylist: _handleOpenPlaylist,
//                 onOpenSettings: _handleOpenSettings,
//               ),
//             ],
//           ),
//           AnimatedBuilder(
//             animation: _sidebarAnimation,
//             builder: (context, child) {
//               return Positioned(
//                 top: 30,
//                 left: -250 + 250 * _sidebarAnimation.value,
//                 bottom: 0,
//                 child: FadeTransition(opacity: _sidebarAnimation, child: child),
//               );
//             },
//             child: Sidebar(
//               onItemTap: _onSidebarItemTap,
//               activeIndex: _activeSidebarIndex,
//             ),
//           ),
//           Positioned(
//             top: 38,
//             left: _sidebarVisible ? 260 : 10,
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
//               WindowControlButton(
//                 icon: Icons.minimize,
//                 isHovered: _isHoverMinimize,
//                 onHover: (hover) => setState(() => _isHoverMinimize = hover),
//                 onPressed: () => windowManager.minimize(),
//               ),
//               FutureBuilder<bool>(
//                 future: windowManager.isMaximized(),
//                 builder: (context, snapshot) {
//                   return WindowControlButton(
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
//               WindowControlButton(
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



import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../components/control_panel.dart';
import '../components/sidebar.dart';
import '../components/window_controls.dart';
import '../components/player_controls.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

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

  late VideoPlayerController _videoController;
  Future<void>? _initializeVideoPlayerFuture;
  bool _isMediaLoaded = false;
  String? _currentFilePath;

  bool _isPlaying = false;
  double _volume = 1.0;
  bool _isMuted = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _dragging = false;

  late AnimationController _sidebarController;
  late Animation<double> _sidebarAnimation;

  @override
  void initState() {
    super.initState();
    
    _videoController = VideoPlayerController.file(File(''))
      ..addListener(_videoListener);

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

  void _videoListener() {
    if (!_dragging && mounted) {
      setState(() {
        _position = _videoController.value.position;
        _duration = _videoController.value.duration;
        _isPlaying = _videoController.value.isPlaying;
        _volume = _videoController.value.volume;
        _isMuted = _videoController.value.volume == 0;
      });
    }
  }

  @override
  void dispose() {
    _videoController.removeListener(_videoListener);
    _videoController.dispose();
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

  Future<void> _openFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.video,
        allowedExtensions: ['mp4', 'avi', 'mov', 'mkv', 'mp3', 'wav', 'aac'],
      );
      if (result != null && result.files.single.path != null) {
        _loadMediaFile(result.files.single.path!);
      }
    } catch (e) {
      print("Error picking files: $e");
    }
  }

  void _loadMediaFile(String filePath) async {
    if (mounted) {
      setState(() {
        _currentFilePath = filePath;
        _isMediaLoaded = false;
      });
    }

    await _videoController.dispose();

    _videoController = VideoPlayerController.file(File(filePath))
      ..addListener(_videoListener);

    try {
      _initializeVideoPlayerFuture = _videoController.initialize();
      await _initializeVideoPlayerFuture;
      
      if (mounted) {
        setState(() {
          _isMediaLoaded = true;
        });
      }
      _videoController.play();
    } catch (e) {
      print("Error initializing video player: $e");
    }
  }

  void _handlePlayPause(bool play) {
    if (play) {
      _videoController.play();
    } else {
      _videoController.pause();
    }
  }

  void _handleVolumeChanged(double value) {
    setState(() {
      _volume = value;
      _isMuted = value == 0;
    });
    _videoController.setVolume(value);
  }

  void _handleMuteToggle(bool mute) {
    if (mute) {
      _videoController.setVolume(0);
    } else {
      _videoController.setVolume(_volume);
    }
    setState(() {
      _isMuted = mute;
    });
  }

  void _handleSeek(Duration position) {
    _videoController.seekTo(position);
  }

  void _handlePrevious() {
    if (_position.inSeconds > 3) {
      _videoController.seekTo(Duration.zero);
    }
  }

  void _handleNext() {
    // Implement next track logic
  }

  void _handleOpenPlaylist() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1E2E32),
        child: Container(
          width: 400,
          height: 500,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('Playlist', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 16),
              Expanded(
                child: _currentFilePath != null
                    ? ListView(
                        children: [
                          ListTile(
                            title: Text(
                              _currentFilePath!.split('/').last,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              _loadMediaFile(_currentFilePath!);
                            },
                          ),
                        ],
                      )
                    : const Center(
                        child: Text(
                          'No media loaded',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleOpenSettings() {
    print("Open Settings");
  }

  // Shows a context menu at the given position.
  Future<void> _showContextMenu(BuildContext context, Offset position) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final String? selectedValue = await showMenu(
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

    if (selectedValue == "open_files") {
      _openFiles();
    } else if (selectedValue == "exit") {
      await windowManager.close();
    }
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
                child: _isMediaLoaded
                    ? FutureBuilder(
                        future: _initializeVideoPlayerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            );
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      )
                    : Listener(
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
              PlayerControls(
                player: _videoController,
                isPlaying: _isPlaying,
                volume: _volume,
                isMuted: _isMuted,
                position: _position,
                duration: _duration,
                onPlayPause: _handlePlayPause,
                onVolumeChanged: _handleVolumeChanged,
                onMuteToggle: _handleMuteToggle,
                onSeek: _handleSeek,
                onPrevious: _handlePrevious,
                onNext: _handleNext,
                onOpenPlaylist: _handleOpenPlaylist,
                onOpenSettings: _handleOpenSettings,
              ),
            ],
          ),
          AnimatedBuilder(
            animation: _sidebarAnimation,
            builder: (context, child) {
              return Positioned(
                top: 30,
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