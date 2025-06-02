import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: Constants.topics.length + 1, vsync: this);
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  List<Blog> _filterBlogs(List<Blog> blogs, String topic) {
    if (topic == 'Trending') return blogs;
    return blogs.where((blog) => blog.topics.contains(topic)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tabLabels = ['Trending', ...Constants.topics];

    return Scaffold(
      drawer: const BlogDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Center(child: Text("Blogsy")),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
            icon: const Icon(CupertinoIcons.add_circled),
          ),
        ],
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: tabLabels.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          if (state is BlogDisplaySuccess) {
            return TabBarView(
              controller: _tabController,
              children: tabLabels.map((topic) {
                final blogs = _filterBlogs(state.blogs, topic);
                if (blogs.isEmpty) {
                  return const Center(child: Text("No blogs found."));
                }
                return ListView.builder(
                  itemCount: blogs.length,
                  itemBuilder: (context, index) {
                    return BlogCard(
                      blog: blogs[index],
                      color: index % 2 == 0
                          ? AppPallete.gradient1
                          : AppPallete.gradient2,
                    );
                  },
                );
              }).toList(),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
