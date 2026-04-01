import '../models/lesson_models.dart';

final List<LessonDefinition> blenderLessons = [
  _b1,
  _b2,
  _b3,
  _b4,
  _b5,
];

const String _bTheory1 = '''
Blender — бесплатный пакет с открытым исходным кодом для 3D-моделирования, анимации, рендера, скульптинга, VFX и монтажа видео. Интерфейс нодовый и модульный: окна можно переставлять, режимы переключаются Tab (объект/редактирование).

Сцена состоит из объектов в Outliner: меши, камеры, источники света, кривые. Трансформации: перемещение G, вращение R, масштаб S; с числом уточняешь ось (например GX — только по X).

Сохраняй проект в .blend — в нём вся сцена, материалы и настройки. Для обмена с играми и другими программами часто экспортируют FBX, OBJ, glTF.

Навигация во вьюпорте: средняя кнопка мыши — вращение, Shift+MMB — панорамирование, колёсико — зум. На тачпаде жесты настраиваются в Preferences.
''';

const String _bSoft1 = '''
Blender — основной инструмент курса; альтернативы по назначению: Maya/3ds Max (индустрия, платно), Cinema 4D (motion), ZBrush (скульпт высокого полигона — можно комбинировать с Blender).

Для текстур иногда используют Substance Painter; для ретопологии и UV Blender достаточен на старте. Рендер-движки в Blender: Cycles (физически корректный), Eevee (реалтайм).

Для начала достаточно одного Blender с официального сайта; плагины ставят через Edit → Preferences → Add-ons.
''';

const String _bInstall1 = '''
Зайди на https://www.blender.org/download/ — выбери ОС (Windows/macOS/Linux). Установщик Windows предлагает путь и ярлыки; macOS — перетащить в Applications.

После запуска выбери Quick Setup (язык, мышь, таблет). Обновления: Help → Check for Updates или скачай новую версию с сайта (проекты открываются между мажорными версиями с осторожностью — делай копии).

Если видеокарта поддерживает, включи GPU в Edit → Preferences → System → Cycles Render Devices. Драйверы GPU обнови с сайта производителя.
''';

final LessonDefinition _b1 = LessonDefinition(
  id: 'lesson1',
  title: 'Интерфейс Blender и сцена',
  theory: _bTheory1,
  softwareSection: _bSoft1,
  installationGuide: _bInstall1,
  questions: const [
    QuizQuestion(question: 'Какой формат — родной для сохранения всей сцены Blender?', options: ['.obj', '.blend', '.jpg'], correctIndex: 1),
    QuizQuestion(question: 'Переключение между Object Mode и Edit Mode:', options: ['Клавиша Tab', 'Пробел', 'Esc'], correctIndex: 0),
    QuizQuestion(question: 'Клавиша перемещения (grab) в Blender:', options: ['S', 'G', 'R'], correctIndex: 1),
    QuizQuestion(question: 'Вращение вида во вьюпорте по умолчанию (трёхкнопочная мышь):', options: ['ЛКМ', 'Средняя кнопка (MMB)', 'Правый Ctrl'], correctIndex: 1),
    QuizQuestion(question: 'Cycles в Blender — это:', options: ['Только 2D', 'Рендер-движок', 'Риггинг костей'], correctIndex: 1),
    QuizQuestion(question: 'Outliner показывает:', options: ['Только материалы', 'Иерархию объектов сцены', 'Только рендер'], correctIndex: 1),
    QuizQuestion(question: 'Blender распространяется:', options: ['Только по подписке', 'Бесплатно с открытым исходным кодом', 'Только для macOS'], correctIndex: 1),
    QuizQuestion(question: 'Масштабирование объекта горячей клавишей:', options: ['G', 'R', 'S'], correctIndex: 2),
    QuizQuestion(question: 'Экспорт в игровой движок часто делают в:', options: ['Только .blend', 'FBX или glTF среди прочих', 'Только .doc'], correctIndex: 1),
    QuizQuestion(question: 'Где включить устройства GPU для Cycles?', options: ['File → Export', 'Edit → Preferences → System', 'Window → New'], correctIndex: 1),
  ],
);

const String _bTheory2 = '''
Режим редактирования (Edit Mode) работает с вершинами (1), рёбрами (2), гранями (3) — переключение числами над клавиатурой. Extrude E выдавливает выделение, Inset I — внутреннее смещение грани, Loop Cut Ctrl+R добавляет разрез.

Модификаторы — неразрушающие операции: Subdivision Surface сглаживает, Mirror зеркалит, Solidify задаёт толщину. Порядок модификаторов важен.

Скульптинг — режим с кистями по сетке; нужна достаточная топология. Ретопология — построение чистой низкополигональной сетки поверх высокополигональной модели.
''';

const String _bSoft2 = '''
Для чистого моделирования хватит Blender. Для сканов и органики иногда используют Meshroom (фотограмметрия) или импорт в Blender. Instant Meshes — бесплатный ретопо, опционально.

Планшет Wacom или аналог удобен для скульпта; для хард-сёрфейса мышь достаточна.
''';

const String _bInstall2 = '''
Модификаторы встроены. Плагины: Edit → Preferences → Add-ons — включи нужные (например LoopTools). Сторонние аддоны кладут в папку scripts/addons (путь указан в Preferences).

Обнови видеодрайвер перед тяжёлым скульптом; в Sculpt режиме снижай Dyntopo осознанно — растёт число полигонов.
''';

final LessonDefinition _b2 = LessonDefinition(
  id: 'lesson2',
  title: 'Моделирование мешей',
  theory: _bTheory2,
  softwareSection: _bSoft2,
  installationGuide: _bInstall2,
  questions: const [
    QuizQuestion(question: 'Extrude в Edit Mode чаще вызывают клавишей:', options: ['I', 'E', 'X'], correctIndex: 1),
    QuizQuestion(question: 'Режим выделения рёбер в Edit Mode (по умолчанию):', options: ['1', '2', '3'], correctIndex: 1),
    QuizQuestion(question: 'Subdivision Surface делает сетку:', options: ['Только квадратной', 'Более гладкой', 'Удаляет материалы'], correctIndex: 1),
    QuizQuestion(question: 'Порядок модификаторов в стеке:', options: ['Не влияет', 'Влияет на результат', 'Случайный'], correctIndex: 1),
    QuizQuestion(question: 'Loop Cut добавляет:', options: ['Свет', 'Петлю рёбер', 'Камеру'], correctIndex: 1),
    QuizQuestion(question: 'Mirror-модификатор обычно используют для:', options: ['Только текста', 'Симметричных объектов', 'Рендера'], correctIndex: 1),
    QuizQuestion(question: 'Inset (I) в полигональном моделировании:', options: ['Выдавливает наружу', 'Внутреннее смещение грани', 'Удаляет объект'], correctIndex: 1),
    QuizQuestion(question: 'Скульптинг в Blender работает с:', options: ['Только кривыми Безье', 'Сеткой в Sculpt Mode', 'Только пустотой'], correctIndex: 1),
    QuizQuestion(question: 'Ретопология — это:', options: ['Рендер', 'Перестроение чистой топологии', 'Только анимация'], correctIndex: 1),
    QuizQuestion(question: 'Ctrl+R в Edit Mode обычно:', options: ['Сохраняет файл', 'Добавляет loop cut', 'Выход из Blender'], correctIndex: 1),
  ],
);

const String _bTheory3 = '''
UV-развёртка «разрезает» поверхность на плоскость для текстурирования. Разметка швов в Edit Mode, затем UV → Unwrap. Проверяй острова в UV Editor на пересечения и растяжение.

Текстуры: изображения (albedo/base color), нормали, roughness, metallic — в PBR-конвейере. UV islands должны иметь достаточный отступ (padding) между собой при запекании.

Smart UV Project быстро для прототипа; для персонажей часто делают ручные швы по менее заметным линиям.
''';

const String _bSoft3 = '''
UV: встроенный UV Editor в Blender. Внешняя раскладка: RizomUV (ранее UVLayout) — платно; для учебы достаточно Blender.

Текстуры рисуют в Substance Painter, Photoshop, Krita, GIMP — в курс импортируют готовые карты. Запекание нормалей — Bake в Blender.
''';

const String _bInstall3 = '''
Для 2K/4K текстур нужно место на диске. Включи плагин Node Wrangler в Add-ons — удобные хоткеи для нод.

Если UV «ломается», проверь масштаб объекта Apply Scale (Ctrl+A) перед развёрткой.
''';

final LessonDefinition _b3 = LessonDefinition(
  id: 'lesson3',
  title: 'UV и текстуры',
  theory: _bTheory3,
  softwareSection: _bSoft3,
  installationGuide: _bInstall3,
  questions: const [
    QuizQuestion(question: 'Зачем нужна UV-развёртка?', options: ['Только для звука', 'Соответствие 3D-поверхности плоской текстуре', 'Только для видео'], correctIndex: 1),
    QuizQuestion(question: 'Unwrap в Blender применяют после:', options: ['Только рендера', 'Разметки швов / выделения', 'Удаления камеры'], correctIndex: 1),
    QuizQuestion(question: 'PBR часто включает:', options: ['Только яркость', 'Base color, roughness, metallic и др.', 'Только WAV'], correctIndex: 1),
    QuizQuestion(question: 'UV Editor в Blender показывает:', options: ['Только график FPS', 'Плоскую развёртку координат', 'Только шейдеры'], correctIndex: 1),
    QuizQuestion(question: 'Padding между островами UV нужен чтобы:', options: ['Ускорить мышь', 'Уменьшить артефакты при фильтрации', 'Удалить свет'], correctIndex: 1),
    QuizQuestion(question: 'Smart UV Project — это:', options: ['Автоматическая развёртка', 'Удаление меша', 'Только анимация'], correctIndex: 0),
    QuizQuestion(question: 'Запекание нормалей (bake) используют для:', options: ['Только аудио', 'Перенос деталей с хайполи на лоуполи', 'Только 2D'], correctIndex: 1),
    QuizQuestion(question: 'Швы (seams) в UV:', options: ['Где сетка разрезается при развёртке', 'Только цвет лампы', 'Только FPS'], correctIndex: 0),
    QuizQuestion(question: 'Перед unwrap полезно при необходимости:', options: ['Apply масштаба объекта', 'Удалить GPU', 'Отключить монитор'], correctIndex: 0),
    QuizQuestion(question: 'Текстура albedo / base color задаёт:', options: ['Только физику', 'Базовый цвет поверхности', 'Только звук шагов'], correctIndex: 1),
  ],
);

const String _bTheory4 = '''
Риггинг — создание арматуры (костей) и весов вершин для деформации меша. Armature объект, Pose Mode для позы, Weight Paint для красок влияния костей.

Анимация ключами: I вставляет ключ кадра; временная шкала — Timeline и Dope Sheet. Ограничители (constraints) копируют вращение, следят за целью.

Принципы: хорошая топология в суставах, своевременное применение ограничений, тест деформаций в Pose Mode до финального скина.
''';

const String _bSoft4 = '''
Риг в Blender полноценный; для микса с игровыми пайплайнами экспортируют FBX с костями. Auto-Rig Pro / Rigify — аддоны Blender для быстрого рига (Rigify встроен как аддон).

Motion capture правят в Blender или в специализированных тулзах; для учебы — ручная анимация ключами.
''';

const String _bInstall4 = '''
Включи аддон Rigify: Preferences → Add-ons → Rigify. Обнови Blender при работе с новыми ригами — иногда ломается совместимость аддонов между мажорами.

Экспорт FBX: учитывай масштаб и ось вперёд для целевого движка (Unreal/Unity имеют свои пресеты).
''';

final LessonDefinition _b4 = LessonDefinition(
  id: 'lesson4',
  title: 'Риггинг и анимация',
  theory: _bTheory4,
  softwareSection: _bSoft4,
  installationGuide: _bInstall4,
  questions: const [
    QuizQuestion(question: 'Pose Mode используется для:', options: ['Редактирования вершин меша', 'Позирования арматуры', 'Только рендера'], correctIndex: 1),
    QuizQuestion(question: 'Вставка ключевого кадра часто:', options: ['Клавиша I', 'Клавиша Esc', 'F12'], correctIndex: 0),
    QuizQuestion(question: 'Weight Paint задаёт:', options: ['Только цвет лампы', 'Влияние костей на вершины', 'Только разрешение экрана'], correctIndex: 1),
    QuizQuestion(question: 'Armature в Blender — это:', options: ['Только камера', 'Скелет из костей', 'Только свет'], correctIndex: 1),
    QuizQuestion(question: 'Constraint «Copy Rotation» может:', options: ['Копировать вращение с цели', 'Удалить сцену', 'Только звук'], correctIndex: 0),
    QuizQuestion(question: 'Dope Sheet показывает:', options: ['Только UV', 'Ключи анимации по времени', 'Только материалы'], correctIndex: 1),
    QuizQuestion(question: 'Rigify — это:', options: ['Только видеокодек', 'Аддон для генерации ригов', 'Только рендер'], correctIndex: 1),
    QuizQuestion(question: 'Экспорт персонажа в игровой движок часто:', options: ['Только .mp3', 'FBX с костями и скином', 'Только .txt'], correctIndex: 1),
    QuizQuestion(question: 'Плохая топология в суставе может дать:', options: ['Идеальную деформацию всегда', 'Артефакты при сгибе', 'Только ускорение рендера'], correctIndex: 1),
    QuizQuestion(question: 'Timeline в Blender отображает:', options: ['Только шейдеры', 'Кадры и воспроизведение', 'Только плагины'], correctIndex: 1),
  ],
);

const String _bTheory5 = '''
Рендер: настройка камеры, света, материалов и движка Cycles или Eevee. Sampling в Cycles снижает шум при росте времени; denoise ускоряет чистоту картинки.

Композитинг внутри Blender: ноды в Compositing для глубины резкости, глэя, цветокора. Вывод: PNG последовательность или видео FFmpeg.

Оптимизация: упрощённые меши для фона, instancing коллекций, кэш симуляций. Финальный рендер — часто на GPU с достаточной VRAM.
''';

const String _bSoft5 = '''
Рендер в Blender; пост-обработку иногда делают в DaVinci Resolve (бесплатно) или After Effects для сложного композита. Для статики достаточно Blender Compositing.

HDRi-фоны с polyhaven.com подключают в World для освещения; скачивание бесплатное.
''';

const String _bInstall5 = '''
Cycles: включи GPU в Preferences. Для denoise используй встроенные ноды OpenImageDenoise в композите или опции рендера в зависимости от версии.

Вывод видео: выбери контейнер и кодек в Output Properties; для соцсетей часто H.264.
''';

final LessonDefinition _b5 = LessonDefinition(
  id: 'lesson5',
  title: 'Рендер и композитинг',
  theory: _bTheory5,
  softwareSection: _bSoft5,
  installationGuide: _bInstall5,
  questions: const [
    QuizQuestion(question: 'Cycles относится к:', options: ['Только 2D-рисованию', 'Рендер-движку', 'Только аудио'], correctIndex: 1),
    QuizQuestion(question: 'Eevee в Blender — это:', options: ['Реалтайм-рендер', 'Только экспорт в PDF', 'Риггинг'], correctIndex: 0),
    QuizQuestion(question: 'Увеличение samples в Cycles обычно:', options: ['Уменьшает шум', 'Удаляет камеру', 'Отключает свет'], correctIndex: 0),
    QuizQuestion(question: 'Denoise помогает:', options: ['Убрать шум на рендере', 'Удалить объект', 'Только UV'], correctIndex: 0),
    QuizQuestion(question: 'Композитинг в Blender делают во вкладке:', options: ['UV Editing', 'Compositing', 'Scripting'], correctIndex: 1),
    QuizQuestion(question: 'HDRi для World часто берут с:', options: ['Только платных закрытых баз', 'Ресурсов вроде Poly Haven и др.', 'Только из .exe'], correctIndex: 1),
    QuizQuestion(question: 'Экспорт анимации в видео настраивается в:', options: ['Output Properties', 'Только Edit Mode', 'Только Sculpt'], correctIndex: 0),
    QuizQuestion(question: 'Instancing в сцене помогает:', options: ['Дублировать объекты экономнее', 'Удалить GPU', 'Только звук'], correctIndex: 0),
    QuizQuestion(question: 'FFmpeg в контексте Blender:', options: ['Только антивирус', 'Кодирование видео при экспорте', 'Только моделирование'], correctIndex: 1),
    QuizQuestion(question: 'Глубина резкости (DOF) настраивается:', options: ['Только в Word', 'В камере и/или композите', 'Только в Paint'], correctIndex: 1),
  ],
);
