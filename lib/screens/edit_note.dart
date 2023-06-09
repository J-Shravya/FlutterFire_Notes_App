import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sampleapp/services/firestore_service.dart';

import '../models/note.dart';

class EditNoteScreen extends StatefulWidget {
  NoteModel note;
  EditNoteScreen(this.note);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool loading = false;
  @override
  void initState() {
    titleController.text = widget.note.title;
    descriptionController.text = widget.note.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Please Confirm"),
                      content: Text("Are you sure to delete the note?"),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              await FirestoreService()
                                  .deleteNote(widget.note.id);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text("Yes")),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("No"))
                      ],
                    );
                  });
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                  controller: titleController,
                  decoration: InputDecoration(border: OutlineInputBorder())),
              SizedBox(
                height: 30,
              ),
              Text(
                "Description",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: descriptionController,
                minLines: 5,
                maxLines: 10,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 30,
              ),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (titleController.text == "" ||
                                descriptionController.text == "") {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("All fields are required!"),
                              ));
                            } else {
                              setState(() {
                                loading = true;
                              });
                              await FirestoreService().updateNote(
                                  widget.note.id,
                                  titleController.text,
                                  descriptionController.text);
                              setState(() {
                                loading = false;
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "Update Note",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          style:
                              ElevatedButton.styleFrom(primary: Colors.orange)),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
