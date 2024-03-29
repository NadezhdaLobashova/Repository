
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	ТекущийПользователь = Пользователи.АвторизованныйПользователь();
	СведенияПользователя = РегистрыСведений.СведенияОПользователях.СведенияОПользователе(ТекущийПользователь);
	//ОбслуживающаяОрганизация = СведенияПользователя.ОбслуживающаяОрганизация;
	ЛинияПоддержки = СведенияПользователя.ЛинияПоддержки;
	//ПерваяЛинияПоддержки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СведенияПользователя.ОбслуживающаяОрганизация, "ПерваяЛинияПоддержки");
	//ЭтоПерваяЛиния = (СведенияПользователя.ЛинияПоддержки = ПерваяЛинияПоддержки);
	ПользователиЛинииПоддержки.ЗагрузитьЗначения(РаботаСПользователями.ПользователиЛинииПоддержки(ЛинияПоддержки, Истина));

	Элементы.СписокВсе.Пометка = Истина;
	
	СостоянияОбращений = "Все";

	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяУниверсальнаяДата());
	Список.Параметры.УстановитьЗначениеПараметра("НизкаяВажность", Перечисления.ВариантыВажности.НизкаяВажность);
	Список.Параметры.УстановитьЗначениеПараметра("ВысокаяВажность", Перечисления.ВариантыВажности.ВысокаяВажность);
	Список.Параметры.УстановитьЗначениеПараметра("СостоянияОбращений", СостоянияОбращений);
	Список.Параметры.УстановитьЗначениеПараметра("ТипКонсультация", Перечисления.ТипыОбращений.Консультация);
	Список.Параметры.УстановитьЗначениеПараметра("ТипОшибка", Перечисления.ТипыОбращений.Ошибка);
	Список.Параметры.УстановитьЗначениеПараметра("ТипПожелание", Перечисления.ТипыОбращений.Пожелание);		
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Результат = Неопределено;
	УстановитьЗаголовкиВариантовОтборов(ТекущийПользователь, ЛинияПоддержки, ПользователиЛинииПоддержки, Результат);

	УстановитьЗаголовкиКлиент(Результат);

КонецПроцедуры

&НаСервере
Процедура НастроитьСписокПоВариантуОтбора()
	
	Элементы.СписокВсе.Пометка = СостоянияОбращений = "Все";
	Элементы.СписокЗакрытые.Пометка = СостоянияОбращений = "Закрытые";	
	Элементы.СписокОжидающие.Пометка = СостоянияОбращений = "Ожидающие";
	Элементы.СписокОткрытые.Пометка = СостоянияОбращений = "Открытые";
	
	Список.Параметры.УстановитьЗначениеПараметра("СостоянияОбращений", СостоянияОбращений);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура Закрытые(Команда)
	
	СостоянияОбращений = "Закрытые";
	НастроитьСписокПоВариантуОтбора();	
	
	Результат = Неопределено;
	УстановитьЗаголовкиВариантовОтборов(ТекущийПользователь, ЛинияПоддержки, ПользователиЛинииПоддержки, Результат);
	
	УстановитьЗаголовкиКлиент(Результат);

КонецПроцедуры

&НаКлиенте
Процедура Открытые(Команда)	
	
	СостоянияОбращений = "Открытые";
	НастроитьСписокПоВариантуОтбора();	
	
	Результат = Неопределено;
	УстановитьЗаголовкиВариантовОтборов(ТекущийПользователь, ЛинияПоддержки, ПользователиЛинииПоддержки, Результат);
	
	УстановитьЗаголовкиКлиент(Результат);

КонецПроцедуры

&НаКлиенте
Процедура Все(Команда)
	
	СостоянияОбращений = "Все";
	НастроитьСписокПоВариантуОтбора();	
	
	Результат = Неопределено;
	УстановитьЗаголовкиВариантовОтборов(ТекущийПользователь, ЛинияПоддержки, ПользователиЛинииПоддержки, Результат);
	
	УстановитьЗаголовкиКлиент(Результат);

КонецПроцедуры

&НаКлиенте
Процедура Ожидающие(Команда)
	
	СостоянияОбращений = "Ожидающие";
	НастроитьСписокПоВариантуОтбора();
	
	Результат = Неопределено;
	УстановитьЗаголовкиВариантовОтборов(ТекущийПользователь, ЛинияПоддержки, ПользователиЛинииПоддержки, Результат);
	
	УстановитьЗаголовкиКлиент(Результат);

КонецПроцедуры

&НаСервереБезКонтекста 
Процедура ВыполнитьОбновлениеСписка(ТекущийПользователь, ЛинияПоддержки, ПользователиЛинииПоддержки, Результат)
	
	УстановитьЗаголовкиВариантовОтборов(ТекущийПользователь, ЛинияПоддержки, ПользователиЛинииПоддержки, Результат);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьЗаголовкиВариантовОтборов(ТекущийПользователь, ЛинияПоддержки, ПользователиЛинииПоддержки, Результат)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СУММА(ВЫБОР
		|			КОГДА ДокументОбращение.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОбращений.ОжиданиеИнициатора)
		|				ТОГДА 1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Ожидающие,
		|	СУММА(1) КАК Все,
		|	СУММА(ВЫБОР
		|			КОГДА ДокументОбращение.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОбращений.Закрыто)
		|				ТОГДА 1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Закрытые,
		|	СУММА(ВЫБОР
		|			КОГДА НЕ ДокументОбращение.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОбращений.Закрыто)
		|				ТОГДА 1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Открытые
		|ИЗ
		|	Документ.Обращение КАК ДокументОбращение
		|ГДЕ
		|	НЕ ДокументОбращение.ПометкаУдаления";
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	Результат = Новый Структура("Все, Закрытые, Открытые, Ожидающие", 0, 0, 0, 0);
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовкиКлиент(Выборка)
	
	Элементы.СписокЗакрытые.Заголовок = СтрШаблон(НСтр("ru='Закрытые (%1)'"), Формат(?(Выборка.Закрытые = Null, 0, Выборка.Закрытые),"ЧЦ=10; ЧН=0; ЧГ=0"));
	Элементы.СписокОжидающие.Заголовок = СтрШаблон(НСтр("ru='Ожидающие (%1)'"), Формат(?(Выборка.Ожидающие = Null, 0, Выборка.Ожидающие),"ЧЦ=10; ЧН=0; ЧГ=0"));
	Элементы.СписокОткрытые.Заголовок = СтрШаблон(НСтр("ru='Открытые (%1)'"), Формат(?(Выборка.Открытые = Null, 0, Выборка.Открытые),"ЧЦ=10; ЧН=0; ЧГ=0")); 
	Элементы.СписокВсе.Заголовок = СтрШаблон(НСтр("ru='Все (%1)'"), Формат(?(Выборка.Все = Null, 0, Выборка.Все),"ЧЦ=10; ЧН=0; ЧГ=0")); 
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Для Каждого Строка Из Строки Цикл
        ОсталосьОформление = Строка.Значение.Оформление.Получить("Осталось");
        Если ЗначениеЗаполнено(ОсталосьОформление) Тогда
            ОсталосьОформление.УстановитьЗначениеПараметра("Текст", ОбщегоНазначенияУСПКлиентСервер.ДниЧасыМинуты(Строка.Значение.Данные.Осталось));
        КонецЕсли;
    КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок(Команда)
	
	Результат = Неопределено;
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ТекущаяДата", УниверсальноеВремя(ТекущаяДата())); 
	ВыполнитьОбновлениеСписка(ТекущийПользователь, ЛинияПоддержки, ПользователиЛинииПоддержки, Результат);
	Элементы.Список.Обновить();
	УстановитьЗаголовкиКлиент(Результат);

КонецПроцедуры
