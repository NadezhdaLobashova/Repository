
Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	ДанныеЗаполнения = БоР_ОбщийМодульКлиентСервер.ПолучитьПолеСтруктуры(Параметры, "Основание");
	Если ДанныеЗаполнения <> Неопределено Тогда
		//Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.франЗадание") И ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		//	СтандартнаяОбработка = Ложь;
		//	ВыбраннаяФорма = "Обработка.РасписаниеЛК.Форма.ФормаПланирования";
		//	
		//	Параметры.Вставить("ДанныеЗаполнения"		, ДанныеЗаполнения);
		//	Параметры.Вставить("ВводНаОсновании"		, Истина);
		//	МассивПользователей = Справочники.Пользователи.ПолучитьПользователейПоФизЛицу(ДанныеЗаполнения.Сотрудник);
		//	Если МассивПользователей.Количество() > 0 Тогда
		//		Адрес_ДанныеСлотов = СформироватьДанныеСлотов(МассивПользователей[0], '00010101', '00010101', 0);
		//		Параметры.Вставить("Адрес_ДанныеСлотов"			, Адрес_ДанныеСлотов);
		//	КонецЕсли;
		//	Параметры.Вставить("ПутьКМетаданнымОбработки"	, "Обработка.РасписаниеЛК");
		//Иначе
		Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Событие") И ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "Обработка.РасписаниеЛК.Форма.ФормаПланирования";
			
			Параметры.Вставить("ДанныеЗаполнения"		, ДанныеЗаполнения);
			Параметры.Вставить("ВводНаОсновании"		, Истина);
			Адрес_ДанныеСлотов = СформироватьДанныеСлотов(ДанныеЗаполнения.Ответственный, '00010101', '00010101', 0);
			Параметры.Вставить("Адрес_ДанныеСлотов"			, Адрес_ДанныеСлотов);
			Параметры.Вставить("ПутьКМетаданнымОбработки"	, "Обработка.РасписаниеЛК");
		//ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПакетЧасов") И ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		//	СтандартнаяОбработка = Ложь;
		//	ВыбраннаяФорма = "Обработка.РасписаниеЛК.Форма.ФормаПланирования";
		//	
		//	Параметры.Вставить("ДанныеЗаполнения"		, ДанныеЗаполнения);
		//	Параметры.Вставить("ВводНаОсновании"		, Истина);
		//	Адрес_ДанныеСлотов = СформироватьДанныеСлотов(ДанныеЗаполнения.Сотрудник, '00010101', '00010101', 0);
		//	Параметры.Вставить("Адрес_ДанныеСлотов"			, Адрес_ДанныеСлотов);
		//	Параметры.Вставить("ПутьКМетаданнымОбработки"	, "Обработка.РасписаниеЛК");
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

// БоР : Создание подходящей структуры для передачи в форму планирования 16.08.2017 17:25:07
Функция СформироватьДанныеСлотов(Сотрудник, ДатаВремяНачала, ДатаВремяОкончания, Продолжительность) Экспорт
	ДанныеСотрудника = Новый Структура;
	ДанныеСотрудника.Вставить("Сотрудник"				, Сотрудник);
	ДанныеСотрудника.Вставить("Слоты"					, Новый Массив);
	
	СвойстваСлота = Новый Структура;
	СвойстваСлота.Вставить("Сотрудник"				, Сотрудник);
	СвойстваСлота.Вставить("ДатаВремяНачала"		, ДатаВремяНачала);
	СвойстваСлота.Вставить("ДатаВремяОкончания"		, ДатаВремяОкончания);
	СвойстваСлота.Вставить("Продолжительность"		, Продолжительность);
	
	ДанныеСотрудника.Слоты.Добавить(СвойстваСлота);
	
	ДанныеСлотов = Новый Массив;
	ДанныеСлотов.Добавить(ДанныеСотрудника);
	
	Адрес_ДанныеСлотов = ПоместитьВоВременноеХранилище(ДанныеСлотов, Новый УникальныйИдентификатор);
	ВозВрат Адрес_ДанныеСлотов;
	
КонецФункции
