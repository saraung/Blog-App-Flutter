import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
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
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  void _deleteBlog(String blogId) {
    context.read<BlogBloc>().add(BlogDelete(id: blogId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Blogs"),
        centerTitle: true,
      ),
      body: BlocListener<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogDeleteSuccess) {
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
                padding: const EdgeInsets.all(16),
                itemCount: myBlogs.length,
                itemBuilder: (context, index) {
                  final blog = myBlogs[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(context, BlogViewerPage.route(blog));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    blog.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteBlog(blog.id),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${calculateReadingTime(blog.content)} min read',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                blog.imageUrl,
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  height: 160,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported,
                                      color: Colors.grey),
                                ),
                              ),
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
