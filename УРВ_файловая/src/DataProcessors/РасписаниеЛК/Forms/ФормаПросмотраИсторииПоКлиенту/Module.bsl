
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	БоР_ОбщийМодуль.ЗаполнитьРеквизитыИзПараметров(ЭтаФорма, Неопределено);
	
	//ДнейВПрошлое = Константы.КоличествоДнейПросмотраКонсультацийВПрошлое.Получить();
	//ДнейВБудущее = Константы.КоличествоДнейПросмотраКонсультацийВБудущее.Получить();
	ДнейВПрошлое = ВЧисло(БоР_ОбщийМодуль.ПолучитьНастройку("КоличествоДнейПросмотраКонсультацийВПрошлое"));
	ДнейВБудущее = ВЧисло(БоР_ОбщийМодуль.ПолучитьНастройку("КоличествоДнейПросмотраКонсультацийВБудущее"));
	
	ТекущаяДата = ТекущаяДата();
	Если Не ЗначениеЗаполнено(ДатаНачала) Тогда
		ДатаНачала = НачалоДня(ТекущаяДата) - 86400 * ДнейВПрошлое;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаОкончания) Тогда
		ДатаОкончания = КонецДня(ТекущаяДата) + 86400 * ДнейВБудущее;
	КонецЕсли;
	НастроитьУсловноеОформление();
КонецПроцедуры

&НаСервере
Функция ЗаполнитьТаблицуРасписания() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	
	#Область Запрос
	"ВЫБРАТЬ
	|	РасписаниеКонсультацийСрезПоследних.Регистратор КАК Регистратор,
	|	РасписаниеКонсультацийСрезПоследних.Сотрудник КАК Сотрудник,
	|	РасписаниеКонсультацийСрезПоследних.Работа КАК Работа,
	|	РасписаниеКонсультацийСрезПоследних.Проект КАК Проект,
	|	РасписаниеКонсультацийСрезПоследних.ДатаВремяНачала КАК ДатаВремяНачала,
	|	РасписаниеКонсультацийСрезПоследних.Контрагент,
	|	РасписаниеКонсультацийСрезПоследних.КонтактноеЛицо,
	|	РасписаниеКонсультацийСрезПоследних.НеДействует,
	|	РасписаниеКонсультацийСрезПоследних.Состояние,
	|	РасписаниеКонсультацийСрезПоследних.ДатаВремяОкончания,
	|	РасписаниеКонсультацийСрезПоследних.Продолжительность,
	|	РасписаниеКонсультацийСрезПоследних.ВидУслуги,
	|	РасписаниеКонсультацийСрезПоследних.ТемаВопроса,
	|	РасписаниеКонсультацийСрезПоследних.КомментарийЗаписи,
	|	РасписаниеКонсультацийСрезПоследних.ТипЗаписи,
	|	РасписаниеКонсультацийСрезПоследних.СрочнаяЗапись
	|ПОМЕСТИТЬ ВТТекущееРасписание
	|ИЗ
	|	РегистрСведений.РасписаниеКонсультаций.СрезПоследних(
	|			&Момент,
	|			ДатаВремяНачала >= &ДатаНачала
	|				И ДатаВремяНачала <= &ДатаОкончания) КАК РасписаниеКонсультацийСрезПоследних
	|ГДЕ
	|	НЕ РасписаниеКонсультацийСрезПоследних.НеДействует
	|	И РасписаниеКонсультацийСрезПоследних.Контрагент = &Контрагент
	|	И РасписаниеКонсультацийСрезПоследних.Контрагент <> ЗНАЧЕНИЕ(Справочник.Абоненты.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РезультатыКонсультацийСрезПоследних.Регистратор,
	|	РезультатыКонсультацийСрезПоследних.Сотрудник,
	|	РезультатыКонсультацийСрезПоследних.ДатаВремяНачала,
	|	РезультатыКонсультацийСрезПоследних.Контрагент,
	|	РезультатыКонсультацийСрезПоследних.КонтактноеЛицо,
	|	РезультатыКонсультацийСрезПоследних.Результат,
	|	РезультатыКонсультацийСрезПоследних.ДатаВремяОкончания,
	|	РезультатыКонсультацийСрезПоследних.Продолжительность,
	|	РезультатыКонсультацийСрезПоследних.ВидУслуги,
	|	РезультатыКонсультацийСрезПоследних.ТемаВопроса,
	|	РезультатыКонсультацийСрезПоследних.ВопросКлиента,
	|	РезультатыКонсультацийСрезПоследних.ОтветСотрудника
	|ПОМЕСТИТЬ ВТТекущиеРезультаты
	|ИЗ
	|	РегистрСведений.РезультатыКонсультаций.СрезПоследних(
	|			&Момент,
	|			ДатаВремяНачала >= &ДатаНачала
	|				И ДатаВремяНачала <= &ДатаОкончания) КАК РезультатыКонсультацийСрезПоследних
	|ГДЕ
	|	НЕ РезультатыКонсультацийСрезПоследних.НеДействует
	|	И РезультатыКонсультацийСрезПоследних.Контрагент = &Контрагент
	|	И РезультатыКонсультацийСрезПоследних.Контрагент <> ЗНАЧЕНИЕ(Справочник.Абоненты.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТТекущееРасписание.Регистратор КАК РегистраторЗаписи,
	|	ВТТекущиеРезультаты.Регистратор КАК РегистраторРезультата,
	|	ВТТекущееРасписание.Сотрудник КАК Сотрудник,
	|	ВТТекущееРасписание.Работа КАК Работа,
	|	ВТТекущееРасписание.Проект КАК Проект,
	|	ВТТекущееРасписание.ДатаВремяНачала КАК ДатаВремяНачала,
	|	ВТТекущееРасписание.Контрагент,
	|	ВТТекущееРасписание.КонтактноеЛицо,
	|	ВТТекущееРасписание.НеДействует,
	|	ВТТекущееРасписание.Состояние,
	|	ВТТекущееРасписание.ДатаВремяОкончания,
	|	ВТТекущееРасписание.Продолжительность,
	|	ВТТекущееРасписание.ВидУслуги,
	|	ВТТекущееРасписание.ТемаВопроса,
	|	ВТТекущееРасписание.КомментарийЗаписи,
	|	ВТТекущееРасписание.ТипЗаписи,
	|	ВТТекущееРасписание.СрочнаяЗапись,
	|	ЕСТЬNULL(ВТТекущиеРезультаты.Результат, ЗНАЧЕНИЕ(Перечисление.РезультатыКонсультации.ПустаяСсылка)) КАК Результат,
	|	ВЫБОР
	|		КОГДА ВТТекущиеРезультаты.Результат = ЗНАЧЕНИЕ(Перечисление.РезультатыКонсультации.ОказанаКонсультация)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ИтоговыеСтатусыРасписанияЛК.ОказанаКонсультация)
	|		КОГДА ВТТекущиеРезультаты.Результат = ЗНАЧЕНИЕ(Перечисление.РезультатыКонсультации.НеОказанаКонсультация)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ИтоговыеСтатусыРасписанияЛК.НеОказанаКонсультация)
	|		КОГДА ВТТекущееРасписание.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЭлементаРасписанияЛК.Запланировано)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ИтоговыеСтатусыРасписанияЛК.Запланировано)
	|		КОГДА ВТТекущееРасписание.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЭлементаРасписанияЛК.ЗаписанКлиент)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ИтоговыеСтатусыРасписанияЛК.ЗаписанКлиент)
	|		КОГДА ВТТекущееРасписание.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЭлементаРасписанияЛК.Блокировка)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ИтоговыеСтатусыРасписанияЛК.Блокировка)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ИтоговыеСтатусыРасписанияЛК.ПустаяСсылка)
	|	КОНЕЦ КАК ИтоговыйСтатус,
	|	ВТТекущиеРезультаты.ВопросКлиента,
	|	ВТТекущиеРезультаты.ОтветСотрудника
	|ИЗ
	|	ВТТекущееРасписание КАК ВТТекущееРасписание
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТекущиеРезультаты КАК ВТТекущиеРезультаты
	|		ПО ВТТекущееРасписание.Сотрудник = ВТТекущиеРезультаты.Сотрудник
	|			И ВТТекущееРасписание.ДатаВремяНачала = ВТТекущиеРезультаты.ДатаВремяНачала
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаВремяНачала,
	|	Сотрудник";
	#КонецОбласти
	
	Момент = Неопределено;
	
	Запрос.УстановитьПараметр("Момент"				, Момент);
	Запрос.УстановитьПараметр("ДатаНачала"			, ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания"		, КонецДня(ДатаОкончания));
	Запрос.УстановитьПараметр("Контрагент"			, Контрагент);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	РезультатЗапроса = РезультатыЗапроса[РезультатыЗапроса.Количество() - 1];
	ТаблицаРасписания.Загрузить(РезультатЗапроса.Выгрузить());
	
КонецФункции

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	ЗаполнитьТаблицуРасписания();
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	ЗаполнитьТаблицуРасписания();
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	ЗаполнитьТаблицуРасписания();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРасписанияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.ТаблицаРасписания.ДанныеСтроки(ВыбраннаяСтрока);
	Если ЗначениеЗаполнено(ТекущиеДанные.РегистраторРезультата) Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("РегистраторРезультата"			, ТекущиеДанные.РегистраторРезультата);
		ДополнительныеПараметры.Вставить("РегистраторЗаписи"				, ТекущиеДанные.РегистраторЗаписи);
		
		ЭлементыМеню = Новый СписокЗначений;
		ЭлементыМеню.Добавить("Документ записи");
		ЭлементыМеню.Добавить("Документ выполнения");
		ЭлементыМеню.Добавить("Событие");

		ОписаниеОповещения = Новый ОписаниеОповещения("ТаблицаРасписанияВыборЗавершение", ЭтаФорма, ДополнительныеПараметры); 
		ПоказатьВыборИзМеню(ОписаниеОповещения, ЭлементыМеню);
		
	ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.РегистраторЗаписи) И ТипЗнч(ТекущиеДанные.РегистраторЗаписи) = Тип("ДокументСсылка.ЗаписьНаЛК") Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ"				, ТекущиеДанные.РегистраторЗаписи);
		ПараметрыФормы.Вставить("ТолькоПросмотр"	, Истина);
		ОткрытьФорму("Документ.ЗаписьНаЛК.ФормаОбъекта", ПараметрыФормы, ЭтаФорма,,,, , РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРасписанияВыборЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		ВозВрат;
	КонецЕсли;
	
	ТекущиеДанные = ДополнительныеПараметры;
	
	Если ВыбранныйЭлемент.Значение = "Документ записи" Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные.РегистраторЗаписи) И ТипЗнч(ТекущиеДанные.РегистраторЗаписи) = Тип("ДокументСсылка.ЗаписьНаЛК") Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Ключ"				, ТекущиеДанные.РегистраторЗаписи);
			ПараметрыФормы.Вставить("ТолькоПросмотр"	, Истина);
			ОткрытьФорму("Документ.ЗаписьНаЛК.ФормаОбъекта", ПараметрыФормы, ЭтаФорма,,,, , РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		КонецЕсли;
	ИначеЕсли ВыбранныйЭлемент.Значение = "Документ выполнения" Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные.РегистраторРезультата) И ТипЗнч(ТекущиеДанные.РегистраторРезультата) = Тип("ДокументСсылка.ВыполнениеКонсультацииЛК") Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Ключ"				, ТекущиеДанные.РегистраторРезультата);
			ПараметрыФормы.Вставить("ТолькоПросмотр"	, Истина);
			ОткрытьФорму("Документ.ВыполнениеКонсультацииЛК.ФормаОбъекта", ПараметрыФормы, ЭтаФорма,,,, , РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		КонецЕсли;
	ИначеЕсли ВыбранныйЭлемент.Значение = "Событие" Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные.РегистраторРезультата) И ТипЗнч(ТекущиеДанные.РегистраторРезультата) = Тип("ДокументСсылка.ВыполнениеКонсультацииЛК") Тогда
			Событие = ТекущиеДанные.РегистраторРезультата.Событие;
			Если ЗначениеЗаполнено(Событие) И ЗначениеЗаполнено(Событие) Тогда
				ПараметрыФормы = Новый Структура;
				ПараметрыФормы.Вставить("Ключ"				, Событие);
				ПараметрыФормы.Вставить("ТолькоПросмотр"	, Истина);
				ОткрытьФорму("Документ.Событие.ФормаОбъекта", ПараметрыФормы, ЭтаФорма,,,, , РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#Область Общие_Вспомогательные

&НаКлиентеНаСервереБезКонтекста
Функция ВЧисло(ПочтиЧисло) Экспорт
	ТипЧисло = Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(0, 0, ДопустимыйЗнак.Любой));
	ВозВрат ТипЧисло.ПривестиЗначение(ПочтиЧисло);
КонецФункции // ВЧисло()

// БоР : Преобразовывает значение в дату 11.01.2010 0:19:23
&НаКлиентеНаСервереБезКонтекста
Функция ВДату(Знач ПочтиДата) Экспорт
	Если ТипЗнч(ПочтиДата) = Тип("СтандартнаяДатаНачала") Тогда
		ПочтиДата = ПочтиДата.Дата;
	КонецЕсли;
	ТипДата = Новый ОписаниеТипов("Дата", , ,Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя));
	ВозВрат ТипДата.ПривестиЗначение(ПочтиДата);
КонецФункции // ВДату()

// БоР : Функция проверяет наличие в строке только цифр 28.09.2008 18:16:27
&НаКлиентеНаСервереБезКонтекста
Функция ЕстьНеЦифры(Знач СтрокаПроверки) Экспорт

	Если ТипЗнч(СтрокаПроверки) <> Тип("Строка") Тогда
		Возврат Истина;
	КонецЕсли;
	
	СтрокаПроверки = СокрЛП(СтрокаПроверки);
	Длина = СтрДлина(СтрокаПроверки);
	
	Для а = 1 По Длина Цикл
		КодСимвола = КодСимвола(Сред(СтрокаПроверки, а, 1));
		Если (КодСимвола < 48) ИЛИ (КодСимвола > 57) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область Условное_оформление

// БоР : Задолбало руками везде настраивать 21.01.2017 0:32:21
&НаСервере
Процедура НастроитьУсловноеОформление() Экспорт
	РегистрыСведений.ЦветаРасписанияЛК.НастроитьУсловноеОформление(УсловноеОформление, "ТаблицаРасписанияИтоговыйСтатус", "ТаблицаРасписания.ИтоговыйСтатус");
КонецПроцедуры

#КонецОбласти
