import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(SuperApp());
}

class SuperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Super App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: HomeScreen(),
    );
  }
}

// ---------------- HOME ----------------

class HomeScreen extends StatelessWidget {
  final List apps = [
    {"title": "Calculator", "icon": Icons.calculate, "screen": CalculatorApp()},
    {"title": "Notes", "icon": Icons.note, "screen": NotesApp()},
    {"title": "Weather", "icon": Icons.cloud, "screen": WeatherApp()},
    {"title": "To-Do", "icon": Icons.check_circle, "screen": TodoApp()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text("🚀 Super App",
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 20),

              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: apps.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final app = apps[index];

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => app["screen"]),
                      ),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.05)
                            ],
                          ),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(app["icon"],
                                size: 45, color: Colors.white),
                            SizedBox(height: 12),
                            Text(app["title"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- CALCULATOR ----------------

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String output = "";

  void press(String value) {
    setState(() {
      if (value == "C") {
        output = "";
      } else if (value == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(output);
          ContextModel cm = ContextModel();
          output =
              exp.evaluate(EvaluationType.REAL, cm).toStringAsFixed(2);
        } catch (e) {
          output = "Error";
        }
      } else {
        output += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculator")),
      body: Column(
        children: [
          Expanded(
              child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(20),
                  child: Text(output,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)))),

          Wrap(
            children: ["1","2","3","+","4","5","6","-","7","8","9","*","C","0","=","/"]
                .map((e) => Padding(
                      padding: EdgeInsets.all(4),
                      child: ElevatedButton(
                        onPressed: () => press(e),
                        child: Text(e),
                      ),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}

// ---------------- NOTES ----------------

class NotesApp extends StatefulWidget {
  @override
  _NotesAppState createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  List<String> notes = [];
  TextEditingController controller = TextEditingController();

  void addNote() {
    if (controller.text.isNotEmpty) {
      setState(() {
        notes.add(controller.text);
        controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Enter note...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: addNote, child: Text("Add Note")),
            Expanded(
              child: ListView(
                children: notes
                    .map((e) => Card(child: ListTile(title: Text(e))))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ---------------- WEATHER ----------------

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String city = "Hyderabad";
  String temp = "";
  String desc = "";
  bool loading = false;

  final apiKey = "bf60c84872ccc9d609c99d4ebe4f4420";

  void fetchWeather() async {
    setState(() => loading = true);

    try {
      final url =
          "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

      final res = await http.get(Uri.parse(url));

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        setState(() {
          temp = "${data['main']['temp']}°C";
          desc = data['weather'][0]['description'];
          loading = false;
        });
      } else {
        setState(() {
          temp = "Error";
          desc = "City not found / API issue";
          loading = false;
        });
      }
    } catch (e) {
      print("ERROR: $e");

      setState(() {
        temp = "Error";
        desc = "Network issue";
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller =
        TextEditingController(text: city);

    return Scaffold(
      appBar: AppBar(title: Text("Weather 🌦")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: "City"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                city = controller.text;
                fetchWeather();
              },
              child: Text("Search"),
            ),
            SizedBox(height: 30),

            loading
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      Text(
                        temp,
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        desc,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}

// ---------------- TODO ----------------

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<String> todos = [];
  TextEditingController controller = TextEditingController();

  void addTodo() {
    if (controller.text.isNotEmpty) {
      setState(() {
        todos.add(controller.text);
        controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("To-Do")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Enter task...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: addTodo, child: Text("Add Task")),
            Expanded(
              child: ListView(
                children: todos
                    .map((e) => Card(child: ListTile(title: Text(e))))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}