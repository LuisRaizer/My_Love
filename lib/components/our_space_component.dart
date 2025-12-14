import 'package:app/widgets/confirmation_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:app/utils/personal_content.dart';
import 'package:app/controllers/app_controller.dart';
import 'package:app/controllers/timer_controller.dart';
import 'package:app/services/photo_service.dart';

class OurSpaceComponent extends StatefulWidget {
  final AppController appController;
  final TimerController timerController;

  const OurSpaceComponent({
    super.key,
    required this.appController,
    required this.timerController,
  });

  @override
  State<OurSpaceComponent> createState() => _OurSpaceComponentState();
}

class _OurSpaceComponentState extends State<OurSpaceComponent> {
  List<Map<String, dynamic>> _defaultPhotos = [];
  List<Map<String, dynamic>> _savedPhotos = [];
  List<Map<String, dynamic>> _galleryPhotos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    setState(() => _isLoading = true);

    _defaultPhotos = PersonalConfig.galleryPhotos;

    _savedPhotos = await PhotoService.loadPhotos();

    _galleryPhotos = [..._defaultPhotos, ..._savedPhotos];

    setState(() => _isLoading = false);
  }

  Future<void> _addPhotoFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      _showAddPhotoDialog(pickedFile);
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  Future<void> _showAddPhotoDialog(XFile pickedFile) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Adicionar Foto'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(File(pickedFile.path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFFe83f3f),
                                  onPrimary: Colors.white,
                                  surface: Colors.white,
                                  onSurface: Colors.black,
                                ),
                                dialogBackgroundColor: Colors.white,
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 94, 94, 94),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDate(selectedDate),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              color: Color(0xFFe83f3f),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      maxLength: 150,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.trim().isNotEmpty) {
                      final compressedImage =
                          await PhotoService.compressAndSaveImage(
                            pickedFile.path,
                          );

                      if (compressedImage != null) {
                        final newPhoto = {
                          'image': compressedImage.path,
                          'title': titleController.text.trim(),
                          'date': _formatDate(selectedDate),
                          'description': descriptionController.text.trim(),
                        };

                        await PhotoService.addPhoto(newPhoto);
                        await _loadPhotos();

                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erro ao processar imagem'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _removePhoto(int index) async {
    if (index < _defaultPhotos.length) {
      return;
    }

    final savedIndex = index - _defaultPhotos.length;

    showDialog(
      context: context,
      builder: (context) => ConfirmationWidget(
        title: 'Remover Foto',
        content:
            'Tem certeza que deseja remover "${_galleryPhotos[index]['title']}"?',
        confirmText: 'Remover',
        confirmColor: Colors.red,
        icon: Icons.delete,
        onConfirm: () async {
          await PhotoService.removePhoto(savedIndex);
          await _loadPhotos();
        },
      ),
    );
  }

  bool _isAssetImage(String imagePath) {
    return imagePath.startsWith('lib/assets');
  }

  Widget _buildImageWidget(String imagePath) {
    if (_isAssetImage(imagePath)) {
      return Image.asset(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    }

    return FutureBuilder<File>(
      future: PhotoService.getOptimizedImage(imagePath),
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return _buildErrorWidget();
        }

        final file = snapshot.data!;

        return Image.file(
          file,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget();
          },
        );
      },
    );
  }

  Widget _buildDialogImageWidget(String imagePath) {
    if (_isAssetImage(imagePath)) {
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildDialogErrorWidget();
        },
      );
    }

    return FutureBuilder<File>(
      future: PhotoService.getOptimizedImage(imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: const Color(0xFF87CEEB).withOpacity(0.3),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return _buildDialogErrorWidget();
        }

        final file = snapshot.data!;

        return Image.file(
          file,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildDialogErrorWidget();
          },
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: const Color(0xFF87CEEB).withOpacity(0.4),
      child: const Center(
        child: Icon(Icons.photo, size: 50, color: Color(0xFFe83f3f)),
      ),
    );
  }

  Widget _buildDialogErrorWidget() {
    return Container(
      color: const Color(0xFF87CEEB).withOpacity(0.3),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.photo, size: 80, color: Color(0xFFe83f3f)),
            const SizedBox(height: 16),
            const Text(
              'Imagem não encontrada',
              style: TextStyle(fontSize: 16, color: Color(0xFFe83f3f)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTimerCard(),
        const SizedBox(height: 8),
        Expanded(child: _buildPhotosCard(context)),
      ],
    );
  }

  Widget _buildTimerCard() {
    return ListenableBuilder(
      listenable: widget.timerController,
      builder: (context, child) {
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              children: [
                const Text(
                  'Nosso Tempinho Juntos...',
                  style: TextStyle(fontFamily: 'FredokaOne', fontSize: 20),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.timerController.getFormattedTime(),
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Desde aquele dia na Unifor 💚',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhotosCard(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final photos = _galleryPhotos;
    final totalItems = photos.length + 1;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.photo_library, color: Color(0xFFe83f3f)),
                const SizedBox(width: 10),
                const Text(
                  'Algumas fotinhas',
                  style: TextStyle(fontFamily: 'FredokaOne', fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: totalItems,
                itemBuilder: (context, index) {
                  if (index == photos.length) {
                    return GestureDetector(
                      onTap: _addPhotoFromGallery,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xFF87CEEB).withOpacity(0.2),
                          border: Border.all(
                            color: const Color(0xFFe83f3f),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Color(0xFFe83f3f),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Adicionar Foto',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFe83f3f),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final photo = photos[index];
                  return GestureDetector(
                    onLongPress: () => _removePhoto(index),
                    onTap: () {
                      _showPhotoDialog(context, photo);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFF87CEEB).withOpacity(0.2),
                        border: Border.all(
                          color: const Color(0xFFe83f3f),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: _buildImageWidget(photo['image']),
                          ),

                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(14),
                                  bottomRight: Radius.circular(14),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.9),
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                              ),
                              height: 60,
                            ),
                          ),

                          Positioned(
                            bottom: 4,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                photo['title'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                photo['date'] ?? '00/00/0000',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.zoom_in,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoDialog(BuildContext context, Map<String, dynamic> photo) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFe83f3f),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            photo['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                photo['date'] ?? '00/00/0000',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.7,
                    ),
                    child: InteractiveViewer(
                      panEnabled: true,
                      scaleEnabled: true,
                      boundaryMargin: const EdgeInsets.all(20),
                      minScale: 0.5,
                      maxScale: 3.0,
                      child: ClipRRect(
                        child: _buildDialogImageWidget(photo['image']),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 10,
                    right: 10,
                    child: Icon(Icons.zoom_in, color: Colors.white),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      photo['description'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
