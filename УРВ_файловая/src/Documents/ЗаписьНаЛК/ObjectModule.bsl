        
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если ДополнительныеСвойства.Свойство("Отказ") И ДополнительныеСвойства.Отказ = Истина Тогда
		Отказ = ДополнительныеСвойства.Отказ;
		ВозВрат;
	КонецЕсли;

	Движения.РасписаниеКонсультаций.Очистить();
	Движения.РасписаниеКонсультаций.Записать();
	ДвиженияРасписаниеКонсультаций = ПолучитьДвиженияРасписаниеКонсультаций(РежимПроведения, Отказ);
	Если ДвиженияРасписаниеКонсультаций = Неопределено Тогда
		Отказ = Истина;
		ВозВрат;
	КонецЕсли;
	Движения.РасписаниеКонсультаций.Загрузить(ДвиженияРасписаниеКонсультаций);
	Движения.РасписаниеКонсультаций.Записывать = Истина;
	
	Движения.Записать();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		ВозВрат;
	КонецЕсли;
	
	СсылкаНаОбъект = БоР_ОбщийМодуль.СоздатьИПолучитьСсылкуОбъекта(ЭтотОбъект);
	
	БоР_ОбщийМодуль.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ДополнительныеСвойства.Свойство("НеЗаполнятьНапоминание") И ДополнительныеСвойства.НеЗаполнятьНапоминание Тогда
		// не создавать
	Иначе
		СоздатьОбновитьНапоминание(РежимЗаписи, СсылкаНаОбъект);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Автор) Тогда
		Автор = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(ДатаСоздания) Тогда
		ДатаСоздания = ТекущаяДата();
	КонецЕсли;	
	//Лобашова 17.07.2019 89291 +
	Если не ЗначениеЗаполнено(Событие) тогда
		СоздатьПровестиДокументСобытие(РежимЗаписи);
	КонецЕсли;
	//Лобашова 17.07.2019 89291 -
КонецПроцедуры

//Лобашова 17.07.2019 89291 +
Процедура СоздатьПровестиДокументСобытие(РежимЗаписи) Экспорт
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ТребуетсяСобытие = Ложь;
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
		ТребуетсяСобытие = Проведен;
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ТребуетсяСобытие = Истина;
	КонецЕсли;
	
	Если ТребуетсяСобытие Тогда
		ДокументОбъект = Документы.Обращение.СоздатьДокумент();
	ИначеЕсли Не ТребуетсяСобытие Тогда
		ВозВрат;
	КонецЕсли;
	 
	 НовоеОбращение = Документы.Обращение.СоздатьДокумент();
	 НовоеОбращение.Тема 							= ТемаВопроса;
	 НовоеОбращение.Дата 							= ТекущаяУниверсальнаяДата();
	 НовоеОбращение.Заполнить(Неопределено);
	 НовоеОбращение.ТипОбращения 					= Перечисления.ТипыОбращений.Консультация;
	 НовоеОбращение.КаналПолучения  				= Справочники.КаналыПолученияОбращений.РасписаниеЛК;
	 Если ЗначениеЗаполнено(КонтактныеТелефоны) Тогда
		 НовоеОбращение.ОписаниеХранилище 				= Новый ХранилищеЗначения(КомментарийЗаписи + Символы.ПС + "Контактный телефон: " + КонтактныеТелефоны);
		 НовоеОбращение.Описание 						= КомментарийЗаписи + Символы.ПС + "Контактный телефон: " + КонтактныеТелефоны;
	 КонецЕсли;
	 НовоеОбращение.Сервис							= Контрагент.Владелец;
	 НовоеОбращение.Инициатор 						= КонтактноеЛицо;
	 ПроектИЭтап = ПолучитьПроектИЭтап();
	 НовоеОбращение.Проект 							= ПроектИЭтап.Проект;
	 НовоеОбращение.ЭтапПроекта 					= ПроектИЭтап.Этап;	 
	 НовоеОбращение.Абонент 						= Контрагент;
	 НовоеОбращение.АбонентОбслуживающейОрганизации = Обслуживание.АбонентОбслуживающейОрганизацииАбонента(НовоеОбращение.Абонент);
	 СведенияОПользователе = РегистрыСведений.СведенияОПользователях.СведенияОПользователе(Сотрудник);
	 НовоеОбращение.ЛинияПоддержки = СведенияОПользователе.ЛинияПоддержки;
	 НовоеОбращение.ОбслуживающаяОрганизация  = СведенияОПользователе.ОбслуживающаяОрганизация;
	 НовоеОбращение.Исполнитель = Сотрудник;
	 //Документы.Обращение.УстановитьИсполнителяПоУмолчанию(НовоеОбращение);
	 
	
	 НовоеОбращение.Записать(РежимЗаписиДокумента.Проведение);
	 
	 Событие = НовоеОбращение.Ссылка;
 КонецПроцедуры
 
 Функция ПолучитьПроектИЭтап()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасписаниеКонсультацийСрезПоследних.Сотрудник КАК Сотрудник,
		|	РасписаниеКонсультацийСрезПоследних.ДатаВремяНачала КАК ДатаВремяНачала,
		|	РасписаниеКонсультацийСрезПоследних.Проект КАК Проект
		|ИЗ
		|	РегистрСведений.РасписаниеКонсультаций.СрезПоследних КАК РасписаниеКонсультацийСрезПоследних
		|ГДЕ
		|	РасписаниеКонсультацийСрезПоследних.Сотрудник = &Сотрудник
		|	И РасписаниеКонсультацийСрезПоследних.ДатаВремяНачала = &ДатаВремяНачала";
	
	Запрос.УстановитьПараметр("ДатаВремяНачала", ДатаВремяНачала);
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Структура = Новый структура();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Проект =  ВыборкаДетальныеЗаписи.Проект;
		Структура.Вставить("Проект", Проект);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЭтапыПроектов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ЭтапыПроектов КАК ЭтапыПроектов
		|ГДЕ
		|	НЕ ЭтапыПроектов.ПометкаУдаления
		|	И ЭтапыПроектов.Владелец = &Проект";
	
	Запрос.УстановитьПараметр("Проект", Проект);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаЗначений = РезультатЗапроса.Выгрузить();
	
	Если ТаблицаЗначений.Количество() = 1 Тогда
		Структура.Вставить("Этап", ТаблицаЗначений[0].Ссылка);
	Иначе
		Структура.Вставить("Этап", Справочники.ЭтапыПроектов.ПустаяСсылка());	
	КонецЕсли;

	Возврат Структура;
КонецФункции
//Лобашова 17.07.2019 89291 -

// БоР :  14.01.2017 21:32:07
Функция ПолучитьДвиженияРасписаниеКонсультаций(РежимПроведения, Отказ) Экспорт
	
	
	Если РежимПроведения = РежимПроведенияДокумента.Оперативный Тогда
		МоментВремени = Неопределено;
	Иначе
		МоментВремени = МоментВремени();
	КонецЕсли;
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	ДР = Бор_ПовторноеИспользованиеКлиентСервер.ПолучитьДоступностьРолей();
	ДоступностьДляПП				= БоР_ОбщийМодульКлиентСервер.ВБулево(БоР_ОбщийМодуль.ПолучитьНастройку("ЛК_ПолныеПраваЭтоПривилегированныйСотрудник"));
	ДанныеПоРолям = Справочники.Пользователи.ДанныеПоРолямСотрудникаЛК(ТекущийПользователь);
	ЭтоПривилегированныйСотрудник	= (ДанныеПоРолям["Итого"] - ДанныеПоРолям[Перечисления.РолиСотрудниковЛК.Сотрудник]) > 0 ИЛИ (ДоступностьДляПП И ДР.ПолныеПрава);
	ЭтоСотрудник					= ДанныеПоРолям[Перечисления.РолиСотрудниковЛК.Сотрудник] > 0;
	ЭтоСамозапись					= ТипЗаписи = Перечисления.ТипыЗаписейЛК.Самозапись;
	
	#Область Получение_ограничений_на_запись
	НачалоНедели				= ДатаВремяНачала;
	КонецНедели					= ДатаВремяНачала;
	НачалоАнализаОграничений	= ДатаВремяНачала;
	КонецАнализаОграничений		= ДатаВремяНачала;
	НачальнаяДатаИнтервала		= ДатаВремяНачала;
	КонечнаяДатаИнтервала		= ДатаВремяНачала;
	МаксимумКонсультацийВНеделю	= 0;
	МаксимумКонсультацийВДень	= 0;
	МинимальныйИнтервалВДнях	= 0;
	
	ПроверятьОграничения = ТипЗаписи = Перечисления.ТипыЗаписейЛК.Самозапись;
			
	Если ПроверятьОграничения Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		
		#Область Запрос
		"ВЫБРАТЬ
		|	ОграниченияЗаписиНаЛКСрезПоследних.МаксимумКонсультацийВНеделю,
		|	ОграниченияЗаписиНаЛКСрезПоследних.МаксимумКонсультацийВДень,
		|	ОграниченияЗаписиНаЛКСрезПоследних.МинимальныйИнтервалВДнях,
		|	ОграниченияЗаписиНаЛКСрезПоследних.КонсультацииНедоступны
		|ИЗ
		|	РегистрСведений.ОграниченияЗаписиНаЛК.СрезПоследних(
		|			&МоментВремени,
		|			ВидУслуги = &ВидУслуги
		//Лобашова 11.03.2019  81724
		//|				И ТипКлиентаЛК = &ТипКлиентаЛК
		|				) КАК ОграниченияЗаписиНаЛКСрезПоследних
		|ГДЕ
		|	(ОграниченияЗаписиНаЛКСрезПоследних.МаксимумКонсультацийВНеделю <> 0
		|			ИЛИ ОграниченияЗаписиНаЛКСрезПоследних.МаксимумКонсультацийВДень <> 0
		|			ИЛИ ОграниченияЗаписиНаЛКСрезПоследних.МинимальныйИнтервалВДнях <> 0
		|			ИЛИ ОграниченияЗаписиНаЛКСрезПоследних.КонсультацииНедоступны)";
		#КонецОбласти
		
		Запрос.УстановитьПараметр("МоментВремени"				, МоментВремени);
		Запрос.УстановитьПараметр("ВидУслуги"					, ВидУслуги);
		//Лобашова 11.03.2019  81724
		//Запрос.УстановитьПараметр("ТипКлиентаЛК"				, Контрагент.ТипКлиентаЛК);
		
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			ЗаданыОграничения = Истина;
			Если ВыборкаДетальныеЗаписи.КонсультацииНедоступны Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Запись на консультации недоступна.";
				Сообщение.Поле = "Контрагент";
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Сообщить();
				ВозВрат Неопределено;
			КонецЕсли;
			МаксимумКонсультацийВНеделю		= ВыборкаДетальныеЗаписи.МаксимумКонсультацийВНеделю;
			МаксимумКонсультацийВДень		= ВыборкаДетальныеЗаписи.МаксимумКонсультацийВДень;
			МинимальныйИнтервалВДнях		= ВыборкаДетальныеЗаписи.МинимальныйИнтервалВДнях;
			//Если ВыборкаДетальныеЗаписи.МаксимумКонсультацийВНеделю > 0 Тогда
			//	НачалоАнализаОграничений	= ДатаВремяНачала;
			//	КонецАнализаОграничений		= ДатаВремяНачала;
			//КонецЕсли;
			НачалоНедели				= НачалоНедели(ДатаВремяНачала);
			КонецНедели					= КонецНедели(ДатаВремяНачала);
			НачалоАнализаОграничений	= НачалоДня(ДатаВремяНачала);
			КонецАнализаОграничений		= КонецДня(ДатаВремяНачала);
			Если ВыборкаДетальныеЗаписи.МаксимумКонсультацийВНеделю > 0 Тогда
				НачалоАнализаОграничений	= Мин(НачалоАнализаОграничений, НачалоНедели);
				КонецАнализаОграничений		= Макс(КонецАнализаОграничений, КонецНедели);
			КонецЕсли;
			Если ВыборкаДетальныеЗаписи.МинимальныйИнтервалВДнях > 0 Тогда
				НачальнаяДатаИнтервала = НачалоДня(ДатаВремяНачала) - (ВыборкаДетальныеЗаписи.МинимальныйИнтервалВДнях - 1) * 86400;
				КонечнаяДатаИнтервала = КонецДня(ДатаВремяНачала) + (ВыборкаДетальныеЗаписи.МинимальныйИнтервалВДнях - 1) * 86400;
				НачалоАнализаОграничений	= Мин(НачалоАнализаОграничений, НачальнаяДатаИнтервала);
				КонецАнализаОграничений		= Макс(КонецАнализаОграничений, КонечнаяДатаИнтервала);
			КонецЕсли;
		Иначе
			ЗаданыОграничения = Ложь;
		КонецЕсли;
	Иначе
		ЗаданыОграничения = Ложь;
	КонецЕсли;
	#КонецОбласти
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	
	#Область Запрос
	"ВЫБРАТЬ
	|	РасписаниеКонсультацийСрезПоследних.ДатаВремяНачала,
	|	РасписаниеКонсультацийСрезПоследних.Сотрудник,
	|	РасписаниеКонсультацийСрезПоследних.Работа,
	|	РасписаниеКонсультацийСрезПоследних.Проект,
	//|	РасписаниеКонсультацийСрезПоследних.Задание,
	//|	РасписаниеКонсультацийСрезПоследних.ПакетЧасов,
	|	РасписаниеКонсультацийСрезПоследних.Событие,
	|	РасписаниеКонсультацийСрезПоследних.Контрагент,
	|	РасписаниеКонсультацийСрезПоследних.КонтактноеЛицо,
	|	РасписаниеКонсультацийСрезПоследних.Состояние,
	|	РасписаниеКонсультацийСрезПоследних.ДатаВремяОкончания,
	|	РасписаниеКонсультацийСрезПоследних.Продолжительность
	|ПОМЕСТИТЬ ВТ_ТекущееРасписание
	|ИЗ
	|	РегистрСведений.РасписаниеКонсультаций.СрезПоследних(
	|			&МоментВремени,
	|			Сотрудник = &Сотрудник
	|				И ДатаВремяНачала = &ДатаВремяНачала) КАК РасписаниеКонсультацийСрезПоследних
	|ГДЕ
	|	НЕ РасписаниеКонсультацийСрезПоследних.НеДействует
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СвойстваЭлементовРасписанияЛК.ДатаВремяНачала,
	|	СвойстваЭлементовРасписанияЛК.Сотрудник,
	|	СвойстваЭлементовРасписанияЛК.ДоступноДляСамозаписи
	|ПОМЕСТИТЬ ВТ_СвойстваСлотов
	|ИЗ
	|	РегистрСведений.СвойстваЭлементовРасписанияЛК КАК СвойстваЭлементовРасписанияЛК
	|ГДЕ
	|	СвойстваЭлементовРасписанияЛК.Сотрудник = &Сотрудник
	|	И СвойстваЭлементовРасписанияЛК.ДатаВремяНачала = &ДатаВремяНачала
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОграниченияЗаписиНаЛК_ПоВидамУслугСрезПоследних.Сотрудник,
	|	ОграниченияЗаписиНаЛК_ПоВидамУслугСрезПоследних.ДатаВремяНачала,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ОграниченияЗаписиНаЛК_ПоВидамУслугСрезПоследних.ВидУслуги = &ВидУслуги
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК ВидУслугиДоступен,
	|	МАКСИМУМ(ИСТИНА) КАК ЕстьОграничения
	|ПОМЕСТИТЬ ВТ_ОграниченияСлота
	|ИЗ
	|	РегистрСведений.ОграниченияЗаписиНаЛК_ПоВидамУслуг.СрезПоследних(
	|			&МоментВремени,
	|			Сотрудник = &Сотрудник
	|				И ДатаВремяНачала = &ДатаВремяНачала) КАК ОграниченияЗаписиНаЛК_ПоВидамУслугСрезПоследних
	|ГДЕ
	|	НЕ ОграниченияЗаписиНаЛК_ПоВидамУслугСрезПоследних.НеДействует
	|
	|СГРУППИРОВАТЬ ПО
	|	ОграниченияЗаписиНаЛК_ПоВидамУслугСрезПоследних.Сотрудник,
	|	ОграниченияЗаписиНаЛК_ПоВидамУслугСрезПоследних.ДатаВремяНачала
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОграниченияСотрудниковЛК_ПоВидамУслуг.Сотрудник,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ОграниченияСотрудниковЛК_ПоВидамУслуг.ВидУслуги = &ВидУслуги
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК ВидУслугиДоступен,
	|	МАКСИМУМ(ИСТИНА) КАК ЕстьОграничения
	|ПОМЕСТИТЬ ВТ_ОграниченияСотрудника
	|ИЗ
	|	РегистрСведений.ОграниченияСотрудниковЛК_ПоВидамУслуг КАК ОграниченияСотрудниковЛК_ПоВидамУслуг
	|ГДЕ
	|	ОграниченияСотрудниковЛК_ПоВидамУслуг.Сотрудник = &Сотрудник
	|
	|СГРУППИРОВАТЬ ПО
	|	ОграниченияСотрудниковЛК_ПоВидамУслуг.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДоступностьВидовУслугКлиентамЛКСрезПоследних.Контрагент,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ДоступностьВидовУслугКлиентамЛКСрезПоследних.ВидУслуги = &ВидУслуги
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК ВидУслугиДоступен,
	|	МАКСИМУМ(ИСТИНА) КАК ЕстьОграничения
	|ПОМЕСТИТЬ ВТ_ОграниченияКонтрагента
	|ИЗ
	|	РегистрСведений.ДоступностьВидовУслугКлиентамЛК.СрезПоследних(&МоментВремени, Контрагент = &Контрагент) КАК ДоступностьВидовУслугКлиентамЛКСрезПоследних
	|ГДЕ
	|	НЕ ДоступностьВидовУслугКлиентамЛКСрезПоследних.НеДействует
	|	И ДоступностьВидовУслугКлиентамЛКСрезПоследних.ДатаНачала <= &ДатаВремяНачала
	|	И (ДоступностьВидовУслугКлиентамЛКСрезПоследних.ДатаОкончания >= НАЧАЛОПЕРИОДА(&ДатаВремяНачала, ДЕНЬ)
	|			ИЛИ ДоступностьВидовУслугКлиентамЛКСрезПоследних.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1))
	|
	|СГРУППИРОВАТЬ ПО
	|	ДоступностьВидовУслугКлиентамЛКСрезПоследних.Контрагент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВЫБОР
	|			КОГДА РасписаниеКонсультацийСрезПоследних.ДатаВремяНачала >= &НачалоНедели
	|					И РасписаниеКонсультацийСрезПоследних.ДатаВремяНачала <= &КонецНедели
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК КоличествоЗаписейЗаНеделю,
	|	СУММА(ВЫБОР
	|			КОГДА НАЧАЛОПЕРИОДА(РасписаниеКонсультацийСрезПоследних.ДатаВремяНачала, ДЕНЬ) = НАЧАЛОПЕРИОДА(&ДатаВремяНачала, ДЕНЬ)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК КоличествоЗаписейЗаДень,
	|	СУММА(ВЫБОР
	|			КОГДА РасписаниеКонсультацийСрезПоследних.ДатаВремяНачала >= &НачальнаяДатаИнтервала
	|					И РасписаниеКонсультацийСрезПоследних.ДатаВремяНачала <= &КонечнаяДатаИнтервала
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК КоличествоЗаписейВИнтервале
	|ИЗ
	|	РегистрСведений.РасписаниеКонсультаций.СрезПоследних(
	|			,
	|			&ПроверятьОграничения
	|				И &ЗаданыОграничения
	|				И ДатаВремяНачала >= &НачалоАнализаОграничений
	|				И ДатаВремяНачала <= &КонецАнализаОграничений) КАК РасписаниеКонсультацийСрезПоследних
	|ГДЕ
	|	НЕ РасписаниеКонсультацийСрезПоследних.НеДействует
	|	И &ПроверятьОграничения
	|	И &ЗаданыОграничения
	|	И РасписаниеКонсультацийСрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЭлементаРасписанияЛК.ЗаписанКлиент)
	|	И РасписаниеКонсультацийСрезПоследних.Контрагент = &Контрагент
	|	И РасписаниеКонсультацийСрезПоследних.ТипЗаписи = &ТипЗаписи
	|	И РасписаниеКонсультацийСрезПоследних.ВидУслуги = &ВидУслуги
	|	И РасписаниеКонсультацийСрезПоследних.Работа.РаботаПоРасписанию
	|	И (РасписаниеКонсультацийСрезПоследних.ДатаВремяНачала <> &ДатаВремяНачала
	|			ИЛИ РасписаниеКонсультацийСрезПоследних.Сотрудник <> &Сотрудник)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ТекущееРасписание.Сотрудник,
	|	ВТ_ТекущееРасписание.ДатаВремяНачала,
	|	ВТ_ТекущееРасписание.Контрагент,
	|	ВТ_ТекущееРасписание.КонтактноеЛицо,
	|	ВТ_ТекущееРасписание.Состояние,
	|	ВТ_ТекущееРасписание.ДатаВремяОкончания,
	|	ВТ_ТекущееРасписание.Продолжительность,
	|	ЕСТЬNULL(ВТ_ОграниченияСлота.ВидУслугиДоступен, ЛОЖЬ) КАК ВидУслугиДоступенПоСлоту,
	|	ЕСТЬNULL(ВТ_ОграниченияСлота.ЕстьОграничения, ЛОЖЬ) КАК ЕстьОграниченияПоСлоту,
	|	ЕСТЬNULL(ВТ_ОграниченияСотрудника.ВидУслугиДоступен, ЛОЖЬ) КАК ВидУслугиДоступенПоСотруднику,
	|	ЕСТЬNULL(ВТ_ОграниченияСотрудника.ЕстьОграничения, ЛОЖЬ) КАК ЕстьОграниченияПоСотруднику,
	|	ЕСТЬNULL(ВТ_ОграниченияКонтрагента.ВидУслугиДоступен, ЛОЖЬ) КАК ВидУслугиДоступенПоКонтрагенту,
	|	ЕСТЬNULL(ВТ_ОграниченияКонтрагента.ЕстьОграничения, ЛОЖЬ) КАК ЕстьОграниченияПоКонтрагенту,
	|	ЕСТЬNULL(ВТ_СвойстваСлотов.ДоступноДляСамозаписи, ЛОЖЬ) КАК ДоступноДляСамозаписи
	|ИЗ
	|	ВТ_ТекущееРасписание КАК ВТ_ТекущееРасписание
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ОграниченияСлота КАК ВТ_ОграниченияСлота
	|		ПО ВТ_ТекущееРасписание.Сотрудник = ВТ_ОграниченияСлота.Сотрудник
	|			И ВТ_ТекущееРасписание.ДатаВремяНачала = ВТ_ОграниченияСлота.ДатаВремяНачала
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ОграниченияСотрудника КАК ВТ_ОграниченияСотрудника
	|		ПО ВТ_ТекущееРасписание.Сотрудник = ВТ_ОграниченияСотрудника.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ОграниченияКонтрагента КАК ВТ_ОграниченияКонтрагента
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СвойстваСлотов КАК ВТ_СвойстваСлотов
	|		ПО (ИСТИНА)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&Период,
	|	ЗаписьНаЛК.Сотрудник,
	|	ВТ_ТекущееРасписание.Работа,
	|	ВТ_ТекущееРасписание.Проект,
	//|	ВТ_ТекущееРасписание.Задание,
	//|	ВТ_ТекущееРасписание.ПакетЧасов,
	//Лобашова 17.07.2019 89291 +
	//|	ВТ_ТекущееРасписание.Событие,
	|	ЗаписьНаЛК.Событие,
	//Лобашова 17.07.2019 89291 -
	|	ЗаписьНаЛК.ДатаВремяНачала,
	|	ЗаписьНаЛК.Контрагент,
	|	ЗаписьНаЛК.КонтактноеЛицо,
	|	ВТ_ТекущееРасписание.ДатаВремяОкончания,
	|	ВТ_ТекущееРасписание.Продолжительность,
	|	ЗаписьНаЛК.ВидУслуги,
	|	ЗаписьНаЛК.ТемаВопроса,
	|	ЗНАЧЕНИЕ(Перечисление.СостоянияЭлементаРасписанияЛК.ЗаписанКлиент) КАК Состояние,
	|	ЗаписьНаЛК.КомментарийЗаписи,
	|	ЗаписьНаЛК.ТипЗаписи,
	|	ЗаписьНаЛК.СрочнаяЗапись,
	|	ЗаписьНаЛК.КонтактныеТелефоны
	|ИЗ
	|	Документ.ЗаписьНаЛК КАК ЗаписьНаЛК
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ТекущееРасписание КАК ВТ_ТекущееРасписание
	|		ПО ЗаписьНаЛК.Сотрудник = ВТ_ТекущееРасписание.Сотрудник
	|			И ЗаписьНаЛК.ДатаВремяНачала = ВТ_ТекущееРасписание.ДатаВремяНачала
	|ГДЕ
	|	ЗаписьНаЛК.Ссылка = &Ссылка";
	
	#КонецОбласти
	
	Запрос.УстановитьПараметр("МоментВремени"				, МоментВремени);
	Запрос.УстановитьПараметр("ДатаВремяНачала"				, ДатаВремяНачала);
	Запрос.УстановитьПараметр("Сотрудник"					, Сотрудник);
	Запрос.УстановитьПараметр("Контрагент"					, Контрагент);
	Запрос.УстановитьПараметр("Период"						, Дата);
	Запрос.УстановитьПараметр("Ссылка"						, Ссылка);
	Запрос.УстановитьПараметр("ТипЗаписи"					, ТипЗаписи);
	Запрос.УстановитьПараметр("ВидУслуги"					, ВидУслуги);
	Запрос.УстановитьПараметр("ПроверятьОграничения"		, ПроверятьОграничения);
	Запрос.УстановитьПараметр("ЗаданыОграничения"			, ЗаданыОграничения);
	Запрос.УстановитьПараметр("НачалоНедели"				, НачалоНедели);
	Запрос.УстановитьПараметр("КонецНедели"					, КонецНедели);
	Запрос.УстановитьПараметр("НачалоАнализаОграничений"	, НачалоАнализаОграничений);
	Запрос.УстановитьПараметр("КонецАнализаОграничений"		, КонецАнализаОграничений);
	Запрос.УстановитьПараметр("НачальнаяДатаИнтервала"		, НачальнаяДатаИнтервала);
	Запрос.УстановитьПараметр("КонечнаяДатаИнтервала"		, КонечнаяДатаИнтервала);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	#Область Проверка_ограничений
	Если ПроверятьОграничения И ЗаданыОграничения Тогда
		РезультатОграничения = РезультатыЗапроса[РезультатыЗапроса.Количество() - 3];
		Выборка = РезультатОграничения.Выбрать();
		Если Выборка.Следующий() Тогда
			СработалоОграничение = Ложь;
			Если ЗначениеЗаполнено(Выборка.КоличествоЗаписейЗаНеделю) И МаксимумКонсультацийВНеделю > 0 И Выборка.КоличествоЗаписейЗаНеделю >= МаксимумКонсультацийВНеделю Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Ограничение записи. Превышено допустимое количество консультаций в неделю.";
				Сообщение.Поле = "Контрагент";
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Сообщить();
				СработалоОграничение = Истина;
			КонецЕсли;
			Если ЗначениеЗаполнено(Выборка.КоличествоЗаписейЗаДень) И МаксимумКонсультацийВДень > 0 И Выборка.КоличествоЗаписейЗаДень >= МаксимумКонсультацийВДень Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Ограничение записи. Превышено допустимое количество консультаций в день.";
				Сообщение.Поле = "Контрагент";
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Сообщить();
				СработалоОграничение = Истина;
			КонецЕсли;
			Если ЗначениеЗаполнено(Выборка.КоличествоЗаписейВИнтервале) И МинимальныйИнтервалВДнях > 0 И Выборка.КоличествоЗаписейВИнтервале > 0 Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Ограничение записи. Нарушение минимального интервала консультаций.";
				Сообщение.Поле = "Контрагент";
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Сообщить();
				СработалоОграничение = Истина;
			КонецЕсли;
			Если СработалоОграничение Тогда
				Отказ = Истина;
				ВозВрат Неопределено;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	#КонецОбласти
	
	
	РезультатТекущееРасписание = РезультатыЗапроса[РезультатыЗапроса.Количество() - 2];
	Выборка = РезультатТекущееРасписание.Выбрать();
	Если Не Выборка.Следующий() Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Время """ + ДатаВремяНачала + """, сотрудник """ + Сотрудник + """" + Символы.ПС + "	Отсутствует в расписании";
		Сообщение.Поле = "Сотрудник";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
		ВозВрат Неопределено;
	КонецЕсли;
	// БоР : две последующих проверки - почти одно и то же. Если оставим состояния, можно убирать проверку на контрагента 15.01.2017 15:08:05
	Если Выборка.Состояние = Перечисления.СостоянияЭлементаРасписанияЛК.ЗаписанКлиент Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Время """ + ДатаВремяНачала + """, сотрудник """ + Сотрудник + """" + Символы.ПС + "	Уже записан контрагент """ + Выборка.Контрагент + """";
		Сообщение.Поле = "Сотрудник";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
		ВозВрат Неопределено;
	КонецЕсли;
	#Область Проверка_ограничений_по_Видам_услуг
	Если Выборка.ЕстьОграниченияПоСлоту И Не Выборка.ВидУслугиДоступенПоСлоту Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Время """ + ДатаВремяНачала + """, сотрудник """ + Сотрудник + """" + Символы.ПС + "Вид услуги """ + ВидУслуги + """ недоступен (ограничения расписания).";
		Сообщение.Поле = "ВидУслуги";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	Если Выборка.ЕстьОграниченияПоСотруднику И Не Выборка.ВидУслугиДоступенПоСотруднику Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Время """ + ДатаВремяНачала + """, сотрудник """ + Сотрудник + """" + Символы.ПС + "Вид услуги """ + ВидУслуги + """ недоступен (ограничения сотрудника).";
		Сообщение.Поле = "ВидУслуги";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	Если Выборка.ЕстьОграниченияПоКонтрагенту И Не Выборка.ВидУслугиДоступенПоКонтрагенту Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Время """ + ДатаВремяНачала + """, сотрудник """ + Сотрудник + """" + Символы.ПС + "Вид услуги """ + ВидУслуги + """ недоступен (ограничения контрагента).";
		Сообщение.Поле = "ВидУслуги";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	#КонецОбласти
	#Область Проверка_ограничений_по_Типу_записи
	Если Не ЭтоПривилегированныйСотрудник И ЭтоСамозапись И Не Выборка.ДоступноДляСамозаписи Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Время """ + ДатаВремяНачала + """, сотрудник """ + Сотрудник + """" + Символы.ПС + "Слот не доступен для самозаписи.";
		Сообщение.Поле = "ТипЗаписи";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	Если Не ЭтоПривилегированныйСотрудник И Не ЭтоСамозапись И Выборка.ДоступноДляСамозаписи Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Время """ + ДатаВремяНачала + """, сотрудник """ + Сотрудник + """" + Символы.ПС + "Слот доступен только для самозаписи.";
		Сообщение.Поле = "ТипЗаписи";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	#КонецОбласти
	
	Если Отказ Тогда
		ВозВрат Неопределено
	КонецЕсли;
	РезультатЗапроса = РезультатыЗапроса[РезультатыЗапроса.Количество() - 1];
	ВозВрат РезультатЗапроса.Выгрузить();
	
КонецФункции

// БоР :  18.01.2017 2:23:06
Процедура СоздатьОбновитьНапоминание(РежимЗаписи, СсылкаНаОбъект) Экспорт
	
	//ИдентификаторНапоминания = Строка(ДатаВремяНачала) + "_" + Строка(Сотрудник.УникальныйИдентификатор());
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ТребуетсяНапоминание = Ложь;
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
		ТребуетсяНапоминание = Проведен;
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ТребуетсяНапоминание = Истина;
	КонецЕсли;
	
	ВремяДоКонсультации = БоР_ОбщийМодульКлиентСервер.ВЧисло(БоР_ОбщийМодуль.ПолучитьНастройку("ЛК_ВремяНапоминанияДоКонсультации"));
	
	Описание = 
	"На консультацию записан клиент:
	|Контрагент: " + Контрагент + "
	|Контактное лицо: " + КонтактноеЛицо + "
	|Вид услуги: " + ВидУслуги + "
	|Тема вопроса: " + ТемаВопроса + "
	|Комментарий записи: " + КомментарийЗаписи
	;
	
	//МенеджерЗаписи = РегистрыСведений.CRM_Напоминания.СоздатьМенеджерЗаписи();
	//Если ЗначениеЗаполнено(ИдентификаторНапоминания) Тогда
	//	Запрос = Новый Запрос;
	//	Запрос.Текст = 
	//	"ВЫБРАТЬ ПЕРВЫЕ 1
	//	|	CRM_Напоминания.Пользователь,
	//	|	CRM_Напоминания.Завершено,
	//	|	CRM_Напоминания.РеальнаяДатаОповещения,
	//	|	CRM_Напоминания.Объект,
	//	|	CRM_Напоминания.Автор,
	//	|	CRM_Напоминания.Автонапоминание,
	//	|	CRM_Напоминания.ИдентификаторЗаписи
	//	|ИЗ
	//	|	РегистрСведений.CRM_Напоминания КАК CRM_Напоминания
	//	|ГДЕ
	//	|	CRM_Напоминания.ИдентификаторЗаписи = &ИдентификаторЗаписи
	//	|	И CRM_Напоминания.Объект = &СсылкаНаОбъект
	//	|	И CRM_Напоминания.ИдентификаторЗаписи <> """"";
	//	
	//	Запрос.УстановитьПараметр("ИдентификаторЗаписи"	, ИдентификаторНапоминания);
	//	Запрос.УстановитьПараметр("СсылкаНаОбъект"		, СсылкаНаОбъект);
	//	РезультатЗапроса = Запрос.Выполнить();
	//	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
	//		МенеджерЗаписи.Пользователь				= ВыборкаДетальныеЗаписи.Пользователь;
	//		МенеджерЗаписи.Завершено				= ВыборкаДетальныеЗаписи.Завершено;
	//		МенеджерЗаписи.РеальнаяДатаОповещения	= ВыборкаДетальныеЗаписи.РеальнаяДатаОповещения;
	//		МенеджерЗаписи.Объект					= ВыборкаДетальныеЗаписи.Объект;
	//		МенеджерЗаписи.Автор					= ВыборкаДетальныеЗаписи.Автор;
	//		МенеджерЗаписи.Автонапоминание			= ВыборкаДетальныеЗаписи.Автонапоминание;
	//		МенеджерЗаписи.Прочитать();
	//	КонецЕсли;
	//КонецЕсли;
	//
	//Если Не ТребуетсяНапоминание И МенеджерЗаписи.Выбран() Тогда // Надо удалить
	//	МенеджерЗаписи.Удалить();
	//	ВозВрат;
	//КонецЕсли;
	//Если Не ТребуетсяНапоминание Тогда
	//	ВозВрат;
	//КонецЕсли;
	//
	//МенеджерЗаписи.Пользователь				= Сотрудник;
	//МенеджерЗаписи.Завершено				= Ложь;
	//МенеджерЗаписи.РеальнаяДатаОповещения	= ДатаВремяНачала - ВремяДоКонсультации;
	//МенеджерЗаписи.Объект					= СсылкаНаОбъект;
	//МенеджерЗаписи.Автор					= Сотрудник;
	//МенеджерЗаписи.Автонапоминание			= Ложь;
	//
	//Если Не ЗначениеЗаполнено(МенеджерЗаписи.ИдентификаторЗаписи) Тогда
	//	МенеджерЗаписи.ИдентификаторЗаписи = Строка(Ссылка.УникальныйИдентификатор()); // Пока используем ссылку на документ как идентификатор
	//КонецЕсли;
	//
	//МенеджерЗаписи.ДатаАктуальности			= ДатаВремяНачала;
	//МенеджерЗаписи.ДатаНачала				= ДатаВремяНачала - ВремяДоКонсультации;
	//МенеджерЗаписи.ДатаОповещения			= ДатаВремяНачала - ВремяДоКонсультации;
	//МенеджерЗаписи.Описание					= Описание;
	//МенеджерЗаписи.Редактирование			= Ложь;
	//МенеджерЗаписи.СрокДоНачала				= 0;
	//МенеджерЗаписи.ТипПериода				= "";
	//МенеджерЗаписи.УдалитьПоИстеченииСрока	= Истина;
	//МенеджерЗаписи.Тема						= "Запись на консультацию";
	//МенеджерЗаписи.Счетчик					= 0;
	//МенеджерЗаписи.Контрагент				= Контрагент;
	//МенеджерЗаписи.КонтактноеЛицо			= КонтактноеЛицо;
	//МенеджерЗаписи.Важность					= Перечисления.ВажностьПроблемыУчета.ВажнаяИнформация;
	//
	//МенеджерЗаписи.Записать();
	//
	//ИдентификаторНапоминания = МенеджерЗаписи.ИдентификаторЗаписи;
	
	МенеджерЗаписи = РегистрыСведений.НапоминанияПользователя.СоздатьМенеджерЗаписи();
	Если ЗначениеЗаполнено(ИдентификаторНапоминания) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НапоминанияПользователя.Пользователь,
		|	НапоминанияПользователя.ВремяСобытия,
		|	НапоминанияПользователя.Источник,
		|	НапоминанияПользователя.СрокНапоминания,
		|	НапоминанияПользователя.Описание,
		|	НапоминанияПользователя.СпособУстановкиВремениНапоминания,
		|	НапоминанияПользователя.ИнтервалВремениНапоминания,
		|	НапоминанияПользователя.ИмяРеквизитаИсточника,
		|	НапоминанияПользователя.ПредставлениеИсточника,
		|	НапоминанияПользователя.Расписание
		|ИЗ
		|	РегистрСведений.НапоминанияПользователя КАК НапоминанияПользователя
		|ГДЕ
		|	НапоминанияПользователя.Идентификатор = &Идентификатор
		|	И НапоминанияПользователя.Источник = &СсылкаНаОбъект
		|	И НапоминанияПользователя.Идентификатор <> """"";
		
		Запрос.УстановитьПараметр("Идентификатор"	, ИдентификаторНапоминания);
		Запрос.УстановитьПараметр("СсылкаНаОбъект"		, СсылкаНаОбъект);
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			МенеджерЗаписи.Пользователь				= ВыборкаДетальныеЗаписи.Пользователь;
			МенеджерЗаписи.ВремяСобытия				= ВыборкаДетальныеЗаписи.ВремяСобытия;
			МенеджерЗаписи.Источник					= ВыборкаДетальныеЗаписи.Источник;
			МенеджерЗаписи.СрокНапоминания			= ВыборкаДетальныеЗаписи.СрокНапоминания;
			МенеджерЗаписи.Описание					= ВыборкаДетальныеЗаписи.Описание;
			МенеджерЗаписи.СпособУстановкиВремениНапоминания	= ВыборкаДетальныеЗаписи.СпособУстановкиВремениНапоминания;
			МенеджерЗаписи.ИнтервалВремениНапоминания			= ВыборкаДетальныеЗаписи.ИнтервалВремениНапоминания;
			МенеджерЗаписи.ИмяРеквизитаИсточника				= ВыборкаДетальныеЗаписи.ИмяРеквизитаИсточника;
			МенеджерЗаписи.ПредставлениеИсточника				= ВыборкаДетальныеЗаписи.ПредставлениеИсточника;
			МенеджерЗаписи.Прочитать();
		КонецЕсли;
	КонецЕсли;
	
	Если Не ТребуетсяНапоминание И МенеджерЗаписи.Выбран() Тогда // Надо удалить
		МенеджерЗаписи.Удалить();
		ВозВрат;
	КонецЕсли;
	Если Не ТребуетсяНапоминание Тогда
		ВозВрат;
	КонецЕсли;
	
	МенеджерЗаписи.Пользователь				= Сотрудник;
	МенеджерЗаписи.ВремяСобытия				= ДатаВремяНачала;
	МенеджерЗаписи.Источник					= СсылкаНаОбъект;
	
	Если Не ЗначениеЗаполнено(МенеджерЗаписи.Идентификатор) Тогда
		МенеджерЗаписи.Идентификатор = Строка(СсылкаНаОбъект.Ссылка.УникальныйИдентификатор()); // Пока используем ссылку на документ как идентификатор
	КонецЕсли;
	
	МенеджерЗаписи.СрокНапоминания				= ДатаВремяНачала - ВремяДоКонсультации;
	МенеджерЗаписи.Описание						= Описание;
	МенеджерЗаписи.СпособУстановкиВремениНапоминания	= Перечисления.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета;
	МенеджерЗаписи.ИнтервалВремениНапоминания	= ВремяДоКонсультации;
	МенеджерЗаписи.ИмяРеквизитаИсточника		= "ДатаВремяНачала";
	МенеджерЗаписи.Расписание					= Неопределено;
	МенеджерЗаписи.ПредставлениеИсточника		= "Запись на консультацию";
	
	МенеджерЗаписи.Записать();
	
	ИдентификаторНапоминания = МенеджерЗаписи.Идентификатор;

КонецПроцедуры
