class LeadTrackingModel {
  final String? id;
  final String? leadName;
  final String? businessReferrer;
  final List<LeadStage>? stages;
  final String? createdAt;
  final String? updatedAt;

  LeadTrackingModel({
    this.id,
    this.leadName,
    this.businessReferrer,
    this.stages,
    this.createdAt,
    this.updatedAt,
  });

  factory LeadTrackingModel.fromJson(Map<String, dynamic> json) {
    return LeadTrackingModel(
      id: json['id'],
      leadName: json['lead_name'],
      businessReferrer: json['business_referrer'],
      stages: json['stages'] != null
          ? List<LeadStage>.from(
              json['stages'].map((x) => LeadStage.fromJson(x)))
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lead_name': leadName,
      'business_referrer': businessReferrer,
      'stages': stages?.map((x) => x.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class LeadStage {
  final String? id;
  final String? title;
  final String? description;
  final String? status; // 'completed', 'current', 'upcoming'
  final String? completedDate;
  final String? comment;
  final bool? isEditable;

  LeadStage({
    this.id,
    this.title,
    this.description,
    this.status,
    this.completedDate,
    this.comment,
    this.isEditable,
  });

  factory LeadStage.fromJson(Map<String, dynamic> json) {
    return LeadStage(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      completedDate: json['completed_date'],
      comment: json['comment'],
      isEditable: json['is_editable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'completed_date': completedDate,
      'comment': comment,
      'is_editable': isEditable,
    };
  }
}

// Sample data for development
class LeadTrackingSampleData {
  static LeadTrackingModel getSampleLead() {
    return LeadTrackingModel(
      id: '1',
      leadName: 'Sarah Johnson',
      businessReferrer: 'TechCorp Solutions',
      stages: [
        LeadStage(
          id: '1',
          title: 'Initial Contact',
          description: 'Lead received and contacted',
          status: 'completed',
          completedDate: 'Jan 15, 2024',
          comment:
              'Lead looks very promising. Initial conversation went well and they showed strong interest in our services.',
          isEditable: true,
        ),
        LeadStage(
          id: '2',
          title: 'Qualification Call',
          description: 'Assess lead requirements',
          status: 'current',
          completedDate: null,
          comment: null,
          isEditable: false,
        ),
        LeadStage(
          id: '3',
          title: 'Proposal Sent',
          description: 'Send detailed proposal',
          status: 'upcoming',
          completedDate: null,
          comment: null,
          isEditable: false,
        ),
        LeadStage(
          id: '4',
          title: 'Follow-up',
          description: 'Follow up on proposal',
          status: 'upcoming',
          completedDate: null,
          comment: null,
          isEditable: false,
        ),
        LeadStage(
          id: '5',
          title: 'Conversion',
          description: 'Lead converted to client',
          status: 'upcoming',
          completedDate: null,
          comment: null,
          isEditable: false,
        ),
      ],
      createdAt: '2024-01-15',
      updatedAt: '2024-01-15',
    );
  }
}
