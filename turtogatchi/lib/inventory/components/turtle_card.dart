import 'package:flutter/material.dart';
import 'package:turtogatchi/inventory/components/turtle_information.dart';

class TurtleCard extends StatefulWidget {
  final bool info;

  const TurtleCard({super.key, required this.info});

  @override
  State<TurtleCard> createState() => _TurtleCardState();
}

class _TurtleCardState extends State<TurtleCard> {
  bool get info => widget.info;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TurtleInformationPage(),
          ),
        ),
      },
      child: Card.outlined(
        elevation: 4,
        color: const Color.fromRGBO(152, 228, 255, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Color.fromRGBO(78, 152, 180, 1.0),
            width: 2,
          ),
        ),
        child: info
            ? SizedBox(
                width: 100,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TODO LOGO GOES HERE
                    Image.asset("assets/images/miniheart.png"),
                    // TODO NAME GOES HERE
                    const Text("Heart"),
                  ],
                ),
              )
            : const SizedBox(
                width: 100,
                height: 100,
                child: Center(
                  child: Icon(
                    Icons.question_mark_sharp,
                    color: Color.fromRGBO(78, 152, 180, 1.0),
                  ),
                ),
              ),
      ),
    );
  }
}
