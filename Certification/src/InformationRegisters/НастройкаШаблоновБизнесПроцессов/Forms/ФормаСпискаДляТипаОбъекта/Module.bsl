
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Объект") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.Отбор,
			"ИдентификаторОбъекта",
			ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Параметры.Объект)));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
