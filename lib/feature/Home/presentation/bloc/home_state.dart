import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<DateTime> days;
  final Map<DateTime, double> dailyProgress; // progress per day [0..1]
  final double avgProgress;
  final String bestDayName;
  final int todayIndex;

  const HomeLoaded({
    required this.days,
    required this.dailyProgress,
    required this.avgProgress,
    required this.bestDayName,
    required this.todayIndex,
  });

  @override
  List<Object?> get props => [days, dailyProgress, avgProgress, bestDayName, todayIndex];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

