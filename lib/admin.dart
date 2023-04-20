import 'package:cloud_crud/screens/signin_screen.dart';
import 'package:cloud_crud/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// text fields' controllers

  final TextEditingController _sidController = TextEditingController();
  final TextEditingController _projecttitleController = TextEditingController();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _sidController,
                  decoration: const InputDecoration(labelText: 'Student Id'),
                ),
                TextField(
                  controller: _projecttitleController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: 'Project Title'),
                ),
                const SizedBox(
                  height: 20,
                ),
                //create
                ElevatedButton(
                  child: const Text('Create'),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF232946), // Button background color
                    onPrimary: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ), // Button padding
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ), // Button text style
                  ),
                  onPressed: () async {
                    String projectTitle = _projecttitleController.text.replaceAll(' ', '').toLowerCase(); // convert to lowercase and ignore white spaces
                    final String sid = _sidController.text;

                    if (projectTitle.length < 4) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error', style: TextStyle(color: Colors.red)),
                          content: const Text('Project title must be at least 4 characters long.'),
                          backgroundColor: Colors.white,
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK', style: TextStyle(color: Colors.blue)),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    // Get the first 4 characters of the project title
                    final String firstFourChars = projectTitle.substring(0, 4);

                    final QuerySnapshot snapshotTitle = await _products
                        .where('projecttitle', isGreaterThanOrEqualTo: firstFourChars)
                        .where('projecttitle', isLessThan: firstFourChars + '\uf8ff')
                        .get();
                    final QuerySnapshot snapshotSID =
                    await _products.where('sid', isEqualTo: sid).get();
                    if (snapshotTitle.docs.isNotEmpty &&
                        snapshotSID.docs.isNotEmpty) {
                      // A document with the same project title and student ID already exists
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error', style: TextStyle(color: Colors.red)),
                          content: const Text(
                              'A project with this student ID and title already exists.'),
                          backgroundColor: Colors.white,
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK', style: TextStyle(color: Colors.blue)),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshotTitle.docs.isNotEmpty) {
                      // A document with the same project title already exists
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error', style: TextStyle(color: Colors.red)),
                          content: const Text(
                              'A project with this title already exists.'),
                          backgroundColor: Colors.white,
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK', style: TextStyle(color: Colors.blue)),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshotSID.docs.isNotEmpty) {
                      // A document with the same student ID already exists
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error', style: TextStyle(color: Colors.red)),
                          content: const Text(
                              'A project with this student ID already exists.'),
                          backgroundColor: Colors.white,
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK', style: TextStyle(color: Colors.blue)),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // No document with the same student ID and project title exists, so create a new one
                      await _products.add({"sid": sid, "projecttitle": projectTitle});
                      _sidController.text = '';
                      _projecttitleController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )


              ],
            ),
          );
        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _sidController.text = documentSnapshot['sid'];
      _projecttitleController.text =
          documentSnapshot['projecttitle'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _sidController,
                  decoration: const InputDecoration(labelText: 'Student ID'),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _projecttitleController,
                  decoration: const InputDecoration(labelText: 'Project Title'),
                ),

                const SizedBox(
                  height: 20,
                ),
                //Update
            ElevatedButton(
              onPressed: () async {
                final String projectTitle = _projecttitleController.text;
                final String sid = _sidController.text;

                final QuerySnapshot snapshotTitle = await _products
                    .where('projecttitle', isEqualTo: projectTitle)
                    .get();
                final QuerySnapshot snapshotSID =
                await _products.where('sid', isEqualTo: sid).get();
                final QuerySnapshot snapshotExceptSelf = await _products
                    .where('projecttitle', isEqualTo: projectTitle.toLowerCase())
                    .where('sid', isEqualTo: sid)
                    .where(FieldPath.documentId,
                    isNotEqualTo: documentSnapshot!.id)
                    .get();

                // Check if a document with the same project title already exists (excluding the current document being updated)
                if (snapshotTitle.docs.isNotEmpty && snapshotExceptSelf.docs.isNotEmpty) {
                  // A document with the same project title and student ID already exists
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error',
                          style: TextStyle(color: Colors.red)),
                      content: const Text(
                          'A project with this student ID and title already exists.'),
                      backgroundColor: Colors.white,
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK',
                              style: TextStyle(color: Colors.blue)),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                } else if (snapshotTitle.docs.isNotEmpty) {
                  // A document with the same project title already exists
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error',
                          style: TextStyle(color: Colors.red)),
                      content: const Text(
                          'A project with this title already exists.'),
                      backgroundColor: Colors.white,
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK',
                              style: TextStyle(color: Colors.blue)),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                } else {
                  // No document with the same project title exists, so update the current document
                  await _products
                      .doc(documentSnapshot!.id)
                      .update({"sid": sid, "projecttitle": projectTitle});
                  _sidController.text = '';
                  _projecttitleController.text = '';
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF232946), // Button background color
                onPrimary: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ), // Button padding
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ), // Button text style
              ),
              child: const Text('Update'), // Button text
            ),


            ],
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _products.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB2B2B2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF232946),
        centerTitle: true,
        title: const Text(
          'Admin',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text('Logout'),
                value: 'logout',
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                print('SignOut');
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                      (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _products.snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Object?>> streamSnapshot) {
          if (streamSnapshot.hasData) {
            final List<QueryDocumentSnapshot<Object?>> documents =
                streamSnapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                final DocumentSnapshot<Object?> documentSnapshot =
                documents[index];
                return Card(
                  color: const Color(0xFFEFEFEF),
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      documentSnapshot['sid'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      documentSnapshot['projecttitle'].toString(),
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xFF232946),
                              size: 24.0,
                            ),
                            onPressed: () => _update(documentSnapshot),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 24.0,
                            ),
                            onPressed: () => _delete(documentSnapshot.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF232946)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF232946),
        onPressed: () => _create(),
        child: const Icon(
          Icons.add,
          size: 32.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

}
