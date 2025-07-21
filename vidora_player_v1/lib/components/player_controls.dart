// import 'package:flutter/material.dart';
// import 'package:vidora_player_v1/components/control_panel.dart';

// class PlayerControls extends StatefulWidget {
//   const PlayerControls({Key? key}) : super(key: key);

//   @override
//   _PlayerControlsState createState() => _PlayerControlsState();
// }

// class _PlayerControlsState extends State<PlayerControls> {
//   bool _isPlaying = false;
//   double _volumeLevel = 0.5;
//   bool _isMuted = false;
//   double _volumeBeforeMute = 0.5;

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
//                             "00:00:00",
//                             style: TextStyle(
//                               color: const Color(0xFF8CAAB3),
//                               fontSize: 12,
//                             ),
//                           ),
//                           Text(
//                             "00:00:00",
//                             style: TextStyle(
//                               color: const Color(0xFF8CAAB3),
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(2),
//                         child: LinearProgressIndicator(
//                           value: 0.25,
//                           backgroundColor: const Color(0xFF2A3B40),
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             const Color(0xFF64929D).withOpacity(0.8),
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
//                         _isMuted
//                             ? Icons.volume_off
//                             : _volumeLevel > 0.5
//                                 ? Icons.volume_up
//                                 : _volumeLevel > 0
//                                     ? Icons.volume_down
//                                     : Icons.volume_mute,
//                       ),
//                       color: const Color(0xFF8CAAB3),
//                       iconSize: 20,
//                       onPressed: () {
//                         setState(() {
//                           if (_isMuted) {
//                             _volumeLevel = _volumeBeforeMute;
//                             _isMuted = false;
//                           } else {
//                             _volumeBeforeMute = _volumeLevel;
//                             _volumeLevel = 0;
//                             _isMuted = true;
//                           }
//                         });
//                       },
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
//                           value: _volumeLevel,
//                           onChanged: (value) {
//                             setState(() {
//                               _volumeLevel = value;
//                               if (value > 0) {
//                                 _isMuted = false;
//                               } else if (_isMuted && value > 0) {
//                                 _isMuted = false;
//                               }
//                             });
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
//                         onPressed: () {},
//                       ),
//                       const SizedBox(width: 16),
//                       IconButton(
//                         icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//                         color: Colors.white,
//                         iconSize: 32,
//                         onPressed: () {
//                           setState(() {
//                             _isPlaying = !_isPlaying;
//                           });
//                         },
//                       ),
//                       const SizedBox(width: 16),
//                       IconButton(
//                         icon: const Icon(Icons.skip_next),
//                         color: const Color(0xFF8CAAB3),
//                         iconSize: 20,
//                         onPressed: () {},
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
//                           onPressed: () {},
//                           iconSize: 20,
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.settings),
//                           color: const Color(0xFF8CAAB3),
//                           onPressed: () {
//                             showDialog(
//                               context: context,
//                               builder: (context) => ControlPanel(
//                                 onClose: () {
//                                   Navigator.of(context).pop();
//                                 },
//                               ),
//                             );
//                           },
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
import 'package:vidora_player_v1/components/control_panel.dart';

class PlayerControls extends StatefulWidget {
  const PlayerControls({Key? key}) : super(key: key);

  @override
  _PlayerControlsState createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  bool _isPlaying = false;
  double _volumeLevel = 0.5;
  bool _isMuted = false;
  double _volumeBeforeMute = 0.5;

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
                            "00:00:00",
                            style: TextStyle(
                              color: const Color(0xFF8CAAB3),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "00:00:00",
                            style: TextStyle(
                              color: const Color(0xFF8CAAB3),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: 0.25,
                          backgroundColor: const Color(0xFF2A3B40),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            const Color(0xFF64929D).withOpacity(0.8),
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
                        _isMuted
                            ? Icons.volume_off
                            : _volumeLevel > 0.5
                                ? Icons.volume_up
                                : _volumeLevel > 0
                                    ? Icons.volume_down
                                    : Icons.volume_mute,
                      ),
                      color: const Color(0xFF8CAAB3),
                      iconSize: 20,
                      onPressed: () {
                        setState(() {
                          if (_isMuted) {
                            _volumeLevel = _volumeBeforeMute;
                            _isMuted = false;
                          } else {
                            _volumeBeforeMute = _volumeLevel;
                            _volumeLevel = 0;
                            _isMuted = true;
                          }
                        });
                      },
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
                          value: _volumeLevel,
                          onChanged: (value) {
                            setState(() {
                              _volumeLevel = value;
                              if (value > 0) {
                                _isMuted = false;
                              } else if (_isMuted && value > 0) {
                                _isMuted = false;
                              }
                            });
                          },
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
                        onPressed: () {},
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        color: Colors.white,
                        iconSize: 32,
                        onPressed: () {
                          setState(() {
                            _isPlaying = !_isPlaying;
                          });
                        },
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        color: const Color(0xFF8CAAB3),
                        iconSize: 20,
                        onPressed: () {},
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
                          onPressed: () {},
                          iconSize: 20,
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          color: const Color(0xFF8CAAB3),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.all(20),
                                child: ControlPanel(
                                  onClose: () => Navigator.of(context).pop(),
                                ),
                              ),
                            );
                          },
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