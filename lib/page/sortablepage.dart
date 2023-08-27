import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sub_mgmt/page/addnewpage.dart';
import 'package:sub_mgmt/page/model/user.dart' as U;
import 'package:sub_mgmt/widget/navigation_drawer.dart';

import '../globals.dart';
import '../login/model/user_model.dart';
import 'editpage.dart';

class MemberList extends StatefulWidget {
  const MemberList({Key? key}) : super(key: key);

  @override
  State<MemberList> createState() => MemberListState();
}

class MemberListState extends State<MemberList> {
  static int counter = 1;

  // HERE
  // Reading data from firebase
  // CollectionReference _referenceMembers =
  //     FirebaseFirestore.instance.collection('users');
  late final CollectionReference _referenceMembers =
      FirebaseFirestore.instance.collection('${currentUser?.uid}');
  late Stream<QuerySnapshot> _streamMembers;
  List<int> selectedIndex = [];
  List<String> selectedDocID = [];

  final searchController = TextEditingController();

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _streamMembers = _referenceMembers.snapshots();
  }

  // For sorting columns
  int? sortColumnIndex;
  bool isAscending = true;

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 8,
          toolbarHeight: 70,
          title: Text(
            "member".tr,
            style: TextStyle(
                fontFamily: GoogleFonts.rubik().fontFamily
              // fontWeight: FontWeight.bold
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                gradient: LinearGradient(
                    colors: const [Color.fromARGB(170,25, 55, 109), Color.fromARGB(170,25, 55, 109)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter)
            ),
          )
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search,color: Color.fromARGB(170,25, 55, 109),),
                  hintText: 'Search_the_name'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color.fromARGB(170,25, 55, 109)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                }),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: _streamMembers,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  if (snapshot.connectionState == ConnectionState.active) {
                    QuerySnapshot querySnapshot = snapshot.data;
                    List<QueryDocumentSnapshot> listQueryDocumentSnapshot = querySnapshot.docs;
                    listQueryDocumentSnapshot = listQueryDocumentSnapshot.where((docSnapshot) => docSnapshot['Name'].toLowerCase().contains(searchQuery.toLowerCase())).toList();
                    counter = 0;
                    return ScrollableWidget(
                      child: Column(
                        children: [
                          DataTable(
                            columns: [
                              DataColumn(
                                label: Text(
                                  'Sr',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'name'.tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'phone'.tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Plan'.tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'fee'.tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Registration'.tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onSort: onSort
                              ),
                              DataColumn(
                                label: Text(
                                  'Expiry'.tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onSort: onSort,
                              ),
                              DataColumn(
                                label: Text(
                                  '',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: listQueryDocumentSnapshot
                                .map(
                                  (element) => DataRow(
                                    selected: selectedDocID.contains(element.id),
                                    onSelectChanged: (isSelected) =>
                                        setState(() {
                                      final isAdding =
                                          isSelected != null && isSelected;

                                      if (isAdding) {
                                        selectedDocID.add(element.id);
                                      } else {
                                        selectedDocID.remove(element.id);
                                      }
                                    }),
                                    cells: <DataCell>[
                                      DataCell(Text((++counter).toString())),
                                      DataCell(Text(element['Name'])),
                                      DataCell(
                                          Text(element['Phone'].toString())),
                                      DataCell(
                                          Text(element['Plan'].toString())),
                                      DataCell(
                                          Text(element['Fee Paid'].toString())),
                                      DataCell(Text(
                                          toDMY(element['Registration Date']))),
                                      DataCell(
                                          Text(toDMY(element['Expiry Date']))),
                                      DataCell(
                                        IconButton(
                                          splashRadius: 22,
                                          color: Colors.black38,
                                          icon: Icon(Icons.edit,color: Colors.green,),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditPage(
                                                    element.id,
                                                    element['Name'],
                                                    element['Phone'],
                                                    element['Plan'],
                                                    element['Fee Paid'],
                                                    element[
                                                        'Registration Date'],
                                                  element['Expiry Date'],
                                                  element['Image']
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                                .toList(),
                            columnSpacing: 32,
                            sortColumnIndex: sortColumnIndex,
                            sortAscending: isAscending,
                          ),
                          SizedBox(height: 80),
                        ],
                      ),
                    );
                  }

                  return Center(child: CircularProgressIndicator());
                }),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FloatingActionButton(
                onPressed: () {
                  if (selectedDocID.isNotEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Delete"),
                            content: Text("Delete Data?"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("No")),
                              TextButton(
                                  onPressed: () {
                                    for (var i in selectedDocID) {
                                      // HERE
                                      final docUser = FirebaseFirestore.instance
                                          .collection('${currentUser?.uid}')
                                          .doc(i);
                                      docUser.delete();
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Yes"))
                            ],
                          );
                        });
                  }
                },
                tooltip: 'Delete',
                elevation: 4.0,
                backgroundColor: Colors.grey[50],
                child: Icon(Icons.delete,color: Colors.red,),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddNewPage()));
              },
              tooltip: 'Add',
              elevation: 4.0,
              backgroundColor: Colors.grey[50],
              child: Transform.scale(
                scale: 1.25,
                  child: Icon(Icons.add,
                      color: Color.fromARGB(255,25, 55, 109))),
            )
          ],
        ),
      ),
    );
  }

  // Method to convert 'yyyy-MM-dd' to 'dd-MM-yyyy' format
  String toDMY(String date) {
    return DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
  }

  void onSort(int columnIndex, bool ascending) async {
    if(columnIndex == 5){
      _streamMembers = _referenceMembers.orderBy('Registration Date', descending: ascending).snapshots();
    }
    if(columnIndex == 6) {
      _streamMembers = _referenceMembers.orderBy('Expiry Date', descending: ascending).snapshots();
    }
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2){
    return value1.compareTo(value2);
  }
}

class ScrollableWidget extends StatelessWidget {
  final Widget child;
  const ScrollableWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: child,
      ),
    );
  }
}
