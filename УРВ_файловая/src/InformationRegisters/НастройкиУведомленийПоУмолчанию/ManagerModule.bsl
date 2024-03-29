#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает настройку по умолчанию
Функция ПолучитьНастройку(Настройка, ВидСобытия) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиУведомленийПоУмолчанию.Значение
		|ИЗ
		|	РегистрСведений.НастройкиУведомленийПоУмолчанию КАК НастройкиУведомленийПоУмолчанию
		|ГДЕ
		|	НастройкиУведомленийПоУмолчанию.Настройка = &Настройка
		|	И НастройкиУведомленийПоУмолчанию.ВидСобытия = &ВидСобытия";
	
	Запрос.УстановитьПараметр("ВидСобытия", ВидСобытия);
	Запрос.УстановитьПараметр("Настройка", Настройка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Значение;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Записывает настройку по умолчанию
Процедура УстановитьНастройку(Настройка, ВидСобытия, Значение) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.НастройкиУведомленийПоУмолчанию.СоздатьМенеджерЗаписи();
	Запись.Настройка = Настройка;
	Запись.ВидСобытия = ВидСобытия;
	Запись.Значение = Значение;
	Запись.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
