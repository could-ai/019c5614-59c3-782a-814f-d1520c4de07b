import 'package:flutter/material.dart';

class OptionsPanel extends StatelessWidget {
  final String selectedModel;
  final String selectedPose;
  final String selectedBackground;
  final Function(String) onModelChanged;
  final Function(String) onPoseChanged;
  final Function(String) onBackgroundChanged;
  final VoidCallback onGenerate;
  final bool isGenerating;

  const OptionsPanel({
    super.key,
    required this.selectedModel,
    required this.selectedPose,
    required this.selectedBackground,
    required this.onModelChanged,
    required this.onPoseChanged,
    required this.onBackgroundChanged,
    required this.onGenerate,
    required this.isGenerating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Configuration',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          
          // Model Selection
          _buildSectionTitle(context, 'Select Model'),
          const SizedBox(height: 12),
          _buildModelSelector(),

          const SizedBox(height: 24),

          // Pose Selection
          _buildSectionTitle(context, 'Select Pose'),
          const SizedBox(height: 12),
          _buildPoseSelector(),

          const SizedBox(height: 24),

          // Background Selection
          _buildSectionTitle(context, 'Background'),
          const SizedBox(height: 12),
          _buildBackgroundSelector(),

          const SizedBox(height: 40),

          // Generate Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: isGenerating ? null : onGenerate,
              icon: isGenerating 
                  ? const SizedBox(
                      width: 20, 
                      height: 20, 
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                    ) 
                  : const Icon(Icons.auto_awesome),
              label: Text(isGenerating ? 'Generating...' : 'Generate Model'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildModelSelector() {
    final models = [
      {'id': 'model_1', 'name': 'Classic', 'icon': Icons.person},
      {'id': 'model_2', 'name': 'Indian', 'icon': Icons.face_3},
      {'id': 'model_3', 'name': 'Athletic', 'icon': Icons.directions_run},
      {'id': 'model_4', 'name': 'Casual', 'icon': Icons.emoji_people},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: models.map((model) {
        final isSelected = selectedModel == model['id'];
        return InkWell(
          onTap: () => onModelChanged(model['id'] as String),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 70,
            height: 90,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF6C63FF).withOpacity(0.1) : Colors.grey[100],
              border: Border.all(
                color: isSelected ? const Color(0xFF6C63FF) : Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  model['icon'] as IconData,
                  color: isSelected ? const Color(0xFF6C63FF) : Colors.grey[600],
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  model['name'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? const Color(0xFF6C63FF) : Colors.grey[800],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPoseSelector() {
    final poses = [
      {'id': 'standing', 'label': 'Standing'},
      {'id': 'walking', 'label': 'Walking'},
      {'id': 'sitting', 'label': 'Sitting'},
      {'id': 'hands_pocket', 'label': 'Hands in Pocket'},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: poses.map((pose) {
        final isSelected = selectedPose == pose['id'];
        return ChoiceChip(
          label: Text(pose['label'] as String),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) onPoseChanged(pose['id'] as String);
          },
          selectedColor: const Color(0xFF6C63FF).withOpacity(0.2),
          labelStyle: TextStyle(
            color: isSelected ? const Color(0xFF6C63FF) : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBackgroundSelector() {
    final backgrounds = [
      {'id': 'studio', 'color': Colors.grey[200], 'label': 'Studio'},
      {'id': 'outdoor', 'color': Colors.green[100], 'label': 'Outdoor'},
      {'id': 'urban', 'color': Colors.blueGrey[100], 'label': 'Urban'},
      {'id': 'beach', 'color': Colors.orange[100], 'label': 'Beach'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: backgrounds.map((bg) {
        final isSelected = selectedBackground == bg['id'];
        return GestureDetector(
          onTap: () => onBackgroundChanged(bg['id'] as String),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: bg['color'] as Color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF6C63FF) : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      )
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                bg['label'] as String,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
