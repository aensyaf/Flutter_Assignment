import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/subject.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({Key? key}) : super(key: key);

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<Subject>? subjectList = <Subject>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;

  @override
  void initState() {
    super.initState();
    _loadSubjects(1);
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
        centerTitle: true,
        title: const Text('MY Tutor', style: TextStyle(color: Colors.white)),
      ),
      body: subjectList!.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("List of Subjects",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ),
                const SizedBox(height: 15),
                Expanded(
                    child: GridView.count(
                        crossAxisCount: 1,
                        childAspectRatio: (1 / 1),
                        children: List.generate(subjectList!.length, (index) {
                          return Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANTS.server +
                                      "/mytutor/mobile/assets/courses/" +
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
                                  flex: 4,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                            subjectList![index]
                                                .subjectName
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 19,
                                                color: Colors.green)),
                                        Text(
                                            "RM " +
                                                double.parse(subjectList![index]
                                                        .subjectPrice
                                                        .toString())
                                                    .toStringAsFixed(2),
                                            style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            subjectList![index]
                                                    .subjectSessions
                                                    .toString() +
                                                " Sessions",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.green)),
                                        Text(
                                            "Rating: " +
                                                double.parse(subjectList![index]
                                                        .subjectRating
                                                        .toString())
                                                    .toStringAsFixed(2) +
                                                "/5",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.green)),
                                      ],
                                    ),
                                  ))
                            ],
                          ));
                        }))),
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if ((curpage - 1) == index) {
                        color = Colors.green;
                      } else {
                        color = Colors.black;
                      }
                      return SizedBox(
                        width: 40,
                        child: TextButton(
                            onPressed: () => {_loadSubjects(index + 1)},
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

  void _loadSubjects(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor_app/php/load_subjects.php"),
        body: {'pageno': pageno.toString()}).then((response) {
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
}