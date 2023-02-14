
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:todos_app/views/index.v.dart';
 import 'package:todos_app/models/todos.model.dart';
const String url = 'https://api.yepe.me/api/v1/todos';
Future main() async {
  await dotenv.load(fileName: ".env");
  debugPrint(dotenv.env['HOSTAPI']!);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RootWidget(),

    );
  }
}
class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  int currentPage = 0;
  static const List<Widget> views =  [
 IndexView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yepe\'s todo list'),
      ),
      body: views[currentPage],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // log to console
          debugPrint('Floating action button pressed');
          final resp = await Todos.getTodos();
          debugPrint(resp.todos!.length.toString());
        },
        child: const Icon(Icons.refresh),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            selectedIcon: 
            Icon(Icons.home, color: Colors.blue)
            ,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_add),
            label: 'Todos',
          ),
        ],
        onDestinationSelected: (int index) {
          if (index == currentPage) {
            return;
          }
          if (index > views.length-1) return;
          setState(() {
            currentPage = index;
          });
        },
      ),
    );
  }
}
