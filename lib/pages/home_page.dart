import 'package:belajar_crud_rirebase/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //firestore
  final FirestoreService firestoreService = FirestoreService();

  //text controller
  final TextEditingController textController = TextEditingController();

  //open a dialog box to add a new note
  void openNoteBox({String? docID}){
    showDialog(context: context, builder: (context) => AlertDialog(
      content: TextField(
        controller: textController
      ),
      actions: [
        //button to save
        ElevatedButton(
          onPressed: (){
            // add a new note
            if (docID == null) {
              firestoreService.addNote(textController.text);
            }
            //update an existing note
            else{
              firestoreService.updateNote(docID, textController.text);
            }

            //clear the text controller
            textController.clear();

            //close the box
            Navigator.pop(context);
          }, 
          child: Text(
            docID == null?'Add':'Edit'
          )
        )
      ],
    ));
  }

  void openDeleteDialog(String docID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('yakin mau hapus note?'),
        actions: [
          // Button to confirm deletion
          ElevatedButton(
            onPressed: () {
              firestoreService.deleteNote(docID);
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Yakin'),
          ),
          // Button to cancel deletion
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Nggak'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(
          child: Text(
            'Notes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: openNoteBox,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(), 
        builder: (context, snapshot){
          //if we have data get all the doc
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            //display as a list
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index){
                //get individual doc
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                //get note from each doc
                Map<String, dynamic> data = 
                  document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                //display as a list tile
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(15),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white
                        ),
                        child: ListTile(
                          title: Text(
                            noteText,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //update
                              IconButton(
                                onPressed: () => openNoteBox(docID: docID), 
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey
                                )
                              ),
                              //delete
                              IconButton(
                                onPressed: () => openDeleteDialog(docID), 
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            );
          }
          //if there is no data not run anything
          else{
            return Text('no Notes');
          }
        }
      ),
    );
  }
}