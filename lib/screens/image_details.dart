import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';

class ImageDetailScreen extends StatelessWidget {
  const ImageDetailScreen(
      {super.key, required this.url, required this.question});

  final String url;

  final String question;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          question,
          textAlign: TextAlign.center,
          maxLines: 10,
          style:
              GoogleFonts.getFont('Roboto Slab', fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: PhotoView(
              imageProvider: NetworkImage(
                url,
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
