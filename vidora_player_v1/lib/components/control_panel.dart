import 'package:flutter/material.dart';

class ControlPanel extends StatefulWidget {
  final VoidCallback onClose;

  const ControlPanel({Key? key, required this.onClose}) : super(key: key);

  @override
  _ControlPanelState createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  int _settingsTabIndex = 0;
  String _selectedPreset = "Flat";
  final List<double> _equalizerBands = List.filled(10, 0.0);
  final List<String> _audioPresets = [
    "Flat",
    "Pop",
    "Rock",
    "Jazz",
    "Classical",
    "Bass Boost",
  ];

  final List<String> _frequencyLabels = [
    "60Hz",
    "170Hz",
    "310Hz",
    "600Hz",
    "1KHz",
    "3KHz",
    "6KHz",
    "12KHz",
    "14KHz",
    "16KHz",
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 600,
          height: 500,
          decoration: BoxDecoration(
            color: const Color(0xFF1E2E32),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF213232),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      "Player Settings",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      color: const Color(0xFF8CAAB3),
                      onPressed: widget.onClose,
                    ),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFF2A3B40).withOpacity(0.8),
                      width: 1,
                    ),
                  ),
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildSettingsTab("Audio", 0),
                    _buildSettingsTab("Video", 1),
                    _buildSettingsTab("Subtitles", 2),
                    _buildSettingsTab("Playback", 3),
                  ],
                ),
              ),

              // Tab Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(child: _buildSettingsContent()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTab(String title, int index) {
    return InkWell(
      onTap: () => setState(() => _settingsTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _settingsTabIndex == index
                  ? const Color(0xFF64929D)
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: _settingsTabIndex == index
                ? Colors.white
                : const Color(0xFF8CAAB3),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsContent() {
    switch (_settingsTabIndex) {
      case 0: // Audio
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingItem(
              "Audio Preset",
              DropdownButton<String>(
                value: _selectedPreset,
                dropdownColor: const Color(0xFF1E2E32),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF8CAAB3),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                onChanged: (String? newValue) {
                  setState(() => _selectedPreset = newValue!);
                },
                items: _audioPresets.map<DropdownMenuItem<String>>((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Equalizer",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < _equalizerBands.length; i++)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 40, // Fixed width for the dB text
                          alignment: Alignment.center,
                          child: Text(
                            "${_equalizerBands[i].toStringAsFixed(1)}dB",
                            style: const TextStyle(
                              color: Color(0xFF8CAAB3),
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 120,
                          width: 20,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 8,
                                ),
                              ),
                              child: Slider(
                                value: _equalizerBands[i],
                                min: -12,
                                max: 12,
                                divisions: 24,
                                activeColor: const Color(0xFF64929D),
                                inactiveColor: const Color(0xFF2A3B40),
                                onChangeEnd: (value) {
                                  setState(() => _equalizerBands[i] = value);
                                },
                                onChanged: (double value) {
                                  setState(() => _equalizerBands[i] = value);
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _frequencyLabels[i],
                          style: const TextStyle(
                            color: Color(0xFF8CAAB3),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            _buildSettingItem(
              "Normalize Volume",
              Switch(
                value: true,
                activeColor: const Color(0xFF64929D),
                onChanged: (bool value) {},
              ),
            ),
          ],
        );

      case 1: // Video
        return Column(
          children: [
            _buildSettingItem(
              "Aspect Ratio",
              DropdownButton<String>(
                value: "Default",
                dropdownColor: const Color(0xFF1E2E32),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF8CAAB3),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                onChanged: (String? newValue) {},
                items: ["Default", "16:9", "4:3", "1:1", "Stretch"]
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList(),
              ),
            ),
            _buildSettingItem(
              "Deinterlace",
              Switch(
                value: false,
                activeColor: const Color(0xFF64929D),
                onChanged: (bool value) {},
              ),
            ),
            _buildSettingItem(
              "Hardware Acceleration",
              Switch(
                value: true,
                activeColor: const Color(0xFF64929D),
                onChanged: (bool value) {},
              ),
            ),
          ],
        );

      case 2: // Subtitles
        return Column(
          children: [
            _buildSettingItem(
              "Default Subtitle Language",
              DropdownButton<String>(
                value: "English",
                dropdownColor: const Color(0xFF1E2E32),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF8CAAB3),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                onChanged: (String? newValue) {},
                items: ["English", "Spanish", "French", "German", "Japanese"]
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList(),
              ),
            ),
            _buildSettingItem(
              "Subtitle Font Size",
              Slider(
                value: 16,
                min: 8,
                max: 32,
                divisions: 6,
                label: "16px",
                activeColor: const Color(0xFF64929D),
                inactiveColor: const Color(0xFF2A3B40),
                onChanged: (double value) {},
              ),
            ),
          ],
        );

      case 3: // Playback
        return Column(
          children: [
            _buildSettingItem(
              "Repeat Mode",
              DropdownButton<String>(
                value: "None",
                dropdownColor: const Color(0xFF1E2E32),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF8CAAB3),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                onChanged: (String? newValue) {},
                items: ["None", "Track", "Playlist", "Folder"]
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList(),
              ),
            ),
            _buildSettingItem(
              "Shuffle",
              Switch(
                value: false,
                activeColor: const Color(0xFF64929D),
                onChanged: (bool value) {},
              ),
            ),
            _buildSettingItem(
              "Playback Speed",
              Slider(
                value: 1.0,
                min: 0.5,
                max: 2.0,
                divisions: 6,
                label: "1.0x",
                activeColor: const Color(0xFF64929D),
                inactiveColor: const Color(0xFF2A3B40),
                onChanged: (double value) {},
              ),
            ),
          ],
        );

      default:
        return Container();
    }
  }

  Widget _buildSettingItem(String title, Widget control) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Color(0xFF8CAAB3), fontSize: 14),
          ),
          SizedBox(width: 180, child: control),
        ],
      ),
    );
  }
}
