#Область СлужебныеПроцедурыИФункции

// Обработчик события при записи учетной записи электронной почты.
Процедура ПриЗаписиУчетнойЗаписиЭлектроннойПочты(Источник, Отказ) Экспорт

	Если Источник.ОбменДанными.Загрузка Тогда
	
		Возврат;
	
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ПапкиЭлектронныхПисем.Ссылка
	               |ИЗ
	               |	Справочник.ПапкиЭлектронныхПисем КАК ПапкиЭлектронныхПисем
	               |ГДЕ
	               |	ПапкиЭлектронныхПисем.ПредопределеннаяПапка
	               |	И ПапкиЭлектронныхПисем.Владелец = &УчетнаяЗапись";
	
	Запрос.УстановитьПараметр("УчетнаяЗапись",Источник.Ссылка);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		УправлениеЭлектроннойПочтой.СоздатьПредопределенныеПапкиЭлектронныхПисемДляУчетнойЗаписи(Источник.Ссылка);
	КонецЕсли;

КонецПроцедуры

// Обработчик подписок ЗаполнитьНаборыЗначенийДоступаТабличныхЧастей* на событие ПередЗаписью
// вызывает заполнение значений доступа табличной части объекта НаборыЗначенийДоступа,
// когда для ограничения доступа к самому объекту используется шаблон #ПоНаборамЗначений.
//  Возможен случай использования подсистемы Управление доступом, когда
// указанной подписки не существует, если для указанной цели наборы не применяются.
//
// Параметры:
//  Источник        - СправочникОбъект,
//                    ДокументОбъект,
//                    ПланВидовХарактеристикОбъект,
//                    ПланСчетовОбъект,
//                    ПланВидовРасчетаОбъект,
//                    БизнесПроцессОбъект,
//                    ЗадачаОбъект,
//                    ПланОбменаОбъект - объект данных, передаваемый в подписку на событие ПередЗаписью.
//
//  Отказ           - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//
//  РежимЗаписи     - Булево - параметр, передаваемый в подписку на событие ПередЗаписью,
//                    когда тип параметра Источник - ДокументОбъект.
//
//  РежимПроведения - Булево - параметр, передаваемый в подписку на событие ПередЗаписью,
//                    когда тип параметра Источник - ДокументОбъект.
//
Процедура ЗаполнитьНаборыЗначенийДоступаТабличныхЧастей(Источник, Отказ = Неопределено, РежимЗаписи = Неопределено, РежимПроведения = Неопределено) Экспорт
	
	Возврат;
	// ОбменДанными.Загрузка проверяется внутри вызова.
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ЗаполнитьНаборыЗначенийДоступаТабличныхЧастей(Источник, Отказ, РежимЗаписи, РежимПроведения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
