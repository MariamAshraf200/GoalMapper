import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesTab extends StatefulWidget {
  final String planId;

  const NotesTab({Key? key, required this.planId}) : super(key: key);

  @override
  _NotesTabState createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  List<String> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes = prefs.getStringList('notes_${widget.planId}') ?? [];
    });
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notes_${widget.planId}', _notes);
  }

  void _showAddNoteDialog(BuildContext context) {
    final TextEditingController _noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add a Note"),
          content: TextFormField(
            controller: _noteController,
            decoration: const InputDecoration(
              hintText: "Write your note here...",
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_noteController.text.isNotEmpty) {
                  setState(() {
                    _notes.add(_noteController.text);
                    _saveNotes();
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.deepPurple),
            onPressed: () {
              _showAddNoteDialog(context);
            },
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                title: Text(_notes[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _notes.removeAt(index);
                      _saveNotes();
                    });
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}