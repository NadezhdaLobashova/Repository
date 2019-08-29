
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Дата = Параметры.Дата;
	Автор = Параметры.Автор;
	ЛинияПоддержки = Параметры.ЛинияПоддержки;
	Комментарий = Параметры.Комментарий;
	ВнутренняяПереписка = Параметры.ВнутренняяПереписка;
	ВыбраннаяСтрока = Параметры.ВыбраннаяСтрока;
	
	Если Пользователи.АвторизованныйПользователь() = Параметры.Автор Или Пользователи.ЭтоПолноправныйПользователь() Тогда
		Элементы.Комментарий.ТолькоПросмотр = Ложь;
		Элементы.ВнутренняяПереписка.ТолькоПросмотр = Ложь;
		ЭтаФорма.КоманднаяПанель.Видимость = Истина;        
    Иначе
		ЭтаФорма.КоманднаяПанель.Видимость = Ложь;        
	КонецЕсли;
	
	СведенияОПользователе = РегистрыСведений.СведенияОПользователях.СведенияОПользователе();
	Если СведенияОПользователе.ОбслуживающаяОрганизация = Справочники.ОбслуживающиеОрганизации.СлужбаПоддержки Или 
		Пользователи.ЭтоПолноправныйПользователь() Тогда
		Элементы.ВнутренняяПереписка.Видимость = Истина;
    Иначе
		Элементы.ВнутренняяПереписка.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Результат = Новый Структура;
	Результат.Вставить("Дата", Дата);
	Результат.Вставить("Автор", Автор);
	Результат.Вставить("ЛинияПоддержки", ЛинияПоддержки);
	Результат.Вставить("Комментарий", Комментарий);
	Результат.Вставить("ВнутренняяПереписка", ВнутренняяПереписка);
	Результат.Вставить("ВыбраннаяСтрока", ВыбраннаяСтрока);
	
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
