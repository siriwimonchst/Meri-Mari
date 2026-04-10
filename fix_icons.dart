import 'dart:io';

void main() {
  final dir = Directory('lib');
  int replacedCount = 0;

  final files = dir.listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  final targetIcon = "const Icon(Icons.arrow_back_ios_new_rounded, color: kText, size: 20)";

  for (final file in files) {
    String content = file.readAsStringSync();
    bool modified = false;

    // Pattern 1: Icons.arrow_back with any color
    final p1 = RegExp(r"const\s+Icon\(\s*Icons\.arrow_back\s*,\s*color:\s*[^,)]+(\s*,\s*size:\s*\d+\s*)?\)");
    if (p1.hasMatch(content)) {
      content = content.replaceAll(p1, targetIcon);
      modified = true;
    }

    // Pattern 2: Icons.arrow_back without any properties
    final p2 = RegExp(r"const\s+Icon\(\s*Icons\.arrow_back\s*\)");
    if (p2.hasMatch(content)) {
      content = content.replaceAll(p2, targetIcon);
      modified = true;
    }
    
    // Pattern 3: Icons.arrow_back_ios
    final p3 = RegExp(r"const\s+Icon\(\s*Icons\.arrow_back_ios(_new)?(_rounded)?\s*,\s*color:\s*[^,)]+(\s*,\s*size:\s*\d+\s*)?\)");
    if (p3.hasMatch(content)) {
      content = content.replaceAll(p3, targetIcon);
      modified = true;
    }

    // Pattern 4: Icons.arrow_back_ios without any properties
    final p4 = RegExp(r"const\s+Icon\(\s*Icons\.arrow_back_ios(_new)?(_rounded)?\s*\)");
    if (p4.hasMatch(content)) {
      content = content.replaceAll(p4, targetIcon);
      modified = true;
    }

    // Pattern 5: Icon(Icons.arrow_back...) without const keyword
    final p5 = RegExp(r"Icon\(\s*Icons\.arrow_back(_ios)?(_new)?(_rounded)?.*?color:\s*[^,)]+.*?\)");
    if (p5.hasMatch(content)) {
       // Only replace if it looks like a simple icon
       if(!content.contains("const Icon(Icons.arrow_back_ios_new_rounded, color: kText, size: 20)")) {
         content = content.replaceAll(p5, targetIcon);
         modified = true;
       }
    }

    if (modified) {
      file.writeAsStringSync(content);
      print('Updated: ${file.path}');
      replacedCount++;
    }
  }

  print('Total files updated: $replacedCount');
}
