import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(Cal());

class Cal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: CalApp(),
    );
  }
}

class CalApp extends StatefulWidget {
  @override
  _CalAppState createState() => _CalAppState();
}

class _CalAppState extends State<CalApp> {
  CalendarController _calendarController;
  List<dynamic> _selectedDayList;
  Map<DateTime, List<dynamic>> _eventsOnday;
  TextEditingController _eventOfDay;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _selectedDayList = [];
    _eventsOnday = {};
    _eventOfDay = TextEditingController();
  }

  void selectedDayTracker(DateTime day, List events) {
    setState(() {
      _selectedDayList = events;
    });
  }

  _showAddDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: _eventOfDay,
                decoration: InputDecoration(hintText: 'Enter Event'),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Save'),
                  onPressed: () {
                    if (_eventOfDay.text.isEmpty) {
                      return;
                    }
                    setState(() {
                      if (_eventsOnday[_calendarController.selectedDay] !=
                          null) {
                        _eventsOnday[_calendarController.selectedDay]
                            .add(_eventOfDay.text);
                      } else {
                        _eventsOnday[_calendarController.selectedDay] = [
                          _eventOfDay.text
                        ];
                      }
                      _eventOfDay.clear();
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendar Application',
          style: TextStyle(color: Colors.yellow),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          TableCalendar(
            initialCalendarFormat: CalendarFormat.month,
            calendarStyle: CalendarStyle(
              markersColor: Colors.yellow,
              markersAlignment: Alignment.topCenter,
              canEventMarkersOverflow: true,
              todayColor: Colors.yellowAccent,
              selectedColor: Colors.deepOrange,
              todayStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
            ),
            headerStyle: HeaderStyle(
              formatButtonShowsNext: false
            ),
            startingDayOfWeek: StartingDayOfWeek.monday,
            events: _eventsOnday,
            calendarController: _calendarController,
            onDaySelected: (day, events) {
              selectedDayTracker(day, events);
            },
            
          ),
          Center(
            child: Container(
              child: Text(
                "EVENTS",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Text(
                "Swipe to dismiss",
                style: TextStyle(fontSize: 12.0, letterSpacing: 1),
              ),
            ),
          ),
          ..._selectedDayList.map((event) => Dismissible(
              key: Key(_selectedDayList[0]),
              onDismissed: (direction) {
                _selectedDayList.removeAt(0);
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("Removed"),));
              },
              child: Card(            
                color: Colors.yellow,
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                      child: Text(
                        event,
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                      ),
                    )
                  ],
                ),
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              )
              ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.event_note),
        backgroundColor: Colors.deepOrange,
        onPressed: _showAddDialog,
      ),
    );
  }
}
