import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MuseumPopup extends StatelessWidget {
  const MuseumPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // radius of the outline
        side: const BorderSide(
          color: Color.fromRGBO(25, 67, 89, 1.0), // color of the outline
          width: 12, // width of the outline
        ),
      ),
      backgroundColor: const Color.fromRGBO(236, 249, 255, 1.0),
      icon: Stack(alignment: Alignment.center, children: <Widget>[
        Positioned(
          right: 0.0,
          top: 0.0,
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(25, 67, 89, 1.0),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        Image.asset(
          width: 100,
          height: 100,
          "assets/images/museum_transparent_background.png",
        ),
      ]),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            textAlign: TextAlign.center,
            "To support the Singapore Live Turtle and Tortoise Museum, you can volunteer your time, donate directly to the museum, or help spread awareness about their conservation efforts by sharing information and visiting their exhibits. ",
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.link),
                ),
                Flexible(
                  child: Text("Learn more about volunteering and visiting"),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(FontAwesomeIcons.instagram),
                ),
                Flexible(child: Text("Instagram")),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(FontAwesomeIcons.facebook),
                ),
                Flexible(child: Text("Facebook")),
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Subscribe to their newsletter!"),
        ),
      ],
    );
  }
}
