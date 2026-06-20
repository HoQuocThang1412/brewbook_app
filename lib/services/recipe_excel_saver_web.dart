import 'dart:html' as html;
import 'dart:typed_data';

import 'recipe_excel_builder.dart';

Future<String> saveRecipeExcelBytes(Uint8List bytes) async {
  final blob = html.Blob(
    [bytes],
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  );
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..download = recipeExportFileName
    ..style.display = 'none';

  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);

  return 'Downloads/$recipeExportFileName';
}
