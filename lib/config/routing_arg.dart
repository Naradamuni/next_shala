///A class that encapsulates the routing arguments between pages
class PageRoutingArguments {
  /// the consructor
  PageRoutingArguments({
    required this.studentId, this.fName,
  });

  ///The student model
  final String studentId;
  final String? fName;
}
