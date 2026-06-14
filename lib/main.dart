import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List user_data = [];
String url = "https://10.0.2.2/";
void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeApp());
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  String emailPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  String rollno_pattern = r"^[0-9]{10}$";
  bool name_error = false;
  bool rollno_error = false;
  bool email_error = false;
  bool cgpa_error = false;
  bool email_invalid = false;
  bool rollno_invalid = false;
  String status = "";
  final TextEditingController name = TextEditingController();
  final TextEditingController roll_no = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController cgpa = TextEditingController();

  void openAlertDialog() {
    final snackBar = SnackBar(content: Text(status));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return;
  }

  Future<void> addEntry() async {
    String uri = "${url}register_student.php";

    setState(() {
      name_error = name.text.isEmpty;
      rollno_error = roll_no.text.isEmpty;
      email_error = email.text.isEmpty;
      cgpa_error = cgpa.text.isEmpty;
    });

    if (name_error || rollno_error || email_error || cgpa_error) {
      setState(() {
        status = "Please fill all required fields.";
      });
      openAlertDialog();
      return;
    }

    RegExp regex_email = RegExp(emailPattern);
    RegExp regex_roll = RegExp(rollno_pattern);

    if (!regex_email.hasMatch(email.text)) {
      setState(() {
        email_invalid = true;
        status = "Invalid Email";
      });
      openAlertDialog();
      return;
    } else if (!regex_roll.hasMatch(roll_no.text)) {
      setState(() {
        rollno_invalid = true;
        status = "Invalid Roll Number";
      });
      openAlertDialog();
      return;
    }

    try {
      setState(() {
        status = "Registering...";
      });
        openAlertDialog();
      var res = await http.post(
        Uri.parse(uri),
        body: {
          "name": name.text,
          "roll_no": roll_no.text,
          "email": email.text,
          "cgpa": cgpa.text,
        },
      );
      var response = jsonDecode(res.body);
      if (response["success"] == "true") {
        setState(() {
          status = "Registered.";
          name.clear();
          roll_no.clear();
          email.clear();
          cgpa.clear();
        });
        openAlertDialog();
      } else {
        if (response["exists"] == "true" && response["email"] == "true") {
          setState(() {
            status =
                "Error: Both roll number and email are already registered.";
          });
          openAlertDialog();
        } else if (response["exists"] == "true") {
          setState(() {
            status = "Error: Roll number already registered.";
          });
          openAlertDialog();
        } else if (response["email"] == "true") {
          setState(() {
            status = "Error: Email already registered.";
          });
          openAlertDialog();
        }
      }
    } catch (e) {
      setState(() {
        status = "There is an error: $e";
      });
        openAlertDialog();
    }
  }

  Future<void> get_details() async {
    try {
      setState(() {
        status = "Getting Details...";
      });
      openAlertDialog();
      String uri = "${url}retrieve_data.php";

      var res = await http.get(Uri.parse(uri));
      setState(() {
        user_data = jsonDecode(res.body);
      });
    } catch (e) {
      setState(() {
        status = "There is an error: $e";
      });
      openAlertDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: AlignmentGeometry.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 350,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Register a Student",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 360,
                    height: 600,
                    margin: EdgeInsets.only(top: 40),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Student Name",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          onChanged: (text) {
                            setState(() {
                              name_error = false;
                            });
                          },
                          controller: name,
                          keyboardType: TextInputType.name,
                          maxLength: 50,
                          decoration: InputDecoration(
                            helper: Row(
                              children: [
                                SizedBox(width: 30),
                                Text(
                                  name_error ? "Name is required" : "",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red[900],
                                  ),
                                ),
                              ],
                            ),
                            prefixIcon: Icon(Icons.person),
                            suffixIcon: name.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        name.clear();
                                      });
                                    },
                                    icon: Icon(Icons.close),
                                    iconSize: 25,
                                  )
                                : null,
                            hintText: "Enter your full name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),

                        Text(
                          "Roll Number",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          onChanged: (text) {
                            setState(() {
                              rollno_error = false;
                              rollno_invalid = false;
                            });
                          },
                          controller: roll_no,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          decoration: InputDecoration(
                            helper: Row(
                              children: [
                                SizedBox(width: 30),
                                Text(
                                  rollno_error
                                      ? "Roll number is required"
                                      : rollno_invalid
                                      ? "Invalid Roll Number"
                                      : "",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red[900],
                                  ),
                                ),
                              ],
                            ),
                            prefixIcon: Icon(Icons.badge),
                            hintText: "Enter roll number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),

                        Text(
                          "Email ID",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          onChanged: (text) {
                            setState(() {
                              email_error = false;
                              email_invalid = false;
                            });
                          },
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            helper: Row(
                              children: [
                                SizedBox(width: 30),
                                Text(
                                  email_error
                                      ? "Email is required"
                                      : email_invalid
                                      ? "Invalid Email"
                                      : "",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red[900],
                                  ),
                                ),
                              ],
                            ),
                            prefixIcon: Icon(Icons.mail),
                            suffixIcon: email.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        email.clear();
                                      });
                                    },
                                    icon: Icon(Icons.close),
                                    iconSize: 25,
                                  )
                                : null,
                            hintText: "Enter student email address",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),

                        Text(
                          "CGPA",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          onChanged: (text) {
                            setState(() {
                              cgpa_error = false;
                            });
                          },
                          controller: cgpa,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            helper: Row(
                              children: [
                                SizedBox(width: 30),
                                Text(
                                  cgpa_error ? "CGPA is required" : "",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red[900],
                                  ),
                                ),
                              ],
                            ),
                            prefixIcon: Icon(Icons.bookmark),
                            hintText: "Enter current CGPA",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            addEntry();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: const Size(double.infinity, 55),
                            elevation: 15,
                            shadowColor: Colors.blue.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'SUBMIT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      await get_details();
                      if (user_data.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecordsScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 5,
                      maximumSize: Size(170, 50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "View Records",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.remove_red_eye, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_sharp),
        ),
      ),
      body: user_data.isEmpty
          ? Container(
              margin: EdgeInsets.all(10),
              child: Text("No records found."),
            )
          : Expanded(
              child: ListView.builder(
                itemCount: user_data.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(5),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text("Name: "),
                              Text(user_data[index]["student_name"]),
                            ],
                          ),

                          Row(
                            children: [
                              Text("Roll Number: "),
                              Text(user_data[index]["roll_no"]),
                            ],
                          ),

                          Row(
                            children: [
                              Text("Email: "),
                              Text(user_data[index]["student_email"]),
                            ],
                          ),

                          Row(
                            children: [
                              Text("CGPA: "),
                              Text(user_data[index]["student_cgpa"]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}