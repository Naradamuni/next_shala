///A class that encapsulates the routing arguments between pages
class PageRoutingArguments {
  /// the consructor
  PageRoutingArguments({
    required this.studentId,
    this.fName,
    this.sectionId,
  });

  ///The student model
  final String studentId;
  final String? fName;
  final String? sectionId;
}
