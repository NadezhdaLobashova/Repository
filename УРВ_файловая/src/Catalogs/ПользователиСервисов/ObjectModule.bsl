#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
    
Процедура ПередЗаписью(Отказ)
	
	// Запишем строку EMail в любом случае.
	СтрокаEmail = "";
	Для каждого Строка Из КонтактнаяИнформация Цикл
		Если Строка.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
			СтрокаEmail = СтрокаEmail + ?(ПустаяСтрока(СтрокаEmail), "", "; ") + Строка.Представление;
		КонецЕсли;
	КонецЦикла; 
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;  
	КонецЕсли;
	
	//{rarus kruser 09082019 91127
	ОбменСНСИ = Константы.ИспользоватьОбменДаннымиНСИ20.Получить();	
	Если ЭтоНовый() И ОбменСНСИ Тогда
		ДатаСоздания = ТекущаяДата();
	КонецЕсли;
	//}rarus kruser 09082019 91127
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;  
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;  
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти  

#КонецЕсли
