import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:todos_app/views/index.v.dart';
import 'package:todos_app/views/todos.v.dart';
import 'package:todos_app/views/profile.v.dart';
import 'package:todos_app/views/login.s.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
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
        primarySwatch: Colors.green,
      ),
      home: const LoginScreen(),
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
  static const List<Widget> views = [
    IndexView(),
    ProfileView(),
    TodosView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yepe\'s todo list'),
      ),
      body: views[currentPage],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPage,
        elevation: 18,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Colors.grey),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            selectedIcon: Icon(Icons.person, color: Colors.grey),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_add),
            selectedIcon: Icon(Icons.bookmark_add, color: Colors.grey),
            label: 'Todos',
          ),
        ],
        onDestinationSelected: (int index) {
          if (index == currentPage) {
            return;
          }
          if (index > views.length - 1) return;
          setState(() {
            currentPage = index;
          });
        },
      ),
    );
  }
}
