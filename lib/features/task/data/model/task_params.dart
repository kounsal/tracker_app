class TaskParams {
  final String? title;
  final String? description;
  final String? status;
  

  TaskParams({this.title, this.description, this.status});

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'status': status};
  }
}
