import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:plane_startup/services/dio_service.dart';

import '../config/apis.dart';
import '../utils/enums.dart';

class WorkspaceService {
  DioConfig dio;
  WorkspaceService(this.dio);

  Future<Either<List<dynamic>, DioException>> getWorkspaces() async {
    try {
      var response = await dio.dioServe(
        hasAuth: true,
        url: APIs.listWorkspaces,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      return Left(response.data);
    } on DioException catch (err) {
      log(err.error.toString());
      return Right(DioException(requestOptions: RequestOptions()));
    }
  }

  Future<Either<List, DioException>> getWorkspaceMembers({required String url}) async {
    try {
      var response = await dio.dioServe(
        hasAuth: true,
        url: url,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      return Left(response.data);
    } on DioException catch (err) {
      log(err.error.toString());
      return Right(DioException(requestOptions: RequestOptions()));
    }
  }


}
