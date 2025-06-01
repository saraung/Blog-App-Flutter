import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSourcel;
  final ConnectionChecker connectionChecker;
  BlogRepositoryImpl(this.blogRemoteDataSource,this.blogLocalDataSourcel,this.connectionChecker);
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try{
      if(!await(connectionChecker.isConnected)){
        return left(Failure("No Internet Connection"));
      }
      BlogModel blogModel = BlogModel(
      id: const Uuid().v1(),
      posterId: posterId,
      title: title,
      content: content,
      imageUrl: '',
      topics: topics,
      updatedAt: DateTime.now(),
    );
    final imageUrl= await blogRemoteDataSource.uploadBlogImage(image: image, blog: blogModel);
    blogModel=blogModel.copyWith(imageUrl: imageUrl);
    final uploadedBlog= await blogRemoteDataSource.uploadBlog(blogModel);
    return right(uploadedBlog);
    } on ServerException catch(e){
      return left(Failure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async  {
   try{
     if(!await(connectionChecker.isConnected)){
      final blogs=blogLocalDataSourcel.loadBlogs();
      return right(blogs);
     }
      final blogs=await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSourcel.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
   }on ServerException catch(e){
    return left(Failure(e.message));
   }
  }

  @override
Future<Either<Failure, Blog>> updateBlog(Blog blog) async {
  try {
    if (!await connectionChecker.isConnected) {
      return left(Failure("No Internet Connection"));
    }
    final updatedBlog = await blogRemoteDataSource.updateBlog(blog);
    return right(updatedBlog);
  } on ServerException catch (e) {
    return left(Failure(e.message));
  }
}

@override
Future<Either<Failure, void>> deleteBlog(String blogId) async {
  try {
    if (!await connectionChecker.isConnected) {
      return left(Failure("No Internet Connection"));
    }
    await blogRemoteDataSource.deleteBlog(blogId);
    return right(null);
  } on ServerException catch (e) {
    return left(Failure(e.message));
  }
}

}
