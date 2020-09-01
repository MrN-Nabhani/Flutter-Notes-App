import 'package:flutter/material.dart';
import 'Screens/note_list.dart';

void main() => runApp(NotesApp());

class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Notes App',

      theme: 
      ThemeData(
        primarySwatch: Colors.yellow,
        fontFamily: 'Schyler', 
        textTheme: TextTheme(title: TextStyle(color: Colors.black, fontSize: 24.0),)
      ),

      debugShowCheckedModeBanner: false,
      
      home: NoteList(),
    );
  }
  
}
