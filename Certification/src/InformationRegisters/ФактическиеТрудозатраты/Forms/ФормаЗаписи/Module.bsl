
#Область ОбработчикиСобытийФормы
    
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоНовый = Параметры.Ключ.Пустой();
	
	Если ЭтоНовый Тогда 
		//Люфт Кристина Задача №87997 03.07.2019 +
		//Запись.ДатаРаботы = ТекущаяДатаСеанса();
		//Запись.Пользователь = Пользователи.АвторизованныйПользователь();
		//
		//СведенияОПользователе = РегистрыСведений.СведенияОПользователях.СведенияОПользователе(Запись.Пользователь);
		//
		//Запись.ОбслуживающаяОрганизация = СведенияОПользователе.ОбслуживающаяОрганизация;
		//Запись.ЛинияПоддержки = СведенияОПользователе.ЛинияПоддержки;
		//Люфт Кристина Задача №87997 03.07.2019 -
		Если Параметры.Свойство("Источник") И ЗначениеЗаполнено(Параметры.Источник) Тогда 
			Запись.Источник = Параметры.Источник;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Запись.Источник) Тогда 
			Запись.ОписаниеРаботы = СтрШаблон(НСтр("ru = 'Работа над ""%1""'"), Запись.Источник);
			//Люфт Кристина Задача №87997 03.07.2019 +
			Запись.ДатаРаботы = ТекущаяДатаСеанса();
			Запись.Пользователь = Пользователи.АвторизованныйПользователь();
		
			СведенияОПользователе = РегистрыСведений.СведенияОПользователях.СведенияОПользователе(Запись.Пользователь);
		
			Запись.ОбслуживающаяОрганизация = СведенияОПользователе.ОбслуживающаяОрганизация;
			Запись.ЛинияПоддержки = СведенияОПользователе.ЛинияПоддержки;
			
		Иначе 		
			Сообщить("Документ не записан.
			|Указать трудозатраты можно только после записи документа.");
			Отказ = Истина;
			//Люфт Кристина Задача №87997 03.07.2019 -
		КонецЕсли;
		
	КонецЕсли;
	
	ДлительностьРаботы = УчетВремениКлиентСервер.ЧислоВСтроку(Запись.Длительность);
	
	Элементы.Пользователь.ТолькоПросмотр = Истина;
	Если РольДоступна("ПолныеПрава") Тогда 
		Элементы.Пользователь.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
	НачальнаяДатаДобавления = Запись.ДатаРаботы;
	
	Элементы.ДлительностьРаботы.СписокВыбора.ЗагрузитьЗначения(МассивВыбораВремени());
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Длительность = УчетВремениКлиентСервер.ЧислоИзСтроки(ДлительностьРаботы);
	
	Если ЭтоНовый Или НачальнаяДатаДобавления <> ТекущийОбъект.ДатаРаботы Тогда 
		ТекущийОбъект.НомерДобавления = УчетВремени.МаксимальныйНомерДобавления(
			ТекущийОбъект.ОбслуживающаяОрганизация, 
			ТекущийОбъект.ЛинияПоддержки, 
			ТекущийОбъект.Пользователь, 
			ТекущийОбъект.ДатаРаботы);
	КонецЕсли;		
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	НачальнаяДатаДобавления = Запись.ДатаРаботы;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ЗначениеЗаполнено(ДлительностьРаботы) Или ДлительностьРаботы = "00:00" Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не заполнено поле ""Длительность""'"),,
			"ДлительностьРаботы",, 
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции
    
&НаКлиентеНаСервереБезКонтекста
Функция МассивВыбораВремени()
	
	МассивВыбора = Новый Массив;
	
	МассивВыбора.Добавить("00:15");
	МассивВыбора.Добавить("00:30");
	МассивВыбора.Добавить("00:45");
	МассивВыбора.Добавить("01:00");
	МассивВыбора.Добавить("01:30");
	МассивВыбора.Добавить("02:00");
	МассивВыбора.Добавить("03:00");
	МассивВыбора.Добавить("04:00");
	МассивВыбора.Добавить("05:00");
	
	Возврат МассивВыбора;
	
КонецФункции

#КонецОбласти 
