import 'dart:io';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/delete_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/update_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final UpdateBlog _updateBlog;
  final DeleteBlog _deleteBlog;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
    required UpdateBlog updateBlog,
    required DeleteBlog deleteBlog,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        _updateBlog = updateBlog,
        _deleteBlog = deleteBlog,
        super(BlogInitial()) {
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
    on<BlogUpdate>(_onBlogUpdate);
    on<BlogDelete>(_onBlogDelete);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final res = await _uploadBlog(UploadBlogParams(
      posterId: event.posterId,
      title: event.title,
      content: event.content,
      image: event.image,
      topics: event.topics,
    ));
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _onFetchAllBlogs(BlogFetchAllBlogs event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final res = await _getAllBlogs(NoParams());
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogDisplaySuccess(r)),
    );
  }

  void _onBlogUpdate(BlogUpdate event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final res = await _updateBlog(event.blog);
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (_) => emit(BlogUpdateSuccess()),
    );
  }

  void _onBlogDelete(BlogDelete event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final res = await _deleteBlog(event.id);
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (_) => emit(BlogDeleteSuccess()),
    );
  }
}
