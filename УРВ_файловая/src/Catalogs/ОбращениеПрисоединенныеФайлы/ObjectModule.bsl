#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;  
	КонецЕсли;
    
    ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;  
	КонецЕсли;
    
    Если ДополнительныеСвойства.ЭтоНовый Тогда
		БизнесСобытия.ЗарегистрироватьСобытие(
			ВладелецФайла,
			Справочники.ВидыБизнесСобытий.ДобавленФайл,,,,
			Ссылка);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
