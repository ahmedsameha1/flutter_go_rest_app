// Mocks generated by Mockito 5.4.3 from annotations
// in clean_architecture_getx/test/features/comment/domain/usecases/create_comment_usecase.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:clean_architecture_getx/features/comment/data/models/comment.dart'
    as _i5;
import 'package:clean_architecture_getx/features/comment/domain/repositories/comment_repository.dart'
    as _i3;
import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [CommentRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockCommentRepository extends _i1.Mock implements _i3.CommentRepository {
  MockCommentRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<String, List<_i5.Comment>>> getComments(int? postId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getComments,
          [postId],
        ),
        returnValue: _i4.Future<_i2.Either<String, List<_i5.Comment>>>.value(
            _FakeEither_0<String, List<_i5.Comment>>(
          this,
          Invocation.method(
            #getComments,
            [postId],
          ),
        )),
      ) as _i4.Future<_i2.Either<String, List<_i5.Comment>>>);

  @override
  _i4.Future<_i2.Either<String, bool>> createComment(_i5.Comment? comment) =>
      (super.noSuchMethod(
        Invocation.method(
          #createComment,
          [comment],
        ),
        returnValue: _i4.Future<_i2.Either<String, bool>>.value(
            _FakeEither_0<String, bool>(
          this,
          Invocation.method(
            #createComment,
            [comment],
          ),
        )),
      ) as _i4.Future<_i2.Either<String, bool>>);

  @override
  _i4.Future<_i2.Either<String, bool>> deleteComment(_i5.Comment? comment) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteComment,
          [comment],
        ),
        returnValue: _i4.Future<_i2.Either<String, bool>>.value(
            _FakeEither_0<String, bool>(
          this,
          Invocation.method(
            #deleteComment,
            [comment],
          ),
        )),
      ) as _i4.Future<_i2.Either<String, bool>>);
}
