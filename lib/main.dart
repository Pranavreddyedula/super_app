import 'package:flutter/material.dart';

void main() {
  runApp(SuperApp());
}

class SuperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Super App',
      theme: ThemeData(
        fontFamily: 'Arial',
        primarySwatch: Colors.deepPurple,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List apps = [
    {"title": "Calculator", "icon": Icons.calculate, "screen": CalculatorApp()},
    {"title": "Notes", "icon": Icons.note, "screen": NotesApp()},
    {"title": "Weather", "icon": Icons.wb_sunny, "screen": WeatherApp()},
    {"title": "To-Do", "icon": Icons.check_circle, "screen": TodoApp()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 60),
            Text(
              "🚀 Super App",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
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
                      MaterialPageRoute(builder: (_) => app["screen"]),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(app["icon"], size: 40, color: Colors.white),
                          SizedBox(height: 10),
                          Text(
                            app["title"],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
          output = eval(output).toString();
        } catch (e) {
          output = "Error";
        }
      } else {
        output += value;
      }
    });
  }

  dynamic eval(String exp) {
    return double.parse(exp);
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
                  child: Text(output, style: TextStyle(fontSize: 30)))),
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

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weather")),
      body: Center(
        child: Text(
          "🌤 28°C\nSunny",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30),
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