import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'recipe_excel_builder.dart';

Future<String> saveRecipeExcelBytes(Uint8List bytes) async {
  if (Platform.isAndroid) {
    return _shareExcelOnAndroid(bytes);
  }

  final filePath = await _downloadsFilePath();
  final file = File(filePath);
  await file.parent.create(recursive: true);
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

Future<String> _shareExcelOnAndroid(Uint8List bytes) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}${Platform.pathSeparator}$recipeExportFileName');
  await file.writeAsBytes(bytes, flush: true);

  await Share.shareXFiles(
    [XFile(file.path, mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')],
    subject: 'Công thức pha chế BrewBook',
    text: 'File Excel công thức pha chế BrewBook',
  );

  return file.path;
}

Future<String> _downloadsFilePath() async {
  final home = Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'];
  if (home != null && home.trim().isNotEmpty) {
    return '$home${Platform.pathSeparator}Downloads${Platform.pathSeparator}$recipeExportFileName';
  }

  final dir = await getApplicationDocumentsDirectory();
  return '${dir.path}${Platform.pathSeparator}$recipeExportFileName';
}
