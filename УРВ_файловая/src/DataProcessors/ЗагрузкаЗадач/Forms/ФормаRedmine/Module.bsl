
////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьПризнакИмпорта(Импортировать)

	Для Каждого ИдентификаторСтроки Из Элементы.Задачи.ВыделенныеСтроки Цикл
		Строка = Объект.ЗадачиRedmine.НайтиПоИдентификатору(ИдентификаторСтроки);
		Строка.Импортировать = Импортировать;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНаСервере()
	
	Обработка = РеквизитФормыВЗначение("Объект");
	
	Объект.ЗадачиRedmine.Очистить();
	Попытка
		МассивЗадач = Обработка.ПолучитьЗадачиПоПроекту(Объект.Проект.RedmineProjectId);
		Для Каждого Задача Из МассивЗадач Цикл
			ЗаполнитьЗначенияСвойств(Объект.ЗадачиRedmine.Добавить(), Задача);
		КонецЦикла; 
	Исключение
		Сообщить("Возникла ошибка при загрузке задач:" + Символы.ПС + ОписаниеОшибки());
	КонецПопытки;
	Объект.ЗадачиRedmine.Сортировать("ДатаСоздания УБЫВ");
	
КонецПроцедуры

&НаСервере
Процедура ФоноваяСинхронизацияЗадачНаСервере()
	
	Обработка = РеквизитФормыВЗначение("Объект");
	Обработка.ФоноваяСинхронизацияЗадач();

КонецПроцедуры

&НаСервере
Процедура ИмпортироватьЗадачиНаСервере()
	
	Обработка = РеквизитФормыВЗначение("Объект");
	
	МассивСтрокДляЗагрузки = Объект.ЗадачиRedmine.Выгрузить(Новый Структура("Импортировать", Истина));
	Для Каждого СтрокаТЧ Из МассивСтрокДляЗагрузки Цикл
		Попытка
			Обработка.ИмпортироватьЗадачу(СтрокаТЧ, Объект.Проект);
		Исключение
			Сообщить("Возникла ошибка при импорте задачи:" + Символы.ПС + ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Проект") Тогда
		Объект.Проект = Параметры.Проект;
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Загрузить(Команда)
	ЗагрузитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтметки(Команда)
	
	УстановитьПризнакИмпорта(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметки(Команда)
	
	УстановитьПризнакИмпорта(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортироватьЗадачи(Команда)
	ИмпортироватьЗадачиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФоноваяСинхронизацияЗадач(Команда)
	ФоноваяСинхронизацияЗадачНаСервере();
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ СПИСКОВ

////////////////////////////////////////////////////////////////////////////////
// 


