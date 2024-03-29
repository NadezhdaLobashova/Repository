// Возвращает список процедур-обработчиков обновления библиотеки.
//
// Здесь в алфавитном порядке размещаются только процедуры-обработчики обновления 
// библиотечных подсистем, которые используются в данной конфигурации. 
// Процедуры-обработчики обновления самой конфигурации следует размещать в функции 
// ОбработчикиОбновления общего модуля ОбновлениеИнформационнойБазыПереопределяемый.
//
// Возвращаемое значение:
//   ТаблицаЗначений - описание полей структуры см. в функции
//               ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления() 
//
Функция ОбработчикиОбновленияСтандартныхПодсистем() Экспорт
	
	Обработчики = ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления();
	
	// Подключаются процедуры-обработчики обновления библиотеки
	
	// АдресныйКлассификатор
	АдресныйКлассификатор.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	// Конец АдресныйКлассификатор
	
	// КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	// Конец КонтактнаяИнформация
	
	
	// ПолучениеФайловИзИнтернета
	ПолучениеФайловИзИнтернета.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	// Конец ПолучениеФайловИзИнтернета
	
	// Пользователи
	Пользователи.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	// Конец Пользователи
	
	
	Возврат Обработчики;
	
КонецФункции

// Возвращает признак, является ли конфигурация базовой.
//
// Пример реализации:
//  Если конфигурации выпускаются парами, то в имени базовой версии
//  может включаться дополнительное слово "Базовая". Тогда логика
//  определения базовой версии выглядит таким образом:
//
//	Возврат Найти(ВРег(Метаданные.Имя), "БАЗОВАЯ") > 0;
//
// Возвращаемое значение:
//   Булево   - Истина, если конфигурация - базовая.
//
Функция ЭтоБазоваяВерсияКонфигурации() Экспорт

	Возврат Найти(ВРег(Метаданные.Имя), "БАЗОВАЯ") > 0;

КонецФункции
