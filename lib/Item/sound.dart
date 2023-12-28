import 'package:flutter/material.dart';

class SoundSelector extends StatefulWidget {
  final Function(String) onSoundSelected;

  SoundSelector({Key? key, required this.onSoundSelected}) : super(key: key);

  @override
  _SoundSelectorState createState() => _SoundSelectorState();
}

class _SoundSelectorState extends State<SoundSelector> {
  String _selectedSong = 'January'; // Default song

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String? song = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SoundSelectorPage(selectedSong: _selectedSong)),
        );
        setState(() {
          _selectedSong = song ?? _selectedSong;
        });
        widget.onSoundSelected(_selectedSong); // Callback with the selected or default song
      },
      child: Container(
        height: 50,
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Sound', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            Row(
              children: [
                Text(_selectedSong, style: TextStyle(color: Colors.white, fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: () async {
                    String? song = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SoundSelectorPage(selectedSong: _selectedSong)),
                    );
                    setState(() {
                      _selectedSong = song ?? _selectedSong;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SoundSelectorPage extends StatefulWidget {
  final String selectedSong;

  SoundSelectorPage({Key? key, required this.selectedSong}) : super(key: key);

  @override
  _SoundSelectorPageState createState() => _SoundSelectorPageState();
}

class _SoundSelectorPageState extends State<SoundSelectorPage> {
  String _selectedSong; // Hold the currently selected or passed song
  final List<String> _songs = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October'];

  _SoundSelectorPageState() : _selectedSong = '';

  @override
  void initState() {
    super.initState();
    _selectedSong = widget.selectedSong;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252934),
      appBar: AppBar(
        title: Text('Select Sound'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: _selectedSong == _songs[index]
                      ? Icon(Icons.check_circle_rounded, color: Colors.blue)
                      : Icon(Icons.radio_button_unchecked, color: Colors.white),
                  title: Text(_songs[index], style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() {
                      _selectedSong = _songs[index];
                    });
                  },
                );
              },
            ),
          ),
          // Other widgets (e.g., volume slider, vibration switch) can be added here
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 100),
        child: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            Navigator.pop(context, _selectedSong);
          },
        ),
      ),
    );
  }
}
