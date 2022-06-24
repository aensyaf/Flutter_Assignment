import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/tutor.dart';

class TutorPage extends StatefulWidget {
  const TutorPage({Key? key}) : super(key: key);

  @override
  State<TutorPage> createState() => _TutorPageState();
}

class _TutorPageState extends State<TutorPage> {
  List<Tutor>? tutorList = <Tutor>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;

  @override
  void initState() {
    super.initState();
    _loadTutors(1);
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
        title: const Text("TUTORS",
          style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.red,
          ),
        ),
        centerTitle: true,
        backgroundColor:Colors.black,
      ),
      body: tutorList!.isEmpty
        ? Center(
          child: Text(
            titlecenter,
            style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold)))
        : Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text(
                  "AVAILABLE TUTORS",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                    childAspectRatio: (1 / 2.26),
                      children: List.generate(tutorList!.length, (index) {
                        return InkWell(
                         splashColor: Colors.red,
                            onTap: () => {_loadTutorDetails(index)},
                          child: Card(
                            child: Column(
                              children: [
                                Flexible(
                                  flex: 6,
                                  child: CachedNetworkImage(
                                    imageUrl: CONSTANTS.server +
                                      "/mytutor_app/assets/images/tutors/" +
                                      tutorList![index].tutorId.toString() +'.jpg',
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
                                  flex: 5,
                                  child: Center(
                                    child: Column(
                                        children: [
                                          Text(
                                              tutorList![index]
                                                  .tutorName
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 14),
                                          
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.email,
                                                size: 14, 
                                                color: Colors.red,
                                              ),
                                              const Text(" Email",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            tutorList![index]
                                                .tutorEmail
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.phone,
                                                size: 14, 
                                                color: Colors.red,
                                              ),
                                              const Text(" Contact No:",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,)
                                              ),
                                            ],
                                          ),
                                          Text(
                                              tutorList![index]
                                                  .tutorPhone
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ))
                              ],
                            )),
                        );
                        }))),
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if ((curpage - 1) == index) {
                        color = Colors.red;
                      } else {
                        color = Colors.black;
                      }
                      return SizedBox(
                        width: 40,
                        child: TextButton(
                            onPressed: () => {_loadTutors(index + 1)},
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

  void _loadTutors(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor_app/php/load_tutors.php"),
        body: {'pageno': pageno.toString()}).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['tutors'] != null) {
          tutorList = <Tutor>[];
          extractdata['tutors'].forEach((v) {
            tutorList!.add(Tutor.fromJson(v));
          });
          setState(() {});
        } else {
          titlecenter = "No Tutor Available";
          setState(() {});
        }
      }
    });
  }


  _loadTutorDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "TUTOR DETAILS",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: CONSTANTS.server +
                      "/mytutor_app/assets/images/tutors/" +
                      tutorList![index].tutorId.toString() +
                      '.jpg',
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 15),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Name:",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12,color: Colors.red)),
                  Text(tutorList![index].tutorName.toString(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text("Email:", style: TextStyle(fontSize: 12,color: Colors.red)),
                  Text(tutorList![index].tutorEmail.toString(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text("Phone:", style: TextStyle(fontSize: 12,color: Colors.red)),
                  Text(tutorList![index].tutorPhone.toString(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text("About:", style: TextStyle(fontSize: 12,color: Colors.red)),
                  Text(tutorList![index].tutorDescription.toString(),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                ])
              ],
            )),
            actions: [
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

}