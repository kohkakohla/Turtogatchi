import 'package:flutter/material.dart';
import 'package:turtogatchi/inventory/components/turtle_card.dart';

Widget cardGenerator(bool info, int id) {
  return TurtleCard(
    info: info,
    id: id,
  );
}
