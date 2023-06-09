import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/dao/prestation.dao.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PrestationDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  PrestationDataSource(List<Prestation> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).dateRdv;
  }



  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).dateRdv.add(const Duration(hours: 1));
  }

  @override
  String getSubject(int index) {
    return "${_getMeetingData(index).contactFullname}\n${_getMeetingData(index).clientNom}" ;
  }

  @override
  Color getColor(int index) {
    return lightColorScheme.primary;
    //return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return false;
    // return _getMeetingData(index).isAllDay;
  }

  Prestation _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Prestation meetingData;
    if (meeting is Prestation) {
      meetingData = meeting;
    }

    return meetingData;
  }
}
