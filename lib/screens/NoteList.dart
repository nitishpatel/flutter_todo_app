import 'package:flutter/material.dart';
import 'package:mydb_todo/database_helper.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:mydb_todo/Note.dart';
import 'NoteDetail.dart';
import 'stats.dart';
class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  @override
  void initState() {
    super.initState();
    updateListView();
  }

  bool isComplete;
  static Color mainUiColor = Color(0xFFb92b27);
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo"),
        backgroundColor: mainUiColor,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.insert_chart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return StatusInfo();
              }));
            },
          )
        ],
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainUiColor,
        child: Icon(Icons.add),
        onPressed: () {
          navigateToDetail(Note('', '', 2, 2), 'Add Note');
        },
      ),
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
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, position) {
        isComplete = this.noteList[position].status == 1 ? true : false;
        return Dismissible(
            background: Container(
              color: Colors.red,
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 40.0,
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
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
              databaseHelper.deleteNote(this.noteList[position].id);
              updateListView();
              final snackBar = SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text('Note Deleted!!!'),
                duration: Duration(seconds: 2),
              );

              Scaffold.of(context).showSnackBar(snackBar);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: this.noteList[position].priority == 1
                  ? Color(0xFFb33939)
                  : Color(0xFFff5252),
              elevation: 10.0,
              child: ListTile(
                leading: Checkbox(
                  value: isComplete,
                  onChanged: (bool value) {
                    setState(() {
                      this.noteList[position].status = value == true ? 1 : 2;
                    });
                    databaseHelper.updateNote(this.noteList[position]);
                  },
                ),
                title: Text(
                  this.noteList[position].title,
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      decoration: this.noteList[position].status == 1
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
                trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      navigateToDetail(this.noteList[position], 'Edit Note');
                    }),
                subtitle: Text(this.noteList[position].date,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    )),
              ),
            ));
      },
    );
  }
}
