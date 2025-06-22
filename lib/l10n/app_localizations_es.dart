// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get ok => 'Ok';

  @override
  String get yes => 'Sí';

  @override
  String get cancel => 'Cancelar';

  @override
  String get appTitle => 'Editor de Markdown';

  @override
  String get previewToolTip => 'Vista previa';

  @override
  String get switchThemeMenuItem => 'Cambiar tema';

  @override
  String get switchViewMenuItem => 'Cambiar vista';

  @override
  String get openFileMenuItem => 'Abrir';

  @override
  String get defaultFileName => 'Markdown';

  @override
  String get markdownTextInputLabel => 'Ingrese su texto de Markdown aquí';

  @override
  String get storagePermission => 'Permiso de almacenamiento';

  @override
  String get storagePermissionContent =>
      'Por favor, permita los permisos de almacenamiento externo en la siguiente pantalla para poder abrir, editar y guardar archivos de Markdown';

  @override
  String get error => 'Error';

  @override
  String get unableToOpenFileError =>
      'No se puede abrir el archivo, intente abrirlo desde la opción de archivo abierto en el menú';

  @override
  String get unableToOpenFileFromMenuError => 'No se puede abrir el archivo';

  @override
  String get emptyInputTextContent => 'Por favor, ingrese algún texto';

  @override
  String get clear => 'Limpiar';

  @override
  String get clearAllTitle => 'Limpiar todo';

  @override
  String get clearAllContent =>
      '¿Está seguro de que desea borrar todo el texto?';

  @override
  String get saveFileDialogTitle => 'Ingrese el nombre del archivo';

  @override
  String get saveFileDialogHintText => 'Nombre de archivo';

  @override
  String get save => 'Guardar';

  @override
  String fileSaveSuccess(String filePath) {
    return 'Archivo guardado exitosamente en $filePath';
  }

  @override
  String get fileSaveError =>
      'Error al guardar el archivo, intente otorgar permisos de acceso al archivo en la configuración';

  @override
  String get imageAlternateTextFallback => 'No se puede mostrar la imagen';

  @override
  String get example => 'ejemplo';

  @override
  String get linkDialogTextTitle => 'Texto';

  @override
  String get linkDialogLinkTitle => 'Enlace';
}
