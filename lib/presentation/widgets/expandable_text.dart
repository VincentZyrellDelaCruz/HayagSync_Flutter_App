import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(this.text, {super.key, this.style, this.trimLines = 3});

  final String? text;
  final TextStyle? style;
  final int trimLines;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final content = widget.text ?? '';

    if (content.isEmpty) {
      return const Text(
        'No description available',
        style: TextStyle(color: Colors.grey, fontSize: 14),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content,
          style: widget.style ?? TextStyle(fontSize: 16),
          maxLines: isExpanded ? null : widget.trimLines,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),

        GestureDetector(
          child: Text(
            isExpanded ? 'Show Less' : 'Show More',
            style: TextStyle(
              color: Colors.blue[400],
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () => setState(() => isExpanded = !isExpanded),
        ),
      ],
    );
  }
}
