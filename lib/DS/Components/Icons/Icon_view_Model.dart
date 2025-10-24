enum IconType {
  favorite,
  settings,
  search,
  home,
  help,
  fixed,
  folder,
  definition,
  bash,
  dialog,
  dica,
}

enum colorType {
  red,
  black,
  white,
  blue,
  yellow,
  pink,
  orange,
  green,
  darkblue,
}

enum IconSize { small, medium, large }

class IconViewModel {
  final IconType icon;
  final IconSize? size;
  final colorType color;

  IconViewModel({required this.icon, this.size, required this.color});
}
