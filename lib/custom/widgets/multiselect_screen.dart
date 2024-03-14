import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MultiSelectUtil extends StatefulWidget {
  const MultiSelectUtil(
      {Key? key, required this.myTopics, required this.mySelected})
      : super(key: key);

  final List myTopics;
  final List<String> mySelected;

  @override
  State<MultiSelectUtil> createState() => _MultiSelectUtilState();
}

class _MultiSelectUtilState extends State<MultiSelectUtil> {
  void itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        widget.mySelected.add(itemValue);
      } else {
        widget.mySelected.remove(itemValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Select Topic',
        style: GoogleFonts.getFont('Roboto Slab', fontWeight: FontWeight.w500),
      ),
      content: SizedBox(
        height: 200,
        child: SingleChildScrollView(
          child: ListBody(
              children: widget.myTopics
                  .map((item) => CheckboxListTile(
                      value: widget.mySelected.contains(item),
                      title: Text(
                        item,
                        style: GoogleFonts.getFont(
                          'Roboto Slab',
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) => itemChange(item, value!)))
                  .toList()),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: GoogleFonts.getFont(
              'Roboto Slab',
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // print('******** Select your topics : ${widget.mySelected}');
            Navigator.pop(context, widget.mySelected);
          },
          child: Text(
            'Submit',
            style: GoogleFonts.getFont(
              'Roboto Slab',
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
