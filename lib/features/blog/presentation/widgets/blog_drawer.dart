import 'package:blog_app/features/auth/presentation/pages/profile_page.dart';
import 'package:blog_app/features/blog/presentation/pages/my_blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';

class BlogDrawer extends StatelessWidget {
  const BlogDrawer({super.key});

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogout());

    // Navigate to LoginPage and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      LoginPage.route(),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppPallete.gradient1,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(context, ProfilePage.route());
            },
          ),
          ListTile(
            leading: const Icon(Icons.my_library_books),
            title: const Text('My Blogs'),
            onTap: () {
              Navigator.push(context, MyBlogPage.route());
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => _logout(context), // 🔥 Logout
          ),
        ],
      ),
    );
  }
}
