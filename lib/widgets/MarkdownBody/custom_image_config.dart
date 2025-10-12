import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markdown_widget/markdown_widget.dart';

class CustomImgConfig extends ImgConfig {
  final bool wrapWithViewer;

  final BoxFit rasterFit;

  final BoxFit svgFit;

  final AlignmentGeometry alignment;

  CustomImgConfig({
    this.wrapWithViewer = true,
    this.rasterFit = BoxFit.cover,
    this.svgFit = BoxFit.scaleDown,
    this.alignment = Alignment.center,
    super.errorBuilder,
  }) : super(
         builder: (url, attrs) {
           double? width;
           double? height;
           try {
             final w = attrs['width'];
             final h = attrs['height'];
             if (w != null && w.trim().isNotEmpty) {
               width = double.tryParse(w) ?? 0;
             }
             if (h != null && h.trim().isNotEmpty) {
               height = double.tryParse(h) ?? 0;
             }
           } catch (_) {}

           final alt = attrs['alt'] ?? '';
           final lower = url.toLowerCase();
           final isNetwork = url.startsWith('http');
           final isSvg =
               lower.endsWith('.svg') ||
               attrs['type']?.toLowerCase() == 'image/svg+xml';

           Widget buildError(Object error) {
             if (errorBuilder != null) return errorBuilder(url, alt, error);

             return Row(
               mainAxisSize: MainAxisSize.min,
               children: [
                 const Icon(
                   Icons.broken_image,
                   color: Colors.redAccent,
                   size: 16,
                 ),
                 if (alt.isNotEmpty) ...[
                   const SizedBox(width: 6),
                   Flexible(child: Text(alt)),
                 ],
               ],
             );
           }

           Widget img;

           if (isSvg) {
             img = isNetwork
                 ? SvgPicture.network(
                     url,
                     width: width,
                     height: height,
                     fit: svgFit,
                     alignment: alignment,
                     clipBehavior: Clip.none,
                     errorBuilder: (ctx, error, stack) => buildError(error),
                   )
                 : SvgPicture.asset(
                     url,
                     width: width,
                     height: height,
                     fit: svgFit,
                     alignment: alignment,
                     clipBehavior: Clip.none,
                     errorBuilder: (ctx, error, stack) => buildError(error),
                   );
           } else {
             img = isNetwork
                 ? Image.network(
                     url,
                     width: width,
                     height: height,
                     fit: rasterFit,
                     alignment: alignment,
                     errorBuilder: (ctx, error, stack) => buildError(error),
                   )
                 : Image.asset(
                     url,
                     width: width,
                     height: height,
                     fit: rasterFit,
                     alignment: alignment,
                     errorBuilder: (ctx, error, stack) => buildError(error),
                   );
           }

           if (!wrapWithViewer) return img;

           return Builder(
             builder: (context) {
               return InkWell(
                 child: Hero(tag: img.hashCode, child: img),
                 onTap: () async {
                   await Navigator.of(context).push(
                     PageRouteBuilder(
                       opaque: false,
                       pageBuilder: (_, _, _) => _ImageViewer(child: img),
                     ),
                   );
                 },
               );
             },
           );
         },
       );
}

class _ImageViewer extends StatelessWidget {
  final Widget child;

  const _ImageViewer({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black.toOpacity(0.3),
        body: Stack(
          fit: StackFit.expand,
          children: [
            InteractiveViewer(
              child: Center(
                child: Hero(tag: child.hashCode, child: child),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.toOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.clear, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
