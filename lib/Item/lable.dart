import 'package:flutter/material.dart';

class LabelSelector extends StatefulWidget {
  final Function(String) onLabelChanged;
  final String defaultLabel;

  LabelSelector({Key? key, this.defaultLabel = 'Alarm', required this.onLabelChanged}) : super(key: key);

  @override
  _LabelSelectorState createState() => _LabelSelectorState();
}

class _LabelSelectorState extends State<LabelSelector> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.defaultLabel);

    // Listen to changes in text field and update the state in parent widget
    _controller.addListener(() {
      widget.onLabelChanged(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String? updatedLabel = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _LabelEditPage(controller: _controller),
          ),
        );

        if (updatedLabel != null) {
          setState(() {
            _controller.text = updatedLabel;
          });
          widget.onLabelChanged(updatedLabel); // Update the label in the parent widget
        }
      },
      child: Container(
        height: 50,
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Label', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            Row(
              children: [
                Text(
                  _controller.text,
                  style: TextStyle(
                    color: _controller.text == widget.defaultLabel ? Colors.grey : Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: () async {
                    String? updatedLabel = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => _LabelEditPage(controller: _controller),
                      ),
                    );
                    if (updatedLabel != null) {
                      setState(() {
                        _controller.text = updatedLabel;
                      });
                      widget.onLabelChanged(updatedLabel);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _LabelEditPage extends StatelessWidget {
  final TextEditingController controller;

  _LabelEditPage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Label'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Alarm',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Colors.black),
            cursorColor: Colors.orange,
            textAlign: TextAlign.right,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pop(context, controller.text); // Pass back the updated label
        },
      ),
    );
  }
}
