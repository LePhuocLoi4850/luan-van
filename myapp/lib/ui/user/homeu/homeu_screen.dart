import 'package:flutter/material.dart';
import '../../../ui/screens.dart';

class HomeUScreen extends StatefulWidget {
  const HomeUScreen({super.key});

  @override
  State<HomeUScreen> createState() => _HomeUScreenState();
}

class _HomeUScreenState extends State<HomeUScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${userProvider.userData?.name}'),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.notifications_rounded))
        ],
      ),
      body: const JobGird(),
    );
  }
}
