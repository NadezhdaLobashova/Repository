&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//инициализация параметров обработки
	//Объект.РедмайнСервер = "192.168.55.27";
	////Объект.РедмайнПорт = 80;
	//Объект.РедмайнКлюч = "fb2eff03513051e7b7e4c1bf57e5dcd8c452f12f";
	//Объект.РедмайнПуть = "/redmine";

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
//Список задач

&НаКлиенте
Процедура ПолучитьСписокЗадач(Команда)
	ПолучитьСписокЗадачНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПолучитьСписокЗадачНаСервере()
	текОбъект = РеквизитФормыВЗначение("Объект");
	текОбъект.ОбновитьСписокЗадач();
КонецПроцедуры

&НаСервере
Процедура ПолучитьВесьСписокЗадачНаСервере()
	текОбъект = РеквизитФормыВЗначение("Объект");
	текОбъект.ОбновитьСписокЗадач(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВесьСписокЗадач(Команда)
	ПолучитьВесьСписокЗадачНаСервере();
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////
//Список проектов
&НаКлиенте
Процедура ПолучитьСписокПроектов(Команда)
	ПолучитьСписокПроектовНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПолучитьСписокПроектовНаСервере()
	текОбект = РеквизитФормыВЗначение("Объект");
	СписокПроектов = текОбект.СписокПроектов();
	МассивПроектов = СписокПроектов.project;
	
	ТаблицаПроектов = Новый ТаблицаЗначений;
	КС = Новый КвалификаторыСтроки(100);
	Массив = Новый Массив;
	Массив.Добавить(Тип("Строка"));
	ОписаниеТиповС = Новый ОписаниеТипов(Массив, , КС);
	ТаблицаПроектов.Колонки.Добавить("id"	, ОписаниеТиповС, "id");
	ТаблицаПроектов.Колонки.Добавить("name"	, ОписаниеТиповС, "name");
	
	Для каждого СтрПроект Из МассивПроектов Цикл
		НовСтрока = ТаблицаПроектов.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрока, СтрПроект);
	КонецЦикла;	
	
	ТаблицаПроектов.Сортировать("id");
	Для каждого СтрПроект Из ТаблицаПроектов Цикл
		Сообщить("id = " + Строка(СтрПроект.id + ". " + СтрПроект.name));
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьВерсииНаСервере()
	текОбект = РеквизитФормыВЗначение("Объект");
	Версии = текОбект.ПолучитьВерсии();
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВерсии(Команда)
	ПолучитьВерсииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПолучитьВесьСписокЗадачПоПроектуНаСервере()
	текОбъект = РеквизитФормыВЗначение("Объект");
	текОбъект.ОбновитьСписокЗадачПоПроекту(Истина, Проект);
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВесьСписокЗадачПоПроекту(Команда)
	ПолучитьВесьСписокЗадачПоПроектуНаСервере();
КонецПроцедуры
