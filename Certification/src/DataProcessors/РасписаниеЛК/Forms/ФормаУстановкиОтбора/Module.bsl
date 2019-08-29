
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БоР_ОбщийМодуль.ЗаполнитьРеквизитыИзПараметров(ЭтаФорма, Неопределено);

	МассивДоступныхСотрудников = РегистрыСведений.РолиСотрудниковЛК.ПолучитьМассивДоступныхСотрудников(Истина, Истина);

	Для каждого Сотрудник Из МассивДоступныхСотрудников Цикл
		строкаТЗ = Сотрудники.Добавить();
		строкаТЗ.Сотрудник	= Сотрудник;
		строкаТЗ.Пометка	= (ОтборПоСотрудникам.НайтиПоЗначению(Сотрудник) <> Неопределено);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ОтборПоСотрудникам.Очистить();
	
	строкиТЗ = Сотрудники.НайтиСтроки(Новый Структура("Пометка", Истина));
	Для каждого строкаТЗ Из строкиТЗ Цикл
		ОтборПоСотрудникам.Добавить(строкаТЗ.Сотрудник);
	КонецЦикла;
	
	Если ОтборПоСотрудникам.Количество() = 0 Тогда
		ПоказатьПредупреждение(, "Необходимо выбрать хотя бы одного сотрудника!", 30);
		Возврат;
	КонецЕсли;
	
	СтруктураВозврата = Новый Структура("ОтборПоСотрудникам", ОтборПоСотрудникам);
	Закрыть(СтруктураВозВрата);

КонецПроцедуры

&НаКлиенте
Процедура КомандаСнятьФлажки(Команда)
	ОбработатьФлажки(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьФлажки(Команда)
	ОбработатьФлажки(Истина);
КонецПроцедуры

&НаКлиенте
Процедура КомандаИнвертироватьФлажки(Команда)
	ОбработатьФлажки();
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьФлажки(НовоеЗначение = Неопределено)
	
	Для каждого строкаТЗ Из Сотрудники Цикл
		строкаТЗ.Пометка = ?(НовоеЗначение = Неопределено, НЕ строкаТЗ.Пометка, НовоеЗначение);
	КонецЦикла;
	
КонецПроцедуры

