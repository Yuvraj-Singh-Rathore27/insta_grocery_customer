
// ============================================
// SKILL PROGRAM MAIN MODEL
// ============================================

class SkillProgram {
  final int? id;
  final String? title;
  final int? typeId;
  final int? storeId;
  final int? categoryId;
  final int? subcategoryId;
  final String? programMode;
  final String? duration;
  final String? feesType;
  final int? price;
  final String? location;
  final String? description;
  final List<SkillProgramImage>? image;
  final bool? isActive;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final SkillProgramType? type;
  final SkillProgramCategory? category;
  final SkillProgramSubCategory? subcategory;
  final SkillProgramStore? store;

  SkillProgram({
    this.id,
    this.title,
    this.typeId,
    this.storeId,
    this.categoryId,
    this.subcategoryId,
    this.programMode,
    this.duration,
    this.feesType,
    this.price,
    this.location,
    this.description,
    this.image,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.category,
    this.subcategory,
    this.store,
  });

  factory SkillProgram.fromJson(Map<String, dynamic> json) {
    return SkillProgram(
      id: json['id'],
      title: json['title'],
      typeId: json['type_id'],
      storeId: json['store_id'],
      categoryId: json['category_id'],
      subcategoryId: json['subcategory_id'],
      programMode: json['program_mode'],
      duration: json['duration'],
      feesType: json['fees_type'],
      price: json['price'],
      location: json['location'],
      description: json['description'],
      image: json['image'] != null
          ? List<SkillProgramImage>.from(
              json['image'].map((x) => SkillProgramImage.fromJson(x)))
          : [],
      isActive: json['is_active'],
      isDeleted: json['is_deleted'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      type: json['type'] != null
          ? SkillProgramType.fromJson(json['type'])
          : null,
      category: json['category'] != null
          ? SkillProgramCategory.fromJson(json['category'])
          : null,
      subcategory: json['subcategory'] != null
          ? SkillProgramSubCategory.fromJson(json['subcategory'])
          : null,
      store: json['store'] != null
          ? SkillProgramStore.fromJson(json['store'])
          : null,
    );
  }
}

// ============================================
// SKILL PROGRAM IMAGE MODEL
// ============================================

class SkillProgramImage {
  
  final String? path;
  final String? name;

  SkillProgramImage({
    
    this.path,
    this.name,
  });

  factory SkillProgramImage.fromJson(Map<String, dynamic> json) {
    return SkillProgramImage(
     
      path: json['path'],
      name: json['name'],
    );
  }
}

// ============================================
// SKILL PROGRAM TYPE MODEL
// ============================================

class SkillProgramType {
  final int? id;
  final String? name;

  SkillProgramType({
    this.id,
    this.name,
  });

  factory SkillProgramType.fromJson(Map<String, dynamic> json) {
    return SkillProgramType(
      id: json['id'],
      name: json['name'],
    );
  }
}

// ============================================
// SKILL PROGRAM CATEGORY MODEL
// ============================================

class SkillProgramCategory {
  final int? id;
  final String? name;

  SkillProgramCategory({
    this.id,
    this.name,
  });

  factory SkillProgramCategory.fromJson(Map<String, dynamic> json) {
    return SkillProgramCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}

// ============================================
// SKILL PROGRAM SUB-CATEGORY MODEL
// ============================================

class SkillProgramSubCategory {
  final int? id;
  final String? name;

  SkillProgramSubCategory({
    this.id,
    this.name,
  });

  factory SkillProgramSubCategory.fromJson(Map<String, dynamic> json) {
    return SkillProgramSubCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}

// ============================================
// SKILL PROGRAM STORE MODEL
// ============================================

class SkillProgramStore {
  final int? id;
  final String? name;

  SkillProgramStore({
    this.id,
    this.name,
  });

  factory SkillProgramStore.fromJson(Map<String, dynamic> json) {
    return SkillProgramStore(
      id: json['id'],
      name: json['name'],
    );
  }
}