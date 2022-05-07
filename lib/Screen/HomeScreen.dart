import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/Model/authentication.dart';
import 'package:todoapp/Screen/ForgotPassword.dart';
import 'package:todoapp/Screen/Login.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user = FirebaseAuth.instance.currentUser;
  DocumentReference ref = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser?.uid);
  TextEditingController addTodoController = TextEditingController();
  TextEditingController editTodoController = TextEditingController();
  late bool _validate;
  final _formKey = GlobalKey<FormState>();

  String email = "";
  int _index = 0;
  bool indexLoading = false;
  var todoList = [];
  late List<bool> isCheck;

  getData() async {
    var _data = await _firestore.collection('Users').doc(_user!.uid).get();
    setState(() {
      email = _data.data()!['email'];
      todoList = _data.data()!['content'];
    });
  }

  getDocsIndex() async {
    String? currentId = _user!.uid;
    QuerySnapshot querySnapshot = await _firestore.collection("Users").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = await querySnapshot.docs[i];
      if(currentId == a.id){
        setState(() {
          _index = i;
        });
        break;
      }
      print("INDEX: ${_index}");
    }
    indexLoading = true;
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    return Colors.cyan;
  }

  @override
  void initState() {
    // TODO: implement initState
    _validate = false;
    getData();
    getDocsIndex();
    isCheck = List<bool>.filled(200, false);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    addTodoController.dispose();
    editTodoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      // Appbar
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade800,
        title: Text(
          "Task List",
          style: TextStyle(fontSize: 26.0),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Add Task'),
                    content: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Your Task';
                        }
                        return null;
                      },
                      controller: addTodoController,
                      decoration: InputDecoration(
                        hintText: 'Task info.',
                        errorText: _validate ? "Enter your task" : null,
                        // errorText: "Enter your task",
                        // label: Text("Task info"),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          try {
                            setState(() {
                              if (addTodoController.text.isNotEmpty) {
                                ref.update({
                                  'content': FieldValue.arrayUnion(
                                      [addTodoController.text])
                                });
                                Navigator.of(context).pop();
                              } else if(addTodoController.text.isEmpty) {
                                _validate = true;
                              } else {
                                _validate = false;
                              }
                              addTodoController.clear();
                              // addTodoController.text.isEmpty ? _validate = true : _validate = false;
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text('SUBMIT'),
                      )
                    ],
                  ),
                );
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 30.0,
              )),
        ],
      ),

      // Drawer
      drawer: Container(
        width: size.width / 1.5,
        child: Drawer(
            backgroundColor: Colors.grey.shade800,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        child: Text(
                          "Email: ${AuthenticationServices(_auth).getUser()?.email}",
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 2.0,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                        },
                        child: Text(
                          "Reset Password",
                          style: TextStyle(fontSize: 20.0, color: Colors.cyan),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.cyan,
                      elevation: 0,
                      minimumSize: Size.fromHeight(60),
                      // maximumSize: Size.fromHeight(50),
                    ),
                    onPressed: () {
                      AuthenticationServices(_auth).signOut().then((result) {
                        if (result == "Sign Out") {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        } else {
                          // print("Result Found: "+result!);
                          var snackBar = SnackBar(
                            content: Text(result!),
                            backgroundColor: Colors.cyan,
                            duration: Duration(seconds: 2),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                    icon: Icon(
                      Icons.logout_outlined,
                      size: 30,
                    ),
                    label: Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            )),
      ),

      // Body
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('Users').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                'Some thing went wrong! \n Restart your app!',
                style: TextStyle(fontSize: 28.0, color: Colors.red),
              ));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.cyan,
              ));
            } else if (snapshot.hasData || snapshot.data != null) {
              return indexLoading == true ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs[_index]['content'].length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot? documentSnapshot = snapshot.data?.docs[_index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: Card(
                      color: Colors.black,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                value: isCheck[index],
                                splashRadius: 20,
                                shape: CircleBorder(),
                                checkColor: Colors.white,
                                fillColor: MaterialStateProperty.resolveWith(getColor),
                                onChanged: (bool? value){
                                  setState(() {
                                    isCheck[index] = value!;
                                  });
                                },
                              ),
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Edit Task'),
                                      content: TextFormField(
                                        controller: editTodoController,
                                        decoration: InputDecoration(
                                          hintText: snapshot.data?.docs[_index]['content'][index],
                                          errorText: _validate ? "Enter your task" : null,
                                          // label: Text("Task info"),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              final contentList = _firestore.collection('Users').doc(_user?.uid);
                                              final docSnap = await contentList.get();
                                              List content = docSnap.get('content');
                                              ref.update({
                                                'content': FieldValue.arrayRemove([content[index]]),
                                              });
                                              ref.update({
                                                'content': FieldValue.arrayUnion([editTodoController.text]),
                                              });
                                              setState(() {
                                                if (editTodoController.text.isEmpty) {
                                                  _validate = true;
                                                } else {
                                                  _validate = false;
                                                  Navigator.of(context).pop();
                                                }
                                                editTodoController.clear();
                                                // addTodoController.text.isEmpty ? _validate = true : _validate = false;
                                              });
                                            } catch (e) {
                                              print(e);
                                            }
                                          },
                                          child: Text('UPDATE'),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                child: Text(
                                  '${documentSnapshot!['content'][index]}',
                                  // '${index} \t ${todoList[index]}',
                                  style:
                                      TextStyle(fontSize: 18.0, color: Colors.white),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  try {
                                    final contentList = _firestore.collection('Users').doc(_user?.uid);
                                    final docSnap = await contentList.get();
                                    List content = docSnap.get('content');
                                    await ref.update({
                                      'content': FieldValue.arrayRemove([content[index]]),
                                    });
                                  } catch (e){
                                    print(e);
                                  }
                                },
                                icon: Icon(Icons.delete, color: Colors.white54, size: 29.0,)
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
                  : Center(child: CircularProgressIndicator(color: Colors.cyan,));
            }
            return Center(child: CircularProgressIndicator(color: Colors.cyan,));
          }),
    );
  }
}
