// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modelclass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoModelClass _$TodoModelClassFromJson(Map<String, dynamic> json) =>
    TodoModelClass(
      Task: json['Task'] as String,
      Discription: json['Discription'] as String,
      Date: json['Date'] as String,
      Time: json['Time'] as String,
      documentid: json['documentid'] as String,
      DoneTask: json['DoneTask'] as bool? ?? false,
      PinTask: json['PinTask'] as bool? ?? false,
    );

Map<String, dynamic> _$TodoModelClassToJson(TodoModelClass instance) =>
    <String, dynamic>{
      'Task': instance.Task,
      'Discription': instance.Discription,
      'Date': instance.Date,
      'Time': instance.Time,
      'documentid': instance.documentid,
      'DoneTask': instance.DoneTask,
      'PinTask': instance.PinTask,
    };
