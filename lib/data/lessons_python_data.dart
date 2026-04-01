import '../models/lesson_models.dart';

final List<LessonDefinition> pythonLessons = [
  _py1,
  _py2,
  _py3,
  _py4,
  _py5,
];

const String _pyTheory1 = '''
Python — интерпретируемый высокоуровневый язык с акцентом на читаемость кода. Он подходит для веб-бэкенда (Django, FastAPI), анализа данных (pandas, NumPy), автоматизации, машинного обучения и обучения основам программирования.

Интерпретатор выполняет код построчно: файл .py передаётся в python, команды можно вводить в интерактивной консоли REPL. Отступы (обычно 4 пробела) задают блоки вместо фигурных скобок — это часть синтаксиса.

Первая программа традиционно выводит приветствие: print("Hello"). Переменные создаются присваиванием без объявления типа: name = "Anna", count = 42. Тип можно проверить функцией type().

Модули подключают через import math, import json as j. Виртуальное окружение venv изолирует зависимости проекта от системных пакетов — это стандартная практика.
''';

const String _pySoft1 = '''
Редактор кода: Visual Studio Code (бесплатно, расширение Python от Microsoft) — универсальный выбор для начинающих. PyCharm Community Edition — мощная IDE от JetBrains с отладчиком и подсказками, тоже бесплатна для обучения.

Интерпретатор: официальная сборка с python.org (Windows/macOS/Linux). Альтернатива — Anaconda/Miniconda, если планируешь data science (сразу conda и часто Jupyter).

Терминал: встроенный в VS Code достаточен; на Windows удобен PowerShell или Windows Terminal.

Для учебных проектов оптимально: Python 3.11+ с сайта python.org + VS Code + расширение Python. PyCharm удобен, если хочешь «всё из коробки» без ручной настройки интерпретатора.
''';

const String _pyInstall1 = '''
Windows: зайди на https://www.python.org/downloads/, скачай установщик. В первом окне отметь «Add Python to PATH», затем Install Now. Проверь: открой cmd или PowerShell, введи python --version и pip --version.

macOS: с python.org или brew install python. Проверка: python3 --version. На Apple Silicon используй универсальный установщик с сайта.

Linux: sudo apt install python3 python3-pip python3-venv (Debian/Ubuntu) или аналог для своего дистрибутива.

VS Code: https://code.visualstudio.com/ → Download. После установки открой Extensions, найди «Python», установи от Microsoft. Выбери интерпретатор: Ctrl+Shift+P → Python: Select Interpreter.

venv: в папке проекта: python -m venv .venv, затем активация: Windows — .venv\\Scripts\\activate, macOS/Linux — source .venv/bin/activate. Установка пакетов: pip install requests.
''';

final LessonDefinition _py1 = LessonDefinition(
  id: 'lesson1',
  title: 'Введение в Python',
  theory: _pyTheory1,
  softwareSection: _pySoft1,
  installationGuide: _pyInstall1,
  questions: const [
    QuizQuestion(
      question: 'Чем Python в основном считается по способу выполнения кода?',
      options: ['Компилируемым в .exe без интерпретатора', 'Интерпретируемым языком', 'Языком только для браузера'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'Что задаёт блоки кода в Python вместо фигурных скобок?',
      options: ['Ключевые слова begin/end', 'Отступы', 'Точка с запятой в конце строки'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'Какая функция показывает тип объекта x?',
      options: ['typeof(x)', 'type(x)', 'inspect(x)'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'Зачем обычно используют venv?',
      options: [
        'Чтобы ускорить интерпретатор',
        'Чтобы изолировать зависимости проекта',
        'Чтобы отключить отступы',
      ],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'Что нужно отметить при установке Python на Windows для вызова из терминала?',
      options: ['Только тёмную тему', 'Add Python to PATH', 'Установить Java'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'Какой редактор часто рекомендуют начинающим вместе с расширением Python?',
      options: ['Только Блокнот', 'Visual Studio Code', 'Photoshop'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'Как создать виртуальное окружение в текущей папке?',
      options: ['python -m venv .venv', 'python new venv', 'install venv global'],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: 'Как вывести строку в консоль в учебной программе?',
      options: ['echo()', 'print()', 'console.log()'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'Где официально скачивают интерпретатор Python?',
      options: ['python.org', 'npmjs.com', 'blender.org'],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: 'PyCharm Community Edition подходит для обучения Python?',
      options: ['Нет, только платная версия', 'Да, бесплатная Community часто используется', 'Только для C++'],
      correctIndex: 1,
    ),
  ],
);

const String _pyTheory2 = '''
Переменная — имя, связанное с объектом в памяти. В Python имя — это ссылка: присваивание не «копирует коробку», а привязывает имя к объекту. Неизменяемые типы (int, str, tuple) при «изменении» создают новый объект.

Основные типы: int (целые), float (дробные), str (строки), bool (True/False), None. Строки в кавычках '...' или "..."; многострочный текст — тройные кавычки.

Приведение типов: int("10"), float("3.14"), str(42). Операции + для чисел складывают, для строк — конкатенируют.

Сравнение: == значение, is проверяет идентичность объектов (для малых int часто кэшируется, для списков — осторожно).
''';

const String _pySoft2 = '''
Для отладки переменных в VS Code используй панель Debug и точки остановки. Встроенный терминал позволяет запускать python file.py без выхода из редактора.

Jupyter Notebook / JupyterLab — если хочешь выполнять код по ячейкам: удобно для экспериментов с переменными. Устанавливается через pip install notebook.

Для проверки типов в крупных проектах добавляют статическую проверку mypy, но для первых шагов достаточно print(type(x)).
''';

const String _pyInstall2 = '''
Jupyter (по желанию): после активации venv выполни pip install notebook, затем jupyter notebook — откроется браузер.

VS Code может открывать .ipynb файлы с расширением Jupyter.

Убедись, что в терминале активировано нужное venv перед pip install, иначе пакеты установятся не в проект.
''';

final LessonDefinition _py2 = LessonDefinition(
  id: 'lesson2',
  title: 'Переменные и типы данных',
  theory: _pyTheory2,
  softwareSection: _pySoft2,
  installationGuide: _pyInstall2,
  questions: const [
    QuizQuestion(question: 'Что возвращает type(42) в Python 3?', options: ['<class \'str\'>', '<class \'int\'>', '<class \'float\'>'], correctIndex: 1),
    QuizQuestion(question: 'Как создать пустое значение «ничего»?', options: ['null', 'None', 'nil'], correctIndex: 1),
    QuizQuestion(question: 'Чему равно bool("") (пустая строка)?', options: ['True', 'False', 'Ошибка'], correctIndex: 1),
    QuizQuestion(question: 'Как преобразовать строку "15" в число?', options: ['str("15")', 'int("15")', 'float("15") только для дробей'], correctIndex: 1),
    QuizQuestion(question: 'Оператор + для двух строк str делает:', options: ['Числовое сложение', 'Конкатенацию', 'Ошибку всегда'], correctIndex: 1),
    QuizQuestion(question: 'Кавычки \'hello\' и "hello" в Python:', options: ['Разный смысл', 'Обычно эквивалентны для строк', 'Только внешние работают'], correctIndex: 1),
    QuizQuestion(question: 'float("3.14") вернёт:', options: ['Строку', 'Число с плавающей точкой', 'Целое 3'], correctIndex: 1),
    QuizQuestion(question: 'Переменная в Python — это:', options: ['Фиксированная ячейка памяти фиксированного типа', 'Имя, ссылающееся на объект', 'Только число'], correctIndex: 1),
    QuizQuestion(question: 'Для многострочного текста удобно:', options: ['Одинарные кавычки только', 'Тройные кавычки """ ... """', 'Только комментарий #'],
        correctIndex: 1),
    QuizQuestion(question: 'pip install устанавливает пакеты:', options: ['В систему Windows без выбора', 'В текущее окружение Python (часто venv)', 'Только в PyCharm платно'], correctIndex: 1),
  ],
);

const String _pyTheory3 = '''
Условия: if условие: блок elif другое: блок else: блок. Любое ненулевое и непустое в логическом контексте может трактоваться как истина (осторожно с списками).

Цикл for item in iterable: перебирает элементы. range(5) даёт 0..4. while условие: выполняется, пока True.

break выходит из ближайшего цикла, continue переходит к следующей итерации. else у цикла for/while выполняется, если цикл не был прерван break (редко используют новичками).

Вложенные циклы: внутренний завершается быстрее. Сложность внимания к отступам.
''';

const String _pySoft3 = '''
Отладка условий: в VS Code поставь breakpoint на строке if и смотри значения переменных в панели Variables.

Для визуализации шагов можно использовать расширение Python Debugger или просто print() на время обучения.
''';

const String _pyInstall3 = '''
Ничего дополнительно для if/for не требуется — достаточно установленного Python из предыдущих уроков. Убедись, что файл сохраняется в UTF-8 для кириллицы в строках.
''';

final LessonDefinition _py3 = LessonDefinition(
  id: 'lesson3',
  title: 'Условия и циклы',
  theory: _pyTheory3,
  softwareSection: _pySoft3,
  installationGuide: _pyInstall3,
  questions: const [
    QuizQuestion(question: 'Что делает break в цикле?', options: ['Следующая итерация', 'Выход из цикла', 'Пауза на 1 сек'], correctIndex: 1),
    QuizQuestion(question: 'range(3) в Python 3 даёт значения:', options: ['1,2,3', '0,1,2', '0,1,2,3'], correctIndex: 1),
    QuizQuestion(question: 'Ключевое слово альтернативной ветки после if:', options: ['elseif', 'elif', 'elsif'], correctIndex: 1),
    QuizQuestion(question: 'continue в цикле:', options: ['Завершает программу', 'Переходит к следующей итерации', 'Удаляет переменную'], correctIndex: 1),
    QuizQuestion(question: 'while True: создаёт:', options: ['Ошибку сразу', 'Цикл до break или прерывания', 'Один запуск'], correctIndex: 1),
    QuizQuestion(question: 'Вложенный for внутри for используют для:', options: ['Только ошибок', 'Таблиц, перебора пар', 'Только файлов'], correctIndex: 1),
    QuizQuestion(question: 'if x: когда x = [] (пустой список)?', options: ['True', 'False в булевом контексте', 'Синтаксическая ошибка'], correctIndex: 1),
    QuizQuestion(question: 'Сколько раз выполнится for i in range(2):', options: ['2', '3', '1'], correctIndex: 0),
    QuizQuestion(question: 'else у цикла for выполнится если:', options: ['Всегда', 'Цикл завершился без break', 'Никогда'], correctIndex: 1),
    QuizQuestion(question: 'Оператор сравнения «равно» в условии:', options: ['=', '==', '==='], correctIndex: 1),
  ],
);

const String _pyTheory4 = '''
Функция объявляется: def name(a, b=0): тело; return значение. Параметры по умолчанию вычисляются один раз при определении — не используй изменяемые объекты как значения по умолчанию ([]), используй None и создавай список внутри.

*args собирает позиционные аргументы в кортеж, **kwargs — именованные в словарь. Лямбда: lambda x: x*2 — для коротких функций.

Области видимости: локальные имена в функции, global и nonlocal для изменения внешних при необходимости. Документация — docstring сразу после def.

Рекурсия поддерживается, но глубина ограничена стеком; для учебных задач обычно хватает.
''';

const String _pySoft4 = '''
Отладка функций: Step Into в отладчике VS Code заходит внутрь вызова. Call Stack показывает вложенность.

PyCharm визуализирует сигнатуры и типы, если добавишь аннотации def f(x: int) -> str.
''';

const String _pyInstall4 = '''
Дополнительных установок не нужно. Для type hints: from __future__ import annotations в старых версиях иногда; в 3.11+ обычно не требуется.
''';

final LessonDefinition _py4 = LessonDefinition(
  id: 'lesson4',
  title: 'Функции',
  theory: _pyTheory4,
  softwareSection: _pySoft4,
  installationGuide: _pyInstall4,
  questions: const [
    QuizQuestion(question: 'Ключевое слово для объявления функции?', options: ['function', 'def', 'fn'], correctIndex: 1),
    QuizQuestion(question: 'Что возвращает функция без return?', options: ['0', 'None', 'Пустая строка'], correctIndex: 1),
    QuizQuestion(question: '*args в объявлении функции — это:', options: ['Один аргумент', 'Кортеж позиционных аргументов', 'Только ключевые слова'], correctIndex: 1),
    QuizQuestion(question: 'Лямбда в Python может содержать:', options: ['Только выражение', 'Любое количество операторов', 'Только print'], correctIndex: 0),
    QuizQuestion(question: 'Докстринг размещают:', options: ['После return', 'Сразу после строки def', 'В конце файла'], correctIndex: 1),
    QuizQuestion(question: 'Плохая практика по умолчанию: def f(a=[]):', options: ['Нормально всегда', 'Общий список между вызовами', 'Ускоряет код'], correctIndex: 1),
    QuizQuestion(question: 'global x внутри функции нужно чтобы:', options: ['Создать локальную', 'Присвоить глобальной x', 'Импортировать модуль'], correctIndex: 1),
    QuizQuestion(question: 'Рекурсия в Python:', options: ['Запрещена', 'Разрешена', 'Только в лямбдах'], correctIndex: 1),
    QuizQuestion(question: 'return a, b вернёт:', options: ['Два отдельных return', 'Кортеж (a, b)', 'Только a'], correctIndex: 1),
    QuizQuestion(question: 'Имя функции должно быть объявлено до:', options: ['Импорта os', 'Вызова в коде ниже в том же файле', 'Установки pip'], correctIndex: 1),
  ],
);

const String _pyTheory5 = '''
Работа с файлами: open(path, mode, encoding='utf-8'). Режимы: r чтение, w перезапись, a дозапись, x создание, b бинарный. with open(...) as f: гарантирует закрытие даже при ошибке.

Чтение: f.read(), f.readline(), f.readlines(), или for line in f. Запись: f.write(str), writelines.

Пути: лучше pathlib.Path для кроссплатформенности. JSON: import json; json.load(f), json.dump(obj, f).

Ошибки перехватывают try/except IOError as e. Кодировка utf-8 явно для текста с кириллицей.
''';

const String _pySoft5 = '''
Для просмотра больших файлов в VS Code достаточно открыть их в редакторе; для логов иногда удобнее tail в терминале (Linux/macOS) или Get-Content -Wait в PowerShell.

Расширение Python позволяет запускать скрипт кнопкой Run.
''';

const String _pyInstall5 = '''
Всё уже есть в стандартной библиотеке для open/json. Для работы с Excel позже установят pandas/openpyxl отдельно: pip install pandas openpyxl.
''';

final LessonDefinition _py5 = LessonDefinition(
  id: 'lesson5',
  title: 'Работа с файлами',
  theory: _pyTheory5,
  softwareSection: _pySoft5,
  installationGuide: _pyInstall5,
  questions: const [
    QuizQuestion(question: 'Зачем with open(...) as f?', options: ['Ускорить диск', 'Автоматически закрыть файл', 'Шифровать файл'], correctIndex: 1),
    QuizQuestion(question: 'Режим "w" при открытии файла:', options: ['Только чтение', 'Перезапись/создание', 'Только добавление в конец'], correctIndex: 1),
    QuizQuestion(question: 'Как указать кодировку UTF-8 в open в Python 3?', options: ['encoding="utf-8"', 'utf8=true', 'Не нужно никогда'], correctIndex: 0),
    QuizQuestion(question: 'json.load ожидает:', options: ['Только строку', 'Файловый объект с JSON', 'Словарь Python'], correctIndex: 1),
    QuizQuestion(question: 'Режим "a" открывает файл для:', options: ['Чтения', 'Дозаписи в конец', 'Удаления'], correctIndex: 1),
    QuizQuestion(question: 'pathlib.Path используют для:', options: ['Только Windows', 'Удобных путей кроссплатформенно', 'Только сетевых дисков'], correctIndex: 1),
    QuizQuestion(question: 'f.read() при большом файле:', options: ['Всегда читает весь файл в память', 'Читает одну строку', 'Запрещено'], correctIndex: 0),
    QuizQuestion(question: 'Бинарный режим обозначается:', options: ['t', 'b в режиме rb/wb', 'bin'], correctIndex: 1),
    QuizQuestion(question: 'try/except при работе с файлами ловит:', options: ['Синтаксические ошибки в коде', 'Часто IOError/OSError', 'Только KeyboardInterrupt'], correctIndex: 1),
    QuizQuestion(question: 'for line in f: итерирует:', options: ['Байты без декодирования', 'Строки при текстовом режиме', 'Только первую строку'], correctIndex: 1),
  ],
);
