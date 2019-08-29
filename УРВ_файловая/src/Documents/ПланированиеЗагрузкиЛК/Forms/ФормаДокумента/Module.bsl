
&НаКлиенте
Процедура РаботыДатаВремяНачалаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Работы.ТекущиеДанные;
	БоР_ОбщийМодульКлиентСервер.УРВ_ДатаВремяНачалаПриИзменении(ТекущиеДанные.ДатаВремяНачала, ТекущиеДанные.ДатаВремяОкончания, ТекущиеДанные.Продолжительность, "Работы[" + (ТекущиеДанные.НомерСтроки - 1) + "].ДатаВремяНачала", "Объект", Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура РаботыДатаВремяОкончанияПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Работы.ТекущиеДанные;
	БоР_ОбщийМодульКлиентСервер.УРВ_ДатаВремяОкончанияПриИзменении(ТекущиеДанные.ДатаВремяНачала, ТекущиеДанные.ДатаВремяОкончания, ТекущиеДанные.Продолжительность, "Работы[" + (ТекущиеДанные.НомерСтроки - 1) + "].ДатаВремяОкончания", "Объект", Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура РаботыПродолжительностьПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Работы.ТекущиеДанные;
	БоР_ОбщийМодульКлиентСервер.УРВ_ПродолжительностьПриИзменении(ТекущиеДанные.ДатаВремяНачала, ТекущиеДанные.ДатаВремяОкончания, ТекущиеДанные.Продолжительность, "Работы[" + (ТекущиеДанные.НомерСтроки - 1) + "].Продолжительность", "Объект", Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура РаботыРаботаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Работы.ТекущиеДанные;
	РаботаПоРасписанию = БоР_ОбщийМодуль.ПолучитьПолеОбъекта(ТекущиеДанные.Работа ,"РаботаПоРасписанию");
	Если РаботаПоРасписанию Тогда
		//ТекущиеДанные.Задание			= Неопределено;
		//ТекущиеДанные.ПакетЧасов		= Неопределено;
		ТекущиеДанные.КрайнийСрок		= Неопределено;
		ТекущиеДанные.Событие			= Неопределено;
	КонецЕсли;
	ТребуетУказанияКонтрагента = БоР_ОбщийМодуль.ПолучитьПолеОбъекта(ТекущиеДанные.Работа ,"ТребуетУказанияКонтрагента");
	Если Не ТребуетУказанияКонтрагента Тогда
		ТекущиеДанные.Контрагент		= Неопределено;
		ТекущиеДанные.КонтактноеЛицо	= Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтменяемыеПланыДатаВремяНачалаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ОтменяемыеПланы.ТекущиеДанные;
	БоР_ОбщийМодульКлиентСервер.УРВ_ДатаВремяНачалаПриИзменении(ТекущиеДанные.ДатаВремяНачала, ТекущиеДанные.ДатаВремяОкончания, ТекущиеДанные.Продолжительность, "ОтменяемыеПланы[" + (ТекущиеДанные.НомерСтроки - 1) + "].ДатаВремяНачала", "Объект", Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОтменяемыеПланыПродолжительностьПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ОтменяемыеПланы.ТекущиеДанные;
	БоР_ОбщийМодульКлиентСервер.УРВ_ПродолжительностьПриИзменении(ТекущиеДанные.ДатаВремяНачала, ТекущиеДанные.ДатаВремяОкончания, ТекущиеДанные.Продолжительность, "ОтменяемыеПланы[" + (ТекущиеДанные.НомерСтроки - 1) + "].ДатаВремяОкончания", "Объект", Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОтменяемыеПланыДатаВремяОкончанияПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ОтменяемыеПланы.ТекущиеДанные;
	БоР_ОбщийМодульКлиентСервер.УРВ_ДатаВремяОкончанияПриИзменении(ТекущиеДанные.ДатаВремяНачала, ТекущиеДанные.ДатаВремяОкончания, ТекущиеДанные.Продолжительность, "ОтменяемыеПланы[" + (ТекущиеДанные.НомерСтроки - 1) + "].Продолжительность", "Объект", Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПерепланированиеПриИзменении(Элемент)
	УстановитьВидимостьДоступность(ЭтаФорма);
КонецПроцедуры

// БоР :  17.08.2017 16:03:23
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьДоступность(ЭтаФорма) Экспорт
	ЭтаФорма.Элементы.СтраницаОтменяемыеПланы.Видимость = ЭтаФорма.Объект.Перепланирование;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьВидимостьДоступность(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	УстановитьВидимостьДоступность(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура РаботыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "РаботыОписаниеТекст" Тогда
		РедактируемаяСтрока = Объект.Работы.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если РедактируемаяСтрока = Неопределено Тогда
			ВозВрат;
		КонецЕсли;
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ОписаниеXML"					, РедактируемаяСтрока.ОписаниеXML);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ВыбраннаяСтрока", ВыбраннаяСтрока);
		
		ИмяФормыДляОткрытия = "Обработка.РасписаниеЛК.Форма.ФормаВводаОписания";
		БоР_ОбщийМодульКлиент.ОткрытьБлокирующуюФорму(ЭтаФорма, ИмяФормыДляОткрытия, ПараметрыФормы, "РаботыВыбор_Завершение", ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыВыбор_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		ВозВрат;
	КонецЕсли;
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		ВозВрат;
	КонецЕсли;
	ВыбраннаяСтрока = Неопределено;
	ДополнительныеПараметры.Свойство("ВыбраннаяСтрока", ВыбраннаяСтрока);
	
	Если ВыбраннаяСтрока <> Неопределено Тогда
		РедактируемаяСтрока = Объект.Работы.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если РедактируемаяСтрока = Неопределено Тогда
			ВозВрат;
		КонецЕсли;
		РедактируемаяСтрока.ОписаниеXML		= Результат.ОписаниеXML;
		РедактируемаяСтрока.ОписаниеТекст	= Результат.ОписаниеТекст;
	КонецЕсли;

КонецПроцедуры



