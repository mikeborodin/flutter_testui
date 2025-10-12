enum TestStatus{passed, failed, running}

class StartEvent {
  final String protocolVersion;
  final String? runnerVersion;
  final int pid;
  final String type;
  final int time;

  StartEvent({
    required this.protocolVersion,
    required this.runnerVersion,
    required this.pid,
    required this.type,
    required this.time,
  });
}

class SuiteEvent {
  final int id;
  final String platform;
  final String path;
  final String type;
  final int time;

  SuiteEvent({
    required this.id,
    required this.platform,
    required this.path,
    required this.type,
    required this.time,
  });
}

class TestStartEvent {
  final int id;
  final String name;
  final int suiteID;
  final List<int> groupIDs;
  final Metadata metadata;
  final int? line;
  final int? column;
  final String? url;
  final String type;
  final int time;

  TestStartEvent({
    required this.id,
    required this.name,
    required this.suiteID,
    required this.groupIDs,
    required this.metadata,
    this.line,
    this.column,
    this.url,
    required this.type,
    required this.time,
  });
}

class Metadata {
  final bool skip;
  final String? skipReason;

  Metadata({
    required this.skip,
    this.skipReason,
  });
}

class AllSuitesEvent {
  final int count;
  final String type;
  final int time;

  AllSuitesEvent({
    required this.count,
    required this.type,
    required this.time,
  });
}

class TestDoneEvent {
  final int testID;
  final String result;
  final bool skipped;
  final bool hidden;
  final String type;
  final int time;

  TestDoneEvent({
    required this.testID,
    required this.result,
    required this.skipped,
    required this.hidden,
    required this.type,
    required this.time,
  });
}

class GroupEvent {
  final int id;
  final int suiteID;
  final int? parentID;
  final String name;
  final Metadata metadata;
  final int testCount;
  final int? line;
  final int? column;
  final String? url;
  final String type;
  final int time;

  GroupEvent({
    required this.id,
    required this.suiteID,
    this.parentID,
    required this.name,
    required this.metadata,
    required this.testCount,
    this.line,
    this.column,
    this.url,
    required this.type,
    required this.time,
  });
}

class DoneEvent {
  final bool success;
  final String type;
  final int time;

  DoneEvent({
    required this.success,
    required this.type,
    required this.time,
  });
}
