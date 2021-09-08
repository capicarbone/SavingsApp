import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 21, bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
            height: 1,
            fontSize: 26,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
