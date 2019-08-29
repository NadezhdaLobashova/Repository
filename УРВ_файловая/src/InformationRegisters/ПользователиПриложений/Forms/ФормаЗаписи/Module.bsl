
#Область ОбработчикиСобытийФормы
    
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
	Если Не ЗначениеЗаполнено(Запись.Сервис) Тогда
		Если ЗначениеЗаполнено(Запись.ПользовательСервиса) Тогда
			Запись.Сервис = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.ПользовательСервиса,"Владелец");
		ИначеЕсли ЗначениеЗаполнено(Запись.Приложение) Тогда
			Запись.Сервис = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.Приложение,"Владелец");
		КонецЕсли;  
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти 
