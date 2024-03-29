
&НаКлиенте
Процедура ОК(Команда)
	
	//МассивИменПолей = Новый Массив;
	//МассивИменПолей.Добавить("Сотрудник");
	//МассивИменПолей.Добавить("Работа");
	//МассивИменПолей.Добавить("ВремяНачала");
	//МассивИменПолей.Добавить("ВремяОкончания");
	//МассивИменПолей.Добавить("Продолжительность");
	//ЕстьОшибки = ПроверитьЗаполнениеРеквизитовТЧ(ТаблицаЗаполнения, МассивИменПолей);
	//
	//Если ЕстьОшибки Тогда
	//	ВозВрат;
	//КонецЕсли;
	
	АдресТаблицы = ПроверитьПолучитьТаблицуПериодовНаСервере();
	Если АдресТаблицы = Неопределено Тогда
		ВозВрат;
	КонецЕсли;
	
	Закрыть(АдресТаблицы);
КонецПроцедуры

//// БоР :  14.01.2017 22:31:19
//&НаКлиенте
//Функция ПроверитьЗаполнениеРеквизитовТЧ(Таблица, МассивИменПолей) Экспорт
//	ЕстьОшибки = Ложь;
//	Для каждого СтрокаТаблицы Из Таблица Цикл
//		Для каждого ИмяПоля Из МассивИменПолей Цикл
//			Если Не ЗначениеЗаполнено(СтрокаТаблицы[ИмяПоля]) Тогда
//				НомерСтроки = Таблица.Индекс(СтрокаТаблицы) + 1;
//				Сообщение = Новый СообщениеПользователю;
//				Сообщение.Текст = "Не указано значение поля """ + ИмяПоля + """ в строке " + НомерСтроки;
//				Сообщение.Поле = "ТаблицаЗаполнения[" + (НомерСтроки - 1) + "]." + ИмяПоля;
//				Сообщение.Сообщить();
//				ЕстьОшибки = Истина;
//			КонецЕсли;
//		КонецЦикла;
//	КонецЦикла;
//	ВозВрат ЕстьОшибки;
//КонецФункции


&НаСервере
Функция ПроверитьПолучитьТаблицуПериодовНаСервере()

	ТаблицаЗаполненияТЗ = ТаблицаЗаполнения.Выгрузить();
	ПронумероватьТЗ(ТаблицаЗаполненияТЗ);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	
	#Область Запрос
	"ВЫБРАТЬ
	|	ТаблицаЗаполнения.НомерСтроки,
	|	ТаблицаЗаполнения.Сотрудник,
	|	ТаблицаЗаполнения.Работа,
	|	ТаблицаЗаполнения.Проект,
	|	ТаблицаЗаполнения.ВремяНачала,
	|	ТаблицаЗаполнения.ВремяОкончания,
	|	ТаблицаЗаполнения.Продолжительность
	|ПОМЕСТИТЬ ВТТаблицаЗаполнения
	|ИЗ
	|	&ТаблицаЗаполнения КАК ТаблицаЗаполнения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТТаблицаЗаполнения2.Сотрудник,
	|	ВТТаблицаЗаполнения2.НомерСтроки КАК НомерСтроки2,
	|	ВТТаблицаЗаполнения2.ВремяНачала КАК ВремяНачала2,
	|	ВТТаблицаЗаполнения2.ВремяОкончания КАК ВремяОкончания2,
	|	ВТТаблицаЗаполнения1.НомерСтроки КАК НомерСтроки1,
	|	ВТТаблицаЗаполнения1.ВремяНачала КАК ВремяНачала1,
	|	ВТТаблицаЗаполнения1.ВремяОкончания КАК ВремяОкончания1
	|ИЗ
	|	ВТТаблицаЗаполнения КАК ВТТаблицаЗаполнения1
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТТаблицаЗаполнения КАК ВТТаблицаЗаполнения2
	|		ПО ВТТаблицаЗаполнения1.Сотрудник = ВТТаблицаЗаполнения2.Сотрудник
	|			И ВТТаблицаЗаполнения1.ВремяОкончания > ВТТаблицаЗаполнения2.ВремяНачала
	|			И ВТТаблицаЗаполнения1.ВремяНачала < ВТТаблицаЗаполнения2.ВремяОкончания
	|			И ВТТаблицаЗаполнения1.НомерСтроки < ВТТаблицаЗаполнения2.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТТаблицаЗаполнения.НомерСтроки,
	|	ВТТаблицаЗаполнения.Сотрудник КАК Сотрудник,
	|	ВТТаблицаЗаполнения.Работа КАК Работа,
	|	ВТТаблицаЗаполнения.Проект КАК Проект,
	|	ВТТаблицаЗаполнения.ВремяНачала КАК ВремяНачала,
	|	ВТТаблицаЗаполнения.ВремяОкончания,
	|	ВТТаблицаЗаполнения.Продолжительность,
	|	НЕ Спр.Отсутствие КАК ПроектОбязателен
	|ИЗ
	|	ВТТаблицаЗаполнения КАК ВТТаблицаЗаполнения
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Работы КАК Спр
	|		ПО (Спр.Ссылка = ВТТаблицаЗаполнения.Работа)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сотрудник,
	|	ВремяНачала";
	#КонецОбласти
	
	Запрос.УстановитьПараметр("ТаблицаЗаполнения", ТаблицаЗаполненияТЗ);
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	РезультатОшибок = РезультатыЗапроса[РезультатыЗапроса.Количество() - 2];
	
	ЕстьОшибки = Ложь;
		
	ВыборкаДетальныеЗаписи = РезультатОшибок.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "В строке """ + ВыборкаДетальныеЗаписи.НомерСтроки1 + """ период пересекается с периодом в строке """ + ВыборкаДетальныеЗаписи.НомерСтроки2 + """";
		Сообщение.Поле = "ТаблицаЗаполнения[" + (ВыборкаДетальныеЗаписи.НомерСтроки1 - 1) + "].ВремяНачала";
		//Сообщение.ПутьКДанным = "ТаблицаЗаполнения[" + (ВыборкаДетальныеЗаписи.НомерСтроки1 - 1) + "].ВремяНачала";
		Сообщение.Сообщить();
		ЕстьОшибки = Истина;
	КонецЦикла;
	
	ПараметрыСтрокиПериода = Новый Структура;
	ПараметрыСтрокиПериода.Вставить("Сотрудник");
	ПараметрыСтрокиПериода.Вставить("Работа");
	ПараметрыСтрокиПериода.Вставить("Проект");
	
	РезультатЗапроса = РезультатыЗапроса[РезультатыЗапроса.Количество() - 1];
	ТаблицаПериодов = РезультатЗапроса.Выгрузить();
	//ТаблицаПериодов.Очистить();
	//ТаблицаПериодов.Колонки.Добавить("ДатаВремяНачала");
	//ТаблицаПериодов.Колонки.Добавить("ДатаВремяОкончания");
	//ТаблицаСотрудников = РезультатЗапроса.Выгрузить();
	//Для каждого СтрокаТаблицаСотрудников Из ТаблицаСотрудников Цикл
	//	ЗаполнитьЗначенияСвойств(ПараметрыСтрокиПериода, СтрокаТаблицаСотрудников);
	//	ДатаНачала = НачалоДня(ДатаРасписания) + (СтрокаТаблицаСотрудников.ВремяНачала - '00010101');
	//	ДатаОкончания = НачалоДня(ДатаРасписания) + (СтрокаТаблицаСотрудников.ВремяОкончания - '00010101');
	//	ДобавитьПериодыВТаблицу(ТаблицаПериодов, ДатаНачала, ДатаОкончания, СтрокаТаблицаСотрудников.Продолжительность, ПараметрыСтрокиПериода);
	//КонецЦикла;
	
	
	ТаблицаПроверки	= ТаблицаПериодов.Скопировать();
	ТаблицаПроверки.Сортировать("НомерСтроки");
	МассивИменПолей = Новый Массив;
	МассивИменПолей.Добавить("Сотрудник");
	МассивИменПолей.Добавить("Работа");
	МассивИменПолей.Добавить("ВремяНачала");
	МассивИменПолей.Добавить("ВремяОкончания");
	МассивИменПолей.Добавить("Продолжительность");
	
	Для каждого СтрокаТаблицы Из ТаблицаПроверки Цикл
		НомерСтроки = СтрокаТаблицы.НомерСтроки;
		//
		Для каждого ИмяПоля Из МассивИменПолей Цикл
			Если Не ЗначениеЗаполнено(СтрокаТаблицы[ИмяПоля]) Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Не указано значение поля """ + ИмяПоля + """ в строке " + НомерСтроки;
				Сообщение.Поле = "ТаблицаЗаполнения[" + (НомерСтроки - 1) + "]." + ИмяПоля;
				Сообщение.Сообщить();
				ЕстьОшибки = Истина;
			КонецЕсли;
		КонецЦикла;
		
		ИмяПоля = "Проект";
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.Проект) И СтрокаТаблицы.ПроектОбязателен Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не указано значение поля """ + ИмяПоля + """ в строке " + НомерСтроки;
			Сообщение.Поле = "ТаблицаЗаполнения[" + (НомерСтроки - 1) + "]." + ИмяПоля;
			Сообщение.Сообщить();
			ЕстьОшибки = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьОшибки Тогда
		ВозВрат Неопределено;
	КонецЕсли;
	
	
	АдресТаблицы = ПоместитьВоВременноеХранилище(ТаблицаПериодов);
	ВозВрат АдресТаблицы;
	
КонецФункции

// БоР :  14.01.2017 22:17:47
&НаСервере
Процедура ДобавитьПериодыВТаблицу(ТаблицаПериодов, ДатаНачала, ДатаОкончания, Продолжительность, ПараметрыСтрокиПериода) Экспорт
	
	ОчередноеВремя = ДатаНачала;
	Пока ОчередноеВремя < ДатаОкончания И ОчередноеВремя + Продолжительность * 60 <= ДатаОкончания Цикл
		СтрокаПериода = ТаблицаПериодов.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПериода, ПараметрыСтрокиПериода);
		СтрокаПериода.ДатаВремяНачала		= ОчередноеВремя;
		СтрокаПериода.ДатаВремяОкончания	= ОчередноеВремя + Продолжительность * 60;
		СтрокаПериода.Продолжительность		= Продолжительность;
		
		ОчередноеВремя = СтрокаПериода.ДатаВремяОкончания;
	КонецЦикла;
	
КонецПроцедуры


// БоР : Добавляет в таблицу колонку с номером строки (как в ТЧ итп) 08.02.2016 3:27:18
&НаСервере
Процедура ПронумероватьТЗ(ТЗ, ИмяКолонки = "НомерСтроки") Экспорт
	
	Если ТипЗнч(ТЗ) <> Тип("ТаблицаЗначений") Тогда
		ВозВрат;
	КонецЕсли;
	Если Ложь Тогда
		ТЗ = Новый ТаблицаЗначений;
	КонецЕсли;
	Если ТЗ.Колонки.Найти(ИмяКолонки) = Неопределено Тогда
		ТЗ.Колонки.Добавить(ИмяКолонки, Новый ОписаниеТипов("Число"));
	КонецЕсли;
	Для каждого СтрокаТЗ Из ТЗ Цикл
		СтрокаТЗ[ИмяКолонки] = ТЗ.Индекс(СтрокаТЗ) + 1;
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	БоР_ОбщийМодуль.ЗаполнитьРеквизитыИзПараметров(ЭтаФорма, Неопределено);
	ПолучитьТаблицуЗаполнения();
КонецПроцедуры

&НаСервере
Процедура ПолучитьТаблицуЗаполнения() Экспорт
	Если Не ЗначениеЗаполнено(АдресТекущейТаблицы) Тогда
		ВозВрат;
	КонецЕсли;
	
	ТаблицаПериодов = ПолучитьИзВременногоХранилища(АдресТекущейТаблицы);
	Если ТипЗнч(ТаблицаПериодов) <> Тип("ТаблицаЗначений") Тогда
		 ВозВрат;
	КонецЕсли;
	
	Если ТаблицаПериодов.Количество() = 0 Тогда
		 ВозВрат;
	КонецЕсли;
	
	// БоР : Если в таблице будут разные даты - что получится, неизвестно 15.01.2017 16:17:49
	// БоР : В конце концов, это просто попытка угадать исходные данные 15.01.2017 16:17:49
	Для каждого СтрокаТаблицаПериодов Из ТаблицаПериодов Цикл
		Секунд = СтрокаТаблицаПериодов.ДатаВремяНачала - НачалоДня(СтрокаТаблицаПериодов.ДатаВремяНачала);
		СтрокаТаблицаПериодов.ДатаВремяНачала = '00010101' + Секунд;
		
		Секунд = СтрокаТаблицаПериодов.ДатаВремяОкончания - НачалоДня(СтрокаТаблицаПериодов.ДатаВремяОкончания);
		СтрокаТаблицаПериодов.ДатаВремяОкончания = '00010101' + Секунд;
	КонецЦикла;
	ТаблицаПериодов.Сортировать("Сотрудник, Работа, Проект, ДатаВремяНачала");
	
	ОчередныеЗначения = Новый Структура;
	ОчередныеЗначения.Вставить("Работа");
	ОчередныеЗначения.Вставить("Проект");
	ОчередныеЗначения.Вставить("Сотрудник");
	ОчередныеЗначения.Вставить("Продолжительность");
	
	ТаблицаЗаполнения.Очистить();
	
	ЗаполнитьЗначенияСвойств(ОчередныеЗначения, ТаблицаПериодов[0]);
	ОчереднаяДатаНачала			= ТаблицаПериодов[0].ДатаВремяНачала;
	ОчереднаяДатаОкончания		= ТаблицаПериодов[0].ДатаВремяОкончания;
	Для каждого СтрокаТаблицаПериодов Из ТаблицаПериодов Цикл
		Если ОчереднаяДатаОкончания < СтрокаТаблицаПериодов.ДатаВремяНачала ИЛИ Не БоР_ОбщийМодульКлиентСервер.СравнитьПоляСтруктур(ОчередныеЗначения, СтрокаТаблицаПериодов) Тогда
			ТекущаяСтрокаЗаполнения = ТаблицаЗаполнения.Добавить();
			ТекущаяСтрокаЗаполнения.Сотрудник			= ОчередныеЗначения.Сотрудник;
			ТекущаяСтрокаЗаполнения.Работа				= ОчередныеЗначения.Работа;
			ТекущаяСтрокаЗаполнения.Проект				= ОчередныеЗначения.Проект;
			ТекущаяСтрокаЗаполнения.Продолжительность	= ОчередныеЗначения.Продолжительность;
			ТекущаяСтрокаЗаполнения.ВремяНачала			= ОчереднаяДатаНачала;
			ТекущаяСтрокаЗаполнения.ВремяОкончания		= ОчереднаяДатаОкончания;
			
			ЗаполнитьЗначенияСвойств(ОчередныеЗначения, СтрокаТаблицаПериодов);
			ОчереднаяДатаНачала = СтрокаТаблицаПериодов.ДатаВремяНачала;
		КонецЕсли;
		ОчереднаяДатаОкончания = СтрокаТаблицаПериодов.ДатаВремяОкончания;
	КонецЦикла;
	
	ТекущаяСтрокаЗаполнения = ТаблицаЗаполнения.Добавить();
	ТекущаяСтрокаЗаполнения.Сотрудник			= ОчередныеЗначения.Сотрудник;
	ТекущаяСтрокаЗаполнения.Работа				= ОчередныеЗначения.Работа;
	ТекущаяСтрокаЗаполнения.Проект				= ОчередныеЗначения.Проект;
	ТекущаяСтрокаЗаполнения.Продолжительность	= ОчередныеЗначения.Продолжительность;
	ТекущаяСтрокаЗаполнения.ВремяНачала			= ОчереднаяДатаНачала;
	ТекущаяСтрокаЗаполнения.ВремяОкончания		= ОчереднаяДатаОкончания;
	
	
	
КонецПроцедуры


&НаКлиенте
Процедура ТаблицаЗаполненияПродолжительностьПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ТаблицаЗаполнения.ТекущиеДанные;
	Продолжительность = ТекущиеДанные.Продолжительность;
	ШагСеткиМин = Бор_ПовторноеИспользованиеКлиентСервер.ПолучитьШагСеткиРасписания();
	ОстатокОтДеления = Продолжительность % ШагСеткиМин;
	Если ОстатокОтДеления <> 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Продолжительность должна быть кратна " + ШагСеткиМин + " минутам!";
		Сообщение.Поле = "ТаблицаЗаполнения[" + (ТекущиеДанные.НомерСтроки - 1) + "].Продолжительность";
		Сообщение.Сообщить();
		ТекущиеДанные.Продолжительность = Макс(Окр(Продолжительность/ШагСеткиМин)*ШагСеткиМин, ШагСеткиМин);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗаполненияВремяНачалаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ТаблицаЗаполнения.ТекущиеДанные;
	Продолжительность = ТекущиеДанные.ВремяНачала - НачалоДня(ТекущиеДанные.ВремяНачала);
	ШагСеткиМин = Бор_ПовторноеИспользованиеКлиентСервер.ПолучитьШагСеткиРасписания();
	ШагСеткиСек = ШагСеткиМин * 60;
	ОстатокОтДеления = Продолжительность % ШагСеткиСек;
	Если ОстатокОтДеления <> 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Время должно быть кратно " + ШагСеткиМин + " минутам!";
		Сообщение.Поле = "ТаблицаЗаполнения[" + (ТекущиеДанные.НомерСтроки - 1) + "].ВремяНачала";
		Сообщение.Сообщить();
		Продолжительность = Макс(Окр(Продолжительность/ШагСеткиСек)*ШагСеткиСек, ШагСеткиСек);
		ТекущиеДанные.ВремяНачала = НачалоДня(ТекущиеДанные.ВремяНачала) + Продолжительность;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗаполненияВремяОкончанияПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ТаблицаЗаполнения.ТекущиеДанные;
	Продолжительность = ТекущиеДанные.ВремяОкончания - НачалоДня(ТекущиеДанные.ВремяОкончания);
	ШагСеткиМин = Бор_ПовторноеИспользованиеКлиентСервер.ПолучитьШагСеткиРасписания();
	ШагСеткиСек = ШагСеткиМин * 60;
	ОстатокОтДеления = Продолжительность % ШагСеткиСек;
	Если ОстатокОтДеления <> 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Время должно быть кратно " + ШагСеткиМин + " минутам!";
		Сообщение.Поле = "ТаблицаЗаполнения[" + (ТекущиеДанные.НомерСтроки - 1) + "].ВремяОкончания";
		Сообщение.Сообщить();
		Продолжительность = Макс(Окр(Продолжительность/ШагСеткиСек)*ШагСеткиСек, ШагСеткиСек);
		ТекущиеДанные.ВремяОкончания = НачалоДня(ТекущиеДанные.ВремяОкончания) + Продолжительность;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗаполненияВремяНачалаОбедаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ТаблицаЗаполнения.ТекущиеДанные;
	Продолжительность = ТекущиеДанные.ВремяНачалаОбеда - НачалоДня(ТекущиеДанные.ВремяНачалаОбеда);
	ШагСеткиМин = Бор_ПовторноеИспользованиеКлиентСервер.ПолучитьШагСеткиРасписания();
	ШагСеткиСек = ШагСеткиМин * 60;
	ОстатокОтДеления = Продолжительность % ШагСеткиСек;
	Если ОстатокОтДеления <> 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Время должно быть кратно " + ШагСеткиМин + " минутам!";
		Сообщение.Поле = "ТаблицаЗаполнения[" + (ТекущиеДанные.НомерСтроки - 1) + "].ВремяНачалаОбеда";
		Сообщение.Сообщить();
		Продолжительность = Макс(Окр(Продолжительность/ШагСеткиСек)*ШагСеткиСек, ШагСеткиСек);
		ТекущиеДанные.ВремяНачалаОбеда = НачалоДня(ТекущиеДанные.ВремяНачалаОбеда) + Продолжительность;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗаполненияВремяОкончанияОбедаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ТаблицаЗаполнения.ТекущиеДанные;
	Продолжительность = ТекущиеДанные.ВремяОкончанияОбеда - НачалоДня(ТекущиеДанные.ВремяОкончанияОбеда);
	ШагСеткиМин = Бор_ПовторноеИспользованиеКлиентСервер.ПолучитьШагСеткиРасписания();
	ШагСеткиСек = ШагСеткиМин * 60;
	ОстатокОтДеления = Продолжительность % ШагСеткиСек;
	Если ОстатокОтДеления <> 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Время должно быть кратно " + ШагСеткиМин + " минутам!";
		Сообщение.Поле = "ТаблицаЗаполнения[" + (ТекущиеДанные.НомерСтроки - 1) + "].ВремяОкончанияОбеда";
		Сообщение.Сообщить();
		Продолжительность = Макс(Окр(Продолжительность/ШагСеткиСек)*ШагСеткиСек, ШагСеткиСек);
		ТекущиеДанные.ВремяОкончанияОбеда = НачалоДня(ТекущиеДанные.ВремяОкончанияОбеда) + Продолжительность;
	КонецЕсли;
КонецПроцедуры
