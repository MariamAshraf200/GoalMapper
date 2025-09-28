enum PlanStatus {
  all,
  completed,
  notCompleted,
}

extension PlanStatusExtension on PlanStatus {
  static PlanStatus fromPlanStatusString(String? type) {
    switch (type?.toUpperCase()) {
      case 'COMPLETED':
        return PlanStatus.completed;
      case 'NOT_COMPLETED':
        return PlanStatus.notCompleted;
      case 'ALL':
      default:
        return PlanStatus.all;
    }
  }

  String toPlanStatusString() {
    switch (this) {
      case PlanStatus.all:
        return 'ALL';
      case PlanStatus.completed:
        return 'Completed';
      case PlanStatus.notCompleted:
        return 'Not Completed';
    }
  }
}
