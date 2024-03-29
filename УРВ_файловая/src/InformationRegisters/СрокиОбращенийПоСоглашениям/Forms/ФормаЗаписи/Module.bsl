
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Запись.Период) Тогда
		ПериодМестный = МестноеВремя(Запись.Период);
	КонецЕсли;
	Если ЗначениеЗаполнено(Запись.СрокОбработки) Тогда
		СрокОбработкиМестный = МестноеВремя(Запись.СрокОбработки);
	КонецЕсли;
	Если ЗначениеЗаполнено(Запись.СрокРеакции) Тогда
		СрокРеакцииМестный = МестноеВремя(Запись.СрокРеакции);
    КонецЕсли;
    
    УстановитьСписокВыбораКлючаПараметров();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(ПериодМестный) Тогда
		ТекущийОбъект.Период = УниверсальноеВремя(ПериодМестный);
	Иначе
		ТекущийОбъект.Период = ПериодМестный;
	КонецЕсли;
	Если ЗначениеЗаполнено(СрокОбработкиМестный) Тогда
		ТекущийОбъект.СрокОбработки = УниверсальноеВремя(СрокОбработкиМестный);
	Иначе
		ТекущийОбъект.СрокОбработки = СрокОбработкиМестный;
	КонецЕсли;
	Если ЗначениеЗаполнено(СрокРеакцииМестный) Тогда
		ТекущийОбъект.СрокРеакции = УниверсальноеВремя(СрокРеакцииМестный);
	Иначе
		ТекущийОбъект.СрокРеакции = СрокРеакцииМестный;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы
    
&НаКлиенте
Процедура СоглашениеПриИзменении(Элемент)
    
    Запись.КлючПараметров = Неопределено;
    УстановитьСписокВыбораКлючаПараметров();
    
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьСписокВыбораКлючаПараметров()
	
    Запрос = Новый Запрос;
    
    Запрос.Текст = 
    	"ВЫБРАТЬ
        |   СоглашенияПараметрыСоглашения.ТипОбращения,
        |   СоглашенияПараметрыСоглашения.Важность,
        |   СоглашенияПараметрыСоглашения.ЛинияПоддержки,
        |   СоглашенияПараметрыСоглашения.СостояниеОбращения,
        |   СоглашенияПараметрыСоглашения.КомпонентСервиса,
        |   СоглашенияПараметрыСоглашения.Раздел,
		//+ Котова А.Ю. 06.11.2018 ТЗ№ 74355 {
		|   СоглашенияПараметрыСоглашения.Абонент,
        |   СоглашенияПараметрыСоглашения.Проект,
		//- Котова А.Ю. 06.11.2018 ТЗ№ 74355 }
        |   СоглашенияПараметрыСоглашения.КлючПараметров
        |ИЗ
        |   Справочник.Соглашения.ПараметрыСоглашения КАК СоглашенияПараметрыСоглашения
        |ГДЕ
        |   СоглашенияПараметрыСоглашения.Ссылка = &Соглашение";
    
    Запрос.УстановитьПараметр("Соглашение", Запись.Соглашение);
    
    Результат = Запрос.Выполнить();
    Выборка = Результат.Выбрать();
    СписокВыбора = Элементы.КлючПараметров.СписокВыбора;
    СписокВыбора.Очистить();
    Пока Выборка.Следующий() Цикл
        ПредставлениеКлюча = "";
        Для каждого КлючевойРеквизит Из Запись.Соглашение.КлючевыеРеквизиты Цикл
            ПредставлениеКлюча = ПредставлениеКлюча + Выборка[КлючевойРеквизит.Реквизит.ИмяПредопределенныхДанных] + "; ";
        КонецЦикла; 
        ПредставлениеКлюча = Лев(ПредставлениеКлюча, СтрДлина(ПредставлениеКлюча) - 2);
        СписокВыбора.Добавить(Выборка.КлючПараметров, ПредставлениеКлюча);
    КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 