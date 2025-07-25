// import 'package:flutter/material.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:vidora_player_v1/components/control_panel.dart';

// class PlayerControls extends StatefulWidget {
//   final Player player;
//   final bool isPlaying;
//   final double volume;
//   final bool isMuted;
//   final Duration position;
//   final Duration duration;
//   final Function(bool) onPlayPause;
//   final Function(double) onVolumeChanged;
//   final Function(bool) onMuteToggle;
//   final Function(Duration) onSeek;
//   final Function() onPrevious;
//   final Function() onNext;
//   final Function() onOpenPlaylist;
//   final Function() onOpenSettings;

//   const PlayerControls({
//     Key? key,
//     required this.player,
//     required this.isPlaying,
//     required this.volume,
//     required this.isMuted,
//     required this.position,
//     required this.duration,
//     required this.onPlayPause,
//     required this.onVolumeChanged,
//     required this.onMuteToggle,
//     required this.onSeek,
//     required this.onPrevious,
//     required this.onNext,
//     required this.onOpenPlaylist,
//     required this.onOpenSettings,
//   }) : super(key: key);

//   @override
//   _PlayerControlsState createState() => _PlayerControlsState();
// }

// class _PlayerControlsState extends State<PlayerControls> {
//   double _sliderValue = 0.0;
//   bool _dragging = false;

//   @override
//   void initState() {
//     super.initState();
//     _sliderValue = widget.position.inMilliseconds.toDouble();
//   }

//   @override
//   void didUpdateWidget(PlayerControls oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (!_dragging) {
//       _sliderValue = widget.position.inMilliseconds.toDouble();
//     }
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = twoDigits(duration.inHours);
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$hours:$minutes:$seconds";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 100,
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E2E32),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.5),
//             blurRadius: 8,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             _formatDuration(widget.position),
//                             style: const TextStyle(
//                               color: Color(0xFF8CAAB3),
//                               fontSize: 12,
//                             ),
//                           ),
//                           Text(
//                             _formatDuration(widget.duration),
//                             style: const TextStyle(
//                               color: Color(0xFF8CAAB3),
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(2),
//                         child: SliderTheme(
//                           data: SliderThemeData(
//                             trackHeight: 2,
//                             thumbShape: const RoundSliderThumbShape(
//                               enabledThumbRadius: 6,
//                             ),
//                             overlayShape: const RoundSliderOverlayShape(
//                               overlayRadius: 10,
//                             ),
//                           ),
//                           child: Slider(
//                             value: _sliderValue,
//                             min: 0,
//                             max: widget.duration.inMilliseconds.toDouble(),
//                             onChangeStart: (value) {
//                               setState(() => _dragging = true);
//                             },
//                             onChangeEnd: (value) {
//                               widget.onSeek(
//                                 Duration(milliseconds: value.toInt()),
//                               );
//                               setState(() => _dragging = false);
//                             },
//                             onChanged: (value) {
//                               setState(() => _sliderValue = value);
//                             },
//                             activeColor: const Color(
//                               0xFF64929D,
//                             ).withOpacity(0.8),
//                             inactiveColor: const Color(0xFF2A3B40),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(
//                         widget.isMuted
//                             ? Icons.volume_off
//                             : widget.volume > 1.0
//                             ? Icons.volume_up
//                             : widget.volume > 0
//                             ? Icons.volume_down
//                             : Icons.volume_mute,
//                       ),
//                       color: const Color(0xFF8CAAB3),
//                       iconSize: 20,
//                       onPressed: () => widget.onMuteToggle(!widget.isMuted),
//                     ),
//                     const SizedBox(width: 3),
//                     SizedBox(
//                       width: 100,
//                       child: SliderTheme(
//                         data: SliderThemeData(
//                           trackHeight: 2,
//                           thumbShape: const RoundSliderThumbShape(
//                             enabledThumbRadius: 6,
//                           ),
//                           overlayShape: const RoundSliderOverlayShape(
//                             overlayRadius: 10,
//                           ),
//                         ),
//                         child: Slider(
//                           value: widget.isMuted ? 0 : widget.volume,
//                           onChanged: (value) {
//                             print(value);
//                             widget.onVolumeChanged(value);
//                           },
//                           activeColor: const Color(0xFF64929D),
//                           inactiveColor: const Color(0xFF2A3B40),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.skip_previous),
//                         color: const Color(0xFF8CAAB3),
//                         iconSize: 20,
//                         onPressed: widget.onPrevious,
//                       ),
//                       const SizedBox(width: 16),
//                       IconButton(
//                         icon: Icon(
//                           widget.isPlaying ? Icons.pause : Icons.play_arrow,
//                         ),
//                         color: Colors.white,
//                         iconSize: 32,
//                         onPressed: () => widget.onPlayPause(!widget.isPlaying),
//                       ),
//                       const SizedBox(width: 16),
//                       IconButton(
//                         icon: const Icon(Icons.skip_next),
//                         color: const Color(0xFF8CAAB3),
//                         iconSize: 20,
//                         onPressed: widget.onNext,
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     right: 0,
//                     child: Row(
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.playlist_play),
//                           color: const Color(0xFF8CAAB3),
//                           onPressed: widget.onOpenPlaylist,
//                           iconSize: 20,
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.settings),
//                           color: const Color(0xFF8CAAB3),
//                           onPressed: widget.onOpenSettings,
//                           iconSize: 20,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerControls extends StatefulWidget {
  final VideoPlayerController player;
  final bool isPlaying;
  final double volume;
  final bool isMuted;
  final Duration position;
  final Duration duration;
  final Function(bool) onPlayPause;
  final Function(double) onVolumeChanged;
  final Function(bool) onMuteToggle;
  final Function(Duration) onSeek;
  final Function() onPrevious;
  final Function() onNext;
  final Function() onOpenPlaylist;
  final Function() onOpenSettings;

  const PlayerControls({
    Key? key,
    required this.player,
    required this.isPlaying,
    required this.volume,
    required this.isMuted,
    required this.position,
    required this.duration,
    required this.onPlayPause,
    required this.onVolumeChanged,
    required this.onMuteToggle,
    required this.onSeek,
    required this.onPrevious,
    required this.onNext,
    required this.onOpenPlaylist,
    required this.onOpenSettings,
  }) : super(key: key);

  @override
  _PlayerControlsState createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  double _sliderValue = 0.0;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.position.inMilliseconds.toDouble();
  }

  @override
  void didUpdateWidget(PlayerControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_dragging) {
      _sliderValue = widget.position.inMilliseconds.toDouble();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2E32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(widget.position),
                            style: const TextStyle(
                              color: Color(0xFF8CAAB3),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _formatDuration(widget.duration),
                            style: const TextStyle(
                              color: Color(0xFF8CAAB3),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 2,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 10,
                            ),
                          ),
                          child: Slider(
                            value: _sliderValue,
                            min: 0,
                            max: widget.duration.inMilliseconds.toDouble(),
                            onChangeStart: (value) {
                              setState(() => _dragging = true);
                            },
                            onChangeEnd: (value) {
                              widget.onSeek(Duration(milliseconds: value.toInt()));
                              setState(() => _dragging = false);
                            },
                            onChanged: (value) {
                              setState(() => _sliderValue = value);
                            },
                            activeColor: const Color(0xFF64929D).withOpacity(0.8),
                            inactiveColor: const Color(0xFF2A3B40),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        widget.isMuted
                            ? Icons.volume_off
                            : widget.volume > 0.66
                                ? Icons.volume_up
                                : widget.volume > 0
                                    ? Icons.volume_down
                                    : Icons.volume_mute,
                      ),
                      color: const Color(0xFF8CAAB3),
                      iconSize: 20,
                      onPressed: () => widget.onMuteToggle(!widget.isMuted),
                    ),
                    const SizedBox(width: 3),
                    SizedBox(
                      width: 100,
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 2,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 10,
                          ),
                        ),
                        child: Slider(
                          value: widget.isMuted ? 0 : widget.volume,
                          onChanged: widget.onVolumeChanged,
                          activeColor: const Color(0xFF64929D),
                          inactiveColor: const Color(0xFF2A3B40),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        color: const Color(0xFF8CAAB3),
                        iconSize: 20,
                        onPressed: widget.onPrevious,
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Icon(
                          widget.isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        color: Colors.white,
                        iconSize: 32,
                        onPressed: () => widget.onPlayPause(!widget.isPlaying),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        color: const Color(0xFF8CAAB3),
                        iconSize: 20,
                        onPressed: widget.onNext,
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.playlist_play),
                          color: const Color(0xFF8CAAB3),
                          onPressed: widget.onOpenPlaylist,
                          iconSize: 20,
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          color: const Color(0xFF8CAAB3),
                          onPressed: widget.onOpenSettings,
                          iconSize: 20,
                        ),
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