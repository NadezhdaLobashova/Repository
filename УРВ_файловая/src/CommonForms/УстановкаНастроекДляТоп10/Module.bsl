
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КоличествоДнейОтбораОбращений = Параметры.КоличествоДнейОтбораОбращений;
	ОтображатьЗакрытые = Параметры.ОтображатьЗакрытые;
	ИспользоватьОтображатьЗакрытые = Параметры.ИспользоватьОтображатьЗакрытые;
	ТипКарточек = Параметры.ТипКарточек;
	
	Если Не ИспользоватьОтображатьЗакрытые Тогда
		Элементы.ОтображатьЗакрытые.Видимость = Ложь;
	КонецЕсли;
	
	Если ТипКарточек = "Пожелания" Тогда
		Элементы.ОтображатьЗакрытые.Заголовок = НСтр("ru='Отображать реализованные пожелания'"); 	
	ИначеЕсли ТипКарточек = "Ошибки" Тогда
		Элементы.ОтображатьЗакрытые.Заголовок = НСтр("ru='Отображать исправленные ошибки'"); 	
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("КоличествоДнейОтбораОбращений", КоличествоДнейОтбораОбращений);
	ПараметрыЗакрытия.Вставить("ОтображатьЗакрытые", ОтображатьЗакрытые);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
