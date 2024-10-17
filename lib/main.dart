import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_exp_119/firebase_options.dart';
import 'package:firebase_exp_119/login_page.dart';
import 'package:firebase_exp_119/note_model.dart';
import 'package:firebase_exp_119/signup_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}

class HomePage extends StatelessWidget {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  String uid;
  HomePage({required this.uid});


  @override
  Widget build(BuildContext context) {

    ///get
    Future<QuerySnapshot<Map<String, dynamic>>> collectionData = fireStore.collection("users").doc(uid).collection("notes").get();
    Stream<QuerySnapshot<Map<String, dynamic>>> collectionDataStream = fireStore.collection("users").doc(uid).collection("notes").snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: collectionDataStream,
        builder: (_, snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }

          if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'),);
          }

          if(snapshot.hasData){
            return snapshot.data!.docs.isNotEmpty ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index){

              NoteModel eachNote = NoteModel.fromMap(snapshot.data!.docs[index].data());

              return ListTile(
                title: Text(eachNote.title),
                subtitle: Text(eachNote.desc),
              );
            }) : Center(child: Text('No Notes yet!!'),);
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var currTime = DateTime.now().millisecondsSinceEpoch.toString();

          ///update
          /*fireStore.collection("users").doc(currTime).update({
            title: "New Note from Flutter",
          });*/

          ///remove
          /*fireStore.collection("users").doc("463746347").delete();*/

          fireStore.collection("users").doc(uid).collection("notes").doc(currTime).set(NoteModel(
                  title: "New Note from Flutter",
                  desc: "This is Note Desc",
                  createdAT: currTime)
              .toMap());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
