
#Область Обработка_Описания
&НаКлиенте
Процедура ОписаниеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(ДанныеСобытия.Href) Тогда
		СтандартнаяОбработка = Ложь;
		ЗапуститьПриложение(ДанныеСобытия.Href);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьОписание(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОписаниеXML"					, ОписаниеXML);
	
	ДополнительныеПараметры = Новый Структура;
	
	ИмяФормыДляОткрытия = "Обработка.РасписаниеЛК.Форма.ФормаВводаОписания";
	БоР_ОбщийМодульКлиент.ОткрытьБлокирующуюФорму(ЭтаФорма, ИмяФормыДляОткрытия, ПараметрыФормы, "РедактироватьОписание_Завершение", ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьОписание_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		ВозВрат;
	КонецЕсли;
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		ВозВрат;
	КонецЕсли;
	ОписаниеXML	= Результат.ОписаниеXML;
	БоР_ОбщийМодульКлиентСервер.РазвернутьФорматированныйДокументИзXML(ОписаниеXML, ОписаниеФД, ОписаниеHTML);
КонецПроцедуры
#КонецОбласти

&НаКлиенте
Процедура ОК(Команда)
	Если Не ПроверитьЗаполнение() Тогда
		ВозВрат;
	КонецЕсли;
	Если Не СоздатьДокументыНаСервере() Тогда
		ВозВрат;
	КонецЕсли;
	СтруктураВозВрата = Новый Структура;
	СтруктураВозВрата.Вставить("РезультатОткрытия"			, Истина);
	Закрыть(СтруктураВозВрата);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	БоР_ОбщийМодуль.ЗаполнитьРеквизитыИзПараметров(ЭтаФорма, Неопределено);
	БоР_ОбщийМодульКлиентСервер.РазвернутьФорматированныйДокументИзXML(ОписаниеXML, ОписаниеФД, ОписаниеHTML);
	Если ЗначениеЗаполнено(Контрагент) Тогда
		Телефон = ПолучитьТелефоны(Контрагент, КонтактноеЛицо);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаВремяНачалаФакт) Тогда
		ДатаВремяНачалаФакт		= ДатаВремяНачала;
		ДатаВремяОкончанияФакт	= ДатаВремяОкончания;
		ПродолжительностьФакт	= Продолжительность;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТелефоны(Контрагент, КонтактноеЛицо)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	
	#Область Запрос
	"ВЫБРАТЬ
		|	ПользователиАбонентов.ПользовательСервиса.Наименование КАК Наименование,
		|	ПользователиАбонентов.ПользовательСервиса.Код КАК Код,
		|	ПользователиАбонентов.ПользовательСервиса.Ссылка КАК КонтактноеЛицо,
		|	ПользователиАбонентов.ПользовательСервиса КАК ПользовательСервиса
		|ПОМЕСТИТЬ ВТКонтактныеЛица
		|ИЗ
		|	РегистрСведений.ПользователиАбонентов КАК ПользователиАбонентов
		|ГДЕ
		|	ПользователиАбонентов.Абонент = &Контрагент
		|	И НЕ ПользователиАбонентов.ПользовательСервиса.ПометкаУдаления
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	КонтактноеЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(ПользователиСервисовКонтактнаяИнформация.Представление, """""""") КАК Представление
		|ИЗ
		|	ВТКонтактныеЛица КАК ВТКонтактныеЛица
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПользователиСервисов.КонтактнаяИнформация КАК ПользователиСервисовКонтактнаяИнформация
		|		ПО ВТКонтактныеЛица.КонтактноеЛицо = ПользователиСервисовКонтактнаяИнформация.Ссылка
		|			И (ПользователиСервисовКонтактнаяИнформация.Тип = &ТипКонтактнойИнформации)
		|ГДЕ
		|	ПользователиСервисовКонтактнаяИнформация.Тип = &ТипКонтактнойИнформации";
	#КонецОбласти
	Запрос.УстановитьПараметр("Контрагент"				, Контрагент);
	Запрос.УстановитьПараметр("КонтактноеЛицо"			, КонтактноеЛицо);
	Запрос.УстановитьПараметр("ТипКонтактнойИнформации"	, Перечисления.ТипыКонтактнойИнформации.Телефон);

	ТаблицаКонтактнойИнформации = Запрос.Выполнить().Выгрузить();
	СтрокаТелефонов = "";
	Для каждого СтрокаКИ Из ТаблицаКонтактнойИнформации Цикл
		СтрокаТелефонов = СтрокаТелефонов + ?(ЗначениеЗаполнено(СтрокаТелефонов), ";", "") + СтрокаКИ.Представление;
	КонецЦикла;
	
	ВозВрат СтрокаТелефонов;
	
КонецФункции

&НаСервере
Функция СоздатьДокументыНаСервере(ТекстОшибки = Неопределено) Экспорт
	
	ТекущаяДата = ТекущаяДата();
	
	МассивДокументов = Новый Массив;
	ДокументОбъект = Документы.ВыполнениеРаботы.СоздатьДокумент();
	ДокументОбъект.Дата						= ТекущаяДата;
	ДокументОбъект.ИсточникСоздания			= "РасписаниеЛК";
	ДокументОбъект.Сотрудник				= Сотрудник;
	ДокументОбъект.ДатаВремяНачала			= ДатаВремяНачала;
	ДокументОбъект.КомментарийЗаписи		= КомментарийЗаписи;
	ДокументОбъект.ДатаВремяНачалаФакт		= ДатаВремяНачалаФакт;
	ДокументОбъект.ДатаВремяОкончанияФакт	= ДатаВремяОкончанияФакт;
	ДокументОбъект.ПродолжительностьФакт	= ПродолжительностьФакт;
	ДокументОбъект.ОписаниеXML				= ОписаниеXML;
	МассивДокументов.Добавить(ДокументОбъект);

	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	Для каждого ДокументОбъект Из МассивДокументов Цикл
		Попытка
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Оперативный);
		Исключение
			ОтменитьТранзакцию();
			#Область Вывод_сообщений
			СообщенияПользователю = ПолучитьСообщенияПользователю(Истина);
			Если СообщенияПользователю.Количество() > 0 Тогда // есть что сказать
				ТекстОшибки = "";
				Для каждого СообщениеПользователю Из СообщенияПользователю Цикл
					ТекстОшибки = ТекстОшибки + ?(ЗначениеЗаполнено(ТекстОшибки), Символы.ПС, "") + СообщениеПользователю.Текст;
				КонецЦикла;
				Сообщить(ТекстОшибки);
			Иначе
				ТекстОшибки = "Ошибка при создании документа " + ДокументОбъект.Метаданные().Синоним + "" + Символы.ПС;
				Сообщить(ТекстОшибки + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецЕсли;
			#КонецОбласти
			ВозВрат Ложь;
		КонецПопытки;
	КонецЦикла;
	ЗафиксироватьТранзакцию();
	
	ВозВрат Истина;

КонецФункции
