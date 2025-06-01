import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateBlog implements UseCase<Blog, Blog> {
  final BlogRepository blogRepository;

  UpdateBlog(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(Blog blog) {
    return blogRepository.updateBlog(blog);
  }
}
