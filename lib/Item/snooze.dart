import 'package:flutter/material.dart';

class SnoozeOption extends StatefulWidget {
  final Function(int) onSnoozeSelected;

  SnoozeOption({Key? key, required this.onSnoozeSelected}) : super(key: key);

  @override
  _SnoozeOptionState createState() => _SnoozeOptionState();
}

class _SnoozeOptionState extends State<SnoozeOption> {
  String _selectedInterval = '5 min'; // Default snooze interval

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showSnoozeDialog();
      },
      child: Container(
        height: 50,
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Snooze', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            Row(
              children: [
                Text(_selectedInterval, style: TextStyle(color: Colors.white, fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: _showSnoozeDialog,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSnoozeDialog() async {
    String? interval = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SnoozeDialog(currentInterval: _selectedInterval);
      },
    );

    if (interval != null && interval != _selectedInterval) {
      setState(() {
        _selectedInterval = interval;
      });
      int snoozeDuration = interval == 'none' ? 0 : int.tryParse(interval.replaceAll(' min', '')) ?? 5;
      widget.onSnoozeSelected(snoozeDuration);
    }
  }
}

class SnoozeDialog extends StatefulWidget {
  final String currentInterval;

  SnoozeDialog({required this.currentInterval});

  @override
  _SnoozeDialogState createState() => _SnoozeDialogState();
}

class _SnoozeDialogState extends State<SnoozeDialog> {
  late String _selectedInterval;
  final List<String> _intervals = ['none', '1 min', '3 min', '5 min', '10 min', '15 min', '20 min', '25 min', '30 min', '45 min', '60 min'];

  @override
  void initState() {
    super.initState();
    _selectedInterval = widget.currentInterval;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Snooze interval", textAlign: TextAlign.center),
      content: Container(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: _intervals.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_intervals[index]),
              trailing: _selectedInterval == _intervals[index] ? Icon(Icons.check) : null,
              onTap: () {
                setState(() {
                  _selectedInterval = _intervals[index];
                });
                Navigator.of(context).pop(_intervals[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
