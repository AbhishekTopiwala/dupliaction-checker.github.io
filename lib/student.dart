import 'package:cloud_crud/screens/signin_screen.dart';
import 'package:cloud_crud/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  final TextEditingController _sidController = TextEditingController();

  final TextEditingController _projecttitleController = TextEditingController();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  Future<void> _create() async {
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
                    String projectTitle = _projecttitleController.text
                        .replaceAll(' ', '')
                        .toLowerCase(); // convert to lowercase and ignore white spaces
                    final String sid = _sidController.text;

                    if (projectTitle.length < 4) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error',
                              style: TextStyle(color: Colors.red)),
                          content: const Text(
                              'Project title must be at least 4 characters long.'),
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
                      return;
                    }

                    // Get the first 4 characters of the project title
                    final String firstFourChars = projectTitle.substring(0, 4);

                    final QuerySnapshot snapshotTitle = await _products
                        .where('projecttitle',
                            isGreaterThanOrEqualTo: firstFourChars)
                        .where('projecttitle',
                            isLessThan: firstFourChars + '\uf8ff')
                        .get();
                    final QuerySnapshot snapshotSID =
                        await _products.where('sid', isEqualTo: sid).get();
                    if (snapshotTitle.docs.isNotEmpty &&
                        snapshotSID.docs.isNotEmpty) {
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
                    } else if (snapshotSID.docs.isNotEmpty) {
                      // A document with the same student ID already exists
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error',
                              style: TextStyle(color: Colors.red)),
                          content: const Text(
                              'A project with this student ID already exists.'),
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
                      // No document with the same student ID and project title exists, so create a new one
                      await _products
                          .add({"sid": sid, "projecttitle": projectTitle});
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

  // Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF232946),
        centerTitle: true,
        title: const Text(
          'Students',
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
                value: 'logout',
                child: Text('Logout'),
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
      backgroundColor: const Color(0xFFB2B2B2),
      body: StreamBuilder(
        stream: _products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  color: const Color(0xFFEFEFEF),
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      documentSnapshot['sid'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      documentSnapshot['projecttitle'].toString(),
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
        onPressed: () => _create(),
        backgroundColor: const Color(0xFF232946),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
