
#Область ОбработчикиСобытийФормы
    
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая()
		И (НЕ Параметры.Свойство("ЗначениеКопирования")
		ИЛИ НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования.Наименование)) Тогда
		Если Параметры.Свойство("ТипОбъекта") Тогда
			Объект.ТипОбъекта = Параметры.ТипОбъекта;
			НастроитьКомпоновщикУсловияИЗаполнитьДеревоРеквизитовОбъекта(Объект.ТипОбъекта);
		КонецЕсли;
		Объект.СпособЗаданияУсловия = Перечисления.СпособыЗаданияУсловия.ВРежимеКонструктора;
		НастроитьКомпоновщикКомбинацииУсловий();
	ИначеЕсли Объект.Ссылка.Пустая()
		И Параметры.Свойство("ЗначениеКопирования")
		И ЗначениеЗаполнено(Параметры.ЗначениеКопирования.Наименование) Тогда
		Настройки = Параметры.ЗначениеКопирования.НастройкаУсловия.Получить();
		НастройкиКомбинацииУсловий = Параметры.ЗначениеКопирования.НастройкаКомбинацииУсловий.Получить();
		НастроитьКомпоновщикУсловияИЗаполнитьДеревоРеквизитовОбъекта(Объект.ТипОбъекта, Настройки);
		НастроитьКомпоновщикКомбинацииУсловий(НастройкиКомбинацииУсловий);
		
	Иначе
		Настройки = Объект.Ссылка.НастройкаУсловия.Получить();
		НастройкиКомбинацииУсловий = Объект.Ссылка.НастройкаКомбинацииУсловий.Получить();
		НастроитьКомпоновщикУсловияИЗаполнитьДеревоРеквизитовОбъекта(Объект.ТипОбъекта, Настройки);
		НастроитьКомпоновщикКомбинацииУсловий(НастройкиКомбинацииУсловий);
	КонецЕсли;
	
	Элементы.Страницы.ТекущаяСтраница = Элементы["Страница" + СтрЗаменить(Строка(Объект.СпособЗаданияУсловия), " ", "")];	
	Элементы.КомпоновщикНастройкиОтборСгруппироватьЭлементыОтбора.Заголовок = НСтр("ru = 'Сгруппировать правила'");
	Элементы.КомпоновщикНастройкиОтборКонтекстноеМенюСгруппироватьЭлементыОтбора.Заголовок = НСтр("ru = 'Сгруппировать правила'");
    Элементы.КомпоновщикНастройкиОтборДобавитьЭлементОтбора.Заголовок = НСтр("ru = 'Добавить правило'");
	Элементы.КомпоновщикНастройкиОтборКонтекстноеМенюДобавитьЭлементОтбора.Заголовок = НСтр("ru = 'Добавить правило'");
	
	// Скрываем кнопку "Очистить" у колонки "Поле" в компоновщике отбора, который используется в режиме "Конструктор".
	Элементы.КомпоновщикНастройкиОтборЛевоеЗначение.КнопкаОчистки = Ложь;
		
	// Настройка действия при изменении вида сравнения.
	Элементы.КомпоновщикНастройкиОтборВидСравнения.УстановитьДействие("ПриИзменении", "Подключаемый_ВидСравненияПриИзменении");
		
	// Настройка действия при начале изменения правого значения сравнения.
	Элементы.КомпоновщикНастройкиОтборПравоеЗначение.УстановитьДействие("НачалоВыбора", "Подключаемый_ПравоеЗначениеНачалоВыбора");
		
	Элементы.КомпоновщикУсловийНастройкиОтборДобавитьЭлементОтбора.Заголовок = НСтр("ru = 'Добавить условие'");
	Элементы.КомпоновщикУсловийНастройкиОтборКонтекстноеМенюДобавитьЭлементОтбора.Заголовок = НСтр("ru = 'Добавить условие'");
	
	Элементы.ГруппаКомпоновщик.Доступность = ЗначениеЗаполнено(Объект.ТипОбъекта);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Проверка на уникальность имени условия.
	РезультатПроверки = ПроверитьУникальностьУсловия();
	Если РезультатПроверки <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Данное Наименование уже указано для другого условия'"),, "Объект.Наименование",, Отказ);
		Возврат;
	КонецЕсли;
	
	Если Объект.СпособЗаданияУсловия = Перечисления.СпособыЗаданияУсловия.КомбинацияИзДругихУсловий
		И КомпоновщикУсловий.Настройки.Отбор.Элементы.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указано ни одного условия'"),,"КомпоновщикУсловий.Настройки.Отбор",, Отказ);
	ИначеЕсли Объект.СпособЗаданияУсловия = Перечисления.СпособыЗаданияУсловия.ВРежимеКонструктора
		И Компоновщик.Настройки.Отбор.Элементы.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указано ни одного правила'"),,"Компоновщик.Настройки.Отбор",, Отказ);
	ИначеЕсли Объект.СпособЗаданияУсловия = Перечисления.СпособыЗаданияУсловия.НаВстроенномЯзыке
		И НЕ ЗначениеЗаполнено(Объект.ВыражениеУсловия) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не задано выражение'"),,"Объект.ВыражениеУсловия",, Отказ);
	КонецЕсли;
	
	Если Объект.СпособЗаданияУсловия = Перечисления.СпособыЗаданияУсловия.КомбинацияИзДругихУсловий
		И ПроверитьНаличиеУсловияВДереве(Истина) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Заполнены не все значения в комбинации условий'"),,"КомпоновщикУсловий.Настройки.Отбор",, Отказ);
		Возврат;
	КонецЕсли;
	
	Если Объект.СпособЗаданияУсловия = Перечисления.СпособыЗаданияУсловия.ВРежимеКонструктора
		И ПроверитьНаличиеПустыхСтрокОтбораВДереве() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Среди правил есть некорректно заполненные'"),,"Компоновщик.Настройки.Отбор",, Отказ);
		Возврат;
	КонецЕсли;
	
	ТекущийОбъект.НастройкаУсловия = Новый ХранилищеЗначения(Компоновщик.ПолучитьНастройки());
	ТекущийОбъект.НастройкаКомбинацииУсловий = Новый ХранилищеЗначения(КомпоновщикУсловий.ПолучитьНастройки());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы
    
&НаКлиенте
Процедура СпособЗаданияУсловияПриИзменении(Элемент)
		
	Если ЗначениеЗаполнено(Объект.СпособЗаданияУсловия) Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы["Страница" + СтрЗаменить(Строка(Объект.СпособЗаданияУсловия), " ", "")];
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОбъектаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПроверитьДоступКТипуДокументаИЗагрузитьНастройки(ВыбранноеЗначение, СтандартнаяОбработка);
	Если НЕ СтандартнаяОбработка Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Недостаточно прав для создания условия маршрутизации для предмета типа ""%1"".'"),
			Строка(ВыбранноеЗначение));
		ПоказатьПредупреждение(, ТекстСообщения);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВидСравненияПриИзменении(Элемент)
	
	СтандартнаяОбработка = Ложь;
	ЭлементОтбора = Компоновщик.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастройкиОтбор.ТекущаяСтрока);
	Если ЭлементОтбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ЭлементОтбора.ПравоеЗначение) = Тип("СправочникСсылка.Пользователи")
		ИЛИ 
		(ТипЗнч(ЭлементОтбора.ПравоеЗначение) = Тип("СписокЗначений")
			И ЭлементОтбора.ПравоеЗначение.ТипЗначения.СодержитТип(Тип("СправочникСсылка.Пользователи"))) Тогда
		
		ПараметрыФормы = Новый Структура;
		Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии
			ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВИерархии Тогда
			ЭлементОтбора.ПравоеЗначение = ПредопределенноеЗначение("Справочник.ГруппыПользователей.ПустаяСсылка");
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЭлементОтбора = Компоновщик.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(
		Элементы.КомпоновщикНастройкиОтбор.ТекущаяСтрока);
	Если ЭлементОтбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ТипЗнч(ЭлементОтбора.ПравоеЗначение) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
	    СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПравоеЗначениеНачалоВыбораПродолжение",
			ЭтотОбъект);
		ОткрытьФорму(
			"Справочник.ГруппыПользователей.ФормаВыбора", 
			ПараметрыФормы, 
			Элемент,,,,
			ОписаниеОповещения,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли ТипЗнч(ЭлементОтбора.ПравоеЗначение) = Тип("СправочникСсылка.ЗначенияСвойствОбъектов") Тогда
		СтандартнаяОбработка = Ложь;
		ИмяДопРеквизита = Строка(ЭлементОтбора.ЛевоеЗначение);
		ИмяДопРеквизита = Сред(ИмяДопРеквизита, Найти(ИмяДопРеквизита, "["));
		ИмяДопРеквизита = Сред(ИмяДопРеквизита, 2, СтрДлина(ИмяДопРеквизита) - 2);
		ВладелецЗначения = ПолучитьВладельцаЗначенияДопРеквизита(ИмяДопРеквизита);

		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ПараметрыФормы.Вставить("Отбор", Новый Структура("Владелец", ВладелецЗначения));
		ОткрытьФорму("Справочник.ЗначенияСвойствОбъектов.Форма.ФормаСписка", ПараметрыФормы, Элемент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоРеквизитов
    
&НаКлиенте
Процедура ДеревоРеквизитовОбъектаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Объект.ВыражениеУсловия = Объект.ВыражениеУсловия + " " + Элемент.ТекущиеДанные.ПолныйПуть;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормыКомпоновщикНастройкиОтбор

&НаКлиенте
Процедура КомпоновщикНастройкиОтборПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормыКомпоновщикУсловийНастройкиОтбор

&НаКлиенте
Процедура КомпоновщикУсловийНастройкиОтборПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	НовыйЭлементОтбора = КомпоновщикУсловий.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
    ПолеОтбора = Новый ПолеКомпоновкиДанных("Результат_проверки_условия");
    НовыйЭлементОтбора.ЛевоеЗначение = ПолеОтбора;
    НовыйЭлементОтбора.Использование = Истина;
    НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикУсловийНастройкиОтборПриИзменении(Элемент)
	
	Если Элемент.ТекущиеДанные.ЛевоеЗначение <> Неопределено Тогда
		ДобавленноеУсловие = Элемент.ТекущиеДанные.ПравоеЗначение;
		Результат = ПроверитьНаличиеУсловияВДереве(Ложь);
		Если Результат Тогда
			ТекстПредупреждения = СтрШаблон(НСтр("ru = 'Нельзя добавить условие ""%1"". Произошло зацикливание условий.'"),
				ДобавленноеУсловие);
			ПоказатьПредупреждение(, ТекстПредупреждения);
			УдалитьУсловиеИзКомбинацииУсловий(ДобавленноеУсловие);
		КонецЕсли;
	КонецЕсли;
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы
    
&НаКлиенте
Процедура ВставитьРеквизитИзДерева(Команда)
	
	Если Элементы.ДеревоРеквизитовОбъекта.ТекущиеДанные <> Неопределено Тогда
		Объект.ВыражениеУсловия = Объект.ВыражениеУсловия + " " + Элементы.ДеревоРеквизитовОбъекта.ТекущиеДанные.ПолныйПуть;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоРеквизитовОбъекта(ТипОбъекта)
	
	ИндексЗначенияПеречисления = Перечисления.ТипыОбъектов.Индекс(ТипОбъекта);
	ИмяЗначенияПеречисления = Метаданные.Перечисления.ТипыОбъектов.ЗначенияПеречисления[ИндексЗначенияПеречисления].Имя;

	Дерево = РеквизитФормыВЗначение("ДеревоРеквизитовОбъекта");
	
	Дерево.Строки.Очистить();
	
	ПолныйПуть = "Предмет";
	НоваяСтрокаВладелецФайла = Дерево.Строки.Добавить();
	НоваяСтрокаВладелецФайла.НаименованиеРеквизита = "Предмет";
	НоваяСтрокаВладелецФайла.ТипРеквизита = ТипОбъекта;
	Если Найти(НРег(Строка(ТипОбъекта)), "документ") > 0 Тогда
		Элементы.ДеревоРеквизитовОбъекта.Заголовок = НСтр("ru = 'Реквизиты документа'");
	ИначеЕсли Найти(НРег(Строка(ТипОбъекта)), "файл") > 0 Тогда
		Элементы.ДеревоРеквизитовОбъекта.Заголовок = НСтр("ru = 'Реквизиты файла'");
	Иначе
		Элементы.ДеревоРеквизитовОбъекта.Заголовок = НСтр("ru = 'Реквизиты объекта'");
	КонецЕсли;
	НоваяСтрокаВладелецФайла.ПолныйПуть = ПолныйПуть;
	
	Если Метаданные.Справочники.Найти(ИмяЗначенияПеречисления) <> Неопределено Тогда
		СправочникОбъект = Метаданные.Справочники[ИмяЗначенияПеречисления];
	ИначеЕсли Метаданные.БизнесПроцессы.Найти(ИмяЗначенияПеречисления) <> Неопределено Тогда
		СправочникОбъект = Метаданные.БизнесПроцессы[ИмяЗначенияПеречисления];
	КонецЕсли;
	Для Каждого СтандартныйРеквизит Из СправочникОбъект.СтандартныеРеквизиты Цикл
		Строка = НоваяСтрокаВладелецФайла.Строки.Добавить();
		Строка.НаименованиеРеквизита = СтандартныйРеквизит.Имя;
		Строка.ТипРеквизита = СтандартныйРеквизит.Тип;
		Строка.ПолныйПуть = ПолныйПуть + "." + СтандартныйРеквизит.Имя;
	КонецЦикла;
	Для Каждого Реквизит Из СправочникОбъект.Реквизиты Цикл
		Строка = НоваяСтрокаВладелецФайла.Строки.Добавить();
		Строка.НаименованиеРеквизита = Реквизит.Имя;
		Строка.ТипРеквизита = Реквизит.Тип;
		Строка.ПолныйПуть = ПолныйПуть + "." + Реквизит.Имя;
	КонецЦикла;
	Для Каждого ТабличнаяЧасть Из СправочникОбъект.ТабличныеЧасти Цикл
		СтрокаТабличнаяЧасть = НоваяСтрокаВладелецФайла.Строки.Добавить();
		СтрокаТабличнаяЧасть.НаименованиеРеквизита = ТабличнаяЧасть.Имя;
		СтрокаТабличнаяЧасть.ТипРеквизита = "Табличная часть";
		СтрокаТабличнаяЧасть.ПолныйПуть = ПолныйПуть + "." + ТабличнаяЧасть.Имя + "[0]";
		Для Каждого СтандартныйРеквизитТЧ Из ТабличнаяЧасть.СтандартныеРеквизиты Цикл
			СтрокаРеквизитТЧ = СтрокаТабличнаяЧасть.Строки.Добавить();
			СтрокаРеквизитТЧ.НаименованиеРеквизита = СтандартныйРеквизитТЧ.Имя;
			СтрокаРеквизитТЧ.ТипРеквизита = СтандартныйРеквизитТЧ.Тип;
			СтрокаРеквизитТЧ.ПолныйПуть = ПолныйПуть + "." + ТабличнаяЧасть.Имя + "[0]" + "." + СтандартныйРеквизитТЧ.Имя; 
		КонецЦикла;
		Для Каждого РеквизитТЧ Из ТабличнаяЧасть.Реквизиты Цикл
			СтрокаРеквизитТЧ = СтрокаТабличнаяЧасть.Строки.Добавить();
			СтрокаРеквизитТЧ.НаименованиеРеквизита = РеквизитТЧ.Имя;
			СтрокаРеквизитТЧ.ТипРеквизита = РеквизитТЧ.Тип;
			СтрокаРеквизитТЧ.ПолныйПуть = ПолныйПуть + "." + ТабличнаяЧасть.Имя + "[0]" + "." + РеквизитТЧ.Имя;
		КонецЦикла; 
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево,"ДеревоРеквизитовОбъекта");
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьДеревоРеквизитовОбъекта()
	
	Дерево = РеквизитФормыВЗначение("ДеревоРеквизитовОбъекта");
	Дерево.Строки.Очистить();
	ЗначениеВРеквизитФормы(Дерево,"ДеревоРеквизитовОбъекта");
	Элементы.ДеревоРеквизитовОбъекта.Заголовок = НСтр("ru = 'Реквизиты объекта'");
	
КонецПроцедуры

&НаСервере
Процедура НастроитьКомпоновщикУсловияИЗаполнитьДеревоРеквизитовОбъекта(Знач ТипОбъекта, Настройки = Неопределено)
	
	ИндексЗначенияПеречисления = Перечисления.ТипыОбъектов.Индекс(ТипОбъекта);
	ИмяЗначенияПеречисления = Метаданные.Перечисления.ТипыОбъектов.ЗначенияПеречисления[ИндексЗначенияПеречисления].Имя;
	
	СхемаКомпоновкиДанных = Справочники.УсловияМаршрутизации.ПолучитьМакет(ИмяЗначенияПеречисления);
	Если Настройки = Неопределено Тогда
		Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КонецЕсли;

	URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы);
	Компоновщик.Инициализировать(ИсточникНастроек);
	Компоновщик.ЗагрузитьНастройки(Настройки);
	
	Если ЗначениеЗаполнено(ТипОбъекта) Тогда
		ЗаполнитьДеревоРеквизитовОбъекта(ТипОбъекта);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьКомпоновщикКомбинацииУсловий(Настройки = Неопределено)
	
	СхемаКомпоновкиДанных = Справочники.УсловияМаршрутизации.ПолучитьМакет("Условия");
	
	Если Настройки = Неопределено Тогда
		Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КонецЕсли;
	
	URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы);
	КомпоновщикУсловий.Инициализировать(ИсточникНастроек);
	КомпоновщикУсловий.ЗагрузитьНастройки(Настройки);
    
    // Скрываем поле сравнения - в него будет ставиться всегда "Равно".
	Элементы.КомпоновщикУсловийНастройкиОтборВидСравнения.Видимость = Ложь;
    
    // Делаем недоступным для редактирования поле "Левое значение".
	Элементы.КомпоновщикУсловийНастройкиОтборЛевоеЗначение.ТолькоПросмотр = Истина;
	Элементы.КомпоновщикУсловийНастройкиОтбор.Шапка = Ложь;
	
КонецПроцедуры
	
&НаСервере
Функция ПроверитьНаличиеУсловияВДереве(ИщемПустоеЗначение)
	
	Результат = Ложь;
	Если Объект.СпособЗаданияУсловия = Перечисления.СпособыЗаданияУсловия.КомбинацияИзДругихУсловий Тогда
		ЭлементыНастройкиОтбора = КомпоновщикУсловий.Настройки.Отбор.Элементы;
		ИскомоеУсловие = ?(ИщемПустоеЗначение, Неопределено, Объект.Ссылка);
		Результат = ВыполнитьПоискУсловияВОдномУровнеКомбинацииУсловий(ЭлементыНастройкиОтбора, ИскомоеУсловие);
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ВыполнитьПоискУсловияВОдномУровнеКомбинацииУсловий(Элементы, ИскомоеУсловие)
	
	Для Каждого ЭлементОтбора Из Элементы Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда		
			Если ВыполнитьПоискУсловияВОдномУровнеКомбинацииУсловий(ЭлементОтбора.Элементы, ИскомоеУсловие) Тогда
				Возврат Истина;
			КонецЕсли;
		Иначе			
			Если (ЗначениеЗаполнено(ИскомоеУсловие) 
				И ЭлементОтбора.ПравоеЗначение = ИскомоеУсловие)
				ИЛИ (НЕ ЗначениеЗаполнено(ИскомоеУсловие) 
				И НЕ ЗначениеЗаполнено(ЭлементОтбора.ПравоеЗначение)) Тогда
				Возврат Истина;
			ИначеЕсли  ЭлементОтбора.ПравоеЗначение <> Неопределено
				И ЭлементОтбора.ПравоеЗначение.СпособЗаданияУсловия = Перечисления.СпособыЗаданияУсловия.КомбинацияИзДругихУсловий
				И ВыполнитьПоискУсловияВОдномУровнеКомбинацииУсловий(ЭлементОтбора.ПравоеЗначение.НастройкаКомбинацииУсловий.Получить().Отбор.Элементы, ИскомоеУсловие) Тогда
					Возврат Истина;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;

	Возврат Ложь;
	
КонецФункции

&НаСервере
Функция ПроверитьНаличиеПустыхСтрокОтбораВДереве()
	
	Результат = Ложь;
	Если Объект.СпособЗаданияУсловия = Перечисления.СпособыЗаданияУсловия.ВРежимеКонструктора Тогда
		ЭлементыНастройкиОтбора = Компоновщик.Настройки.Отбор.Элементы;
		Результат = ВыполнитьПоискПустойСтрокиВОдномУровнеНастройкиОтбора(ЭлементыНастройкиОтбора);
	КонецЕсли;
	Возврат Результат;		
	
КонецФункции

&НаСервере
Функция ВыполнитьПоискПустойСтрокиВОдномУровнеНастройкиОтбора(Элементы)
	
	Для Каждого ЭлементОтбора Из Элементы Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда		
			Если ВыполнитьПоискПустойСтрокиВОдномУровнеНастройкиОтбора(ЭлементОтбора.Элементы) Тогда
				Возврат Истина;
			КонецЕсли;
		Иначе			
			Если (НЕ ЗначениеЗаполнено(ЭлементОтбора.ПравоеЗначение)
				ИЛИ НЕ ЗначениеЗаполнено(Строка(ЭлементОтбора.ЛевоеЗначение)))
				И ЭлементОтбора.ВидСравнения <> ВидСравненияКомпоновкиДанных.Заполнено
				И ЭлементОтбора.ВидСравнения <> ВидСравненияКомпоновкиДанных.НеЗаполнено Тогда
				Возврат Истина;
				
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;

	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура УдалитьУсловиеИзКомбинацииУсловий(ИмяУсловия)
	
	Если Объект.СпособЗаданияУсловия = Перечисления.СпособыЗаданияУсловия.КомбинацияИзДругихУсловий Тогда
		ЭлементыНастройкиОтбора = КомпоновщикУсловий.Настройки.Отбор.Элементы;
		ВыполнитьПоискИУдалениеДляОдногоУровня(ЭлементыНастройкиОтбора, ИмяУсловия);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПоискИУдалениеДляОдногоУровня(Элементы, ИмяУсловия)
	
	Для Каждого ЭлементОтбора Из Элементы Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда		
			ВыполнитьПоискИУдалениеДляОдногоУровня(ЭлементОтбора.Элементы, ИмяУсловия);
		ИначеЕсли ЭлементОтбора.ПравоеЗначение <> Неопределено Тогда
			СпособЗаданияУсловия = ЭлементОтбора.ПравоеЗначение.СпособЗаданияУсловия;
				
			Если ЭлементОтбора.ПравоеЗначение.Наименование = ИмяУсловия Тогда
				ЭлементОтбора.ПравоеЗначение = Справочники.УсловияМаршрутизации.ПустаяСсылка();
			ИначеЕсли СпособЗаданияУсловия = Перечисления.СпособыЗаданияУсловия.КомбинацияИзДругихУсловий Тогда
            	ВыполнитьПоискИУдалениеДляОдногоУровня(ЭлементОтбора.ПравоеЗначение.НастройкаКомбинацииУсловий.Получить().Отбор.Элементы, ИмяУсловия);
			КонецЕсли;
			
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьУникальностьУсловия()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	Условия.Ссылка          
				   |ИЗ
	               |	Справочник.УсловияМаршрутизации КАК Условия
	               |ГДЕ
	               |	Условия.Наименование = &Наименование
	               |	И Условия.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Наименование", Объект.Наименование);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
	   Возврат Выборка;	 
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции	

&НаКлиенте
Процедура ПроверитьВыражениеПродолжение(ИзмененныйТекст, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(ИзмененныйТекст) Тогда
		Объект.ВыражениеУсловия = ИзмененныйТекст;
	КонецЕсли;	
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВладельцаЗначенияДопРеквизита(ИмяДопРеквизита)
	
	Возврат ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию(ИмяДопРеквизита);	
	
КонецФункции

&НаКлиенте
Процедура ПравоеЗначениеНачалоВыбораПродолжение(Результат, Параметры) Экспорт
	
	ЭлементОтбора = Компоновщик.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(
		Элементы.КомпоновщикНастройкиОтбор.ТекущаяСтрока);
	ЭлементОтбора.ПравоеЗначение = Результат;	
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьДоступКТипуДокументаИЗагрузитьНастройки(ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		ОчиститьДеревоРеквизитовОбъекта();
		Компоновщик.Настройки.Отбор.Элементы.Очистить();
		Возврат;
	КонецЕсли;
	
	ИндексЗначенияПеречисления = Перечисления.ТипыОбъектов.Индекс(ВыбранноеЗначение);
	ИмяЗначенияПеречисления = Метаданные.Перечисления.ТипыОбъектов.ЗначенияПеречисления[ИндексЗначенияПеречисления].Имя;
	Если Метаданные.Справочники.Найти(ИмяЗначенияПеречисления) <> Неопределено Тогда
		СтандартнаяОбработка = ПравоДоступа("Чтение", Метаданные.Справочники[ИмяЗначенияПеречисления]); 
	ИначеЕсли Метаданные.БизнесПроцессы.Найти(ИмяЗначенияПеречисления) <> Неопределено Тогда
		СтандартнаяОбработка = ПравоДоступа("Чтение", Метаданные.БизнесПроцессы[ИмяЗначенияПеречисления]); 
	КонецЕсли;
	Если СтандартнаяОбработка Тогда
		Элементы.ГруппаКомпоновщик.Доступность = ЗначениеЗаполнено(ВыбранноеЗначение);
		НастроитьКомпоновщикУсловияИЗаполнитьДеревоРеквизитовОбъекта(ВыбранноеЗначение);
		Элементы.КомпоновщикНастройкиОтбор.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

