import 'package:blog_app/features/blog/presentation/pages/book_mark_page.dart';
import 'package:blog_app/features/blog/presentation/pages/my_blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogDrawer extends StatelessWidget {
  const BlogDrawer({super.key});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(AuthLogout());
              Navigator.of(context).pushAndRemoveUntil(
                LoginPage.route(),
                (route) => false,
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appUserState = context.watch<AppUserCubit>().state;
    final user = appUserState is AppUserLoggedIn ? appUserState.user : null;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppPallete.gradient1, AppPallete.gradient2],
              ),
            ),
            accountName: Text(user?.name ?? 'Guest'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppPallete.gradient2,
              child: Text(
                user?.name.substring(0, 1).toUpperCase() ?? "?",
                style: const TextStyle(fontSize: 24, color: Colors.black),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text('My Blogs'),
            onTap: () => Navigator.push(context, MyBlogPage.route()),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_outline),
            title: const Text('Saved Blogs'),
            onTap: () {
              Navigator.push(context, BookMarkPage.route());
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Blog App',
                applicationVersion: 'v1.0.0',
                applicationLegalese: '© 2025 Saraung Babu',
                children: [
                  const Text('Built with Flutter 💙'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final url = Uri.parse('https://www.saraung.com');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    child: const Text(
                      'Visit my portfolio: www.saraung.com',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Made by Saraung Babu'),
                ],
              );
            },
          ),
          const Divider(thickness: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
