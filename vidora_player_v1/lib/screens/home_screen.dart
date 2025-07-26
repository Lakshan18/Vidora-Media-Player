import 'dart:convert';

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

enum VideoFit { contain, cover, fill, fitWidth, fitHeight }

class _HomeScreenState extends State<HomeScreen>
    with WindowListener, SingleTickerProviderStateMixin {
  VideoFit _videoFit = VideoFit.fill;

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
  double _volumeBeforeMute = 1.0;
  bool _isMuted = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _dragging = false;

  bool _hasEmbeddedSubtitles = false;
  String? _externalSubtitlePath;
  List<SubtitleItem> _subtitles = [];
  String? _currentSubtitleText;

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

  BoxFit _getBoxFit(VideoFit fit) {
    switch (fit) {
      case VideoFit.contain:
        return BoxFit.contain;
      case VideoFit.cover:
        return BoxFit.cover;
      case VideoFit.fill:
        return BoxFit.fill;
      case VideoFit.fitWidth:
        return BoxFit.fitWidth;
      case VideoFit.fitHeight:
        return BoxFit.fitHeight;
    }
  }

  void _videoListener() {
    if (!_dragging && mounted) {
      final newSubtitle = _getCurrentSubtitle(_videoController.value.position);
      if (newSubtitle != _currentSubtitleText) {
        print('[DEBUG] Subtitle changed: $newSubtitle');
      }

      setState(() {
        _position = _videoController.value.position;
        _duration = _videoController.value.duration;
        _isPlaying = _videoController.value.isPlaying;
        _volume = _videoController.value.volume;
        _isMuted = _videoController.value.volume == 0;
        _currentSubtitleText = newSubtitle;
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
        allowedExtensions: ['mp4', 'avi', 'mov', 'mkv'],
      );
      if (result != null && result.files.single.path != null) {
        _loadMediaFile(result.files.single.path!);
      }
    } catch (e) {
      print("Error picking files: $e");
    }
  }

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

  void _loadMediaFile(String filePath) async {
    print('[DEBUG] Loading media file: $filePath');

    if (mounted) {
      setState(() {
        _currentFilePath = filePath;
        _isMediaLoaded = false;
        _hasEmbeddedSubtitles = false;
        _externalSubtitlePath = null;
        _subtitles = [];
        _currentSubtitleText = null;
      });
    }

    await _videoController.dispose();

    _videoController = VideoPlayerController.file(File(filePath))
      ..addListener(_videoListener);

    try {
      _initializeVideoPlayerFuture = _videoController.initialize();
      await _initializeVideoPlayerFuture;

      final subtitlePath = _findExternalSubtitle(filePath);

      if (subtitlePath != null) {
        print('[SUBTITLE LOADING] Loading subtitle file: $subtitlePath');
        _externalSubtitlePath = subtitlePath;
        await _loadSubtitlesFromFile(subtitlePath);
        print('[SUBTITLE LOADED] ${_subtitles.length} subtitles loaded');

        if (_subtitles.isNotEmpty) {
          print('[SUBTITLE EXAMPLE] First subtitle:');
          print('Start: ${_subtitles.first.start}');
          print('End: ${_subtitles.first.end}');
          print('Text: ${_subtitles.first.text}');
        }
      }

      if (mounted) {
        setState(() {
          _isMediaLoaded = true;
        });
      }
      _videoController.play();
    } catch (e) {
      print("[ERROR] Initializing video player: $e");
    }
  }

  String? _findExternalSubtitle(String videoPath) {
    final videoFile = File(videoPath);
    final videoDir = videoFile.parent;
    final videoNameWithoutExt = videoFile.path
        .split(Platform.pathSeparator)
        .last
        .replaceAll(RegExp(r'\..+$'), '');

    print('[SUBTITLE SEARCH] Looking for subtitles in: ${videoDir.path}');
    print('[SUBTITLE SEARCH] Base filename: $videoNameWithoutExt');

    final possibleExtensions = ['.srt', '.vtt', '.ass', '.ssa'];

    for (final ext in possibleExtensions) {
      final subtitlePath =
          '${videoDir.path}${Platform.pathSeparator}$videoNameWithoutExt$ext';
      print('[SUBTITLE SEARCH] Checking: $subtitlePath');
      if (File(subtitlePath).existsSync()) {
        print('[SUBTITLE FOUND] Exact match: $subtitlePath');
        return subtitlePath;
      }
    }

    final commonPatterns = [
      videoNameWithoutExt.replaceAll('.', ' '),
      videoNameWithoutExt.replaceAll(RegExp(r'@.+$'), ''),
      videoNameWithoutExt.replaceAll(RegExp(r'\.20\d{2}'), ''),
    ];

    for (final pattern in commonPatterns) {
      for (final ext in possibleExtensions) {
        final subtitlePath =
            '${videoDir.path}${Platform.pathSeparator}$pattern$ext';
        print('[SUBTITLE SEARCH] Checking pattern: $subtitlePath');
        if (File(subtitlePath).existsSync()) {
          print('[SUBTITLE FOUND] Pattern match: $subtitlePath');
          return subtitlePath;
        }
      }
    }

    try {
      final subtitleFiles = videoDir.listSync().where((file) {
        return file is File &&
            possibleExtensions.any(
              (ext) => file.path.toLowerCase().endsWith(ext),
            );
      }).toList();

      if (subtitleFiles.isNotEmpty) {
        print(
          '[SUBTITLE FOUND] First subtitle in directory: ${subtitleFiles.first.path}',
        );
        return subtitleFiles.first.path;
      }
    } catch (e) {
      print('[SUBTITLE ERROR] Directory listing failed: $e');
    }

    print('[SUBTITLE NOT FOUND] No matching subtitle files found');
    return null;
  }

  Future<void> _loadSubtitlesFromFile(String path) async {
    try {
      print('[SUBTITLE] Loading file with multiple encoding attempts...');
      final file = File(path);

      final encodings = [
        utf8,
        latin1,
        Encoding.getByName('windows-1252'),
        Encoding.getByName('utf-16'),
      ];

      for (final encoding in encodings.whereType<Encoding>()) {
        try {
          final content = await file.readAsString(encoding: encoding);
          _subtitles = _parseSubtitles(content);
          print('[SUBTITLE] Successfully loaded with ${encoding.name}');
          return;
        } catch (e) {
          print('[SUBTITLE] Failed with ${encoding.name}: $e');
        }
      }

      final content = await file.readAsString();
      _subtitles = _parseSubtitles(content);
    } catch (e) {
      print('[SUBTITLE ERROR] Loading subtitles: $e');
      _subtitles = [];
    }
  }

  List<SubtitleItem> _parseSubtitles(String content) {
    final subtitles = <SubtitleItem>[];
    final blocks = content.split('\n\n');

    print('[DEBUG] Found ${blocks.length} subtitle blocks');

    for (final block in blocks) {
      try {
        final lines = block
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList();
        if (lines.length >= 3) {
          final timeParts = lines[1].split(' --> ');
          if (timeParts.length == 2) {
            final start = _parseDuration(timeParts[0]);
            final end = _parseDuration(timeParts[1]);
            final rawText = lines.sublist(2).join('\n');
            final cleanText = _cleanSubtitleText(rawText);
            subtitles.add(SubtitleItem(start, end, cleanText));
          }
        }
      } catch (e) {
        print('[ERROR] Parsing subtitle block: $e\nBlock content: $block');
      }
    }

    return subtitles;
  }

  String _cleanSubtitleText(String text) {
    return text
        .replaceAll(RegExp(r'<font[^>]*>'), '')
        .replaceAll(RegExp(r'</font>'), '')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'^\s+'), '')
        .replaceAll(RegExp(r'\s+$'), '');
  }

  Duration _parseDuration(String timeStr) {
    final parts = timeStr.split(',');
    final timeParts = parts[0].split(':');
    final hours = int.parse(timeParts[0]);
    final minutes = int.parse(timeParts[1]);
    final seconds = int.parse(timeParts[2]);
    final milliseconds = parts.length > 1 ? int.parse(parts[1]) : 0;

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
    );
  }

  String? _getCurrentSubtitle(Duration position) {
    for (final subtitle in _subtitles) {
      if (position >= subtitle.start && position <= subtitle.end) {
        return subtitle.text;
      }
    }
    return null;
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
      if (value > 0) {
        _isMuted = false;
        _volumeBeforeMute = value;
      } else {
        _isMuted = true;
      }
    });
    _videoController.setVolume(value);
  }

  void _handleMuteToggle(bool mute) {
    if (mute) {
      _volumeBeforeMute = _volume;
      _videoController.setVolume(0);
    } else {
      _videoController.setVolume(_volumeBeforeMute);
    }
    setState(() {
      _isMuted = mute;
      if (!mute) {
        _volume = _volumeBeforeMute;
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2427),
      body: Stack(
        children: [
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) {
              if (event.kind == PointerDeviceKind.mouse &&
                  event.buttons == kSecondaryMouseButton) {
                _showContextMenu(context, event.position);
              }
            },
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: Stack(
                    children: [
                      if (_isMediaLoaded)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final videoAspect =
                                _videoController.value.aspectRatio;
                            final screenAspect =
                                constraints.maxWidth / constraints.maxHeight;

                            double width, height;

                            if (videoAspect > screenAspect) {
                              width = constraints.maxWidth;
                              height = width / videoAspect;
                            } else {
                              height = constraints.maxHeight;
                              width = height * videoAspect;
                            }

                            return Center(
                              child: ClipRect(
                                child: SizedBox(
                                  width: width,
                                  height: height,
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: _videoController.value.size.width,
                                      height:
                                          _videoController.value.size.height,
                                      child: VideoPlayer(_videoController),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      else
                        Container(
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
                      if (_currentSubtitleText != null)
                        Positioned(
                          bottom: 60,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Text(
                                _currentSubtitleText!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 240, 254, 255),
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Poppins",
                                  shadows: [
                                    Shadow(
                                      blurRadius: 8,
                                      color: Colors.black,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
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

class SubtitleItem {
  final Duration start;
  final Duration end;
  final String text;

  SubtitleItem(this.start, this.end, this.text);
}
