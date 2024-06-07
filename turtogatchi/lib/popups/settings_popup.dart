import 'package:flutter/material.dart';

class SettingsPopup extends StatefulWidget {
  const SettingsPopup({super.key});

  @override
  State<SettingsPopup> createState() => _SettingsPopupState();
}

class _SettingsPopupState extends State<SettingsPopup> {
  double _currentVolumeValue = 20;
  double _currentMusicVolumeValue = 20;
  bool _currentNotificationStatus = false;

  @override
  Widget build(BuildContext context) {
    // TODO MAKE THIS PAGE FUNCTIONAL
    return AlertDialog(
      // BORDER
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // radius of the outline
        side: const BorderSide(
          color: Color.fromRGBO(25, 67, 89, 1.0), // color of the outline
          width: 12, // width of the outline
        ),
      ),

      // BG COLOR
      backgroundColor: const Color.fromRGBO(236, 249, 255, 1.0),

      // IMAGE AND TITLE
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Settings",
            style: TextStyle(fontFamily: 'MarioRegular', fontSize: 24),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Image.network("https://i.imgur.com/wgyOfDh.png"),
          )
        ],
      ),

      // CONTENT INSIDE
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // VOLUME CONTROL TODO MAKE VOLUME FUNCTIONAL
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset("assets/images/volume.png"),
                Expanded(
                  child: Slider(
                    max: 100.0,
                    value: _currentVolumeValue,
                    divisions: 100,
                    label: _currentVolumeValue.round().toString(),
                    onChanged: (value) => {
                      setState(() {
                        _currentVolumeValue = value;
                      })
                    },
                  ),
                )
              ],
            ),
          ),

          // MUSIC CONTROL
          // TODO MAKE MUSIC FUNCTIONAL
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Image.asset("assets/images/music.png"),
                ),
                Expanded(
                  child: Slider(
                    max: 100.0,
                    value: _currentMusicVolumeValue,
                    divisions: 100,
                    label: _currentMusicVolumeValue.round().toString(),
                    onChanged: (value) => {
                      setState(() {
                        _currentMusicVolumeValue = value;
                      })
                    },
                  ),
                )
              ],
            ),
          ),

          // NOTIFICATIONS SWITCH
          // TODO MAKE NOTIFICATIONS FUNCTIONAL?
          // TODO WHAT NOTIFICATIONS?
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset("assets/images/notification.png"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Switch(
                    value: _currentNotificationStatus,
                    onChanged: (value) => {
                      setState(() {
                        _currentNotificationStatus = value;
                      })
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
