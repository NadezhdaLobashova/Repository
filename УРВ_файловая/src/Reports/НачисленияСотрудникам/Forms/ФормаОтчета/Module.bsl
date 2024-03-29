&НаСервере
Процедура ПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	УстановитьКлючВарианта();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьКлючВарианта();
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойВариантаНаСервере(Настройки)
	УстановитьКлючВарианта();
КонецПроцедуры

&НаСервере
Процедура УстановитьКлючВарианта()
	Отчет.КлючВарианта = КлючТекущегоВарианта;
КонецПроцедуры	

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	перем ВыполненноеДействие;
	
	СтандартнаяОбработка = Ложь;
	
	Если Расшифровка = Неопределено Тогда 
		Возврат 
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
    ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
	
	Форма = ПолучитьФорму("Отчет.ОтчетРасшифровкаПоРегистраторам.Форма",ПараметрыФормы);
	
	ЗначениеДатаНачала                  = Форма.Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаНачала")); 
	ЗначениеДатаНачала.Значение         = Расшифровка.ДатаНачала;
	ЗначениеДатаНачала.Использование    = Истина;
	
	ЗначениеДатаОкончания               = Форма.Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаОкончания"));
	ЗначениеДатаОкончания.Значение      = КонецДня(Расшифровка.ДатаОкончания);
	ЗначениеДатаОкончания.Использование = Истина;
		
	ЗначениеСотрудник                   = Форма.Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Сотрудник"));
	ЗначениеСотрудник.Значение          = Расшифровка.Сотрудник;
	ЗначениеСотрудник.Использование     = Истина;
	
	Если Отчет.КлючВарианта <> "Сокращенный" Тогда
		ЗначениеПроект                      = Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ПолеОтбораПроект                    = Новый ПолеКомпоновкиДанных("Проект"); 
		ЗначениеПроект.ЛевоеЗначение        = ПолеОтбораПроект; 
		ЗначениеПроект.Использование        = Истина; 
		ЗначениеПроект.ПравоеЗначение       = Расшифровка.Проект;
		ЗначениеПроект.ВидСравнения         = ВидСравненияКомпоновкиДанных.Равно;
		
		ЗначениеВидРаботы                   = Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ПолеОтбораВидРаботы                 = Новый ПолеКомпоновкиДанных("ВидРаботы"); 
		ЗначениеВидРаботы.ЛевоеЗначение     = ПолеОтбораВидРаботы; 
		ЗначениеВидРаботы.Использование     = Истина; 
		ЗначениеВидРаботы.ПравоеЗначение    = Расшифровка.ВидРаботы;
		ЗначениеВидРаботы.ВидСравнения      = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	
    Форма.Открыть();
	 
КонецПроцедуры


