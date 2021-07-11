import 'package:flutter/material.dart';
import 'package:crudoperation/conn.dart';
import 'package:crudoperation/model.dart';

class Home extends StatefulWidget {
  @override
  homePageState createState() => homePageState();
}

class homePageState extends State<Home> {
  final name = TextEditingController();
  final course = TextEditingController();
  Future<List<Student>> students;
  var dbHelper;
  List data = [];
  int id;
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshList();
    id = null;
  }

  refreshList() {
    setState(() {
      students = dbHelper.getStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // The title text which will be shown on the action bar
        title: Text("CRUD Opration"),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: 200,
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                          fillColor: Colors.black26,
                          filled: true,
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          )),
                      style: TextStyle(color: Colors.white),
                    ),
                    TextFormField(
                        controller: course,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            fillColor: Colors.black26,
                            filled: true,
                            hintText: 'Course',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ))),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              data = [
                                {'name': name.text, 'course': course.text}
                              ];
                              print("create");
                              print(data);
                              //Student e = Student(898, name.text, course.text);
                              //dbHelper.insert(e);
                              Student e = Student(
                                  id: null,
                                  name: name.text,
                                  course: course.text);
                              dbHelper.save(e);
                              refreshList();
                            },
                            child: Row(
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 25),
                                Text('Create',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ))
                              ],
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.orange,
                            ),
                            onPressed: () {
                              Student e = Student(
                                  id: this.id,
                                  name: name.text,
                                  course: course.text);
                              dbHelper.update(e);
                              refreshList();
                            },
                            child: Row(
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 25),
                                Text('Update',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ))
                              ],
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 25, right: 210),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Name"), Text("course")],
                )),
            Container(
              height: 900,
              child: FutureBuilder(
                builder: (context, snapshot) {
                  // WHILE THE CALL IS BEING MADE AKA LOADING
                  if (ConnectionState.active != null && !snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // WHEN THE CALL IS DONE BUT HAPPENS TO HAVE AN ERROR
                  if (ConnectionState.done != null && snapshot.hasError) {
                    return Center(child: Text(snapshot.error));
                  }

                  // IF IT WORKS IT GOES HERE!
                  return ListView.separated(
                    physics: ScrollPhysics(),
                    padding: EdgeInsets.all(10),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(right: 80),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(snapshot.data[index].getName()),
                                Text(snapshot.data[index].getCourse())
                              ],
                            ),
                          ),
                          trailing: Wrap(
                            spacing: 2,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Color(0xffbF7B801),
                                  size: 25,
                                ),
                                onPressed: () {
                                  name.text = snapshot.data[index].getName();
                                  course.text =
                                      snapshot.data[index].getCourse();
                                  id = snapshot.data[index].getId();
                                  print("id ${id}");
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 25,
                                ),
                                onPressed: () {
                                  id = snapshot.data[index].getId();
                                  dbHelper.delete(id);
                                  print("id ${id}");
                                  id = null;
                                  refreshList();
                                },
                              ),
                            ],
                          ));
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        indent: 20,
                        endIndent: 20,
                      );
                    },
                  );
                },
                future: students,
              ),
            )
          ],
        ),
      ),
    );
  }
}
