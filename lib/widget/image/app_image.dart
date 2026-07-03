import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constant/app_api_url.dart';
import '../AppLoader/app_loader.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    this.color = Colors.grey,
    this.fit = BoxFit.fill,
    this.height,
    this.path,
    this.url,
    this.width,
    this.filePath,
    this.iconColor,
  });

  final String? path;
  final String? filePath;
  final String? url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Color color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return _buildImage();
  }

  Widget _buildImage() {
    if (filePath != null) {
      return Image.file(
        File(filePath!),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) =>
            _PlaceholderWidget(width: width, height: height),
      );
    }

    if (url != null) {
      if (url!.isEmpty || url!.toLowerCase().contains("null")) {
        return _PlaceholderWidget(width: width, height: height);
      }
      return _NetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: fit,
      );
    }

    if (path != null) {
      return Image.asset(
        path!,
        width: width,
        height: height,
        fit: fit,
        color: iconColor,
        errorBuilder: (_, __, ___) =>
            _PlaceholderWidget(width: width, height: height),
      );
    }

    return _PlaceholderWidget(width: width, height: height);
  }
}

class _NetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const _NetworkImage({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final String resolvedUrl = AppApiUrl.resolveImageUrl(imageUrl);
    
    return CachedNetworkImage(
      imageUrl: resolvedUrl,
      width: width,
      height: height,
      fit: fit,
      // ─── Optimization ────────────────────────────────
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
      useOldImageOnUrlChange: true,
      filterQuality: FilterQuality.low, // Faster rendering
      // ────────────────────────────────────────────────
      placeholder: (context, url) => _LoadingWidget(width: width, height: height),
      errorWidget: (context, url, error) =>
          _PlaceholderWidget(width: width, height: height),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const _LoadingWidget({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade100,
      child: Center(child: AppLoader(size: 30.sp)),
    );
  }
}

class _PlaceholderWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const _PlaceholderWidget({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade100,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 48,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class CustomHttpClient extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}