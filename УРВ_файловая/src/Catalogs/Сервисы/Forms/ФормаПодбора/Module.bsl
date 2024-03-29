
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
		Если Параметры.ДанныеПодбора <> Неопределено Тогда
			
			ДанныеПодбора.ЗагрузитьЗначения(Параметры.ДанныеПодбора);
			
		КонецЕсли; 
		
	КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		
		Для каждого Значение Из ВыбранноеЗначение Цикл
			
			ДобавитьЗначениеВыбора(Значение);
			
		КонецЦикла; 
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Для каждого Строка Из Элементы.Список.ВыделенныеСтроки Цикл
		
		ДобавитьЗначениеВыбора(Строка);
		
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОповеститьОВыборе(ДанныеПодбора.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть()
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДобавитьЗначениеВыбора(Значение)
	
	Если ДанныеПодбора.НайтиПоЗначению(Значение) = Неопределено Тогда
		Если ТипЗнч(Значение) = Тип("СправочникСсылка.Сервисы") Тогда
			ДанныеПодбора.Добавить(Значение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 
