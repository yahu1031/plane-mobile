import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/enums.dart';
import '../repository/dashboard_service.dart';

class DashBoardProvider extends ChangeNotifier {
  DashBoardProvider(
      {required ChangeNotifierProviderRef<DashBoardProvider>? this.ref,
      required this.dashboardService});
  Ref? ref;
  DashboardService dashboardService;

  StateEnum getDashboardState = StateEnum.loading;
  Map dashboardData = {};
  bool hideGithubBlock = false;

  Future getDashboard() async {
    getDashboardState = StateEnum.loading;
    try {
      var workspaceSlug = ref!
          .read(ProviderList.workspaceProvider)
          .selectedWorkspace
          .workspaceSlug;
          
      dashboardData = await dashboardService.getDashboardData(
          url: APIs.dashboard.replaceAll('\$SLUG', workspaceSlug));
      getDashboardState = StateEnum.success;
      notifyListeners();
    } on DioException catch (err) {
      log(err.toString());
      getDashboardState = StateEnum.error;
      notifyListeners();
    }
  }
}
