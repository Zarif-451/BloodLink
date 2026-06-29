import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/widgets/timeline_stepper.dart';

List<TimelineStep> buildRequestTimeline(RequestStatus status) {
  if (status == RequestStatus.rejected) {
    return const [
      TimelineStep(title: 'Submitted', isComplete: true),
      TimelineStep(title: 'Under review', isComplete: true),
      TimelineStep(title: 'Rejected', isComplete: true, isActive: true),
    ];
  }

  if (status == RequestStatus.cancelled) {
    return const [
      TimelineStep(title: 'Submitted', isComplete: true),
      TimelineStep(title: 'Cancelled', isComplete: true, isActive: true),
    ];
  }

  if (status == RequestStatus.fulfilled) {
    return const [
      TimelineStep(title: 'Submitted', isComplete: true),
      TimelineStep(title: 'Under review', isComplete: true),
      TimelineStep(title: 'Approved', isComplete: true),
      TimelineStep(title: 'Allocated', isComplete: true),
      TimelineStep(title: 'In transit', isComplete: true),
      TimelineStep(title: 'Fulfilled', isComplete: true),
    ];
  }

  int level(RequestStatus s) => switch (s) {
        RequestStatus.pending => 1,
        RequestStatus.approved => 2,
        RequestStatus.allocated => 3,
        RequestStatus.inTransit => 4,
        RequestStatus.fulfilled => 5,
        _ => 0,
      };

  final current = level(status);

  TimelineStep step(String title, int stepLevel) {
    return TimelineStep(
      title: title,
      isComplete: current > stepLevel,
      isActive: current == stepLevel,
    );
  }

  return [
    const TimelineStep(title: 'Submitted', isComplete: true),
    step('Under review', 1),
    step('Approved', 2),
    step('Allocated', 3),
    step('In transit', 4),
    step('Fulfilled', 5),
  ];
}
