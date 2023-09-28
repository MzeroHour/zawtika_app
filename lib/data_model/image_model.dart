class MediaImage {
  int? id;
  int? modelId;
  String? fileName;
  String? url;

  MediaImage({
    this.id,
    this.modelId,
    this.fileName,
    this.url,
  });

  factory MediaImage.fromJson(Map<String, dynamic> json) => MediaImage(
        id: json['id'] ?? 0,
        modelId: json['model_id'],
        fileName: json['file_name'],
        url: json['url'],
      );
}
