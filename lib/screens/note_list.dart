import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mydb_todo/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'note_detail.dart';
import 'package:mydb_todo/note.dart';

class NoteList extends StatefulWidget {
  NoteList({Key key}) : super(key: key);

  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TODO",
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Note('', '', 2), "Add Note");
        },
        child: Icon(Icons.add),
      ),
      body: getNoteListView(),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Dismissible(
          background: Container(
            color: Colors.redAccent,
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 40.0,
            ),
          ),
          secondaryBackground: Container(
            color: Colors.redAccent,
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 40.0,
            ),
          ),
          key: Key(this.noteList[position].toString()),
          onDismissed: (endToStart) {
            dataBaseHelper.deleteNote(this.noteList[position].id);
            updateListView();
            final snackBar = SnackBar(backgroundColor: Colors.redAccent,content: Text('Note Deleted!!!'));

            Scaffold.of(context).showSnackBar(snackBar);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 20.0,
            color: Colors.deepPurple,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: this.noteList[position].priority == 1
                    ? Colors.redAccent
                    : Colors.green,
                backgroundImage:
                AssetImage("images/logo.png"),
              ),
              title: Text(
                this.noteList[position].title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25.0),
              ),
              subtitle: Text(
                this.noteList[position].date,
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              trailing: GestureDetector(
                child: Icon(Icons.open_in_new),
                onTap: () {
                  navigateToDetail(this.noteList[position], "Edit TODO");
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = dataBaseHelper.initalizeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = dataBaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
