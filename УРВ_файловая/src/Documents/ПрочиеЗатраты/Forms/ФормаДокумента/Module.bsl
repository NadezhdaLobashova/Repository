
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Или Не ЗначениеЗаполнено(Объект.Месяц) Тогда
		Объект.Месяц = НачалоМесяца(ТекущаяДата());
	КонецЕсли;	
	ЭтотОбъект.МесяцСтрокой = Формат(Объект.Месяц, "ДФ = ""гггг ММММ""");		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Направление = 1 Тогда
		Объект.Месяц = КонецМесяца(Объект.Месяц) + 1;
	Иначе
		Объект.Месяц = НачалоМесяца(НачалоМесяца(Объект.Месяц) - 1);
	КонецЕсли;
	
	ЭтотОбъект.МесяцСтрокой = Формат(Объект.Месяц, "ДФ = ""гггг ММММ""");
КонецПроцедуры

&НаКлиенте
Процедура ТипЗатратПриИзменении(Элемент)
	УстановитьВидимостьДоступность();	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьДоступность()
	Если Объект.ТипЗатрат = ПредопределенноеЗначение("Перечисление.ТипПрочихЗатрат.Оклад") Тогда
		Элементы.ЗатратыСотрудник.Видимость 				= Истина;
		Элементы.ЗатратыЧасы.Видимость 						= Истина;
		Элементы.ЗатратыЗаполнитьИРаспределить.Видимость 	= Истина;
	ИначеЕсли Объект.ТипЗатрат = ПредопределенноеЗначение("Перечисление.ТипПрочихЗатрат.Премия") Тогда
		Элементы.ЗатратыСотрудник.Видимость 				= Истина;
		Элементы.ЗатратыЧасы.Видимость 						= Ложь;
		Элементы.ЗатратыЗаполнитьИРаспределить.Видимость 	= Ложь;
		Элементы.ЗатратыСотрудник.ТолькоПросмотр			= Ложь;
		Элементы.ЗатратыЭтапПроекта.ТолькоПросмотр			= Ложь;
		Элементы.ЗатратыСтатья.ТолькоПросмотр			= Ложь;
	ИначеЕсли Объект.ТипЗатрат = ПредопределенноеЗначение("Перечисление.ТипПрочихЗатрат.ПрочиеЗатраты") Тогда
		Элементы.ЗатратыСотрудник.Видимость 				= Ложь;
		Элементы.ЗатратыЧасы.Видимость 						= Ложь;
		Элементы.ЗатратыЗаполнитьИРаспределить.Видимость 	= Ложь;
	Иначе
		Элементы.ЗатратыСотрудник.Видимость 				= Истина;
		Элементы.ЗатратыЧасы.Видимость 						= Истина;
		Элементы.ЗатратыЗаполнитьИРаспределить.Видимость 	= Ложь;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИРаспределить(Команда)
	ЗаполнитьИРаспределитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИРаспределитьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОкладыСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
		|	ОкладыСотрудниковСрезПоследних.Оклад
		|ПОМЕСТИТЬ ОкладыСотрудников
		|ИЗ
		|	РегистрСведений.ОкладыСотрудников.СрезПоследних(&КонецПериода, ) КАК ОкладыСотрудниковСрезПоследних
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОтработанноеВремяОстатки.Сотрудник КАК Сотрудник,
		|	ОтработанноеВремяОстатки.ЧасыОстаток КАК ВсегоЧасов
		|ПОМЕСТИТЬ втВсегоЧасов
		|ИЗ
		|	РегистрНакопления.ОтработанноеВремя.Остатки(
		|			&МоментВремени,
		|			Работа.ВидРаботы = ЗНАЧЕНИЕ(Перечисление.ВидыРабот.ОкладнаяРабота)
		|				И (Месяц МЕЖДУ &НачалоПериода И &КонецПериода)
		|				И Сотрудник В
		|					(ВЫБРАТЬ
		|						ОкладыСотрудников.Сотрудник
		|					ИЗ
		|						ОкладыСотрудников КАК ОкладыСотрудников)) КАК ОтработанноеВремяОстатки
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОтработанноеВремяОстатки.ЭтапПроекта КАК ЭтапПроекта,
		|	ОтработанноеВремяОстатки.Сотрудник КАК Сотрудник,
		|	ВЫБОР
		|		КОГДА ОтработанноеВремяОстатки.Работа.ВидыРабот.ОсновнаяСтатья = ЗНАЧЕНИЕ(Справочник.СтатьиПланирования.Пустаяссылка)
		|			ТОГДА ОтработанноеВремяОстатки.Проект.ОсновнаяСтатья
		|		ИНАЧЕ ОтработанноеВремяОстатки.Работа.ВидыРабот.ОсновнаяСтатья
		|	КОНЕЦ КАК Статья,
		|	ОтработанноеВремяОстатки.Дата,
		|	ОтработанноеВремяОстатки.Работа,
		|	ОтработанноеВремяОстатки.ЧасыОстаток КАК Часы,
		|	ОтработанноеВремяОстатки.ИдентификаторСтроки,
		|	ОтработанноеВремяОстатки.Задача,
		|	ОтработанноеВремяОстатки.ВидРабочегоВремени
		|ПОМЕСТИТЬ втЧасовПоПроектуПоДням
		|ИЗ
		|	РегистрНакопления.ОтработанноеВремя.Остатки(
		|			&МоментВремени,
		|			Проект = &Проект
		|				И Работа.ВидРаботы = ЗНАЧЕНИЕ(Перечисление.ВидыРабот.ОкладнаяРабота)
		|				И (Месяц МЕЖДУ &НачалоПериода И &КонецПериода)
		|				И Сотрудник В
		|					(ВЫБРАТЬ
		|						ОкладыСотрудников.Сотрудник
		|					ИЗ
		|						ОкладыСотрудников КАК ОкладыСотрудников)) КАК ОтработанноеВремяОстатки
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втЧасовПоПроектуПоДням.ЭтапПроекта КАК ЭтапПроекта,
		|	втЧасовПоПроектуПоДням.Сотрудник КАК Сотрудник,
		|	втЧасовПоПроектуПоДням.Статья,
		|	СУММА(втЧасовПоПроектуПоДням.Часы) КАК Часы
		|ПОМЕСТИТЬ втЧасовПоПроекту
		|ИЗ
		|	втЧасовПоПроектуПоДням КАК втЧасовПоПроектуПоДням
		|
		|СГРУППИРОВАТЬ ПО
		|	втЧасовПоПроектуПоДням.Статья,
		|	втЧасовПоПроектуПоДням.ЭтапПроекта,
		|	втЧасовПоПроектуПоДням.Сотрудник
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОкладыСотрудников.Сотрудник,
		|	втЧасовПоПроекту.ЭтапПроекта,
		|	втЧасовПоПроекту.Статья,
		|	втЧасовПоПроекту.Часы,
		|	втЧасовПоПроекту.Часы / втВсегоЧасов.ВсегоЧасов * ОкладыСотрудников.Оклад КАК Сумма
		|ИЗ
		|	втЧасовПоПроекту КАК втЧасовПоПроекту
		|		ЛЕВОЕ СОЕДИНЕНИЕ ОкладыСотрудников КАК ОкладыСотрудников
		|		ПО (ОкладыСотрудников.Сотрудник = втЧасовПоПроекту.Сотрудник)
		|		ЛЕВОЕ СОЕДИНЕНИЕ втВсегоЧасов КАК втВсегоЧасов
		|		ПО втЧасовПоПроекту.Сотрудник = втВсегоЧасов.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втЧасовПоПроектуПоДням.ЭтапПроекта,
		|	втЧасовПоПроектуПоДням.Сотрудник КАК Сотрудник,
		|	втЧасовПоПроектуПоДням.Статья,
		|	втЧасовПоПроектуПоДням.Дата КАК Дата,
		|	втЧасовПоПроектуПоДням.Работа,
		|	втЧасовПоПроектуПоДням.Часы,
		|	втЧасовПоПроектуПоДням.ИдентификаторСтроки,
		|	втЧасовПоПроектуПоДням.Задача,
		|	втЧасовПоПроектуПоДням.ВидРабочегоВремени
		|ИЗ
		|	втЧасовПоПроектуПоДням КАК втЧасовПоПроектуПоДням
		|
		|УПОРЯДОЧИТЬ ПО
		|	Сотрудник,
		|	Дата
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Объект.Месяц));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Объект.Месяц));
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(КонецМесяца(Объект.Месяц), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Проект", Объект.Проект);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Объект.Затраты.Загрузить(РезультатЗапроса[РезультатЗапроса.Количество() - 2].Выгрузить());
	Объект.ЗатратыПоДням.Загрузить(РезультатЗапроса[РезультатЗапроса.Количество() - 1].Выгрузить());
КонецПроцедуры
