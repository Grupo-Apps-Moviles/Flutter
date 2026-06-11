import 'package:waypass_app/features/travel/domain/stop.dart';

class StopDto {
  final int id;
  final String name;
  final String imageUrl;
  final String address;

  const StopDto({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.address,
  });

  factory StopDto.fromJson(Map<String, dynamic> json) {
    return StopDto(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Stop toDomain() {
    return Stop(
      id: id,
      name: name,
      imageUrl: imageUrl,
      address: address,
    );
  }
}