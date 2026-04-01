import '../models/lesson_models.dart';

final List<LessonDefinition> uiUxLessons = [
  _u1,
  _u2,
  _u3,
  _u4,
  _u5,
];

const String _uTheory1 = '''
UI (User Interface) — то, что пользователь видит и с чем взаимодействует: экраны, кнопки, поля, навигация. UX (User Experience) — ощущение от использования: насколько просто достичь цели, насколько предсказуемо и приятно.

Хороший интерфейс опирается на иерархию: что важнее — крупнее и выше в потоке. Законы близости и сходства из гештальта: рядом — связано, одинаковое оформление — одна категория.

Процесс: исследование пользователей, сценарии (user flows), прототипы, тестирование, итерации. Доступность (a11y): контраст текста, размер зон нажатия, поддержка скринридеров.
''';

const String _uSoft1 = '''
Прототипирование: Figma (веб, бесплатный тариф для личного использования) — стандарт индустрии для UI и дизайн-систем. Альтернативы: Adobe XD (поддержка ограничена), Sketch (macOS), Penpot (open source).

Исследования: Miro, FigJam для карт и эвристик; опросы — Google Forms, Tally. Аналитика после релиза: не заменяет интервью, но показывает поведение.

Для начала: Figma + FigJam достаточно для курса; установка через сайт или десктоп-клиент.
''';

const String _uInstall1 = '''
Figma: зайди на https://www.figma.com/ — Sign up. Работает в браузере; для офлайн и производительности скачай Desktop App с той же страницы (Download).

Создай файл, изучи Frame (F) для артбордов под iOS/Android/Web. Плагины: Community → Plugins — например Icons, Unsplash.

Шрифты: Google Fonts бесплатны; в Figma подключи через Font settings. Экспорт: выдели слой → Export в PNG/SVG/PDF.
''';

final LessonDefinition _u1 = LessonDefinition(
  id: 'lesson1',
  title: 'Основы UI и UX',
  theory: _uTheory1,
  softwareSection: _uSoft1,
  installationGuide: _uInstall1,
  questions: const [
    QuizQuestion(question: 'UX в первую очередь про:', options: ['Только цвет логотипа', 'Опыт и достижение целей пользователем', 'Только код HTML'], correctIndex: 1),
    QuizQuestion(question: 'UI — это в основном:', options: ['Только серверная БД', 'Визуальный и интерактивный слой', 'Только маркетинг'], correctIndex: 1),
    QuizQuestion(question: 'Иерархия в интерфейсе помогает:', options: ['Спрятать всё', 'Показать важность элементов', 'Удалить навигацию'], correctIndex: 1),
    QuizQuestion(question: 'a11y обычно означает:', options: ['Только 11 пикселей', 'Доступность (accessibility)', 'Только Android 11'], correctIndex: 1),
    QuizQuestion(question: 'Figma чаще всего используют как:', options: ['Видеомонтаж', 'Инструмент UI/прототипов', '3D-скульпт'], correctIndex: 1),
    QuizQuestion(question: 'Прототип до разработки нужен чтобы:', options: ['Заменить тесты пользователей', 'Проверить сценарии и UX раньше кода', 'Удалить дизайнера'], correctIndex: 1),
    QuizQuestion(question: 'Penpot относится к:', options: ['Только платным CAD', 'Open-source дизайн-инструментам', 'Только играм'], correctIndex: 1),
    QuizQuestion(question: 'Гештальт «близость» говорит:', options: ['Цвет не важен', 'Рядом расположенное воспринимается связанным', 'Только шрифты'], correctIndex: 1),
    QuizQuestion(question: 'FigJam в экосистеме Figma подходит для:', options: ['Только 3D', 'Досок, флоу, совместной работы', 'Только рендера'], correctIndex: 1),
    QuizQuestion(question: 'Контраст текста и фона важен для:', options: ['Только печати', 'Читаемости и доступности', 'Только иконок'], correctIndex: 1),
  ],
);

const String _uTheory2 = '''
Сетка и колонки выравнивают контент; типичные 12-колоночные сетки для веба. Отступы (spacing) из шкалы (4, 8, 16 px) дают ритм.

Типографика: ограничь количество гарнитур (часто 1–2), задай шкалу размеров (например 12/14/16/20/24). Межстрочный интервал (line-height) для читаемости длинного текста выше, чем для заголовков.

Кнопки: явная подпись, состояния default/hover/disabled/focus. Формы: подписи полей, сообщения об ошибках рядом с полем, не только цветом.
''';

const String _uSoft2 = '''
В Figma: Auto Layout для отступов и растягивания; Components и Variants для кнопок в разных состояниях. Styles для цвета и текста.

Проверка контраста: плагины вроде Stark или веб-инструменты WCAG contrast checker.
''';

const String _uInstall2 = '''
Включи в Figma библиотеки компонентов: Team Library при работе в команде. Локально создай UI Kit как отдельный файл и публикуй при необходимости.

Экспорт макетов для разработчика: Dev Mode (платно в командах) или спецификации вручную через Inspect в браузере.
''';

final LessonDefinition _u2 = LessonDefinition(
  id: 'lesson2',
  title: 'Сетка и типографика',
  theory: _uTheory2,
  softwareSection: _uSoft2,
  installationGuide: _uInstall2,
  questions: const [
    QuizQuestion(question: 'Auto Layout в Figma помогает с:', options: ['Только 3D', 'Отступами и адаптивным поведением блоков', 'Только звуком'], correctIndex: 1),
    QuizQuestion(question: 'Шкала отступов 4/8/16 px часто используется для:', options: ['Случайных значений', 'Согласованного ритма интерфейса', 'Только печати'], correctIndex: 1),
    QuizQuestion(question: 'Variants компонента — это:', options: ['Только экспорт PNG', 'Варианты одного компонента (состояния, размеры)', 'Только видео'], correctIndex: 1),
    QuizQuestion(question: 'Для длинного текста line-height обычно:', options: ['Ниже чем у заголовка', 'Выше для читаемости', 'Всегда 0'], correctIndex: 1),
    QuizQuestion(question: 'Состояние focus у кнопки важно для:', options: ['Только мыши', 'Клавиатуры и доступности', 'Только принтера'], correctIndex: 1),
    QuizQuestion(question: '12-колоночная сетка часто применяется в:', options: ['Только Excel', 'Веб-макетах', 'Только Blender'], correctIndex: 1),
    QuizQuestion(question: 'Ошибку формы лучше показывать:', options: ['Только красным без текста', 'Рядом с полем и текстом', 'Только в консоли'], correctIndex: 1),
    QuizQuestion(question: 'Сколько гарнитур обычно рекомендуют для простого UI?', options: ['10–15', 'Часто 1–2', 'Ровно 0'], correctIndex: 1),
    QuizQuestion(question: 'Плагин Stark в Figma может помочь с:', options: ['Только 3D', 'Контрастом и доступностью', 'Только аудио'], correctIndex: 1),
    QuizQuestion(question: 'Component в дизайн-системе — это:', options: ['Только картинка', 'Повторяемый элемент с правилами', 'Только шрифт системы'], correctIndex: 1),
  ],
);

const String _uTheory3 = '''
User flow — путь от входа до цели (например «оформить заказ»). Его рисуют блок-схемой: экраны, решения, ошибки.

Jobs To Be Done формулирует задачу пользователя: «нанять продукт для…». Персоны — обобщённые образы, не заменяют реальных интервью.

Карта эвристик Нильсена — чеклист юзабилити: видимость статуса, соответствие реальному миру, контроль и свобода, согласованность, предотвращение ошибок и др.
''';

const String _uSoft3 = '''
FigJam или Miro для flowchart. В Figma прототипы: связи между фреймами, переходы, простая анимация в Prototype.

Запись интервью: с согласия пользователя; заметки в Notion или Docs.
''';

const String _uInstall3 = '''
В Figma переключись на Prototype (правый верх), соедини фреймы стрелками, задай триггер On tap / While hovering. Презентация: Present.

Экспорт flow в PDF: можно через плагины или скриншоты фреймов.
''';

final LessonDefinition _u3 = LessonDefinition(
  id: 'lesson3',
  title: 'Сценарии и эвристики',
  theory: _uTheory3,
  softwareSection: _uSoft3,
  installationGuide: _uInstall3,
  questions: const [
    QuizQuestion(question: 'User flow описывает:', options: ['Только цвета', 'Путь пользователя по экранам к цели', 'Только шрифты'], correctIndex: 1),
    QuizQuestion(question: 'Эвристики Нильсена — это:', options: ['Законы физики', 'Принципы проверки юзабилити', 'Только про типографику'], correctIndex: 1),
    QuizQuestion(question: 'Персоны в UX:', options: ['Заменяют любые исследования', 'Обобщённые модели пользователей', 'Только HR-документ'], correctIndex: 1),
    QuizQuestion(question: 'Jobs To Be Done фокусируется на:', options: ['Только логотипе', 'Задаче, которую «нанимают» решить', 'Только CSS'], correctIndex: 1),
    QuizQuestion(question: 'Прототип в Figma (Prototype) связывает:', options: ['Только слои без смысла', 'Фреймы и переходы', 'Только видео'], correctIndex: 1),
    QuizQuestion(question: '«Видимость статуса системы» — эвристика про:', options: ['Скрыть всё', 'Понятную обратную связь пользователю', 'Только звук'], correctIndex: 1),
    QuizQuestion(question: 'FigJam удобен для:', options: ['Только 3D', 'Совместных досок и диаграмм', 'Только компиляции'], correctIndex: 1),
    QuizQuestion(question: 'Интервью с пользователями лучше:', options: ['Без цели', 'С сценарием и вопросами', 'Только по email шаблону без ответов'], correctIndex: 1),
    QuizQuestion(question: 'Согласованность интерфейса (эвристика) значит:', options: ['Разные стили везде', 'Похожие вещи выглядят и работают одинаково', 'Только один цвет'], correctIndex: 1),
    QuizQuestion(question: 'Ошибки в сценарии оформления заказа нужно:', options: ['Игнорировать', 'Продумать сообщения и восстановление', 'Только красный экран'], correctIndex: 1),
  ],
);

const String _uTheory4 = '''
Мобильные паттерны: таб-бар внизу для основных разделов, жесты назад на Android, safe area под вырез iPhone. Touch target не меньше ~44pt по гайдлайнам Apple HIG.

Material Design (Google) и Human Interface Guidelines (Apple) задают компоненты и поведение; адаптируй под бренд, не копируй слепо.

Адаптив: breakpoints для ширины экрана; контент не только «уменьшается», но и перестраивается (reflow).
''';

const String _uSoft4 = '''
Figma: пресеты фреймов iPhone/Pixel. Плагины для проверки safe area. Для превью на устройстве — Figma Mirror на телефон.

Android Studio Layout Inspector — для разработчиков; дизайнеру достаточно гайдов и макетов.
''';

const String _uInstall4 = '''
Скачай Figma Mirror из App Store / Google Play, войди в аккаунт, открой файл — просмотр в реальном времени.

Проверь макеты на минимальной ширине (320 dp) если аудитория на старых устройствах.
''';

final LessonDefinition _u4 = LessonDefinition(
  id: 'lesson4',
  title: 'Мобильный UI и гайдлайны',
  theory: _uTheory4,
  softwareSection: _uSoft4,
  installationGuide: _uInstall4,
  questions: const [
    QuizQuestion(question: 'HIG чаще связывают с:', options: ['Google веб-поиском', 'Apple Human Interface Guidelines', 'Только Blender'], correctIndex: 1),
    QuizQuestion(question: 'Material Design разрабатывает:', options: ['Apple', 'Google', 'Blender Foundation'], correctIndex: 1),
    QuizQuestion(question: 'Минимальная зона касания ~44pt рекомендуется для:', options: ['Только десктопа', 'Удобного нажатия пальцем', 'Только печати'], correctIndex: 1),
    QuizQuestion(question: 'Safe area на iPhone учитывает:', options: ['Только обои', 'Вырезы и индикаторы', 'Только Android'], correctIndex: 1),
    QuizQuestion(question: 'Tab bar в мобильном приложении обычно:', options: ['Только сверху всегда', 'Внизу для основных разделов', 'Только в настройках Windows'], correctIndex: 1),
    QuizQuestion(question: 'Адаптивный дизайн — это:', options: ['Только один размер макета', 'Перестройка под ширину экрана', 'Только шрифт'], correctIndex: 1),
    QuizQuestion(question: 'Figma Mirror используют для:', options: ['Рендера видео', 'Просмотра макета на устройстве', 'Только кода'], correctIndex: 1),
    QuizQuestion(question: 'Гайдлайны нужны чтобы:', options: ['Запретить креатив', 'Согласовать ожидания пользователей платформы', 'Только для печати'], correctIndex: 1),
    QuizQuestion(question: 'Breakpoint в вёрстке — это:', options: ['Ошибка', 'Порог ширины для смены раскладки', 'Только цвет'], correctIndex: 1),
    QuizQuestion(question: 'Жест «назад» на Android часто:', options: ['Только в iOS', 'Системный или край экрана', 'Только в Photoshop'], correctIndex: 1),
  ],
);

const String _uTheory5 = '''
Юзабилити-тест: наблюдение за пользователем по сценарию «попробуй оформить…». Количество участников для качественных находок часто начинают с 5 по классической эвристике Нильсена для одного класса задач.

Метрики продукта: конверсия, время задачи, ошибки, NPS — интерпретировать в контексте. A/B-тест сравнивает варианты на части аудитории.

Handoff разработчику: спецификации отступов, состояний, ассеты экспортом; в команде — дизайн-токены и Storybook для компонентов.
''';

const String _uSoft5 = '''
Maze, Useberry — тестирование прототипов Figma. Hotjar, Amplitude — поведение на проде (с GDPR).

Для handoff: Figma Dev Mode, Zeplin (альтернатива), или экспорт через плагины.
''';

const String _uInstall5 = '''
Плагин для экспорта иконок в SVG с правильными слоями — проверь, что stroke/outline совместимы с кодом.

Настрой единую naming-convention слоёв до передачи в разработку.
''';

final LessonDefinition _u5 = LessonDefinition(
  id: 'lesson5',
  title: 'Тестирование и передача в разработку',
  theory: _uTheory5,
  softwareSection: _uSoft5,
  installationGuide: _uInstall5,
  questions: const [
    QuizQuestion(question: 'Юзабилити-тест с пользователем обычно включает:', options: ['Только опрос без задач', 'Сценарий и наблюдение действий', 'Только A/B без гипотезы'], correctIndex: 1),
    QuizQuestion(question: 'A/B-тест сравнивает:', options: ['Только цвета логотипа', 'Два варианта на аудитории', 'Только два шрифта в Word'], correctIndex: 1),
    QuizQuestion(question: 'Handoff — это:', options: ['Только печать', 'Передача макетов и правил разработчику', 'Только видео'], correctIndex: 1),
    QuizQuestion(question: 'NPS измеряет:', options: ['Только скорость сайта', 'Лояльность/рекомендацию', 'Только количество кликов'], correctIndex: 1),
    QuizQuestion(question: 'Конверсия в воронке — это:', options: ['Всегда 100%', 'Доля дошедших до шага', 'Только про шрифты'], correctIndex: 1),
    QuizQuestion(question: 'Storybook чаще используют для:', options: ['Только БД', 'Каталога UI-компонентов в коде', 'Только 3D'], correctIndex: 1),
    QuizQuestion(question: 'Дизайн-токены — это:', options: ['Только видео', 'Именованные значения цвета, отступов и т.д.', 'Только Photoshop'], correctIndex: 1),
    QuizQuestion(question: 'Hotjar/аналитика помогает увидеть:', options: ['Замены юристов', 'Поведение на проде (осторожно с GDPR)', 'Только погоду'], correctIndex: 1),
    QuizQuestion(question: 'Малое число участников теста:', options: ['Всегда бесполезно', 'Может выявлять серьёзные проблемы на раннем этапе', 'Заменяет закон'], correctIndex: 1),
    QuizQuestion(question: 'Экспорт SVG для иконок нужно проверить на:', options: ['Только размер файла > 1 GB', 'Совместимость stroke/fill с кодом', 'Только количество слоёв = 1000'], correctIndex: 1),
  ],
);
