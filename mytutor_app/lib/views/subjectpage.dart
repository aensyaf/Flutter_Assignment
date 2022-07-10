import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor_app/views/cartscreen.dart';
import 'package:mytutor_app/views/loginscreen.dart';
import 'package:mytutor_app/views/registerscreen.dart';
import '../constants.dart';
import '../models/user.dart';
import '../models/subject.dart';

class SubjectPage extends StatefulWidget {
  final User user;
  const SubjectPage({Key? key,
    required this.user,}) : super(key: key);

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<Subject>? subjectList = <Subject>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;
  int cart = 0;
  TextEditingController searchController = TextEditingController();
  String search = "";
  @override
  void initState() {
    super.initState();
    _loadSubjects(1, search, "All");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SUBJECT',
          style: TextStyle(
            color: Color.fromARGB(255,155,36,36),
            fontWeight: FontWeight.bold,
            )
        ),
        centerTitle: true,
        backgroundColor:Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          ),
          TextButton.icon(
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => CartScreen(
                            user: widget.user,
                          )));
              _loadSubjects(1, search, "All");
              _loadMyCart();
            },
            
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            label: Text(widget.user.cart.toString(),
                style: const TextStyle(color: Colors.white)),
          ),

          
        ],
      ),
      body: subjectList!.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: 
                    Text("AVAILABLE SUBJECTS",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                      ),
                    ),
                ),
                const SizedBox(height: 15),
                Expanded(
                    child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: (1 / 1.19),
                      children: List.generate(subjectList!.length, (index) {
                        return Card(
                          child: Column(
                          children: [
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANTS.server +
                                      "/mytutor_app/assets/images/courses/" +
                                      subjectList![index].subjectId.toString() +
                                      '.jpg',
                                  fit: BoxFit.cover,
                                  width: resWidth,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Flexible(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        subjectList![index].subjectName.toString().toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                          )
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "PRICE: RM " + double.parse(
                                        subjectList![index].subjectPrice.toString()).toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                      
                                      Text(
                                        "SESSIONS: "+subjectList![index].subjectSessions.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
                                        )
                                      ),
                                      Text(
                                        "RATING: " +double.parse(subjectList![index].subjectRating.toString()).toStringAsFixed(2) +"/5",
                                        style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                        )
                                      ),

                                      Expanded(
                                              flex: 3,
                                              child: IconButton(
                                                  onPressed: () {
                                                    _addtocartDialog(index);
                                                  },
                                                  icon: const Icon(
                                                      Icons.shopping_cart))),
                                    ],
                                  ),
                                ),
                              )
                            
                          ],
                        ));
                      }
                    )
                  )
                ),
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if ((curpage - 1) == index) {
                        color =Color.fromARGB(255,155,36,36);
                      } else {
                        color = Colors.black;
                      }
                      return SizedBox(
                        width: 40,
                        child: TextButton(
                            onPressed: () => {_loadSubjects(index + 1, "", "All")},
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color),
                            )),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _loadSubjects(int pageno, String _search, String _type) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor_app/php/load_subjects.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['subjects'] != null) {
          subjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjectList!.add(Subject.fromJson(v));
          });
          setState(() {});
        } else {
          titlecenter = "No Subject Available";
          setState(() {});
        }
      }
    });
  }

  void _loadSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "SEARCH SUBJECT ",
          ),
          content: SizedBox(
            height: screenHeight/6,
            child: SingleChildScrollView(
              child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          labelText: 'Enter Subject Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        search = searchController.text;
                        Navigator.of(context).pop();
                        _loadSubjects(1, search, "All");
                      },
                      child: const Text("Search"),
                    )
                  ],
                ),
            ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "CANCEL",
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      );
  }

  _addtocartDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18.0))),
          title: const Text("Add to Cart"),
          content: const Text("Are you sure to add this subject?"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _addtoCart(index);
              },
            ),
            TextButton(
              child: const Text("No",),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _loadMyCart() {
    if (widget.user.email != "guest@gmail.com") {
      http.post(
          Uri.parse(
              CONSTANTS.server + "/mytutor_app/php/load_mycartqty.php"),
          body: {
            "email": widget.user.email.toString(),
          }).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      ).then((response) {
        print(response.body);
        var jsondata = jsonDecode(response.body);
        if (response.statusCode == 200 && jsondata['status'] == 'success') {
          print(jsondata['data']['carttotal'].toString());
          setState(() {
            widget.user.cart = jsondata['data']['carttotal'].toString();
          });
        }
      });
    }
  }


  void _addtoCart(int index) {
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor_app/php/insert_cart.php"),
        body: {
          "email": widget.user.email.toString(),
          "subjectid": subjectList![index].subjectId.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}