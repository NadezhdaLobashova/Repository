

////////////////////////////////////////////////////////////////////////////////
// ПРОВЕРКА ПРАВИЛЬНОСТИ ЗАПОЛНЕНИЯ ДОКУМЕНТОВ

// Формирует фамилию и инициалы либо по наименованию элемента справочника ФизическиеЛица,
// либо по переданным строкам.
// Если передан Объект, то извлеченная из него строка считается совокупностью 
// Фамилия + Имя + Отчество, разделенными пробелами.
//
// Параметры
//  ОбъектИлиСтрока - строка, ссылка или объект элемента справочника ФизическиеЛица.
//  Фамилия		    - фамилия физического лица.
//  Имя		        - имя физического лица.
//  Отчество	    - отчество физического лица.
//
// Возвращаемое значение 
//  Строка - фамилия и инициалы одной строкой. 
//  В параметрах Фамилия, Имя и Отчество записываются вычисленные части.
//
// Пример:
//  Результат = ФамилияИнициалыФизЛица("Иванов Иван Иванович"); // Результат = "Иванов И. И."
//
Функция ФамилияИнициалыФизЛица(ОбъектИлиСтрока = "", Фамилия = " ", Имя = " ", Отчество = " ") Экспорт

	ТипОбъекта = ТипЗнч(ОбъектИлиСтрока);
	Если ТипОбъекта = Тип("Строка") Тогда
		ФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СокрЛП(ОбъектИлиСтрока), " ");
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ФизическиеЛица") Или ТипОбъекта = Тип("СправочникОбъект.ФизическиеЛица") Тогда
		ФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СокрЛП(ОбъектИлиСтрока.Наименование), " ");
	Иначе
		// используем возможно переданные отдельные строки
		Возврат ?(Не ПустаяСтрока(Фамилия), 
		          Фамилия + ?(Не ПустаяСтрока(Имя), " " + Лев(Имя,1) + "." + ?(Не ПустаяСтрока(Отчество), Лев(Отчество,1) + ".", ""), ""),
		          "")
	КонецЕсли;
	
	КоличествоПодстрок = ФИО.Количество();
	Фамилия            = ?(КоличествоПодстрок > 0, ФИО[0], "");
	Имя                = ?(КоличествоПодстрок > 1, ФИО[1], "");
	Отчество           = ?(КоличествоПодстрок > 2, ФИО[2], "");
	
	Возврат ?(Не ПустаяСтрока(Фамилия), 
	          Фамилия + ?(Не ПустаяСтрока(Имя), " " + Лев(Имя,1) + "." + ?(Не ПустаяСтрока(Отчество), Лев(Отчество, 1) + ".", ""), ""),
	          "");
	
КонецФункции
