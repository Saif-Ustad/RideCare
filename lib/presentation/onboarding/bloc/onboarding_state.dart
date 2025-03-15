import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final int currentPage;

  const OnboardingState({required this.currentPage});

  OnboardingState copyWith({int? currentPage}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [currentPage];
}
