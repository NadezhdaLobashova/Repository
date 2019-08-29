
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	Если КлючВарианта = "Основной" ИЛИ КлючВарианта = "ВРазрезеВыходныхДней" ИЛИ КлючВарианта = "Сокращенный" Тогда
		
		Попытка
			
			СтандартнаяОбработка = Ложь;
			
			НастройкиОтчета = ЭтотОбъект.КомпоновщикНастроек.ПолучитьНастройки();
			
			ЗначениеПериод = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("МесяцОтчета");
			
			ДатаНачала    = НачалоМесяца(ТекущаяДата());
			ДатаОкончания = КонецМесяца(ТекущаяДата());
			
			Если ТипЗнч(ЗначениеПериод.Значение) = Тип("СтандартныйПериод") Тогда
				ДатаНачала = ЗначениеПериод.Значение.ДатаНачала;
				ДатаОкончания = ЗначениеПериод.Значение.ДатаОкончания; 
			КонецЕсли;
			
			Если РольДоступна("РуководительПодразделения") И Не РольДоступна("ПолныеПрава") Тогда			
				НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("РуководительПодразделения",Истина);
			КонецЕсли;
			
			НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ПодразделениеПараметр", ПараметрыСеанса.РазрешенныеПодразделения);
			
			
			
			// Параметры документа
			ДокументРезультат.ТолькоПросмотр = Истина;
			ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
			ДокументРезультат.Очистить();
			ДокументРезультат.АвтоМасштаб = Истина;
			ДокументРезультат.НачатьАвтогруппировкуСтрок();
			
			
			Данные = Новый ДеревоЗначений;
			
			КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
			МакетКомпоновки = КомпоновщикМакета.Выполнить(ЭтотОбъект.СхемаКомпоновкиДанных, НастройкиОтчета,,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
			
			//Создадим и инициализируем процессор компоновки
			ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
			ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Истина);
			
			ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
			ПроцессорВывода.УстановитьОбъект(Данные);
			
			//Обозначим начало вывода
			ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
			
			
			Если КлючВарианта = "Основной" Тогда
				
				Макет = ПолучитьМакет("Макет");
				
				ОбластьШапка = Макет.ПолучитьОбласть("ОбластьШапка");
				ДокументРезультат.Вывести(ОбластьШапка);
				
				Номер = 1;
				Для Каждого СтрокаСотрудник из Данные.Строки Цикл
					ТаблицаИтога = СоздатьПустуюТаблицу(Ложь);
					Для Каждого СтрокаДанных1 из СтрокаСотрудник.Строки Цикл
						Для Каждого СтрокаДанных Из СтрокаДанных1.Строки Цикл
							ОбластьСотрудник = Макет.ПолучитьОбласть("ОбластьСотрудник");
							ОбластьСотрудник.Параметры.Заполнить(СтрокаДанных);
							ОбластьСотрудник.Параметры.СтруктураАванс = Новый Структура("ДатаНачала, ДатаОкончания, Проект, ВидРаботы, Сотрудник", ДатаНачала, ДатаНачала + (14*24*60*60), СтрокаДанных.Проект, СтрокаДанных.ВидРаботы, СтрокаДанных.Сотрудник);
							ОбластьСотрудник.Параметры.СтруктураЗП    = Новый Структура("ДатаНачала, ДатаОкончания, Проект, ВидРаботы, Сотрудник", ДатаОкончания - (15*24*60*60), ДатаОкончания, СтрокаДанных.Проект, СтрокаДанных.ВидРаботы, СтрокаДанных.Сотрудник);
							ОбластьСотрудник.Параметры.СтруктураИТОГО = Новый Структура("ДатаНачала, ДатаОкончания, Проект, ВидРаботы, Сотрудник", ДатаНачала, ДатаОкончания, СтрокаДанных.Проект, СтрокаДанных.ВидРаботы, СтрокаДанных.Сотрудник);
							ОбластьСотрудник.Параметры.Номер = Номер;
							ДокументРезультат.Вывести(ОбластьСотрудник);
							СтрокаВТ = ТаблицаИтога.Добавить();
							ЗаполнитьЗначенияСвойств(СтрокаВТ,СтрокаДанных);
						КонецЦикла;
					КонецЦикла;
					ТаблицаИтога.Свернуть(,"ЧасовАванс,СуммаАванс,СуммаАвансНаРуки,ЧасовЗП,СуммаЗП,СуммаЗПНаРуки,ИТОГОЧасы,ИтогоСумма,ИтогоСуммаНаРуки");
					ОбластьИтог = Макет.ПолучитьОбласть("ОбластьИтог");
					Если ТаблицаИтога.Количество()>0 Тогда
						ОбластьИтог.Параметры.Заполнить(ТаблицаИтога[0]);			
					КонецЕсли;
					ДокументРезультат.Вывести(ОбластьИтог);
					Номер = Номер + 1;
				КонецЦикла;
				
				
			ИначеЕсли КлючВарианта = "Сокращенный" Тогда
				
				Макет = ПолучитьМакет("Сокращенный");
				
				ОбластьШапка = Макет.ПолучитьОбласть("ОбластьШапка");
				ДокументРезультат.Вывести(ОбластьШапка);
				
				ДанныеКопия = СоздатьПустуюТаблицу(Ложь);
				ДанныеКопия.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
				
				Для Каждого СтрокаДереваДанных Из Данные.Строки Цикл
					СтрокаКопия = ДанныеКопия.Добавить();
					СтрокаКопия.Сотрудник = СтрокаДереваДанных.Сотрудник;
					Для Каждого СтрокаНачисления Из СтрокаДереваДанных.Строки Цикл
						ЗаполнитьЗначенияСвойств(СтрокаКопия,СтрокаНачисления);
					Конеццикла;
				Конеццикла;	
				
				ДанныеКопия.Свернуть("Сотрудник","ЧасовАванс,СуммаАванс,СуммаАвансНаРуки,ЧасовЗП,СуммаЗП,СуммаЗПНаРуки,ИТОГОЧасы,ИтогоСумма,ИтогоСуммаНаРуки");
				ДанныеКопия.Сортировать("Сотрудник возр");
				
				Для Каждого СтрокаСотрудник из ДанныеКопия Цикл
					
					ОбластьСотрудник = Макет.ПолучитьОбласть("ОбластьСтрока");
					ОбластьСотрудник.Параметры.Заполнить(СтрокаСотрудник);
					
					ОбластьСотрудник.Параметры.СтруктураАванс = Новый Структура("ДатаНачала, ДатаОкончания, Сотрудник", ДатаНачала, ДатаНачала + (14*24*60*60), СтрокаСотрудник.Сотрудник);
					ОбластьСотрудник.Параметры.СтруктураЗП    = Новый Структура("ДатаНачала, ДатаОкончания, Сотрудник", ДатаОкончания - (15*24*60*60), ДатаОкончания, СтрокаСотрудник.Сотрудник);
					ОбластьСотрудник.Параметры.СтруктураИТОГО = Новый Структура("ДатаНачала, ДатаОкончания, Сотрудник", ДатаНачала, ДатаОкончания, СтрокаСотрудник.Сотрудник);
					
					ДокументРезультат.Вывести(ОбластьСотрудник);
					
				КонецЦикла;	
			КонецЕсли;
			
			
		Исключение
			Инфо = ИнформацияОбОшибке();
			ВызватьИсключение НСтр("ru = 'В настройку отчета внесены критичные изменения. Отчет не будет сформирован.'") + " " + Инфо.Описание;
		КонецПопытки;
		
	Иначе
		
		НастройкиОтчета = ЭтотОбъект.КомпоновщикНастроек.ПолучитьНастройки();
		
		Если РольДоступна("РуководительПодразделения") И Не РольДоступна("ПолныеПрава") Тогда			
			НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("РуководительПодразделения",Истина);
		КонецЕсли;
		
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ПодразделениеПараметр", ПараметрыСеанса.РазрешенныеПодразделения);
		
	КонецЕсли;

КонецПроцедуры
	
Функция СоздатьПустуюТаблицу(ВРазрезеВыходных)
	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("ЧасовАванс",Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("СуммаАванс",Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("СуммаАвансНаРуки",Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("ЧасовЗП",Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("СуммаЗП",Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("СуммаЗПНаРуки",Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("ИТОГОЧасы",Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("ИтогоСумма",Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("ИтогоСуммаНаРуки",Новый ОписаниеТипов("Число"));
	Если ВРазрезеВыходных Тогда
		ТаблицаДанных.Колонки.Добавить("СуммаАвансВых",Новый ОписаниеТипов("Число"));
		ТаблицаДанных.Колонки.Добавить("СуммаАвансНаРукиВых",Новый ОписаниеТипов("Число"));
		ТаблицаДанных.Колонки.Добавить("СуммаЗПВых",Новый ОписаниеТипов("Число"));
		ТаблицаДанных.Колонки.Добавить("СуммаЗПНаРукиВых",Новый ОписаниеТипов("Число"));
		ТаблицаДанных.Колонки.Добавить("ИтогоСуммаВых",Новый ОписаниеТипов("Число"));
		ТаблицаДанных.Колонки.Добавить("ИтогоСуммаНаРукиВых",Новый ОписаниеТипов("Число"));
    КонецЕсли;
    Возврат ТаблицаДанных
КонецФункции	
	
	






	
	
	
	
	
	
