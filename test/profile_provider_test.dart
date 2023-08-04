import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plane_startup/models/user_profile_model.dart';
import 'package:plane_startup/provider/profile_provider.dart';
import 'package:plane_startup/repository/profile_provider_service.dart';
import 'package:plane_startup/utils/enums.dart';

class MockProfileService extends Mock implements ProfileService {}

void main() {
  late ProfileService mockProfileService;
  late ProfileProvider profileProvider;
  setUp(() {
    mockProfileService = MockProfileService();
    profileProvider = ProfileProvider(profileService: mockProfileService);
  });

  test('GET Profile', () async{
    when(() => mockProfileService.getProfile()).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 1500));
      return Left(UserProfile.initialize(firstName: 'TESTING'));
    });
    var getProfile= profileProvider.getProfile();
    expect(profileProvider.getProfileState, StateEnum.loading);
    await getProfile;
    expect(profileProvider.getProfileState, StateEnum.success);
    expect(profileProvider.userProfile.firstName, 'TESTING');
  });

    test('ERROR GET Profile', () async{
  
      when(() => mockProfileService.getProfile()).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 1500));
      return Right( DioException(requestOptions: RequestOptions()));
    });
    var getProfile = profileProvider.getProfile();
    expect(profileProvider.getProfileState, StateEnum.loading);
    await getProfile;
    expect(profileProvider.getProfileState, StateEnum.error);
    expect(profileProvider.userProfile.firstName, '');
  });
}
