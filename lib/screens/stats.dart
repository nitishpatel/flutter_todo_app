import 'package:flutter/material.dart';
import 'package:mydb_todo/database_helper.dart';
import 'Indicator.dart';
import 'package:fl_chart/fl_chart.dart';
class StatusInfo extends StatefulWidget {
  @override
  _StatusInfoState createState() => _StatusInfoState();
}

class _StatusInfoState extends State<StatusInfo> {
  DatabaseHelper helper = DatabaseHelper();
  Map<String, double> dataMap = new Map();

  static var totalTasks;
  static var completedTasks;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    dataMap.putIfAbsent("Tasks Completed", () => completedTasks);
    dataMap.putIfAbsent("Total Tasks", () => totalTasks);
  }

  Future getData() async {
    var a = await helper.getCount();
    var b = await helper.getStatusCount();
    setState(() {
      totalTasks = a;
      completedTasks = b;
    });
    toDouble();
  }

  void toDouble() async {
    var a = completedTasks.toString();
    var b = totalTasks.toString();
    print(a);
    print(b);
    setState(() {
      completedTasks = double.parse(a);
      totalTasks = double.parse(b);
    });
    display();
  }

  void display() {
    print(completedTasks);
    print(totalTasks);
  }

  List<Color> colorlist = [Colors.red, Colors.blue];
  void updateData() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tasks Analysis"),
          centerTitle: true,
        ),
        
        body:Container(
          child:PieChartSample1(),
        )
        );
  }
}

class PieChartSample1 extends StatelessWidget {

  final pieChartSections = [
    PieChartSectionData(
      color: Color(0xff0293ee),
      value: _StatusInfoState.completedTasks,
      title: "",
      radius: 80,
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff044d7c)),
      titlePositionPercentageOffset: 0.55,
    ),
    PieChartSectionData(
      color: Color(0xfff8b250),
      value: _StatusInfoState.totalTasks-_StatusInfoState.completedTasks,
      title: "",
      radius: 65,
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff90672d)),
      titlePositionPercentageOffset: 0.55,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 28,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Indicator(color: Color(0xff0293ee), text: "Completed", isSquare: false),
                Indicator(color: Color(0xfff8b250), text: "Pending", isSquare: false),
              ],
            ),
            SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: FlChart(
                  chart: PieChart(
                    PieChartData(
                      startDegreeOffset: 180,
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 12,
                      centerSpaceRadius: 0,
                      sections: pieChartSections),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}