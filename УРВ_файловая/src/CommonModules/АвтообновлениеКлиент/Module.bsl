
#Область ПрограммныйИнтерфейс

// Открывает модальную форму настройки автообновления списка. При завершении диалога.
// устанавливает выбранные параметры автообновления списка.
//
// Параметры:
// Форма - уникальный идентификатор открытой формы.
// ИмяСписка - Строка - имя реквизита списка на форме.
//
Процедура УстановитьПараметрыАвтообновленияСписка(Форма, ИмяСписка) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АвтоОбновление", Форма.Элементы[ИмяСписка].АвтоОбновление);
	ПараметрыФормы.Вставить("ПериодАвтоОбновления", Форма.Элементы[ИмяСписка].ПериодАвтоОбновления);
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Форма", Форма);
	ПараметрыОбработчика.Вставить("ИмяСписка", ИмяСписка);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"УстановитьПараметрыАвтообновленияСпискаПродолжение",
		ЭтотОбъект,
		ПараметрыОбработчика);
	ОткрытьФорму("ОбщаяФорма.НастройкаАвтообновления",
		ПараметрыФормы,
		Форма,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры	


// Открывает модальную форму настройки автообновления формы. При завершении диалога
// возвращает выбранные параметры автообновления.
//
// Параметры:
// Форма - уникальный идентификатор открытой формы.
//
Функция УстановитьПараметрыАвтообновленияФормы(
	Форма, НастройкиАвтообновления, ОписаниеОповещения = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АвтоОбновление", НастройкиАвтообновления.АвтоОбновление);
	ПараметрыФормы.Вставить("ПериодАвтоОбновления", НастройкиАвтообновления.ПериодАвтоОбновления);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяФормы", Форма.ИмяФормы);
	ДополнительныеПараметры.Вставить("ОписаниеОповещения", ОписаниеОповещения);
	
	ОписаниеОповещенияПослеЗакрытияФормыНастройкиАвтообновления = 
		Новый ОписаниеОповещения(
			"УстановитьПараметрыАвтообновленияФормыПродолжение",
			ЭтотОбъект,
			ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.НастройкаАвтообновления",
		ПараметрыФормы,
		Форма,,,,
		ОписаниеОповещенияПослеЗакрытияФормыНастройкиАвтообновления,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции
    
Процедура УстановитьПараметрыАвтообновленияСпискаПродолжение(Результат, Параметры) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	Форма = Параметры.Форма;
	ИмяСписка = Параметры.ИмяСписка;
	АвтообновлениеВызовСервера.СохранитьНастройкиАвтообновленияСписка(Форма.ИмяФормы, ИмяСписка, Результат);
	Форма.Элементы[ИмяСписка].АвтоОбновление = Результат.АвтоОбновление;
	Форма.Элементы[ИмяСписка].ПериодАвтоОбновления = Результат.ПериодАвтоОбновления;
	Если Результат.АвтоОбновление Тогда
		Форма.Элементы[ИмяСписка].Обновить();
	КонецЕсли;
	
КонецПроцедуры

// Процедура - Установить параметры автообновления формы продолжение.
//
// Параметры:
//  Результат - Структура:
//              * АвтоОбновление - признак использования автообновления.
//              * ПериодАвтоОбновления - периодичность автообновления в секундах.
//  ДополнительныеПараметры - Структура:
//                            * ИмяФормы - форма, на которой устанавливаются настройки автообновления.
//                            * ОписаниеОповещения - действие после установки автообновления.
//
Процедура УстановитьПараметрыАвтообновленияФормыПродолжение(Результат, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		АвтообновлениеВызовСервера.СохранитьНастройкиАвтообновленияФормы(Параметры.ИмяФормы, Результат);
	КонецЕсли;
	
	Если Параметры.ОписаниеОповещения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещения, Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 
