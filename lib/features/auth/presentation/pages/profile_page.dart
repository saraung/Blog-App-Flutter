import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const ProfilePage());

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppUserCubit>().state;

    // Default fallback values
    String userName = 'Guest';
    String userEmail = 'guest@example.com';

    if (state is AppUserLoggedIn) {
      userName = state.user.name;
      userEmail = state.user.email;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              userEmail,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("About"),
              subtitle: Text("This is a simple blog app profile page."),
            ),
          ],
        ),
      ),
    );
  }
}
