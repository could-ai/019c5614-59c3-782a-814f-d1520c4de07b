import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';

class PreviewArea extends StatelessWidget {
  final XFile? selectedImage;
  final VoidCallback onPickImage;
  final bool isGenerating;
  final bool resultReady;
  final String selectedModel;
  final String selectedPose;
  final String selectedBackground;

  const PreviewArea({
    super.key,
    required this.selectedImage,
    required this.onPickImage,
    required this.isGenerating,
    required this.resultReady,
    required this.selectedModel,
    required this.selectedPose,
    required this.selectedBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FA),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview Workspace',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload your product and see the magic happen.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              children: [
                // Upload / Input Area
                Expanded(
                  child: _buildUploadCard(context),
                ),
                const SizedBox(width: 24),
                // Result Area
                Expanded(
                  child: _buildResultCard(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.upload_file, color: Color(0xFF6C63FF)),
                const SizedBox(width: 8),
                Text(
                  'Product Image',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GestureDetector(
                onTap: onPickImage,
                child: selectedImage == null
                    ? DottedBorder(
                        color: Colors.grey.shade400,
                        strokeWidth: 2,
                        dashPattern: const [8, 4],
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Click to upload',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Supports JPG, PNG',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: kIsWeb 
                                  ? NetworkImage(selectedImage!.path) 
                                  : FileImage(File(selectedImage!.path)) as ImageProvider,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              onPressed: onPickImage,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.red,
                              ),
                              icon: const Icon(Icons.edit),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: Color(0xFF6C63FF)),
                const SizedBox(width: 8),
                Text(
                  'Generated Model',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: isGenerating
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: Color(0xFF6C63FF),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'AI is working its magic...',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                    : resultReady
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Placeholder for the generated image
                                // In a real app, this would be the URL from the backend
                                Container(
                                  color: _getBackgroundColor(selectedBackground),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          _getModelIcon(selectedModel),
                                          size: 100,
                                          color: Colors.black26,
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          'Model: ${_getModelName(selectedModel)}',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text('Pose: $selectedPose'),
                                        const SizedBox(height: 20),
                                        if (selectedImage != null)
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.white, width: 2),
                                              borderRadius: BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: kIsWeb 
                                                  ? NetworkImage(selectedImage!.path) 
                                                  : FileImage(File(selectedImage!.path)) as ImageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 16,
                                  right: 16,
                                  child: FloatingActionButton.small(
                                    onPressed: () {},
                                    child: const Icon(Icons.download),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 48,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No result yet',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(String bgId) {
    switch (bgId) {
      case 'outdoor': return Colors.green.shade100;
      case 'urban': return Colors.blueGrey.shade100;
      case 'beach': return Colors.orange.shade100;
      case 'studio':
      default: return Colors.grey.shade200;
    }
  }

  IconData _getModelIcon(String modelId) {
    switch (modelId) {
      case 'model_2': return Icons.face_3; // Indian
      case 'model_3': return Icons.directions_run;
      case 'model_4': return Icons.emoji_people;
      case 'model_1':
      default: return Icons.person;
    }
  }

  String _getModelName(String modelId) {
    switch (modelId) {
      case 'model_2': return 'Indian';
      case 'model_3': return 'Athletic';
      case 'model_4': return 'Casual';
      case 'model_1':
      default: return 'Classic';
    }
  }
}
