import 'package:flutter/material.dart';
import '../../core/themes/app_colors.dart'; // 假设 AppColors 定义在此路径

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  String? _selectedType;
  bool _isSubmitting = false;

  // 反馈类型选项
  final List<String> _feedbackTypes = [
    '建议',
    '错误报告',
    '功能请求',
    '用户体验',
    '其他'
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 48.0 : 24.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildTypeSelector(),
                const SizedBox(height: 24),
                _buildFeedbackField(),
                const SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.feedback_outlined,
          size: 40,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: 16),
        const Text(
          '您的意见对我们非常重要',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '请描述您遇到的问题或建议，我们会尽快处理',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '反馈类型',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _feedbackTypes.map((type) {
            return FeedbackTypeChip(
              label: type,
              isSelected: _selectedType == type,
              onSelected: (selected) {
                setState(() {
                  _selectedType = selected ? type : null;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFeedbackField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '详细描述',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _feedbackController,
          maxLines: 5,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: '请详细描述您的意见或建议...',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入反馈内容';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: _isSubmitting
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.textQuaternary,
          ),
        )
            : const Icon(
          Icons.send_outlined,
          color: AppColors.textTertiary,
        ),
        label: Text(
          _isSubmitting ? '提交中...' : '提交反馈',
          style: const TextStyle(color: AppColors.textQuaternary),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isSubmitting
            ? null
            : () async {
          if (_formKey.currentState!.validate()) {
            if (_selectedType == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('请选择反馈类型'),
                  backgroundColor: AppColors.snackBarBackground,
                ),
              );
              return;
            }
            setState(() => _isSubmitting = true);
            // 模拟提交过程
            await Future.delayed(const Duration(seconds: 2));
            setState(() => _isSubmitting = false);
            _showSuccessDialog();
          }
        },
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.dialogBackground,
        title: const Text(
          '提交成功',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          '感谢您的反馈，我们会尽快处理！',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '确定',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackTypeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const FeedbackTypeChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.textQuaternary : AppColors.textPrimary,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: _withCustomAlpha(AppColors.secondary,100),
      selectedColor: AppColors.primary,
      surfaceTintColor: AppColors.primary,
      shadowColor: AppColors.primary,
      selectedShadowColor: AppColors.primary,
      side: BorderSide.none,
      checkmarkColor: AppColors.textTertiary,
      elevation: 0,
    );
  }

  Color _withCustomAlpha(Color color, int alpha) {
    return Color.fromARGB(
      alpha.clamp(0, 255),
      (color.r * 255.0).toInt(),
      (color.g * 255.0).toInt(),
      (color.b * 255.0).toInt(),
    );
  }
}
