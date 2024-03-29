
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Отбор.Свойство("Владелец") И ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
		Элементы.ОбслуживающаяОрганизация.Видимость = Ложь;
		ОбслуживающаяОрганизация = Параметры.Отбор.Владелец;
	Иначе
		ИсходнаяЛинияПоддержки = Параметры.ТекущаяСтрока;
		Если ЗначениеЗаполнено(ИсходнаяЛинияПоддержки) И ТипЗнч(ИсходнаяЛинияПоддержки) = Тип("СправочникСсылка.ЛинииПоддержки") Тогда
			ОбслуживающаяОрганизация = Справочники.ЛинииПоддержки.ОбслуживающаяОрганизация(ИсходнаяЛинияПоддержки);
		КонецЕсли;
		Элементы.ОбслуживающаяОрганизация.Видимость = Истина;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Ссылка") <> Ложь Тогда
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор, "Владелец", ОбслуживающаяОрганизация, ВидСравненияКомпоновкиДанных.Равно,, Истина);
    Если ЗначениеЗаполнено(ИсходнаяЛинияПоддержки) Тогда
    	Элементы.Список.ТекущаяСтрока = ИсходнаяЛинияПоддержки;
    КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если Не ЗначениеЗаполнено(ОбслуживающаяОрганизация) Тогда
		ОбслуживающаяОрганизация = Настройки.Получить("ОбслуживающаяОрганизация");
	КонецЕсли;
	
	Настройки.Удалить("ОбслуживающаяОрганизация");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы
	
&НаКлиенте
Процедура ОбслуживающаяОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор, "Владелец", ОбслуживающаяОрганизация, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЭтоПерваяЛинияПоддержки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ВыделенныйШрифт);

КонецПроцедуры

#КонецОбласти
