import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fullfit_app/presentation/providers/providers.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutDetailsScreen extends ConsumerStatefulWidget {
  const WorkoutDetailsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WorkoutDetailsScreen> createState() =>
      _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends ConsumerState<WorkoutDetailsScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String workoutId = '';

  @override
  void initState() {
    super.initState();

    final date = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(workoutsProvider.notifier).getWorkout(workoutId, date);
    });
  }

  Widget buildWorkoutDetailsBody() {
    final workout = ref.watch(workoutsProvider);
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    if (workout.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    } else if (workout.isFailure) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            _CustomHeader(selectedDate: _selectedDay ?? _focusedDay),
            SizedBox(height: 200.h),
            const Center(
              child: Text('There is not workout available for this day'),
            ),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CustomHeader(selectedDate: _selectedDay ?? _focusedDay),
              Html(
                data: workout.workout!.workout,
                style: {'h2': Style(color: colors.primary)},
              ),
              SizedBox(height: 16.h),
              Text('Muscle groups', style: textStyles.titleMedium),
              SizedBox(
                height: 180.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: workout.workout!.muscleGroups.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/${workout.workout!.muscleGroups[index].replaceAll(' ', '_').toLowerCase()}.png',
                          height: 100.h,
                        ),
                        Chip(
                          label: Text(
                            workout.workout!.muscleGroups[index].toUpperCase(),
                            style: textStyles.bodyMedium
                                ?.copyWith(color: colors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 90.h,
        flexibleSpace: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              headerVisible: false,
              calendarBuilders: CalendarBuilders(
                todayBuilder: (context, day, focusedDay) => Container(
                  margin: const EdgeInsets.only(top: 2),
                  height: 50.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: colors.primary.withOpacity(0.5),
                  ),
                  child: Center(
                    child: Text(day.day.toString(),
                        style: textStyles.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                ),
                selectedBuilder: (context, day, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.only(top: 2),
                    height: 50.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: colors.primary,
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: textStyles.bodyMedium?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2023, 06, 01),
              lastDay: DateTime.now(),
              calendarFormat: CalendarFormat.week,
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
                ref
                    .read(workoutsProvider.notifier)
                    .getWorkout(workoutId, _selectedDay ?? _focusedDay);
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
            ),
          ),
        ),
      ),
      body: buildWorkoutDetailsBody(),
    );
  }
}

class _CustomHeader extends StatelessWidget {
  final DateTime selectedDate;
  const _CustomHeader({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    final formatter = DateFormat('EEEE dd, y');
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: colors.primary,
                size: 16.w,
              ),
              Text(
                'back',
                style: textStyles.bodyMedium?.copyWith(color: colors.primary),
              ),
            ],
          ),
        ),
        const Spacer(),
        Text(formatter.format(selectedDate), style: textStyles.titleSmall),
      ],
    );
  }
}
