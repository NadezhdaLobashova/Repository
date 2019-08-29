#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Количество() = 1 Тогда
		
		ВидБизнесСобытия = Получить(0).ВидБизнесСобытия;
	
		БизнесСобытия.СохранитьПодпискуНаБизнесСобытия(ВидБизнесСобытия, 
			Перечисления.ПотребителиБизнесСобытий.АвтоматическийЗапускБизнесПроцессов);
	
	ИначеЕсли Количество() = 0 Тогда 
			
		КоличествоПодписчиков = ПолучитьКоличествоПодписчиков(ЭтотОбъект.Отбор.ВидБизнесСобытия.Значение);
		
		Если КоличествоПодписчиков = 0 Тогда
			БизнесСобытия.УдалитьПодпискуНаБизнесСобытия(ЭтотОбъект.Отбор.ВидБизнесСобытия.Значение, 
				Перечисления.ПотребителиБизнесСобытий.АвтоматическийЗапускБизнесПроцессов);
		КонецЕсли;	
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьКоличествоПодписчиков(ВидБизнесСобытия)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПравилаАвтоматическогоЗапускаБизнесПроцессов.ВидБизнесСобытия
	               |ИЗ
	               |	РегистрСведений.ПравилаАвтоматическогоЗапускаБизнесПроцессов КАК ПравилаАвтоматическогоЗапускаБизнесПроцессов
	               |ГДЕ
	               |	ПравилаАвтоматическогоЗапускаБизнесПроцессов.ВидБизнесСобытия = &ВидБизнесСобытия";
				   
	Запрос.УстановитьПараметр("ВидБизнесСобытия", ВидБизнесСобытия);				   
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Возврат Таблица.Количество();
	
КонецФункции;	
	
#КонецОбласти 

#КонецЕсли