class VideoModel {
  final int id;
 
  final String name;
  final List<dynamic> video; // You can replace dynamic with a specific ImageModel if needed
  final int videoCategoryId;
  final int reaction;
  final String comment;
  final String storeName;
 

  final int storeId;
  final String description;
  final int createdBy;
  final int createdById;
  final int updatedBy;
  final int updatedById;
  final bool isActive;

  final int totalLike;
  final int totalComment;
  final List<dynamic> reactions;

  VideoModel({
    required this.id,
   
    required this.name,
    required this.storeName,
    required this.reaction,
    required this.comment,

    required this.video,
    required this.videoCategoryId,
    required this.storeId,
    required this.description,
    required this.createdBy,
    required this.createdById,
    required this.updatedBy,
    required this.updatedById,
    required this.isActive,


    this.totalComment=0,
    this.totalLike=0,
    this.reactions=const [],


  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
  final videoJson = json['video'] ?? json; // 👈 key point

  return VideoModel(
    id: videoJson['id'] is int
        ? videoJson['id']
        : int.tryParse(videoJson['id']?.toString() ?? '0') ?? 0,

    name: videoJson['name'] ?? '',

    storeName: videoJson['store'] != null
        ? videoJson['store']['name']?.toString() ?? ''
        : '',

    video: videoJson['image'] ?? [],

    videoCategoryId: videoJson['video_category'] != null
        ? videoJson['video_category']['id'] ?? 0
        : videoJson['video_category_id'] ?? 0,

    storeId: videoJson['store'] != null
        ? videoJson['store']['id'] ?? 0
        : videoJson['store_id'] ?? 0,

    description: videoJson['description'] ?? '',

    createdBy: videoJson['created_by'] ?? 0,
    createdById: videoJson['created_by_id'] ?? 0,
    updatedBy: videoJson['updated_by'] ?? 0,
    updatedById: videoJson['updated_by_id'] ?? 0,

    isActive: videoJson['is_active'] ?? true,

    // 🔥 NEW (safe for list API also)
    totalLike: json['stats'] != null
        ? json['stats']['total_likes'] ?? 0
        : 0,

    totalComment: json['stats'] != null
        ? json['stats']['total_comments'] ?? 0
        : 0,

    reactions: json['reactions'] ?? [],
    
    reaction: 0,
    comment: '',
  );
}

   VideoModel copyWith({
    bool? isActive,
  }) {
    return VideoModel(
      id: id,
      name: name,
      video: video,
      storeName: storeName,

      reaction: reaction,
      comment: comment,
      videoCategoryId: videoCategoryId,
      storeId: storeId,
      description: description,
      createdBy: createdBy,
      createdById: createdById,
      updatedBy: updatedBy,
      updatedById: updatedById,
      isActive: isActive ?? this.isActive,
    );
  }

  


  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'name': name,
      'image': video,
      'video_category_id': videoCategoryId,
      'store_id': storeId,
      'description': description,
      'created_by': createdBy,
      'created_by_id': createdById,
      'updated_by': updatedBy,
      'updated_by_id': updatedById,
      'is_active':isActive
    };
  }

  
}