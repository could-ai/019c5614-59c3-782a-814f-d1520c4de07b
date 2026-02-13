import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/options_panel.dart';
import '../widgets/preview_area.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? _selectedImage;
  String _selectedModel = 'model_1';
  String _selectedPose = 'standing';
  String _selectedBackground = 'studio';
  bool _isGenerating = false;
  bool _resultReady = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
        _resultReady = false;
      });
    }
  }

  void _updateModel(String modelId) {
    setState(() {
      _selectedModel = modelId;
    });
  }

  void _updatePose(String poseId) {
    setState(() {
      _selectedPose = poseId;
    });
  }

  void _updateBackground(String bgId) {
    setState(() {
      _selectedBackground = bgId;
    });
  }

  Future<void> _generateImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a product image first.')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _resultReady = false;
    });

    // Simulate AI generation delay
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isGenerating = false;
      _resultReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Fashion Studio'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.help_outline),
            label: const Text('Help'),
          ),
          const SizedBox(width: 16),
          FilledButton(
            onPressed: () {},
            child: const Text('Export'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive Layout
          if (constraints.maxWidth > 900) {
            // Desktop / Wide Web Layout
            return Row(
              children: [
                // Left Sidebar (Options)
                SizedBox(
                  width: 350,
                  child: OptionsPanel(
                    selectedModel: _selectedModel,
                    selectedPose: _selectedPose,
                    selectedBackground: _selectedBackground,
                    onModelChanged: _updateModel,
                    onPoseChanged: _updatePose,
                    onBackgroundChanged: _updateBackground,
                    onGenerate: _generateImage,
                    isGenerating: _isGenerating,
                  ),
                ),
                const VerticalDivider(width: 1),
                // Main Content (Preview & Upload)
                Expanded(
                  child: PreviewArea(
                    selectedImage: _selectedImage,
                    onPickImage: _pickImage,
                    isGenerating: _isGenerating,
                    resultReady: _resultReady,
                    selectedModel: _selectedModel,
                    selectedPose: _selectedPose,
                    selectedBackground: _selectedBackground,
                  ),
                ),
              ],
            );
          } else {
            // Mobile / Tablet Layout
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 600,
                    child: PreviewArea(
                      selectedImage: _selectedImage,
                      onPickImage: _pickImage,
                      isGenerating: _isGenerating,
                      resultReady: _resultReady,
                      selectedModel: _selectedModel,
                      selectedPose: _selectedPose,
                      selectedBackground: _selectedBackground,
                    ),
                  ),
                  const Divider(height: 1),
                  OptionsPanel(
                    selectedModel: _selectedModel,
                    selectedPose: _selectedPose,
                    selectedBackground: _selectedBackground,
                    onModelChanged: _updateModel,
                    onPoseChanged: _updatePose,
                    onBackgroundChanged: _updateBackground,
                    onGenerate: _generateImage,
                    isGenerating: _isGenerating,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
