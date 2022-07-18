class UserOrgModel {
  UserOrgModel({
    required this.login,
    required this.id,
    required this.nodeId,
    required this.url,
    required this.reposUrl,
    required this.eventsUrl,
    required this.hooksUrl,
    required this.issuesUrl,
    required this.membersUrl,
    required this.publicMembersUrl,
    required this.avatarUrl,
    required this.description,
  });
  late final String? login;
  late final int? id;
  late final String? nodeId;
  late final String? url;
  late final String? reposUrl;
  late final String? eventsUrl;
  late final String? hooksUrl;
  late final String? issuesUrl;
  late final String? membersUrl;
  late final String? publicMembersUrl;
  late final String? avatarUrl;
  late final String? description;

  UserOrgModel.fromJson(Map<String, dynamic> json){
    login = json['login'];
    id = json['id'];
    nodeId = json['node_id'];
    url = json['url'];
    reposUrl = json['repos_url'];
    eventsUrl = json['events_url'];
    hooksUrl = json['hooks_url'];
    issuesUrl = json['issues_url'];
    membersUrl = json['members_url'];
    publicMembersUrl = json['public_members_url'];
    avatarUrl = json['avatar_url'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['login'] = login;
    data['id'] = id;
    data['node_id'] = nodeId;
    data['url'] = url;
    data['repos_url'] = reposUrl;
    data['events_url'] = eventsUrl;
    data['hooks_url'] = hooksUrl;
    data['issues_url'] = issuesUrl;
    data['members_url'] = membersUrl;
    data['public_members_url'] = publicMembersUrl;
    data['avatar_url'] = avatarUrl;
    data['description'] = description;
    return data;
  }
}