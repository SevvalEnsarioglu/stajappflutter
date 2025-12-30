import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import '../config/theme.dart';

class RichTextEditorWidget extends StatefulWidget {
  final Function(String) onChanged;
  final String placeholder;
  final double height;

  const RichTextEditorWidget({
    super.key,
    required this.onChanged,
    this.placeholder = 'İçeriğinizi buraya yazın...',
    this.height = 300,
  });

  @override
  State<RichTextEditorWidget> createState() => _RichTextEditorWidgetState();
}

class _RichTextEditorWidgetState extends State<RichTextEditorWidget> {
  final QuillController _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onEditorChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onEditorChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onEditorChanged() {
    final delta = _controller.document.toDelta().toJson();
    final converter = QuillDeltaToHtmlConverter(
      List.castFrom(delta),
      ConverterOptions.forEmail(),
    );
    final html = converter.convert();
    widget.onChanged(html);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceLight),
      ),
      child: Column(
        children: [
          Theme(
             data: Theme.of(context).copyWith(
               // Customize toolbar widget colors if needed, but defaults are usually okay
               // AppTheme.surfaceDark is dark, so icons should be light.
               // Default Quill theme generally adapts, but we might need specific icon theme
             ),
            child: QuillSimpleToolbar(
              controller: _controller,
              config: const QuillSimpleToolbarConfig(
                showFontFamily: false,
                showSearchButton: false,
                showIndent: false,
                showSubscript: false,
                showSuperscript: false,
                showInlineCode: false,
                showCodeBlock: false,
                showQuote: false,
                
                // Keep these to match Web:
                showBoldButton: true,
                showItalicButton: true,
                showUnderLineButton: true,
                showStrikeThrough: false,
                
                showColorButton: true,
                showBackgroundColorButton: false, 
                
                showClearFormat: false,
                
                showHeaderStyle: true,
                
                showListNumbers: true,
                showListBullets: true,
                showListCheck: false,
                
                showLink: true,
                
                showFontSize: true,
                
                toolbarSectionSpacing: 4,
                buttonOptions: QuillSimpleToolbarButtonOptions(
                  base: QuillToolbarBaseButtonOptions(
                   iconTheme: QuillIconTheme(
                     iconButtonUnselectedData: IconButtonData(
                       color: AppTheme.textSecondary,
                     ),
                     iconButtonSelectedData: IconButtonData(
                       color: AppTheme.primaryColor,
                     ),
                   ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: AppTheme.surfaceLight),
          Expanded(
            child: QuillEditor.basic(
              controller: _controller,
              config: QuillEditorConfig(
                placeholder: widget.placeholder,
                padding: const EdgeInsets.all(16),
                // Custom styles removed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
