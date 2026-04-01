import 'models/lesson_models.dart';
import 'data/lessons_python_data.dart';
import 'data/lessons_blender_data.dart';
import 'data/lessons_ui_ux_data.dart';

/// Уроки по идентификатору курса (должен совпадать с [courseId] на главной).
class CourseLessonsCatalog {
  CourseLessonsCatalog._();

  static List<LessonDefinition> lessonsFor(String courseId) {
    switch (courseId) {
      case 'python_basics':
        return pythonLessons;
      case 'blender_3d':
        return blenderLessons;
      case 'ui_ux':
        return uiUxLessons;
      default:
        return const [];
    }
  }
}
