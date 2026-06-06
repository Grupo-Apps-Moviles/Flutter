import 'package:waypass_app/features/profile/domain/user_profile.dart';

sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserProfile profile;
  ProfileSuccess({required this.profile});
}

class ProfileLogoutSuccess extends ProfileState {}

class ProfileFailure extends ProfileState {
  final String error;
  ProfileFailure({required this.error});
}