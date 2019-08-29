
#Область ОбработчикиСобытийФормы
    
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
    КонецЕсли;
    
    УстановитьУсловноеОформление();
    
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции
    
&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
    
    Запрос = Новый Запрос;
    Запрос.Текст =
        "ВЫБРАТЬ
        |   СоглашенияПараметрыСоглашения.Ссылка КАК Соглашение,
        |   СоглашенияПараметрыСоглашения.НомерСтроки,
        |   СоглашенияПараметрыСоглашения.КлючПараметров,
        |   СоглашенияПараметрыСоглашения.ТипОбращения,
        |   СоглашенияПараметрыСоглашения.Важность,
        |   СоглашенияПараметрыСоглашения.ЛинияПоддержки,
        |   СоглашенияПараметрыСоглашения.СостояниеОбращения,
        |   СоглашенияПараметрыСоглашения.КомпонентСервиса,
        |   СоглашенияПараметрыСоглашения.Раздел,
        |   СоглашенияПараметрыСоглашения.ВремяОбработки,
		//+ Котова А.Ю. 29.04.2018 ТЗ№ 74355 {
		|   СоглашенияПараметрыСоглашения.Абонент,
        |   СоглашенияПараметрыСоглашения.Проект,
		//- Котова А.Ю. 29.04.2018 ТЗ№ 74355 }
        |   СоглашенияПараметрыСоглашения.ВремяРеакции
        |ИЗ
        |   Справочник.Соглашения.ПараметрыСоглашения КАК СоглашенияПараметрыСоглашения
        |       ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СрокиОбращенийПоСоглашениям КАК СрокиОбращенийПоСоглашениям
        |       ПО СоглашенияПараметрыСоглашения.КлючПараметров = СрокиОбращенийПоСоглашениям.КлючПараметров
        |           И СоглашенияПараметрыСоглашения.Ссылка = СрокиОбращенийПоСоглашениям.Соглашение";
        
    Результат = Запрос.Выполнить();
    Выборка = Результат.Выбрать();
    
    Пока Выборка.Следующий() Цикл
        ПредставлениеКлюча = "";
        Для каждого КлючевойРеквизит Из Выборка.Соглашение.КлючевыеРеквизиты Цикл
            ПредставлениеКлюча = ПредставлениеКлюча + Выборка[КлючевойРеквизит.Реквизит.ИмяПредопределенныхДанных] + "; ";
        КонецЦикла; 
        ПредставлениеКлюча = Лев(ПредставлениеКлюча, СтрДлина(ПредставлениеКлюча) - 2);
        
    	Элемент = Список.УсловноеОформление.Элементы.Добавить();
    	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
    	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("КлючПараметров");
    	
    	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
    	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КлючПараметров");
    	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
    	ОтборЭлемента.ПравоеЗначение = Выборка.КлючПараметров;

    	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", ПредставлениеКлюча);
        
    КонецЦикла;
    
КонецПроцедуры
 
#КонецОбласти 
