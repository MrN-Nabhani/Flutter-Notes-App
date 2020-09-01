import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/utils/database_helper.dart';
import 'package:notes_app/models/node.dart';

class NoteDetail extends StatefulWidget{
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(note, appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail>{

  var titleController = TextEditingController();
  var descritionController = TextEditingController();

  DatabaseHelper databaseHelper = DatabaseHelper();
  String appBarTitle;
  Note note;

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descritionController.text = note.description;
    return 
        Scaffold(
          appBar:  
              AppBar(title: Text(appBarTitle), 
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    goBack();
                  },),
                ),
          body: getForm(),
        );
  }


  ListView getForm(){
    return 
        ListView(
          children: <Widget>[
            
            Padding(
            padding: EdgeInsets.all(10.0),
            child:
              TextFormField(
                controller: titleController,

                decoration: InputDecoration(
                  labelText: 'Note Title',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )
                ),
                                
                onChanged: (value){
                    note.title = value;
                },

              ),
            ),

            Padding(
            padding: EdgeInsets.all(10.0),
            child:
              TextFormField(
                controller: descritionController,
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: 'description',
                  labelStyle: TextStyle(color: Colors.grey),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )
                ),

                onChanged: (value){
                    note.description = value; 
                },
              )
            ),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
          child:
            RaisedButton(
              child: Text('SAVE'),
              color: Theme.of(context).primaryColor,
              onPressed: (){
                _saveNote();
              },
            ),

          )
      ]
    );
  }
  void _saveNote() async{

    goBack();

    int result;
    note.date = DateFormat.yMMMd().format(DateTime.now());
    
    if(note.id != null){
      result = await databaseHelper.updateNote(note);
      
    }else {
      result = await databaseHelper.insertNote(note);
    }

    if(result == 0){
      _showAlertDialog('Oops!', 'Something gone wrong :\\');
    }
  }

/*
  void _snackbar(BuildContext context, String message){
      var snackbar = SnackBar(content: Text(message),);
      Scaffold.of(context).showSnackBar(snackbar);
      
  }
*/
  void _showAlertDialog(String title, String message){
      var dialog = AlertDialog(title: Text(title), content: Text(message),);
      showDialog(
        context: context,
        builder: (_) => dialog,
      );
  }

  void goBack(){
    Navigator.pop(context, true);
  }

}