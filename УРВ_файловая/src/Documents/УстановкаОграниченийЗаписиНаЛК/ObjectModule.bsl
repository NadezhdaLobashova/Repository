
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если ДополнительныеСвойства.Свойство("Отказ") И ДополнительныеСвойства.Отказ = Истина Тогда
		Отказ = ДополнительныеСвойства.Отказ;
		ВозВрат;
	КонецЕсли;

	Движения.ОграниченияЗаписиНаЛК.Очистить();
	Движения.ОграниченияЗаписиНаЛК.Записать();
	//ДвиженияОграниченияЗаписиНаЛК = ПолучитьДвиженияОграниченияЗаписиНаЛК(РежимПроведения);
	//Если ДвиженияОграниченияЗаписиНаЛК = Неопределено Тогда
	//	Отказ = Истина;
	//	ВозВрат;
	//КонецЕсли;
	//Движения.ОграниченияЗаписиНаЛК.Загрузить(ДвиженияОграниченияЗаписиНаЛК);
	Движения.ОграниченияЗаписиНаЛК.Записывать = Истина;
	// регистр ОграниченияЗаписиНаЛК
	Для Каждого ТекСтрокаОграничения Из Ограничения Цикл
		Движение = Движения.ОграниченияЗаписиНаЛК.Добавить();
		Движение.Период							= Дата;
		Движение.ВидУслуги						= ТекСтрокаОграничения.ВидУслуги;
		Движение.ТипКлиентаЛК					= ТекСтрокаОграничения.ТипКлиентаЛК;
		Движение.МаксимумКонсультацийВНеделю	= ТекСтрокаОграничения.МаксимумКонсультацийВНеделю;
		Движение.МаксимумКонсультацийВДень		= ТекСтрокаОграничения.МаксимумКонсультацийВДень;
		Движение.МинимальныйИнтервалВДнях		= ТекСтрокаОграничения.МинимальныйИнтервалВДнях;
		Движение.КонсультацииНедоступны			= ТекСтрокаОграничения.КонсультацииНедоступны;
	КонецЦикла;
	
	
	Движения.Записать();
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	БоР_ОбщийМодуль.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если Не ЗначениеЗаполнено(Автор) Тогда
		Автор = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(ДатаСоздания) Тогда
		ДатаСоздания = ТекущаяДата();
	КонецЕсли;	
	
КонецПроцедуры

Функция ПолучитьДвиженияОграниченияЗаписиНаЛК(РежимПроведения)
	
	//// регистр ОграниченияЗаписиНаЛК
	//Движения.ОграниченияЗаписиНаЛК.Записывать = Истина;
	//Движения.ОграниченияЗаписиНаЛК.Очистить();
	//Для Каждого ТекСтрокаОграничения Из Ограничения Цикл
	//	Движение = Движения.ОграниченияЗаписиНаЛК.Добавить();
	//	Движение.Период							= Дата;
	//	Движение.ВидУслуги				= ТекСтрокаОграничения.ВидУслуги;
	//	Движение.ТипКлиентаЛК					= ТекСтрокаОграничения.ТипКлиентаЛК;
	//	Движение.МаксимумКонсультацийВНеделю	= ТекСтрокаОграничения.МаксимумКонсультацийВНеделю;
	//	Движение.МаксимумКонсультацийВДень		= ТекСтрокаОграничения.МаксимумКонсультацийВДень;
	//	Движение.МинимальныйИнтервалВДнях		= ТекСтрокаОграничения.МинимальныйИнтервалВДнях;
	//	Движение.КонсультацииНедоступны			= ТекСтрокаОграничения.КонсультацииНедоступны;
	//КонецЦикла;

КонецФункции
