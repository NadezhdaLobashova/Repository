///////////////Вспомогательные процедуры и функции/////////////////////
Процедура ЗафиксироватьРезультатВыполненияОбмена (Узел,Комментарий,ДействиеПриОбмене)
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("УзелИнформационнойБазы",Узел);
	СтруктураЗаписи.Вставить("ДействиеПриОбмене",ДействиеПриОбмене);
	СтруктураЗаписи.Вставить("РезультатВыполненияОбмена",Перечисления.РезультатыВыполненияОбмена.Ошибка);
	СтруктураЗаписи.Вставить("ДатаНачала",ТекущаяДата());
	СтруктураЗаписи.Вставить("ДатаОкончания",ТекущаяДата());
	СтруктураЗаписи.Вставить("Комментарий",Комментарий);
	РегистрыСведений.СостоянияОбменовДаннымиНСИ20.ДобавитьЗапись(СтруктураЗаписи);
КонецПроцедуры

Функция ПолучитьСтруктуруОбмена(Тест=ложь) Экспорт
	УзелНСИ = ПланыОбмена.НСИ_20.НайтиПоКоду("0");
	СтруктураОбмена = Новый Структура;
	Если УзелНСИ.Пустая() Тогда
		Сообщение = "Не найден узел НСИ!";
		ВызватьИсключение  Сообщение;
	КОнецЕсли;
	
	Если Не Тест Тогда
		URL = СокрЛП(УзелНСИ.URLВебСервиса);
		Логин = СокрЛП(УзелНСИ.Логин);
		Пароль = СокрЛП(УзелНСИ.Пароль);
		Определения = Новый WSОпределения(URL,Логин,Пароль,15);
		WSСервис = Определения.Сервисы[0];
		Прокси = Новый WSПрокси(Определения, WSСервис.URIПространстваИмен, WSСервис.Имя, WSСервис.ТочкиПодключения[0].Имя);
		Прокси.Пароль = Пароль;
		Прокси.Пользователь = Логин;
		СтруктураОбмена.Вставить("Прокси",Прокси);
		СтруктураОбмена.Вставить("МногопакетныйРежим",УзелНСИ.МногопакетныйРежим);
	КонецЕсли;
	СтруктураОбмена.Вставить("Узел",ПланыОбмена.НСИ_20.ЭтотУзел());
	СтруктураОбмена.Вставить("УзелНСИ",УзелНСИ);
	Возврат СтруктураОбмена;
КонецФункции

////////////////Процедуры и фанкции обмена данными/////////////////////
Процедура ВыполнитьОбмен() Экспорт
    
	ВсеДанныеВыгружены 	= Ложь;
	ВсеДанныеПолучены  	= Ложь;
	Отказ				= Ложь;
	ОчиститьПриОтправке = Истина;
	
	СтруктураОбмена = ПолучитьСтруктуруОбмена();
	//shav 2018-03-18 При получении данных - ошибка. Закомментировано, т.к. не используется получение данных
	//Пока Не ВсеДанныеВыгружены Цикл
		Пока Не ВсеДанныеВыгружены ИЛИ Не ВсеДанныеПолучены Цикл
		ВыполнитьЗагрузкуДанных(СтруктураОбмена,ВсеДанныеПолучены,,Отказ);
	//_shav 2018-03-18
		
		ВыполнитьВыгрузкуДанных(СтруктураОбмена,ВсеДанныеВыгружены,,Отказ,ОчиститьПриОтправке);
		
		Если Не СтруктураОбмена.МногопакетныйРежим Тогда
			ВсеДанныеВыгружены = Истина;
		КонецЕсли;
		
		Если Отказ Тогда 
			Прервать;
		КонецЕсли;
		
	КонецЦикла;

	//Если ОчиститьПриОтправке = Истина И ВсеДанныеВыгружены Тогда
	Если ВсеДанныеВыгружены Тогда
		ПланыОбмена.УдалитьРегистрациюИзменений(СтруктураОбмена.УзелНСИ);
	КонецЕсли;

КонецПроцедуры

Процедура ВыполнитьВыгрузкуДанных(СтруктураОбмена,ВсеДанныеВыгружены,ВыводитьРезультат = Ложь, Отказ = Ложь, ОчиститьПриОтправке = Неопределено) Экспорт  
	Сообщение="";
	ОбменДаннымиНСИ_20Сервер.ВыполнитьВыгрузкуДляУзлаИнформационнойБазыЧерезСтроку("НСИ_20",СтруктураОбмена.УзелНСИ.Код ,Сообщение,ВсеДанныеВыгружены,ОчиститьПриОтправке);
	Сообщение = Новый ХранилищеЗначения(Сообщение);
	Попытка
		СтруктураОбмена.Прокси.PutChanges("НСИ_20",СтруктураОбмена.Узел.Код,Сообщение);
	Исключение
		ДействиеПриОбмене = Перечисления.ДействияПриОбмене.ВыгрузкаДанных;
		ЗафиксироватьРезультатВыполненияОбмена(СтруктураОбмена.УзелНСИ,ОписаниеОшибки(),ДействиеПриОбмене);
		Отказ = Истина;
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	Если ВыводитьРезультат Тогда
		ПредставлениеПакетаОбмена = Сообщение.Получить();		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьЗагрузкуДанных(СтруктураОбмена,ВсеДанныеПолучены,ВыводитьРезультат = Ложь, Отказ = Ложь) Экспорт 
	Попытка
		Сообщение = Новый ХранилищеЗначения("");
		ВсеДанныеПолучены = СтруктураОбмена.Прокси.GetChanges("НСИ_20",СтруктураОбмена.Узел.Код,Сообщение);
	Исключение
		ДействиеПриОбмене = Перечисления.ДействияПриОбмене.ЗагрузкаДанных;
		ЗафиксироватьРезультатВыполненияОбмена(СтруктураОбмена.УзелНСИ,ОписаниеОшибки(),ДействиеПриОбмене);
		Отказ = Истина;
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	//Реквизит2 = рез.Получить();
	ОбменДаннымиНСИ_20Сервер.ВыполнитьЗагрузкуДляУзлаИнформационнойБазыЧерезСтроку("НСИ_20", СтруктураОбмена.УзелНСИ.Код, Сообщение.Получить());
	
	Если ВыводитьРезультат Тогда
		ПредставлениеПакетаОбмена = ПредставлениеПакетаОбмена + Символы.ПС + Сообщение.Получить();		
	КонецЕсли;	
КонецПроцедуры


////////////////Процедуры и фанкции для перехода с НСИ1 на НСИ2/////////////////////
Функция ВыгрузитьТаблицуСоответствияКодов() Экспорт
    
	Запрос = Новый Запрос;
	Запрос.Текст = 
    "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
    |   СоответствиеОбъектовОбмена.СерверныйТип КАК СерверныйТип,
    |   СоответствиеОбъектовОбмена.ЛокальнаяСсылка КАК ЛокальнаяСсылка
    |ИЗ
    |   Справочник.СоответствиеОбъектовОбмена КАК СоответствиеОбъектовОбмена
    |ГДЕ
    |   СоответствиеОбъектовОбмена.СерверныйТип <> """"
    |   И (СоответствиеОбъектовОбмена.Статус = ЗНАЧЕНИЕ(Перечисление.ЛокальныйСтатусСсылки.Новая)
    |           ИЛИ СоответствиеОбъектовОбмена.Статус = ЗНАЧЕНИЕ(Перечисление.ЛокальныйСтатусСсылки.Изменена))";
    Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда 
		Сообщить("Обнаружены зарегистрированные изменения (Необходимо произвести полный обмен со старой НСИ). Выгрузка кодов невозможна!", СтатусСообщения.ОченьВажное);
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			Сообщить(""+Выборка.ЛокальнаяСсылка.ПолноеНаименование()+" ("+Выборка.СерверныйТип+")");
		КонецЦикла;
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
    "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
    |   СоответствиеОбъектовОбмена.СерверныйТип КАК СерверныйТип
    |ИЗ
    |   Справочник.СоответствиеОбъектовОбмена КАК СоответствиеОбъектовОбмена
    |ГДЕ
    |   СоответствиеОбъектовОбмена.СерверныйТип <> """"";
    Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	МассивСерверныхТипов = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Имя = Выборка.СерверныйТип;
		//Если Имя = "CatalogObject.Работники" Тогда 
		//	Имя = "CatalogObject.Сотрудники";
		//КонецЕсли;
		НЗ = РегистрыСведений.НастройкаОбменаНСИ.СоздатьНаборЗаписей();
		НЗ.Отбор.СерверныйТип.Установить(Имя);
		НЗ.Прочитать();
		Если НЗ.Количество() > 0 Тогда 
			Имя = СтрЗаменить(НЗ[0].ЛокальныйТип, ".", "Ссылка.");
		КонецЕсли;
		НЗ = Неопределено;
		
		Мета = Метаданные.НайтиПоТипу(Тип(Имя));
		Если Мета <> Неопределено Тогда 
			Если Не Метаданные.ПланыОбмена.НСИ_20.Состав.Содержит(Мета) Тогда 
				МассивСерверныхТипов.Добавить(Выборка.СерверныйТип);
				Сообщить("Серверный тип отсутствует в плане обмена НСИ2 (объекты данного типа выгружены не будут): "+Выборка.СерверныйТип, СтатусСообщения.Важное);
			КонецЕсли;
		Иначе
			Сообщить("Не найден серверный тип (объекты данного типа выгружены не будут): "+Выборка.СерверныйТип, СтатусСообщения.Важное);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивСерверныхТипов.Количество() > 0 Тогда 
		Сообщить("Список исключенных из выгрузки типов (нет в плане обмена НСИ2, либо не удалось сопоставить): ");
		Для Каждого Стр Из МассивСерверныхТипов Цикл
			Сообщить(Стр);
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
    "ВЫБРАТЬ РАЗРЕШЕННЫЕ
    |   СоответствиеОбъектовОбмена.ЛокальнаяСсылка КАК ЛокальнаяСсылка,
    |   СоответствиеОбъектовОбмена.СервернаяСсылка КАК СервернаяСсылка,
    |   СоответствиеОбъектовОбмена.СерверныйТип КАК СерверныйТип
    |ИЗ
    |   Справочник.СоответствиеОбъектовОбмена КАК СоответствиеОбъектовОбмена
    |ГДЕ
    |   НЕ СоответствиеОбъектовОбмена.СерверныйТип В (&МассивСерверныхТипов)
    |   И СоответствиеОбъектовОбмена.СерверныйТип <> """"
    |   И СоответствиеОбъектовОбмена.СервернаяСсылка <> """"
    |
    |УПОРЯДОЧИТЬ ПО
    |   СерверныйТип
    |ИТОГИ
    |   КОЛИЧЕСТВО(ЛокальнаяСсылка),
    |   МАКСИМУМ(СерверныйТип)
    |ПО
    |   СервернаяСсылка";
    Запрос.УстановитьПараметр("МассивСерверныхТипов", МассивСерверныхТипов);
	Результат = Запрос.Выполнить();
	ВыборкаГрупп = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ТД = Новый ТабличныйДокумент;
	ТД.Область("R1C1").Текст = "ЛокальнаяСсылка";
	ТД.Область("R1C2").Текст = "СервернаяСсылка";
	ТД.Область("R1C3").Текст = "СерверныйТип";
	ТД.Область("R1C4").Текст = "Работник.СервернаяСсылка";
	НомерСтроки = 1;
	стрОбъектНеНайден = "<Объект не найден>";
	КоличествоОдинаковыхСсылок = 0;
	Пока ВыборкаГрупп.Следующий() Цикл
		Если ВыборкаГрупп.ЛокальнаяСсылка > 1 Тогда 
			Сообщить("Серверная ссылка "+ ВыборкаГрупп.СервернаяСсылка + " типа "+ВыборкаГрупп.СерверныйТип+" дублируется "+ВыборкаГрупп.ЛокальнаяСсылка+" раз. Эти соответствия не будут перенесены", СтатусСообщения.ОченьВажное);
			Продолжить;
		КонецЕсли;
		Выборка = ВыборкаГрупп.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Лев(Выборка.ЛокальнаяСсылка, СтрДлина(стрОбъектНеНайден)) = стрОбъектНеНайден Тогда 
				Сообщить(""+Выборка.ЛокальнаяСсылка + " " + Выборка.СервернаяСсылка + " " + Выборка.СерверныйТип, СтатусСообщения.ОченьВажное);
				Продолжить;
			КонецЕсли;
			Если СокрЛП(Выборка.СервернаяСсылка) = "" ИЛИ Выборка.ЛокальнаяСсылка.Пустая() Тогда 
				Продолжить;
			КонецЕсли;			
			
			стрЛокальнаяСсылка = Нрег(Выборка.ЛокальнаяСсылка.УникальныйИдентификатор());
			стрСервернаяСсылка = НРег(Выборка.СервернаяСсылка);
			Если стрЛокальнаяСсылка = стрСервернаяСсылка Тогда 
				КоличествоОдинаковыхСсылок = КоличествоОдинаковыхСсылок + 1;
			Иначе
				НомерСтроки = НомерСтроки + 1;
				стрНомерСтроки = Формат(НомерСтроки,"ЧГ=");
				ТД.Область("R"+стрНомерСтроки+"C1").Текст = стрЛокальнаяСсылка;
				ТД.Область("R"+стрНомерСтроки+"C2").Текст = стрСервернаяСсылка;
				ТД.Область("R"+стрНомерСтроки+"C3").Текст = СтрПолучитьСтроку(СтрЗаменить(Выборка.СерверныйТип, ".", Символы.ПС), 2);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	Сообщить("Пропущено ссылок, имеющих одинаковые серверную и локальную ссылки: "+КоличествоОдинаковыхСсылок);
	
    ////Дополнительно выгружаем соответствие для объекта "ФотоСотрудников"
    ////Этого объекта в старой НСИ нет. Поэтому для них нет записей в справочние СоответствиеОбъектовОбмена
    ////В новой НСИ они есть и их надо будет связать (связка осуществляется при загрузке формируемой таблицы)
    //// ++ aleves <//> // закоментировано до выяснения ситуации с фото
    ////Запрос = Новый Запрос;
    ////Запрос.Текст = 
    ////"ВЫБРАТЬ
    ////|	ФизическиеЛица.ОсновноеИзображение,
    ////|	СоответствиеОбъектовОбмена.СервернаяСсылка КАК РаботникСервернаяСсылка
    ////|ИЗ
    ////|	Справочник.ФизическиеЛица КАК ФизическиеЛица
    ////|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СоответствиеОбъектовОбмена КАК СоответствиеОбъектовОбмена
    ////|		ПО ФизическиеЛица.Ссылка = СоответствиеОбъектовОбмена.ЛокальнаяСсылка
    ////|ГДЕ
    ////|	СоответствиеОбъектовОбмена.СервернаяСсылка <> """"
    //////|	И ФизическиеЛица.ОсновноеИзображение <> ЗНАЧЕНИЕ(Справочник.ХранилищеДополнительнойИнформации.Пустаяссылка)
    ////|";
    ////Результат = Запрос.Выполнить();
    ////Выборка = Результат.Выбрать();
    ////Пока Выборка.Следующий() Цикл
    ////	стрЛокальнаяСсылка = Нрег(Выборка.ОсновноеИзображение.УникальныйИдентификатор());
    ////	стрРаботник = Нрег(Выборка.РаботникСервернаяСсылка);
    ////	
    ////	НомерСтроки = НомерСтроки + 1;
    ////	стрНомерСтроки = Формат(НомерСтроки,"ЧГ=");
    ////	ТД.Область("R"+стрНомерСтроки+"C1").Текст = стрЛокальнаяСсылка;
    ////	ТД.Область("R"+стрНомерСтроки+"C3").Текст = "ФотоСотрудников";
    ////	ТД.Область("R"+стрНомерСтроки+"C4").Текст = стрРаботник;
    ////КонецЦикла;
    //// -- aleves <//>
    ////
    ////Возврат ТД;
	
КонецФункции