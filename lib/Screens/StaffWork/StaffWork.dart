import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confidence/Screens/StaffWork/AllWorkFile.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:input_quantity/input_quantity.dart';
import 'package:uuid/uuid.dart';

class StaffWork extends StatefulWidget {
  final String FileID;
  final String TotalStudent;
  final String Incomplete;
  StaffWork(
      {super.key,
      required this.FileID,
      required this.TotalStudent,
      required this.Incomplete});

  @override
  _StaffWorkState createState() => _StaffWorkState();
}

class _StaffWorkState extends State<StaffWork> {
  int _selectedDestination = 0;

  bool DataLoad = false;

  var uuid = Uuid();

  TextEditingController SearchByStudentIDController = TextEditingController();
  TextEditingController StudentNameController = TextEditingController();
  TextEditingController StudentPhoneNoController = TextEditingController();
  TextEditingController StudentFatherPhoneNoController =
      TextEditingController();
  TextEditingController AddressController = TextEditingController();

  final List<TextEditingController> CommentController = [];

  createControllers() {
    for (var i = 0; i < AllStudentInfo.length; i++) {
      CommentController.add(TextEditingController());
    }
  }

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

// var ProductID = "";

  List AllStudentInfo = [];

  Future<void> getAllStudentInfo() async {
    CollectionReference _collectionStudentInfoRef =
        FirebaseFirestore.instance.collection('PhoneCallStudentList');

    Query StudentInfoquery =
        _collectionStudentInfoRef.where("FileID", isEqualTo: widget.FileID);

    QuerySnapshot StudentInfoquerySnapshot = await StudentInfoquery.get();
    AllStudentInfo =
        StudentInfoquerySnapshot.docs.map((doc) => doc.data()).toList();

    if (AllStudentInfo.isEmpty) {
      DataLoad = false;
    } else {
      setState(() {
        AllStudentInfo = [];
        AllStudentInfo =
            StudentInfoquerySnapshot.docs.map((doc) => doc.data()).toList();

        CommentController.clear();
        createControllers();
      });
      DataLoad = true;
    }

    // print(AllData);
  }

  List FileHeaderInfo = [];

  Future<void> getFileHeaderInfo() async {
    CollectionReference _collectionFileInfoRef =
        FirebaseFirestore.instance.collection('StaffWorkHeader');

    Query FileInfoquery =
        _collectionFileInfoRef.where("FileID", isEqualTo: widget.FileID);

    QuerySnapshot FileInfoquerySnapshot = await FileInfoquery.get();

    FileHeaderInfo =
        FileInfoquerySnapshot.docs.map((doc) => doc.data()).toList();

    if (FileHeaderInfo.isEmpty) {
      setState(() {
        DataLoad = false;
      });
    } else {
      setState(() {
        FileHeaderInfo = [];
        FileHeaderInfo =
            FileInfoquerySnapshot.docs.map((doc) => doc.data()).toList();
        CommentController.clear();
        createControllers();

        DataLoad = true;
      });
    }

    // print(AllData);
  }

  @override
  void initState() {
    // FlutterNativeSplash.remove();

    getAllStudentInfo();

    getFileHeaderInfo();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    var ProductUniqueID = uuid.v4();

    return Row(
      children: [
        Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[],
          ),
        ),
        VerticalDivider(
          width: 1,
          thickness: 1,
        ),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              actions: [
                PopupMenuButton(
                  onSelected: (value) {
                    // your logic
                  },
                  itemBuilder: (BuildContext bc) {
                    return [
                      PopupMenuItem(
                        child: Text("Add Student Info"),
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              String SelectedStudentStatus = "";
                              String Title =
                                  "Student এর Information যুক্ত করুন";

                              bool loading = false;

                              // String LabelText ="আয়ের খাত লিখবেন";

                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            Title,
                                            style: const TextStyle(
                                                fontFamily: "Josefin Sans",
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: loading
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  width: 300,
                                                  child: TextField(
                                                    onChanged: (value) {},
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: 'Student Name',

                                                      hintText: 'Student Name',

                                                      //  enabledBorder: OutlineInputBorder(
                                                      //       borderSide: BorderSide(width: 3, color: Colors.greenAccent),
                                                      //     ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 3,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                      errorBorder:
                                                          const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 3,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    66,
                                                                    125,
                                                                    145)),
                                                      ),
                                                    ),
                                                    controller:
                                                        StudentNameController,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  width: 300,
                                                  child: TextField(
                                                    onChanged: (value) {},
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          'Student Phone No',

                                                      hintText:
                                                          'Student Phone No',

                                                      //  enabledBorder: OutlineInputBorder(
                                                      //       borderSide: BorderSide(width: 3, color: Colors.greenAccent),
                                                      //     ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 3,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                      errorBorder:
                                                          const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 3,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    66,
                                                                    125,
                                                                    145)),
                                                      ),
                                                    ),
                                                    controller:
                                                        StudentPhoneNoController,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  width: 300,
                                                  child: TextField(
                                                    onChanged: (value) {},
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          'Student Father phone no',

                                                      hintText:
                                                          'Student Father phone no',

                                                      //  enabledBorder: OutlineInputBorder(
                                                      //       borderSide: BorderSide(width: 3, color: Colors.greenAccent),
                                                      //     ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 3,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                      errorBorder:
                                                          const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 3,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    66,
                                                                    125,
                                                                    145)),
                                                      ),
                                                    ),
                                                    controller:
                                                        StudentFatherPhoneNoController,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  width: 300,
                                                  child: TextField(
                                                    onChanged: (value) {},
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: 'Address',

                                                      hintText: 'Address',

                                                      //  enabledBorder: OutlineInputBorder(
                                                      //       borderSide: BorderSide(width: 3, color: Colors.greenAccent),
                                                      //     ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 3,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                      errorBorder:
                                                          const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 3,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    66,
                                                                    125,
                                                                    145)),
                                                      ),
                                                    ),
                                                    controller:
                                                        AddressController,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            loading = true;
                                          });

                                          var PerStudentHistory = {
                                            "FileID": widget.FileID,
                                            "status": "incomplete",
                                            "Comment": [],
                                            "SID": ProductUniqueID.toString(),
                                            "StudentName": StudentNameController
                                                .text
                                                .trim(),
                                            "StudentPhoneNo":
                                                StudentPhoneNoController.text
                                                    .trim(),
                                            "StudentFatherPhoneNo":
                                                StudentFatherPhoneNoController
                                                    .text
                                                    .trim(),
                                            "Address":
                                                AddressController.text.trim(),
                                            "LastCallingDate": "None",
                                            "Dream": "None",
                                            "CallCount": "0",
                                          };

                                          final docUser = FirebaseFirestore
                                              .instance
                                              .collection(
                                                  "PhoneCallStudentList")
                                              .doc(ProductUniqueID);

                                          docUser
                                              .set(PerStudentHistory)
                                              .then((value) => setState(() {
                                                    getAllStudentInfo();

                                                    setState(() {
                                                      loading = false;
                                                    });

                                                    Navigator.pop(context);

                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //       builder: (context) => CustomerProfile(
                                                    //           CustomerID: widget.CustomerID)),
                                                    // );
                                                  }))
                                              .onError((error, stackTrace) =>
                                                  setState(() {
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                  }));
                                        },
                                        child: const Text("Save"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                      PopupMenuItem(
                        child: Text("Go to All Work"),
                        value: '/about',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AllWorkFile()));
                        },
                      ),
                      // PopupMenuItem(
                      //   child: Text("Contact"),
                      //   value: '/contact',
                      // )
                    ];
                  },
                )
              ],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Phone Call Work    S/C: ${FileHeaderInfo[0]["SchoolOrCollegeName"]}    RC:${FileHeaderInfo[0]["RecentClass"]}     D:${FileHeaderInfo[0]["Department"]}  LW: ${FileHeaderInfo[0]["LastWork"]}  IC: ${FileHeaderInfo[0]["Incomplete"]}/${FileHeaderInfo[0]["TotalStudent"]}",
                  ),
                ],
              ),
            ),
            body: !DataLoad
                ? const SingleChildScrollView(
                    child: Center(
                      child: Text("No Data Available"),
                    ),
                  )
                : GridView.count(
                    crossAxisCount: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    padding: EdgeInsets.all(20),
                    childAspectRatio: 3 / 2,
                    children: [
                      Card(
                        surfaceTintColor: Colors.white,
                        elevation: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: DataTable2(
                              headingTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              columnSpacing: 12,
                              headingRowColor:
                                  const WidgetStatePropertyAll(Colors.pink),
                              horizontalMargin: 12,
                              minWidth: 2600,
                              dividerThickness: 3,
                              columns: const [
                                DataColumn2(
                                  label: Text('SL'),
                                  size: ColumnSize.L,
                                ),
                                DataColumn(
                                  label: Text('SID'),
                                ),
                                DataColumn(
                                  label: Text('Student Name'),
                                ),
                                DataColumn(
                                  label: Text('Phone No'),
                                ),
                                DataColumn(
                                  label: Text('Father Phone No'),
                                ),
                                DataColumn(
                                  label: Text('Status'),
                                ),
                                DataColumn(
                                  label: Text('Dream'),
                                ),
                                DataColumn(
                                  label: Text('Last Call'),
                                ),
                                DataColumn(
                                  label: Text('Count'),
                                ),
                                DataColumn(
                                  label: Text('Add Comment'),
                                ),
                              ],
                              rows: List<DataRow>.generate(
                                  AllStudentInfo.length,
                                  (index) => DataRow(cells: [
                                        DataCell(Text('${index + 1}')),
                                        DataCell(Text(AllStudentInfo[index]
                                                ["SID"]
                                            .toString()
                                            .toUpperCase())),
                                        DataCell(Text(AllStudentInfo[index]
                                                ["StudentName"]
                                            .toString()
                                            .toUpperCase())),
                                        DataCell(Text(AllStudentInfo[index]
                                                ["StudentPhoneNo"]
                                            .toString()
                                            .toUpperCase())),
                                        DataCell(Text(AllStudentInfo[index]
                                                ["StudentFatherPhoneNo"]
                                            .toString()
                                            .toUpperCase())),
                                        DataCell(Text(AllStudentInfo[index]
                                                ["status"]
                                            .toString()
                                            .toUpperCase())),
                                        DataCell(Row(
                                          children: [
                                            Text(AllStudentInfo[index]["Dream"]
                                                .toString()
                                                .toUpperCase()),
                                            ElevatedButton.icon(
                                                onPressed: () async {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      String
                                                          SelectedStudentStatus =
                                                          "";
                                                      String Title =
                                                          "Student এর Aim যুক্ত করুন";

                                                      final List<String>
                                                          Student_Aim = [
                                                        'BUET',
                                                        'University',
                                                        'Medical',
                                                        'Nursing',
                                                      ];
                                                      String?
                                                          selectedStudent_Aim_Value;

                                                      bool loading = false;

                                                      // String LabelText ="আয়ের খাত লিখবেন";

                                                      return StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                          return AlertDialog(
                                                            title: Column(
                                                              children: [
                                                                Center(
                                                                  child: Text(
                                                                    Title,
                                                                    style: const TextStyle(
                                                                        fontFamily:
                                                                            "Josefin Sans",
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            content: loading
                                                                ? const Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  )
                                                                : SingleChildScrollView(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Card(
                                                                          elevation:
                                                                              20,
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                200,
                                                                            child:
                                                                                DropdownButtonHideUnderline(
                                                                              child: DropdownButton2<String>(
                                                                                isExpanded: true,
                                                                                hint: Text(
                                                                                  'Select Student Aim',
                                                                                  style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    color: Theme.of(context).hintColor,
                                                                                  ),
                                                                                ),
                                                                                items: Student_Aim.map((String item) => DropdownMenuItem<String>(
                                                                                      value: item,
                                                                                      child: Text(
                                                                                        item,
                                                                                        style: const TextStyle(
                                                                                          fontSize: 14,
                                                                                        ),
                                                                                      ),
                                                                                    )).toList(),
                                                                                value: selectedStudent_Aim_Value,
                                                                                onChanged: (String? value) {
                                                                                  setState(() async {
                                                                                    selectedStudent_Aim_Value = value;

                                                                                    setState(() {
                                                                                      loading = true;
                                                                                    });

                                                                                    var ChangeStudentDream = {
                                                                                      "Dream": selectedStudent_Aim_Value
                                                                                    };

                                                                                    final docUser = FirebaseFirestore.instance.collection("PhoneCallStudentList").doc(AllStudentInfo[index]["SID"]);

                                                                                    docUser
                                                                                        .update(ChangeStudentDream)
                                                                                        .then((value) => setState(() {
                                                                                              setState(() {
                                                                                                loading = false;
                                                                                              });

                                                                                              getAllStudentInfo();

                                                                                              Navigator.pop(context);

                                                                                              const snackBar = SnackBar(
                                                                                                /// need to set following properties for best effect of awesome_snackbar_content
                                                                                                elevation: 0,

                                                                                                behavior: SnackBarBehavior.floating,
                                                                                                backgroundColor: Colors.transparent,
                                                                                                content: AwesomeSnackbarContent(
                                                                                                  title: 'Dream update Successfull',
                                                                                                  message: 'Dream update Successfull',

                                                                                                  /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                                                                  contentType: ContentType.success,
                                                                                                ),
                                                                                              );

                                                                                              ScaffoldMessenger.of(context)
                                                                                                ..hideCurrentSnackBar()
                                                                                                ..showSnackBar(snackBar);

                                                                                              // Navigator.push(
                                                                                              //   context,
                                                                                              //   MaterialPageRoute(
                                                                                              //       builder: (context) => CustomerProfile(
                                                                                              //           CustomerID: widget.CustomerID)),
                                                                                              // );
                                                                                            }))
                                                                                        .onError((error, stackTrace) => setState(() {
                                                                                              setState(() {
                                                                                                loading = false;
                                                                                              });

                                                                                              const snackBar = SnackBar(
                                                                                                /// need to set following properties for best effect of awesome_snackbar_content
                                                                                                elevation: 0,

                                                                                                behavior: SnackBarBehavior.floating,
                                                                                                backgroundColor: Colors.transparent,
                                                                                                content: AwesomeSnackbarContent(
                                                                                                  title: 'Something Wrong!!!',
                                                                                                  message: 'Something Wrong!!!',

                                                                                                  /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                                                                  contentType: ContentType.failure,
                                                                                                ),
                                                                                              );

                                                                                              ScaffoldMessenger.of(context)
                                                                                                ..hideCurrentSnackBar()
                                                                                                ..showSnackBar(snackBar);
                                                                                            }));
                                                                                  });
                                                                                },
                                                                                buttonStyleData: const ButtonStyleData(
                                                                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                                                                  height: 40,
                                                                                  width: 140,
                                                                                ),
                                                                                menuItemStyleData: const MenuItemStyleData(
                                                                                  height: 40,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child: const Text(
                                                                    "Cancel"),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  setState(() {
                                                                    loading =
                                                                        true;
                                                                  });

                                                                  var ChangeStudentDream =
                                                                      {
                                                                    "Dream":
                                                                        selectedStudent_Aim_Value
                                                                  };

                                                                  final docUser = FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "PhoneCallStudentList")
                                                                      .doc(AllStudentInfo[
                                                                              index]
                                                                          [
                                                                          "SID"]);

                                                                  docUser
                                                                      .update(
                                                                          ChangeStudentDream)
                                                                      .then((value) =>
                                                                          setState(
                                                                              () {
                                                                            setState(() {
                                                                              loading = false;
                                                                            });

                                                                            getAllStudentInfo();

                                                                            Navigator.pop(context);

                                                                            const snackBar =
                                                                                SnackBar(
                                                                              /// need to set following properties for best effect of awesome_snackbar_content
                                                                              elevation: 0,

                                                                              behavior: SnackBarBehavior.floating,
                                                                              backgroundColor: Colors.transparent,
                                                                              content: AwesomeSnackbarContent(
                                                                                title: 'Dream update Successfull',
                                                                                message: 'Dream update Successfull',

                                                                                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                                                contentType: ContentType.success,
                                                                              ),
                                                                            );

                                                                            ScaffoldMessenger.of(context)
                                                                              ..hideCurrentSnackBar()
                                                                              ..showSnackBar(snackBar);

                                                                            // Navigator.push(
                                                                            //   context,
                                                                            //   MaterialPageRoute(
                                                                            //       builder: (context) => CustomerProfile(
                                                                            //           CustomerID: widget.CustomerID)),
                                                                            // );
                                                                          }))
                                                                      .onError((error,
                                                                              stackTrace) =>
                                                                          setState(
                                                                              () {
                                                                            setState(() {
                                                                              loading = false;
                                                                            });

                                                                            const snackBar =
                                                                                SnackBar(
                                                                              /// need to set following properties for best effect of awesome_snackbar_content
                                                                              elevation: 0,

                                                                              behavior: SnackBarBehavior.floating,
                                                                              backgroundColor: Colors.transparent,
                                                                              content: AwesomeSnackbarContent(
                                                                                title: 'Something Wrong!!!',
                                                                                message: 'Something Wrong!!!',

                                                                                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                                                contentType: ContentType.failure,
                                                                              ),
                                                                            );

                                                                            ScaffoldMessenger.of(context)
                                                                              ..hideCurrentSnackBar()
                                                                              ..showSnackBar(snackBar);
                                                                          }));
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "Save"),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                                label: Icon(Icons.edit))
                                          ],
                                        )),
                                        DataCell(Text(AllStudentInfo[index]
                                                ["LastCallingDate"]
                                            .toString()
                                            .toUpperCase())),
                                        DataCell(Text(AllStudentInfo[index]
                                                ["CallCount"]
                                            .toString()
                                            .toUpperCase())),
                                        DataCell(ElevatedButton(
                                            onPressed: () async {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  String SelectedStudentStatus =
                                                      "";
                                                  String Title =
                                                      "ফোন কলের কথা গুলো shortly যুক্ত করুন।";

                                                  bool loading = false;

                                                  List PerStudentComment =
                                                      AllStudentInfo[index]
                                                          ["Comment"];

                                                  // String LabelText ="আয়ের খাত লিখবেন";

                                                  return StatefulBuilder(
                                                    builder:
                                                        (context, setState) {
                                                      return AlertDialog(
                                                        title: Column(
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                "${Title}",
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        "Josefin Sans",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        content: loading
                                                            ? const Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              )
                                                            : SingleChildScrollView(
                                                                child: Column(
                                                                  children: [
                                                                    for (int i =
                                                                            0;
                                                                        i < PerStudentComment.length;
                                                                        i++)
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          "${i + 1}. ${PerStudentComment[i].toString()}",
                                                                          style: const TextStyle(
                                                                              fontFamily: "Josefin Sans",
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    const SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          300,
                                                                      child:
                                                                          TextField(
                                                                        maxLines:
                                                                            10,
                                                                        onChanged:
                                                                            (value) {},
                                                                        keyboardType:
                                                                            TextInputType.multiline,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                          labelText:
                                                                              'Comment',

                                                                          hintText:
                                                                              'Comment',

                                                                          //  enabledBorder: OutlineInputBorder(
                                                                          //       borderSide: BorderSide(width: 3, color: Colors.greenAccent),
                                                                          //     ),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(width: 3, color: Theme.of(context).primaryColor),
                                                                          ),
                                                                          errorBorder:
                                                                              const OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(width: 3, color: Color.fromARGB(255, 66, 125, 145)),
                                                                          ),
                                                                        ),
                                                                        controller:
                                                                            CommentController[index],
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: const Text(
                                                                "Cancel"),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                loading = true;
                                                              });

                                                              List
                                                                  PerStudentComments =
                                                                  [];

                                                              PerStudentComments =
                                                                  AllStudentInfo[
                                                                          index]
                                                                      [
                                                                      "Comment"];

                                                              PerStudentComments.add(
                                                                  CommentController[
                                                                      index].text.trim());

                                                              var perStudentInfoWithComment =
                                                                  {
                                                                "Comment":
                                                                    PerStudentComments,
                                                                "CallCount":
                                                                    ((int.parse(AllStudentInfo[index]["CallCount"])) +
                                                                            1)
                                                                        .toString(),
                                                                "status":
                                                                    "Call-${((int.parse(AllStudentInfo[index]["CallCount"])) + 1).toString()}",
                                                                "LastCallingDate":
                                                                    DateTime.now()
                                                                        .toIso8601String(),
                                                              };

                                                              print(
                                                                  perStudentInfoWithComment);

                                                              // var id = getRandomString(7);

                                                              final StudentInfo = FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'PhoneCallStudentList')
                                                                  .doc(AllStudentInfo[
                                                                          index]
                                                                      ["SID"]);

                                                              StudentInfo.update(
                                                                      perStudentInfoWithComment)
                                                                  .then((value) =>
                                                                      setState(
                                                                          () async {
                                                                        var UpdateCallingHeader =
                                                                            {
                                                                          "LastWork":
                                                                              DateTime.now().toIso8601String(),
                                                                          "Incomplete": AllStudentInfo[index]["status"] == "incomplete"
                                                                              ? (int.parse(widget.TotalStudent) - 1).toString()
                                                                              : widget.Incomplete,
                                                                        };

                                                                        // var id = getRandomString(7);

                                                                        final UpdateHeaderInfo = FirebaseFirestore
                                                                            .instance
                                                                            .collection('StaffWorkHeader')
                                                                            .doc(widget.FileID);

                                                                        getFileHeaderInfo();
                                                                        getAllStudentInfo();

                                                                        UpdateHeaderInfo.update(
                                                                                UpdateCallingHeader)
                                                                            .then((value) =>
                                                                                setState(() async {
                                                                                  // Navigator.pop(context);

                                                                                  const snackBar = SnackBar(
                                                                                    elevation: 0,
                                                                                    behavior: SnackBarBehavior.floating,
                                                                                    backgroundColor: Colors.transparent,
                                                                                    content: AwesomeSnackbarContent(
                                                                                      title: 'successfull',
                                                                                      message: 'Hey Thank You. Good Job',

                                                                                      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                                                      contentType: ContentType.success,
                                                                                    ),
                                                                                  );

                                                                                  ScaffoldMessenger.of(context)
                                                                                    ..hideCurrentSnackBar()
                                                                                    ..showSnackBar(snackBar);

                                                                                  setState(() {
                                                                                    loading = false;
                                                                                  });
                                                                                }))
                                                                            .onError((error, stackTrace) => setState(() {
                                                                                  const snackBar = SnackBar(
                                                                                    /// need to set following properties for best effect of awesome_snackbar_content
                                                                                    elevation: 0,

                                                                                    behavior: SnackBarBehavior.floating,
                                                                                    backgroundColor: Colors.transparent,
                                                                                    content: AwesomeSnackbarContent(
                                                                                      title: 'Something Wrong!!!!',
                                                                                      message: 'Try again later...',

                                                                                      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                                                      contentType: ContentType.failure,
                                                                                    ),
                                                                                  );

                                                                                  ScaffoldMessenger.of(context)
                                                                                    ..hideCurrentSnackBar()
                                                                                    ..showSnackBar(snackBar);

                                                                                  setState(() {
                                                                                    loading = false;
                                                                                  });
                                                                                }));

                                                                        // Navigator.pop(context);

                                                                        const snackBar =
                                                                            SnackBar(
                                                                          elevation:
                                                                              0,
                                                                          behavior:
                                                                              SnackBarBehavior.floating,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          content:
                                                                              AwesomeSnackbarContent(
                                                                            title:
                                                                                'successfull',
                                                                            message:
                                                                                'Hey Thank You. Good Job',

                                                                            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                                            contentType:
                                                                                ContentType.success,
                                                                          ),
                                                                        );

                                                                        ScaffoldMessenger.of(
                                                                            context)
                                                                          ..hideCurrentSnackBar()
                                                                          ..showSnackBar(
                                                                              snackBar);

                                                                        setState(
                                                                            () {
                                                                          loading =
                                                                              false;
                                                                        });
                                                                      }))
                                                                  .onError((error,
                                                                          stackTrace) =>
                                                                      setState(
                                                                          () {
                                                                        const snackBar =
                                                                            SnackBar(
                                                                          /// need to set following properties for best effect of awesome_snackbar_content
                                                                          elevation:
                                                                              0,

                                                                          behavior:
                                                                              SnackBarBehavior.floating,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          content:
                                                                              AwesomeSnackbarContent(
                                                                            title:
                                                                                'Something Wrong!!!!',
                                                                            message:
                                                                                'Try again later...',

                                                                            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                                            contentType:
                                                                                ContentType.failure,
                                                                          ),
                                                                        );

                                                                        ScaffoldMessenger.of(
                                                                            context)
                                                                          ..hideCurrentSnackBar()
                                                                          ..showSnackBar(
                                                                              snackBar);

                                                                        setState(
                                                                            () {
                                                                          loading =
                                                                              false;
                                                                        });
                                                                      }));
                                                            },
                                                            child: const Text(
                                                                "Save"),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            child: Text("Add Comment"))),
                                      ]))),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  // void selectDestination(int index) {
  //   setState(() {
  //     _selectedDestination = index;
  //   });
  // }
}
