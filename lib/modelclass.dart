import 'package:json_annotation/json_annotation.dart';
part 'modelclass.g.dart';
@JsonSerializable()
class TodoModelClass{
  String Task;
  String Discription;
  String Date;
  String Time;
  String documentid;
  bool DoneTask;
  bool PinTask;

  TodoModelClass({
    required this.Task,
    required this.Discription,
    required this.Date,
    required this.Time,
    required this.documentid,
    this.DoneTask=false,
    this.PinTask=false,
  });

  factory TodoModelClass.fromJson(Map<String, dynamic> json) => _$TodoModelClassFromJson(json);
  Map<String, dynamic> toJson() => _$TodoModelClassToJson(this);}



//flutter pub run build_runner build



