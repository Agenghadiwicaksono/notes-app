import 'package:cloud_firestore/cloud_firestore.dart';
class FirestoreService {
  
  // get colection of notes
  final CollectionReference notes = 
    FirebaseFirestore.instance.collection('notes');
  // CRAETE: add a new note
  Future<void> addNote(String note){
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }
  // READ: get notes from database
  Stream<QuerySnapshot> getNotesStream(){
    final notesStream = 
    notes.orderBy('timestamp', descending: true).snapshots();

    return notesStream;
  }

  // UPDATE: update a note
  Future<void> updateNote(String docID, String newNote){
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  // DELETE: delete a note
  Future<void> deleteNote(String docID){
    return notes.doc(docID).delete();
  }
}