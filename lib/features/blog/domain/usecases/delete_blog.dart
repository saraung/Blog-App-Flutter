import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBlog implements UseCase<void, String> {
  final BlogRepository blogRepository;

  DeleteBlog(this.blogRepository);

  @override
  Future<Either<Failure, void>> call(String blogId) {
    return blogRepository.deleteBlog(blogId);
  }
}
