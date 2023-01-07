import 'package:dartz/dartz.dart';

import '../../../../common/repository/repository_helper.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/user.dart';

class UserRepositoryImpl extends UserRepository with RepositoryHelper<User> {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<User>>> getUsers(
      {Gender? gender, UserStatus? status}) async {
    return checkItemsFailOrSuccess(remoteDataSource.getUsers(gender: gender, status: status));
  }

  @override
  Future<Either<String, bool>> createUser(User user) async {
    return checkItemFailOrSuccess(remoteDataSource.createUser(user));
  }

  @override
  Future<Either<String, bool>> updateUser(User user) async {
    return checkItemFailOrSuccess(remoteDataSource.updateUser(user));
  }

  @override
  Future<Either<String, bool>> deleteUser(User user) async {
    return checkItemFailOrSuccess(remoteDataSource.deleteUser(user));
  }
}
