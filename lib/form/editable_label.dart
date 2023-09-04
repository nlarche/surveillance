import 'package:flutter/material.dart';

class EditableLabel extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;

  EditableLabel({required this.text, required this.onChanged});

  @override
  _EditableLabelState createState() => _EditableLabelState();
}

class _EditableLabelState extends State<EditableLabel> {
  bool isEditing = false;
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      // Edit mode
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: FocusNode(),
              style: const TextStyle(fontSize: 16.0),
              onChanged: widget.onChanged,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {        Expanded(flex: 2, child: Container()),

              setState(() {
                isEditing = false;
                widget.onChanged(_controller.text);
              });
            },
          ),
        ],
      );
    } else {
      // Display mode
      return InkWell(
        onTap: () {
          setState(() {
            isEditing = true;
            _controller.text = widget.text;
          });
        },
        child: Text(
          widget.text,
          style: const TextStyle(fontSize: 16.0),
        ),
      );
    }
  }
}
