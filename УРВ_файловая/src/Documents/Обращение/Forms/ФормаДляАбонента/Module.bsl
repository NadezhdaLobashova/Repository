
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	Если Не УправлениеДоступомУСПВызовСервера.ДоступныПользователиСервиса() Тогда
		Элементы.Инициатор.Видимость = Ложь;
	КонецЕсли;
	
    Поля = Новый Массив;
    Поля.Добавить("Осталось");
    Список.УстановитьОграниченияИспользованияВГруппировке(Поля);
    Список.УстановитьОграниченияИспользованияВОтборе(Поля);
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяУниверсальнаяДата());
	Список.Параметры.УстановитьЗначениеПараметра("СостояниеЗакрыто", Перечисления.СостоянияОбращений.Закрыто);
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		Элементы.СписокНастроитьАвтообновление.Видимость = Ложь;
	Иначе
		НастройкиАвтообновления = Автообновление.ПолучитьНастройкиАвтообновленияФормы(ЭтаФорма);
		Элементы.СписокНастроитьАвтообновление.Видимость = Истина;
    КонецЕсли;
    
	Если Параметры.Отбор.Свойство("Абонент") Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru='Обращения абонента'"); 
    ИначеЕсли Параметры.Отбор.Свойство("Инициатор") Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru='Обращения пользователя'"); 
		Элементы.Инициатор.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТекущаяДатаКлиента = ТекущаяДата();
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"СекундДоМестногоВремени",
		ТекущаяДатаКлиента - УниверсальноеВремя(ТекущаяДатаКлиента));
	
	#Если Не ВебКлиент Тогда
		УстановитьАвтообновлениеФормы();
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
    
    Для Каждого Строка Из Строки Цикл
        ОсталосьОформление = Строка.Значение.Оформление.Получить("Осталось");
        Если ЗначениеЗаполнено(ОсталосьОформление) Тогда
            ОсталосьОформление.УстановитьЗначениеПараметра("Текст", ОбщегоНазначенияУСПКлиентСервер.ДниЧасыМинуты(Строка.Значение.Данные.Осталось));
        КонецЕсли;
    КонецЦикла;
    
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ВыполнитьОбновлениеСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьАвтообновление(Команда)
	
	УстановитьПараметрыАвтообновленияФормы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформлениеСпискаОбращений = Список.КомпоновщикНастроек.Настройки.УсловноеОформление;
	УсловноеОформлениеСпискаОбращений.ИдентификаторПользовательскойНастройки = "ОсновноеОформление";
	
	// удаление предустановленных элементов оформления
	Предустановленные = Новый Массив;
	ЭлементыОформления = УсловноеОформлениеСпискаОбращений.Элементы;
	Для каждого ЭлементУсловногоОформления Из ЭлементыОформления Цикл
		Если ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
			Предустановленные.Добавить(ЭлементУсловногоОформления);
		КонецЕсли;
	КонецЦикла;
	Для каждого ЭлементУсловногоОформления Из Предустановленные Цикл
		ЭлементыОформления.Удалить(ЭлементУсловногоОформления);
	КонецЦикла;
	
	// Оформление при срыве сроков реакции
	ЭлементУсловногоОформления = УсловноеОформлениеСпискаОбращений.Элементы.Добавить();
	ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СрокРеакцииСорван");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СрокОбработкиСорван");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПредупреждениеЦвет);
	
	// Оформление при срыве сроков обработки
	ЭлементУсловногоОформления = УсловноеОформлениеСпискаОбращений.Элементы.Добавить();
	ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СрокОбработкиСорван");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
		
КонецПроцедуры

&НаКлиенте
Процедура Автообновление()
	
	Если ТипЗнч(НастройкиАвтообновления) <> Тип("Структура")
		Или (ТипЗнч(НастройкиАвтообновления) = Тип("Структура")
		И Не НастройкиАвтообновления.Автообновление) Тогда
		ОтключитьОбработчикОжидания("Автообновление");
	Иначе
		ОбновитьРезультатВыполнения = Ложь;
		ВыполнитьОбновлениеСписка();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьАвтообновлениеФормы()
	
	Если ТипЗнч(НастройкиАвтообновления) = Тип("Структура")
		И НастройкиАвтообновления.Автообновление Тогда
		ПодключитьОбработчикОжидания(
			"Автообновление", 
			НастройкиАвтообновления.ПериодАвтоОбновления,
			Ложь);
	Иначе
		ОтключитьОбработчикОжидания("Автообновление");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере 
Процедура ВыполнитьОбновлениеСписка()
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяУниверсальнаяДата());
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПараметрыАвтообновленияФормы()
	
	ОписаниеОповещения = 
		Новый ОписаниеОповещения(
			"УстановитьПараметрыАвтообновленияФормыПродолжение",
			ЭтотОбъект);
	
	АвтообновлениеКлиент.УстановитьПараметрыАвтообновленияФормы(
		ЭтаФорма, 
		НастройкиАвтообновления,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПараметрыАвтообновленияФормыПродолжение(Результат, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		НастройкиАвтообновления = Результат;
		УстановитьАвтообновлениеФормы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
