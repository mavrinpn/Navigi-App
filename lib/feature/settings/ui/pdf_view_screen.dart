import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:smart/services/storage_service.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/button/back_button.dart';

class PdfViewScreen extends StatefulWidget {
  const PdfViewScreen({
    super.key,
    required this.fileId,
    required this.title,
  });

  final String fileId;
  final String title;
  final String bucketId = 'documents';

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  late final String url;
  @override
  void initState() {
    super.initState();
    final fileStorageManager = context.read<FileStorageManager>();
    url = fileStorageManager.createViewUrl(
      widget.fileId,
      widget.bucketId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.appBarColor,
        elevation: 0,
        titleSpacing: 6,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomBackButton(),
            Expanded(
              child: Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: AppTypography.font20black,
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.grey,
      body: PdfViewer.openFutureFile(
        () async => (await DefaultCacheManager().getSingleFile(url)).path,
        params: const PdfViewerParams(
          padding: 10,
          minScale: 1.0,
        ),
      ),
    );
  }
}
