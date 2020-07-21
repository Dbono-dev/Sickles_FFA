class Events {

  Events({
    this.title,
    this.date,
    this.description,
    this.location,
    this.startTime,
    this.endTime,
    this.type,
    this.agenda,
    this.participates,
    this.participatesInfo,
    this.participatesName,
    this.maxParticipates,
    this.informationDialog,
    this.key
  });

  final String title;
  final String date;
  final String description;
  final String location;
  final String startTime;
  final String endTime;
  final String type;
  final String agenda;
  var participates;
  var participatesInfo;
  var participatesName;
  final String maxParticipates;
  final bool informationDialog;
  final String key;
}