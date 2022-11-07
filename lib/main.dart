// Started with https://docs.flutter.dev/development/ui/widgets-intro
//import 'dart:io';

import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';

class DetailList extends StatefulWidget {
  const DetailList({super.key});

  @override
  State createState() => _DetailListState();
}

class _DetailListState extends State<DetailList> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _MakeModelController = TextEditingController();
  final TextEditingController _PackageController = TextEditingController();
  final TextEditingController _PriceEstimateController =
      TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.red);

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add detail'),
            content: Column(children: <Widget>[
              TextField(
                key: Key("MMKey"),
                onChanged: (value) {
                  setState(() {
                    MakeModelText = value;
                  });
                },
                controller: _MakeModelController,
                decoration:
                    const InputDecoration(hintText: "Vehicle Make/Model"),
              ),
              TextField(
                  key: Key("PackKey"),
                  onChanged: (value) {
                    setState(() {
                      PackageText = value;
                    });
                  },
                  controller: _PackageController,
                  decoration: const InputDecoration(
                      hintText: "Select Package 1, 2, or 3")),
              TextField(
                  key: Key("PEKey"),
                  //keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      PriceEstimateText = int.parse(value);
                    });
                  },
                  controller: _PriceEstimateController,
                  decoration: const InputDecoration(
                      hintText: "Enter your price range")),
            ]),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    _handleNewItem(PackageText, MakeModelText, PackageText,
                        PriceEstimateText);
                    Navigator.pop(context);
                  });
                },
              ),

              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _MakeModelController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("CancelButton"),
                    style: noStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          }
                        : null,
                    child: const Text('Cancel'),
                  );
                },
              ),
            ],
          );
        });
  }

  int _detailcounter = 0;

  int _totalDetailCost = 0;

  String valueText = "";

  String MakeModelText = "";

  String PackageText = "";

  int PriceEstimateText = 0;

  static final List<Car> cars1 = [
    const Car(makemodel: "Nissan Example", package: "Ex: 1", priceestimate: 100)
  ];
//Need to find a way to display all text across banner rather than just 1st text

  final _carSet = <Car>{};

  final Car cars = const Car(
      makemodel: " Nissan Altima S", package: " 1", priceestimate: 100);
  //Example

  void _handleListChanged(bool completed, Car car) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      cars1.remove(car);
      if (!completed) {
        _carSet.add(car);
        cars1.add(car);
      } else {
        _carSet.remove(car);
        cars1.insert(0, car);
        //Need to find a way to delete examples
      }
    });
  }

  void _handleDeleteItem(Car Car) {
    setState(() {
      print("Deleting item");
      cars1.remove(Car);
      _totalDetailCost -= Car.priceestimate;
      _detailcounter--;
    });
  }

  void _handleNewItem(
      String itemText, String makeModel, String package, int priceEstimate) {
    setState(() {
      print("Adding new item");
      Car cars = Car(
          makemodel: makeModel, package: package, priceestimate: priceEstimate);
      cars1.insert(0, cars);
      _totalDetailCost += priceEstimate;
      _MakeModelController.clear();
      _PackageController.clear();
      _PriceEstimateController.clear();
    });
  }

  void _detailCounter() {
    setState(() {
      _detailcounter++;
    });
  }

  double _displayAverage(int totalCash, int totalDetails) {
    if (totalDetails != 0) {
      return totalCash / totalDetails;
    }
    return 0;
  }

  //sends to analytics page
  void _toAnalyticsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Analytics_page(),
      ),
    );
  }

  Future<void> _averageDetail(BuildContext context) async {
    print("Loading Average Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Detail Average'),
            content: SizedBox(
              width: 100,
              height: 60,
              child: Text(
                  "Detail Average is \$${_displayAverage(_totalDetailCost, _detailcounter)}"),
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                child: const Text('Leave'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('G-hops Detailing List'),
        ),
        body: Column(
          // padding: const EdgeInsets.symmetric(vertical: 8.0),
          children:
              //     Text(
              //    '$_detailcounter'
              //     )
              //    ],

              cars1.map((Car) {
            return ToDoListItem(
              cars: Car,
              completed: _carSet.contains(Car),
              onListChanged: _handleListChanged,
              onDeleteItem: _handleDeleteItem,
            );
          }).toList(),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Wrap(
              spacing: 2, // set spacing here
              children: <Widget>[
                Text("Details:"),
                Text('$_detailcounter'),
              ],
            ),
            ElevatedButton(
              key: const Key("AverageKey"),
              child: const Text("Average Detail Price"),
              onPressed: () {
                _averageDetail(context);
              },
            ),

            //press this button and takes to analytics page
            ElevatedButton(
              key: const Key('AnalyticsKey'),
              child: Text('Analytics'),
              onPressed: _toAnalyticsPage,
            )
          ]),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              _displayTextInputDialog(context);
              _detailCounter();
            }));
  }
}

//attempt to build analytics page so you can see what's most common
//amongst cars serviced, plans picked, and prices paid
class Analytics_page extends StatefulWidget {
  const Analytics_page({super.key});

  @override
  State createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<Analytics_page> {
  //loop through list of - count the most common stuff
  //will then return a dictionary/widget to house it
  static Map<String, int> carCounts = {};
  static Map<String, int> planCounts = {};
  static Map<int, int> costCounts = {};
  static List<String> resultList = [];

  //checks if value (String or int) in dic and adds to counter
  //else initializes in dic
  void valCheck(dynamic val, Map<dynamic, dynamic> dic) {
    if (dic.entries.contains(val)) {
      dic[val] += 1;
    } else {
      //type 'String' is not a subtype of type 'int' of 'key' error flutter
      //_TypeError (type 'int' is not a subtype of type 'String' of 'key')
      dic[val] = 1;
    }
  }

  //loops through dic, finds most common occurrence and returns it as a String
  String getMax(Map dic) {
    int max = 0;
    var keyvalue = '';
    for (int i = 0; i < dic.entries.length; i++) {
      if (dic.values.elementAt(i) > max) {
        //this sets the keyvalue to the mapvalue ('MapEntry(car:1)MapEntry(2:1)MapEntry(100:1)')
        //needs to just be a string
        //keyvalue = dic.entries.elementAt(i).toString();
        //var kv = dic.entries.elementAt(i);
        keyvalue = '${dic.keys.elementAt(i)}';
        //keyvalue = '$kv';
        max = dic.values.elementAt(i);
      }
    }
    return ('$keyvalue');
  }

  //loops through list of cars and gets info, then calls our check
  getMostCommon() {
    //does nothing for code other than easy tying
    //and wont mess with the list itself in other parts of the code
    var carList = _DetailListState.cars1;

    for (int i = 0; i < carList.length; i++) {
      Car car = carList[i];

      valCheck(car.makemodel, carCounts);
      valCheck(car.package, planCounts);
      valCheck(car.priceestimate, costCounts);
      //print('this is the counts for $carCounts');
    }
    //adds most common occurences to list
    var result =
        ('Common Car:${getMax(carCounts)} Common Cost:${getMax(costCounts)} Common Plan:${getMax(planCounts)}');

    resultList.add(result);
    //return resultList.last.toString();
    return resultList.last;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue, title: Text('G-hops Analytics')),
        body: Center(child: Text(getMostCommon())));
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'G-hops Detailing List',
    home: DetailList(),
  ));
}
