import 'package:flutter/material.dart';
import 'package:notes_app/Screens/note_detail.dart';

import 'package:notes_app/utils/database_helper.dart';
import 'package:notes_app/models/node.dart';

//import 'package:flutter/widgets.dart';

class NoteList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList>{

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> notesList;
  int _notesCount = 0;

  @override
  Widget build(BuildContext context) {

    if(notesList == null){
      notesList = new List<Note>();
      updateNoteList();
    }

    return Scaffold(
          appBar: AppBar(
            title: Text('Notes',),
            backgroundColor: Colors.yellow,
          ),

          body: getListView(),

          floatingActionButton: 
          FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Add Note',
            elevation: 4.5,
            onPressed: () {
              goToNoteDetail(Note('', ''),'Add Note');
            },
          )
    );
        
  }

  ListView getListView(){
    return ListView.builder(
      itemCount: _notesCount,
      itemBuilder: (context, index)=>(
        Card(
          color: Colors.white,
          elevation: 3.5,

          child:
            ListTile( 
              title: Text(notesList[index].title),
              subtitle: Text(notesList[index].date),
              leading: Icon(Icons.note, color: Theme.of(context).primaryColor,),
              trailing: IconButton(
                    icon: Icon(Icons.cancel),
                    color: Colors.redAccent,
                    onPressed: (){
                      delete(context, notesList[index]);
                    },
                  ),
              onTap: (){
                goToNoteDetail(notesList[index],'Edit Note');
              },
            )
        )
      ),
    );
  }

  void delete(BuildContext context, Note note) async {

    int result = await databaseHelper.deleteNote(note.id);

    if(result != 0){
      _snackbar(context, 'Note Deleted', note);
      updateNoteList();
    }
  }

  void _snackbar(BuildContext context, String message, Note lastNote){
      var snackbar = SnackBar(content: 
          Row(children: <Widget>[
            Text('Note Deleted! Undo this action?'),

            SizedBox(width: 64.0,),

            IconButton(icon: Icon(Icons.refresh), 
              iconSize: 30.0,
              tooltip: 'UNDO',
              onPressed: ()async { 
                Scaffold.of(context).hideCurrentSnackBar();
                int result = await databaseHelper.insertNote(lastNote);
                if(result != 0)
                    updateNoteList();
              },),

          ],),
            

      );

      Scaffold.of(context).showSnackBar(snackbar);
  }

  void updateNoteList() async {
    List<Note> newNote = await databaseHelper.getNotesList();
    setState(() {
      notesList = newNote;
      _notesCount = notesList.length;
      debugPrint('notes : ');
    for(var note in notesList)
      debugPrint(note.description);
    });
  }

  void goToNoteDetail(Note note, String title) async {
      bool listUpdated = await Navigator.push(context, MaterialPageRoute(builder: (context){return NoteDetail(note, title); } ));
      if(listUpdated)
        updateNoteList();
  }
}