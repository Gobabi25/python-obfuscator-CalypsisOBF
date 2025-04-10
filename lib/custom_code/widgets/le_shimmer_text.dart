// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:shimmer/shimmer.dart';

class LeShimmerText extends StatefulWidget {
  const LeShimmerText({
    super.key,
    this.width,
    this.height,
    required this.texte,
    required this.texte2,
    required this.size,
    required this.size2,
    this.color,
  });

  final double? width;
  final double? height;
  final String texte;
  final String texte2;
  final double size;
  final double size2;
  final Color? color;

  @override
  State<LeShimmerText> createState() => _LeShimmerTextState();
}

class _LeShimmerTextState extends State<LeShimmerText> {
  @override
  Widget build(BuildContext context) {
    print("shimmer");
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade800,
        highlightColor: Colors.grey.shade500,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.texte,
                style: TextStyle(
                    fontSize: widget.size,
                    color: widget.color,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10,
            ),
            Text(widget.texte2,
                style: TextStyle(fontSize: widget.size2, color: widget.color)),
          ],
        ));
  }
}
