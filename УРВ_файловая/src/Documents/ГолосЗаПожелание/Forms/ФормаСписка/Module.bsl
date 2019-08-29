
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
    
    Если ЗначениеЗаполнено(Параметры.Пожелание) Тогда
	    ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Пожелание", Параметры.Пожелание, 
            ВидСравненияКомпоновкиДанных.Равно, , Истина);
        Элементы.Пожелание.Видимость = Ложь;
    КонецЕсли;
    
    УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
    ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Голос");
	Элемент.Оформление.УстановитьЗначениеПараметра("ВыделятьОтрицательные", Истина);
	
КонецПроцедуры
 
#КонецОбласти 
