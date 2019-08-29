Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	Поля.Добавить("Наименование");
	Поля.Добавить("Код");
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	Представление = "№" +Данные.Код + " " + Данные.Наименование;
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	Если ВидФормы = "ФормаОбъекта" Тогда
		СтандартнаяОбработка = Ложь;
		Если Параметры.Ключ.СозданаВручную Тогда
			ВыбраннаяФорма = "Справочник.Задачи.Форма.ФормаЭлементаРучная";
		Иначе
			ВыбраннаяФорма = "Справочник.Задачи.Форма.ФормаЭлемента";
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры
