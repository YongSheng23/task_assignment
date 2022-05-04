import 'package:flutter/material.dart';
import 'package:level_map/level_map.dart';
import 'dart:math' as math;
import 'custom_stepper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int itemLength = 5;
  TextStyle textStyle = const TextStyle(fontSize: 12,fontWeight: FontWeight.bold);
  String dropdownValue = "Yellow";
  final _scrollController = ScrollController();

  void initState() {
    super.initState();

    // Setup the listener.
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
          print('At the top');
        } else {
          print('At the bottom');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 50, right: 50),
              child: Theme(
                data: Theme.of(context).copyWith(splashColor: Colors.white),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      value: dropdownValue,
                      isDense: true,
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: colorsSelected(dropdownValue),
                      ),
                      elevation: 16,
                      style: TextStyle(color: colorsSelected(dropdownValue)),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['Yellow', 'Red', 'Blue', 'Green', 'Pink']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
              color: colorsSelected(dropdownValue),
            ),
          ),
        ),
        NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            final metrics = scrollEnd.metrics;
            if (metrics.atEdge) {
              bool isTop = metrics.pixels == 0;
              if (isTop) {
                showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(25.0),
                          ),
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 200,
                              child: const Center(
                                  child: Text(
                                    "Level 0",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                            );
                          });
              } else {
                print('At the bottom');
              }
            }
            return false;
          },
          child: Expanded(
            flex: 5,
            child: LayoutBuilder(
              builder: (context, constraints) => Container(
                width: constraints.maxWidth,
                child: ListView.builder(
                  reverse: true,
                  itemCount: itemLength,
                  itemBuilder: (context, index) {
                    int levelName = index + 1;
                    final textWidth =
                        _textSize("Chapter $index", textStyle).width;

                    final painterWidth = constraints.maxWidth -
                        ((textWidth + 24) *
                            2); //24 for CircleAvatar, contains boths side

                    return SizedBox(
                      height: index == itemLength - 1 ? 54 * 2 : 100 + 24,
                      width: constraints.maxWidth,
                      child: Stack(
                        children: [
                          if (index != itemLength)
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: painterWidth,
                                height: 150,
                                child: CustomPaint(
                                  painter: DivPainter(index: index, color:dropdownValue),
                                ),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: index.isEven
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.end,
                            children: [
                              if (index.isOdd)
                                Padding(
                                  padding: const EdgeInsets.only(right: 30.0),
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Level $levelName Content",
                                        style: textStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              GestureDetector(
                                  onTap: () {
                                    if (index == 0) {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              height: 200,
                                              child: const Center(
                                                  child: Text(
                                                "Level 1",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                            );
                                          });
                                    }
                                    if (index == 1) {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              height: 200,
                                              child: const Center(
                                                  child: Text(
                                                "Level 2",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                            );
                                          });
                                    }
                                    if (index == 2) {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              height: 200,
                                              child: const Center(
                                                  child: Text(
                                                "Level 3",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                            );
                                          });
                                    }
                                    if (index == 3) {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              height: 200,
                                              child: const Center(
                                                  child: Text(
                                                "Level 4",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                            );
                                          });
                                    }
                                    if (index == 4) {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              height: 200,
                                              child: const Center(
                                                  child: Text(
                                                "Level 5",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                            );
                                          });
                                    }
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 50.0, right: 50),
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage("assets/images/vimigo_logo_mini.png"),
                                      radius: 30,
                                      backgroundColor: colorsSelected(dropdownValue),
                                    ),
                                  )),
                              if (index.isEven)
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0),
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Level $levelName Content",
                                        style: textStyle,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}

Size _textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

class DivPainter extends CustomPainter {
  int index;
  String color;

  DivPainter({required this.index,required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    print (color);
    Paint paint = Paint()
      ..color = colorsSelected(color)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;


    final path1 = Path()
      // ..moveTo(0, 24)
      // ..lineTo(size.width, size.height + 14);
      ..moveTo(0, 50)
      ..quadraticBezierTo(0, 100 , size.width * 0.80, 85)
      ..quadraticBezierTo(size.width, size.height*0.75 , size.width, size.height);

    final path2 = Path()
      // ..moveTo(0, size.height)
      // ..lineTo(size.width, 24);
      ..moveTo(0, size.height)
      ..quadraticBezierTo(size.width * 0, 85 , size.width * 0.80, 85)
      ..quadraticBezierTo(size.width, size.height*0.65 , size.width, size.height*0.45);

    index.isEven
        ? canvas.drawPath(path1, paint)
        : canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Color colorsSelected (String color){
  if (color == "Yellow"){
    return Colors.yellow;
  }
  else if (color == "Red"){
    return Colors.red;
  }
  else if (color == "Blue"){
    return Colors.blue;
  }
  else if (color == "Green"){
    return Colors.green;
  }
  else if (color == "Pink"){
    return Colors.pinkAccent;
  }
  else{
    return Colors.grey;
  }
}
