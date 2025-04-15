import 'dart:io';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';

Future<String> uploadImageToCloudinary(File imageFile) async {
  final cloudinary = Cloudinary.full(
    apiKey: '542826878257526',
    apiSecret: 'SoxrsYuf_hr-gJjW0RaBt8Mdwbc',
    cloudName: 'dy09leiov',
  );
  try {
    final response = await cloudinary.uploadResource(
      CloudinaryUploadResource(
        filePath: imageFile.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'reviews',
      ),
    );

    if (response.isSuccessful && response.secureUrl != null) {
      return response.secureUrl!;
    } else {
      throw Exception('Upload failed: ${response.error}');
    }
  } catch (e) {
    throw Exception('Cloudinary upload error: $e');
  }
}
