import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class PhotoService {
  static const String _photosKey = 'user_gallery_photos';

  static Future<void> savePhotos(List<Map<String, dynamic>> photos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(photos);
      await prefs.setString(_photosKey, encoded);
    } catch (e) {
      print('Erro ao salvar fotos: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> loadPhotos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = prefs.getString(_photosKey);
      
      if (encoded != null) {
        final decoded = jsonDecode(encoded) as List;
        return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
      }
    } catch (e) {
      print('Erro ao carregar fotos: $e');
    }
    
    return [];
  }

  static Future<void> addPhoto(Map<String, dynamic> photo) async {
    final photos = await loadPhotos();
    photos.add(photo);
    await savePhotos(photos);
  }

  static Future<void> removePhoto(int index) async {
    final photos = await loadPhotos();
    if (index >= 0 && index < photos.length) {
      final photo = photos[index];
      final imagePath = photo['image'];
      await _deleteImageFile(imagePath);
      
      photos.removeAt(index);
      await savePhotos(photos);
    }
  }

  static Future<void> _deleteImageFile(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        print('🗑️ Arquivo removido (usuário deletou foto): $imagePath');
      }
    } catch (e) {
      print('❌ Erro ao remover arquivo: $e');
    }
  }

  static Future<File?> compressAndSaveImage(String imagePath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'gallery_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final targetPath = '${appDir.path}/$fileName';
      
      final originalFile = File(imagePath);
      final originalSize = await originalFile.length();
      print('📷 Tamanho original: ${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB');

      int quality = 35;
      
      final result = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        targetPath,
        quality: quality,
        format: CompressFormat.jpeg,
        autoCorrectionAngle: true,
      );
      
      if (result != null) {
        final compressedFile = File(result.path);
        final compressedSize = await compressedFile.length();
        final sizeInMB = compressedSize / (1024 * 1024);
        
        print('✅ Imagem comprimida: ${sizeInMB.toStringAsFixed(2)} MB');
        print('   Qualidade: $quality%');
        
        return compressedFile;
      }
    } catch (e) {
      print('❌ Erro ao comprimir imagem: $e');
    }
    
    return File(imagePath);
  }

  static Future<File> getOptimizedImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        return file;
      }
    } catch (e) {
      print('❌ Erro ao carregar imagem: $e');
    }
    
    return File(imagePath);
  }
}