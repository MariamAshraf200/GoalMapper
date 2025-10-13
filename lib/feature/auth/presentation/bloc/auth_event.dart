import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckSignInEvent extends AuthEvent {}
class SignInEvent extends AuthEvent {}
class SignOutEvent extends AuthEvent {}

