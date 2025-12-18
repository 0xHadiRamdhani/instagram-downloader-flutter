import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class UrlInputWidget extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final String? errorText;
  final bool isLoading;

  const UrlInputWidget({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.onSubmitted,
    this.errorText,
    this.isLoading = false,
  });

  @override
  State<UrlInputWidget> createState() => _UrlInputWidgetState();
}

class _UrlInputWidgetState extends State<UrlInputWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              hintText: 'https://www.instagram.com/p/ABC123DEF/',
              prefixIcon: const Icon(Icons.link, color: AppColors.grey),
              suffixIcon: _buildSuffixIcon(),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: const BorderSide(color: AppColors.error, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppConstants.padding,
                vertical: 16,
              ),
            ),
            style: const TextStyle(fontSize: 16, fontFamily: 'InstagramSans'),
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.errorText!,
            style: const TextStyle(
              color: AppColors.error,
              fontSize: 14,
              fontFamily: 'InstagramSans',
            ),
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );
    }

    if (_controller.text.isNotEmpty) {
      return IconButton(
        icon: const Icon(Icons.clear, color: AppColors.grey),
        onPressed: () {
          _controller.clear();
          widget.onChanged('');
        },
      );
    }

    return IconButton(
      icon: const Icon(Icons.paste, color: AppColors.grey),
      onPressed: _pasteFromClipboard,
    );
  }

  Future<void> _pasteFromClipboard() async {
    try {
      // This would need to be implemented with actual clipboard access
      // For now, we'll just clear the field
      _controller.clear();
      widget.onChanged('');

      // You could implement actual clipboard paste here
      // final clipboardText = await Clipboard.getData('text/plain');
      // if (clipboardText?.text != null) {
      //   _controller.text = clipboardText!.text!;
      //   widget.onChanged(clipboardText.text!);
      // }
    } catch (e) {
      // Handle error
    }
  }
}
