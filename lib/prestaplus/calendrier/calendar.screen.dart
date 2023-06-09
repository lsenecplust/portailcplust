import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.sfdatasource.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/prestationcard.widget.dart';
import 'package:portail_canalplustelecom_mobile/widgets/futurebuilder.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalanderdarScreen extends StatelessWidget {
  const CalanderdarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
        future: Prestation.get(context),
        builder: (context, snapshot) {
          return SfCalendar(
            view: CalendarView.schedule,
            scheduleViewMonthHeaderBuilder: scheduleViewHeaderBuilder,
            appointmentBuilder: appointmentBuilder,
            scheduleViewSettings: const ScheduleViewSettings(
                hideEmptyScheduleWeek: true, appointmentItemHeight: 82),
            dataSource: PrestationDataSource(snapshot.data!),
          );
        });
  }

  Widget appointmentBuilder(context, calendarAppointmentDetails) {
    if ((calendarAppointmentDetails.appointments.first is Prestation) ==
        false) {
      throw Exception("Not implemented yet");
    }
    final Prestation prestation = calendarAppointmentDetails.appointments.first;
    return PrestationCard(prestation: prestation);
  }

  Widget scheduleViewHeaderBuilder(
      BuildContext context, ScheduleViewMonthHeaderDetails details) {
    return Stack(
      children: [
        Image(
            image: ExactAssetImage(
                'assets/images/calendrier/${details.date.month}.png'),
            fit: BoxFit.cover,
            width: details.bounds.width,
            height: details.bounds.height),
        Positioned(
          left: 55,
          right: 0,
          top: 20,
          bottom: 0,
          child: Text(
            DateFormat('MMMM yyyy').format(details.date).toUpperCase(),
            style: const TextStyle(fontSize: 18),
          ),
        )
      ],
    );
  }
}
