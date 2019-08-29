
#Область СлужебныйПрограммныйИнтерфейс
    
// Обработка получения полей представления обращения
//
Процедура ОбработкаПолученияПолейПредставленияОбращения(МенеджерОбъекта, Поля, СтандартнаяОбработка) Экспорт
	
	Поля.Добавить("НомерСокращенный");
	Поля.Добавить("Дата");
	Поля.Добавить("Тема");
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Обработка получения представления обращения
//
Процедура ОбработкаПолученияПредставленияОбращения(МенеджерОбъекта, Данные, Представление, СтандартнаяОбработка) Экспорт
	
	Представление = СтрШаблон(НСтр("ru='%1 %2 от %3 (Обращение)'"), 
		Данные.НомерСокращенный, Данные.Тема, Формат(МестноеВремя(Данные.Дата),"ДЛФ=D")); 
		
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Обработка получения полей представления приложения
//
Процедура ОбработкаПолученияПолейПредставленияПриложения(Источник, Поля, СтандартнаяОбработка) Экспорт
	
	Поля.Добавить("Код");
	Поля.Добавить("Наименование");
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Обработка получения представления приложения
//
Процедура ОбработкаПолученияПредставленияПриложения(Источник, Данные, Представление, СтандартнаяОбработка) Экспорт
	
	Представление = СтрШаблон(НСтр("ru='%1 %2'"), Формат(Данные.Код, "ЧГ=0"), Данные.Наименование); 
		
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти 
