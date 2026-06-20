import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

import '../models/recipe.dart';

const String recipeExportFileName = 'Cong_thuc_pha_che.xlsx';
const String baseIngredientCategory = 'Nguyên liệu nền';

const List<String> recipeExportCategoryOrder = [
  baseIngredientCategory,
  'Cà phê',
  'Trà Thanh nhiệt',
  'Đá xay & sinh tố',
];

Uint8List buildRecipeExcelWorkbook(List<Recipe> recipes) {
  final groups = _groupRecipes(recipes);
  final archive = Archive();

  archive.addFile(_textFile('[Content_Types].xml', _contentTypesXml(groups.length)));
  archive.addFile(_textFile('_rels/.rels', _rootRelsXml()));
  archive.addFile(_textFile('xl/workbook.xml', _workbookXml(groups)));
  archive.addFile(_textFile('xl/_rels/workbook.xml.rels', _workbookRelsXml(groups.length)));
  archive.addFile(_textFile('xl/styles.xml', _stylesXml()));

  for (var i = 0; i < groups.length; i++) {
    archive.addFile(
      _textFile('xl/worksheets/sheet${i + 1}.xml', _worksheetXml(groups[i])),
    );
  }

  final bytes = ZipEncoder().encode(archive) ?? <int>[];
  return Uint8List.fromList(bytes);
}

List<_RecipeGroup> _groupRecipes(List<Recipe> recipes) {
  final activeRecipes = recipes.where((r) => r.status == RecipeStatus.dangBan).toList();
  final result = <_RecipeGroup>[];

  for (final category in recipeExportCategoryOrder) {
    final items = activeRecipes.where((r) => r.category.trim() == category).toList();
    if (items.isNotEmpty) result.add(_RecipeGroup(category, items));
  }

  final known = recipeExportCategoryOrder.toSet();
  final otherCategories = activeRecipes
      .map((r) => r.category.trim())
      .where((category) => category.isNotEmpty && !known.contains(category))
      .toSet()
      .toList()
    ..sort();

  for (final category in otherCategories) {
    final items = activeRecipes.where((r) => r.category.trim() == category).toList();
    if (items.isNotEmpty) result.add(_RecipeGroup(category, items));
  }

  return result.isEmpty ? [_RecipeGroup('Công thức', const [])] : result;
}

String _worksheetXml(_RecipeGroup group) {
  final rows = <_ExcelRow>[];
  final merges = <String>[];
  var row = 1;

  rows.add(_ExcelRow(row, [_cell('A$row', group.name.toUpperCase(), 1)], height: 30));
  merges.add('A$row:C$row');
  row += 2;

  if (group.recipes.isEmpty) {
    rows.add(_ExcelRow(row, [_cell('A$row', 'Không có công thức đang bán', 5)], height: 24));
    merges.add('A$row:C$row');
  }

  for (final recipe in group.recipes) {
    rows.add(_ExcelRow(row, [_cell('A$row', recipe.name.toUpperCase(), 2)], height: 26));
    merges.add('A$row:C$row');
    row++;

    rows.add(_ExcelRow(row, [
      _cell('A$row', 'Nguyên liệu', 3),
      _cell('B$row', 'Định lượng', 3),
      _cell('C$row', 'Ghi nhanh', 3),
    ], height: 22));
    row++;

    for (final ingredient in recipe.ingredients) {
      rows.add(_ExcelRow(row, [
        _cell('A$row', ingredient.name, 4),
        _cell('B$row', _formatIngredientQuantity(ingredient.quantity, ingredient.unit), 4),
        _cell('C$row', '', 4),
      ], height: 22));
      row++;
    }

    if (recipe.steps.isNotEmpty) {
      rows.add(_ExcelRow(row, [_cell('A$row', 'Cách pha', 3)], height: 22));
      merges.add('A$row:C$row');
      row++;

      for (var i = 0; i < recipe.steps.length; i++) {
        rows.add(_ExcelRow(row, [_cell('A$row', '${i + 1}. ${recipe.steps[i]}', 5)], height: 30));
        merges.add('A$row:C$row');
        row++;
      }
    }

    row++;
  }

  final rowXml = rows.map((r) => r.toXml()).join();
  final mergeXml = merges.isEmpty
      ? ''
      : '<mergeCells count="${merges.length}">${merges.map((m) => '<mergeCell ref="$m"/>').join()}</mergeCells>';

  return '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <sheetPr><pageSetUpPr fitToPage="1"/></sheetPr>
  <sheetViews><sheetView workbookViewId="0"/></sheetViews>
  <sheetFormatPr defaultRowHeight="22"/>
  <cols>
    <col min="1" max="1" width="28" customWidth="1"/>
    <col min="2" max="2" width="18" customWidth="1"/>
    <col min="3" max="3" width="26" customWidth="1"/>
  </cols>
  <sheetData>$rowXml</sheetData>
  $mergeXml
  <pageMargins left="0.35" right="0.35" top="0.45" bottom="0.45" header="0.2" footer="0.2"/>
  <pageSetup paperSize="9" orientation="portrait" fitToWidth="1" fitToHeight="0"/>
</worksheet>''';
}

String _formatIngredientQuantity(double quantity, String unit) {
  final cleanUnit = unit.trim();
  if (quantity <= 0) return cleanUnit;

  final quantityText = quantity == quantity.roundToDouble() ? quantity.toInt().toString() : quantity.toString();
  return cleanUnit.isEmpty ? quantityText : '$quantityText $cleanUnit';
}

ArchiveFile _textFile(String path, String content) {
  final bytes = utf8.encode(content);
  return ArchiveFile(path, bytes.length, bytes);
}

_ExcelCell _cell(String ref, String value, int style) => _ExcelCell(ref, value, style);

String _contentTypesXml(int sheetCount) {
  final sheetOverrides = List.generate(
    sheetCount,
    (i) => '<Override PartName="/xl/worksheets/sheet${i + 1}.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>',
  ).join();

  return '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
  <Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>
  $sheetOverrides
</Types>''';
}

String _rootRelsXml() => '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
</Relationships>''';

String _workbookXml(List<_RecipeGroup> groups) {
  final sheets = List.generate(groups.length, (i) {
    return '<sheet name="${_xmlAttr(_safeSheetName(groups[i].name))}" sheetId="${i + 1}" r:id="rId${i + 1}"/>';
  }).join();

  return '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <sheets>$sheets</sheets>
</workbook>''';
}

String _workbookRelsXml(int sheetCount) {
  final sheetRels = List.generate(sheetCount, (i) {
    return '<Relationship Id="rId${i + 1}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet${i + 1}.xml"/>';
  }).join();
  final styleId = sheetCount + 1;

  return '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  $sheetRels
  <Relationship Id="rId$styleId" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>''';
}

String _stylesXml() => '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
  <fonts count="3">
    <font><sz val="14"/><name val="Times New Roman"/></font>
    <font><b/><sz val="20"/><name val="Times New Roman"/></font>
    <font><b/><sz val="15"/><name val="Times New Roman"/></font>
  </fonts>
  <fills count="2">
    <fill><patternFill patternType="none"/></fill>
    <fill><patternFill patternType="gray125"/></fill>
  </fills>
  <borders count="2">
    <border><left/><right/><top/><bottom/><diagonal/></border>
    <border><left style="thin"><color auto="1"/></left><right style="thin"><color auto="1"/></right><top style="thin"><color auto="1"/></top><bottom style="thin"><color auto="1"/></bottom><diagonal/></border>
  </borders>
  <cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>
  <cellXfs count="6">
    <xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0" applyAlignment="1"><alignment vertical="top" wrapText="1"/></xf>
    <xf numFmtId="0" fontId="1" fillId="0" borderId="0" xfId="0" applyAlignment="1"><alignment horizontal="center" vertical="center" wrapText="1"/></xf>
    <xf numFmtId="0" fontId="2" fillId="0" borderId="1" xfId="0" applyAlignment="1"><alignment horizontal="center" vertical="center" wrapText="1"/></xf>
    <xf numFmtId="0" fontId="2" fillId="0" borderId="1" xfId="0" applyAlignment="1"><alignment horizontal="center" vertical="center" wrapText="1"/></xf>
    <xf numFmtId="0" fontId="0" fillId="0" borderId="1" xfId="0" applyAlignment="1"><alignment vertical="top" wrapText="1"/></xf>
    <xf numFmtId="0" fontId="0" fillId="0" borderId="1" xfId="0" applyAlignment="1"><alignment vertical="top" wrapText="1"/></xf>
  </cellXfs>
  <cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>
</styleSheet>''';

String _safeSheetName(String name) {
  final cleaned = name.replaceAll(RegExp(r'[\\/*?:\[\]]'), ' ').trim();
  if (cleaned.length <= 31) return cleaned;
  return cleaned.substring(0, 31);
}

String _xmlText(String value) => const HtmlEscape(HtmlEscapeMode.element).convert(value);
String _xmlAttr(String value) => const HtmlEscape(HtmlEscapeMode.attribute).convert(value);

class _RecipeGroup {
  final String name;
  final List<Recipe> recipes;

  const _RecipeGroup(this.name, this.recipes);
}

class _ExcelRow {
  final int index;
  final List<_ExcelCell> cells;
  final double? height;

  const _ExcelRow(this.index, this.cells, {this.height});

  String toXml() {
    final heightXml = height == null ? '' : ' ht="$height" customHeight="1"';
    return '<row r="$index"$heightXml>${cells.map((c) => c.toXml()).join()}</row>';
  }
}

class _ExcelCell {
  final String ref;
  final String value;
  final int style;

  const _ExcelCell(this.ref, this.value, this.style);

  String toXml() {
    return '<c r="$ref" t="inlineStr" s="$style"><is><t>${_xmlText(value)}</t></is></c>';
  }
}
