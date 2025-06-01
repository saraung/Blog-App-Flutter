import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const MyBlogPage());
  const MyBlogPage({super.key});

  @override
  State<MyBlogPage> createState() => _MyBlogPageState();
}

class _MyBlogPageState extends State<MyBlogPage> {
  @override
  void initState() {
    super.initState();
    // Load blogs when the page loads
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  void _deleteBlog(String blogId) {
    context.read<BlogBloc>().add(BlogDelete(id: blogId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("My Blogs")),
      ),
      body: BlocListener<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogDeleteSuccess) {
            // Refresh blog list after successful deletion
            context.read<BlogBloc>().add(BlogFetchAllBlogs());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Blog deleted successfully")),
            );
          } else if (state is BlogFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.error}")),
            );
          }
        },
        child: BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            if (state is BlogLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BlogFailure) {
              return Center(child: Text("Error: ${state.error}"));
            } else if (state is BlogDisplaySuccess) {
              final posterId =
                  (context.read<AppUserCubit>().state as AppUserLoggedIn)
                      .user
                      .id;

              final myBlogs = state.blogs
                  .where((blog) => blog.posterId == posterId)
                  .toList();

              if (myBlogs.isEmpty) {
                return const Center(
                    child: Text("No blogs found. Add a new one!"));
              }

              return ListView.builder(
                itemCount: myBlogs.length,
                itemBuilder: (context, index) {
                  final blog = myBlogs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, BlogViewerPage.route(blog));
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(blog.title),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // IconButton(
                            //   icon: const Icon(Icons.edit, color: Colors.blue),
                            //   onPressed: () {
                        
                            //   },
                            // ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteBlog(blog.id),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
