
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Ссылка1Нажатие(Элемент, СтандартнаяОбработка)
	
	ПерейтиПоНавигационнойСсылке(ПолучитьНавигационнуюСсылку(Элементы.Список.ТекущиеДанные.Ссылка1));
	
КонецПроцедуры

&НаКлиенте
Процедура Ссылка2Нажатие(Элемент, СтандартнаяОбработка)
	
	ПерейтиПоНавигационнойСсылке(ПолучитьНавигационнуюСсылку(Элементы.Список.ТекущиеДанные.Ссылка2));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "Ссылка1" Или Поле.Имя = "Ссылка2" Или Поле.Имя = "Источник" Тогда
		Если ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные[Поле.Имя]) Тогда
			ПерейтиПоНавигационнойСсылке(ПолучитьНавигационнуюСсылку(Элементы.Список.ТекущиеДанные[Поле.Имя]));
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьСобытия(Команда)
    
    ОбработаноСобытий = ОбработатьСобытияНаСервере();
    ПоказатьОповещениеПользователя(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='События обработаны (%1)'"), ОбработаноСобытий)); 
    Элементы.Список.Обновить();
    
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Ссылка2");
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Ссылка2");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

&НаСервере
Функция ОбработатьСобытияНаСервере()
    
    Возврат БизнесСобытия.ОбработкаПроизошедшихБизнесСобытий();
    
КонецФункции

#КонецОбласти
 
