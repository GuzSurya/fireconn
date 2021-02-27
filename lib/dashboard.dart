import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireconn/services/crud.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String studentName;
  String studentNim;

  QuerySnapshot students;

  CrudMethods crudObj = new CrudMethods();

  Future<bool> addDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add data", style: TextStyle(fontSize: 15.0)),
            content: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: "Enter Student Name"),
                  onChanged: (value) {
                    this.studentName = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: "Enter Student NIM"),
                  onChanged: (value) {
                    this.studentNim = value;
                  },
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                  child: Text("Add"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Map<String, dynamic> studentData = {
                      "studentName": this.studentName,
                      "studentNim": this.studentNim
                    };
                    crudObj.addData(studentData).then((result) {
                      dialogTrigger(context);
                    }).catchError((e) {
                      print(e);
                    });
                  })
            ],
          );
        });
  }

  Future<bool> updateDialog(BuildContext context, selectedDoc) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Update data", style: TextStyle(fontSize: 15.0)),
            content: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: "Enter Student Name"),
                  onChanged: (value) {
                    this.studentName = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: "Enter Student NIM"),
                  onChanged: (value) {
                    this.studentNim = value;
                  },
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                  child: Text("Update"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Map<String, dynamic> studentData = {
                      "studentName": this.studentName,
                      "studentNim": this.studentNim
                    };
                    updateTrigger(context, selectedDoc, studentData);
                  })
            ],
          );
        });
  }

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success", style: TextStyle(fontSize: 15.0)),
            content: Text("New data successfully added"),
            actions: <Widget>[
              TextButton(
                  child: Text("Close"),
                  onPressed: () {
                    crudObj.getData().then((results) {
                      setState(() {
                        students = results;
                      });
                    });
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  Future<bool> updateTrigger(
      BuildContext context, selectedDoc, studentData) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success", style: TextStyle(fontSize: 15.0)),
            content: Text("New data successfully updated"),
            actions: <Widget>[
              TextButton(
                  child: Text("Close"),
                  onPressed: () {
                    crudObj.updateData(selectedDoc, studentData);
                    crudObj.getData().then((results) {
                      setState(() {
                        students = results;
                      });
                    });
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  Future<bool> deleteTrigger(BuildContext context, i) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Warning !!", style: TextStyle(fontSize: 15.0)),
            content: Text("Are you sure to delete this data ?"),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  TextButton(
                      child: Text("Yes"),
                      onPressed: () {
                        crudObj.deleteData(students.docs[i].id);
                        crudObj.getData().then((results) {
                          setState(() {
                            students = results;
                          });
                        });
                        Navigator.of(context).pop();
                      }),
                  TextButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              )
            ],
          );
        });
  }

  Future<bool> logoutTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Warning !!", style: TextStyle(fontSize: 15.0)),
            content: Text("Are you sure want to Log Out ?"),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  TextButton(
                      child: Text("Yes"),
                      onPressed: () {
                        FirebaseAuth.instance
                            .signOut()
                            .then(
                              (value) => Navigator.of(context)
                                  .pushReplacementNamed("/landingpage"),
                            )
                            .catchError((e) {
                          print(e);
                        });
                        Navigator.of(context).pop();
                      }),
                  TextButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              )
            ],
          );
        });
  }

  @override
  void initState() {
    crudObj.getData().then((results) {
      setState(() {
        students = results;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  addDialog(context);
                }),
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  logoutTrigger(context);
                }),
          ],
        ),
        body: _studentList());
  }

  Widget _studentList() {
    if (students != null) {
      return ListView.builder(
        itemCount: students.docs.length,
        padding: EdgeInsets.all(5.0),
        itemBuilder: (context, i) {
          return ListTile(
              title: Text(students.docs[i].data()['studentName']),
              subtitle: Text(students.docs[i].data()['studentNim']),
              onTap: () {
                updateDialog(context, students.docs[i].id);
              },
              onLongPress: () {
                deleteTrigger(context, i);
              });
        },
      );
    } else {
      return Text("Loading, Please wait..");
    }
  }
}
