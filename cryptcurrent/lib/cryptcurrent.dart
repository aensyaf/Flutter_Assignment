import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ConverterPage(),
    );
  }
}

class ConverterPage extends StatefulWidget {
  const ConverterPage({Key? key}) : super(key: key);

  @override
  _ConverterPageState createState() => _ConverterPageState();
}


class _ConverterPageState extends State<ConverterPage> {
  TextEditingController curr1TextController = TextEditingController();
  List<String> currencyList = [
    "btc",
    "eth",
    "ltc",
    "bch",
    "bnb",
    "eos",
    "xrp",
    "xlm",
    "link",
    "dot",
    "yfi",
    "bits",
    "sats",
    "usd",
    "aed",
    "ars",
    "aud",
    "bdt",
    "bhd",
    "bmd",
    "brl",
    "cad",
    "chf",
    "clp",
    "cny",
    "czk",
    "dkk",
    "eur",
    "gbp",
    "hkd",
    "huf",
    "idr",
    "ils",
    "inr",
    "jpy",
    "krw",
    "kwd",
    "lkr",
    "mmk",
    "mxn",
    "myr",
    "ngn",
    "nok",
    "nzd",
    "php",
    "pkr",
    "pln",
    "rub",
    "sar",
    "sek",
    "sgd",
    "thb",
    "try",
    "twd",
    "uah",
    "vef",
    "vnd",
    "zar",
    "xdr",
    "xag",
    "xau "
  ];

  double input = 0.0, rate = 0.0, result = 0.0;
  String name = "", type = "", unit = "",  unit1 = "usd", unit2 = "btc";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CURRENCY CONVERTER', 
          style : TextStyle(fontSize: 22, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF29d38),
        ),
        
        body: Padding(
          padding: const EdgeInsets.only(top:20, left: 20, right: 20),
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 14, right: 300, bottom:10),
                    child: Text("FROM:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black,)),
                  ),
                  //Input amount textfield
                  SizedBox(
                    width: 400,
                    height:40,
                    child: TextField(
                            controller: curr1TextController,
                            keyboardType: const TextInputType.numberWithOptions(),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              labelText: "Input amount here",
                              fillColor: Colors.white,
                              labelStyle: const TextStyle(
                                fontSize: 14, color: Colors.amber, ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                                filled: true,
                                suffixIcon: IconButton(
                                  onPressed: curr1TextController.clear,
                                  icon: const Icon(Icons.clear),
                                )
                            ),
                            
                          ),
                  ),

                  const SizedBox(height:10),

                  //row for fromCurrency, swap icon, toCurrency
                  Row(
                    children: [
                      Expanded(
                            flex: 1,
                            child: 
                            Container(
                              width: 600,
                              height:38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10)
                            ),
                              child: DropdownButton(
                                dropdownColor: Colors.amber,
                                style: const TextStyle(color: Colors.black,fontSize: 16, fontWeight: FontWeight.bold),
                                underline: Container(),
                                itemHeight: 50,
                                value: unit1,
                                onChanged: (newValue) {
                                  setState(() { 
                                    unit1 = newValue.toString();
                                    });
                                },
                                items: currencyList.map((unit1) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      unit1.toUpperCase(),),
                                    value: unit1,
                                  );
                                }).toList(),
                                
                              ),
                            ),
                      ),

                      //icon
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.swap_horiz),
                      ),

                      //drop down button for 'to' currency
                      Expanded(
                        flex: 1,
                        child: 
                        Container(
                          width: 500,
                          height:38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: DropdownButton(
                            dropdownColor: Colors.amber,
                            style: const TextStyle(color: Colors.black,fontSize: 16, fontWeight: FontWeight.bold),
                            underline: Container(),
                            itemHeight: 50,
                            value: unit2,
                            onChanged: (newValue) {
                              setState(() { 
                                unit2 = newValue.toString();
                                });
                            },
                            items: currencyList.map((unit2) {
                              return DropdownMenuItem(
                                child: Text(
                                  unit2.toUpperCase(),),
                                value: unit2,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],),

                  const SizedBox(height: 10),

                  //convert elevated button
                  SizedBox(
                    height: 38,
                    width: 500,
                    child: ElevatedButton(style: ElevatedButton.styleFrom(
                      onPrimary: Colors.black,
                      primary: Colors.amber,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: _loadCurrency, child: const Text("CONVERT", style: TextStyle(fontSize:16, fontWeight: FontWeight.bold)), ),
                  ), 
                  
                  const SizedBox(height:24),

                  //display result 
                  Container(
                  height: 300,
                  width: 400,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 237, 237, 237),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [ BoxShadow(
                        color: Color.fromARGB(255, 0, 0, 0),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0,4),
                      ),
                      ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height : 60),
                      const Text("RESULT",textAlign: TextAlign.center, style: TextStyle(fontSize:26, fontWeight: FontWeight.bold)),
                      const SizedBox(height : 15),
                      Text(unit+" "+result.toStringAsFixed(2), style: const TextStyle(fontSize:32, fontWeight: FontWeight.bold, color:Colors.amber)),
                      const SizedBox(height : 12),
                      Text(name, textAlign: TextAlign.center,
                      style: const TextStyle(fontSize:18, fontWeight: FontWeight.normal, color:Colors.black)),
                      Text("1 "+unit+" = "+rate.toStringAsFixed(2), style: const TextStyle(fontSize:12, fontWeight: FontWeight.normal, color:Colors.black)),
                    ]
                  )
                ),
                ],
              ),
            )
        )
        )
      );
    }

  Future<void> _loadCurrency() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Converting..."));
    progressDialog.show();
    var url = Uri.parse(
      "https://api.coingecko.com/api/v3/exchange_rates");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jData = response.body;
      var parsedData = json.decode(jData);
      rate = parsedData['rates'][unit2]['value'];
      name = parsedData['rates'][unit2]['name'];
      unit = parsedData['rates'][unit2]['unit'];

      setState(() {
        result = rate * double.parse(curr1TextController.text);
      });
      progressDialog.dismiss();
    }
    else{
      throw Exception("Failed to load result");
    }
  }
}