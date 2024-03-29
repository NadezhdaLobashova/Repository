
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Роль = Параметры.РольИсполнителя;
	ОсновнойОбъектАдресации = Параметры.ОсновнойОбъектАдресации;
	ДополнительныйОбъектАдресации = Параметры.ДополнительныйОбъектАдресации;
	УстановитьТипыОбъектовАдресации();
	УстановитьСостояниеЭлементов();
	
	Если Параметры.ВыборОбъектаАдресации Тогда
		ТекущийЭлемент = Элементы.ОсновнойОбъектАдресации;
	КонецЕсли;
	
	СведенияПользователей = РегистрыСведений.СведенияОПользователях.Получить(Новый Структура("Пользователь", Пользователи.АвторизованныйПользователь()));
	ОбслуживающаяОрганизация = СведенияПользователей.ОбслуживающаяОрганизация;
	ЛинияПоддержки = СведенияПользователей.ЛинияПоддержки;
	
	Если ТипыОсновногоОбъектаАдресации.СодержитТип(Тип("СправочникСсылка.ОбслуживающиеОрганизации")) Тогда
		ОсновнойОбъектАдресации = ОбслуживающаяОрганизация;
	КонецЕсли;
	
	Если ТипыДополнительногоОбъектаАдресации.СодержитТип(Тип("СправочникСсылка.ЛинииПоддержки")) Тогда
		ДополнительныйОбъектАдресации = ЛинияПоддержки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ИспользуетсяБезОбъектовАдресации Тогда
		Возврат;
	КонецЕсли;
		
	ЗаданыТипыОсновногоОбъектаАдресации = ИспользуетсяСОбъектамиАдресации И ЗначениеЗаполнено(ТипыОсновногоОбъектаАдресации);
	ЗаданыТипыДополнительногоОбъектаАдресации = ИспользуетсяСОбъектамиАдресации И ЗначениеЗаполнено(ТипыДополнительногоОбъектаАдресации);
	
	Если ЗаданыТипыОсновногоОбъектаАдресации И ОсновнойОбъектАдресации = Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю( 
		    СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Поле ""%1"" не заполнено.'"), Роль.ТипыОсновногоОбъектаАдресации.Наименование ),,,
				"ОсновнойОбъектАдресации", Отказ);
				
	ИначеЕсли ЗаданыТипыДополнительногоОбъектаАдресации И ДополнительныйОбъектАдресации = Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Поле ""%1"" не заполнено.'"), Роль.ТипыДополнительногоОбъектаАдресации.Наименование ),,, 
			"ДополнительныйОбъектАдресации", Отказ);
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	ОсновнойОбъектАдресации = Неопределено;
	ДополнительныйОбъектАдресации = Неопределено;
	УстановитьТипыОбъектовАдресации();
	УстановитьСостояниеЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура OKВыполнить()
	
	ОчиститьСообщения();
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	РезультатВыбора = ПараметрыЗакрытия();
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьТипыОбъектовАдресации()
	
	ТипыОсновногоОбъектаАдресации = Роль.ТипыОсновногоОбъектаАдресации.ТипЗначения;
	ТипыДополнительногоОбъектаАдресации = Роль.ТипыДополнительногоОбъектаАдресации.ТипЗначения;
	ИспользуетсяСОбъектамиАдресации = Роль.ИспользуетсяСОбъектамиАдресации;
	ИспользуетсяБезОбъектовАдресации = Роль.ИспользуетсяБезОбъектовАдресации;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеЭлементов()

	ЗаданыТипыОсновногоОбъектаАдресации = ИспользуетсяСОбъектамиАдресации
		И ЗначениеЗаполнено(ТипыОсновногоОбъектаАдресации);
	ЗаданыТипыДополнительногоОбъектаАдресации = ИспользуетсяСОбъектамиАдресации 
		И ЗначениеЗаполнено(ТипыДополнительногоОбъектаАдресации);
		
	Элементы.ОсновнойОбъектАдресации.Заголовок = Роль.ТипыОсновногоОбъектаАдресации.Наименование;
	Элементы.ОсновнойОбъектАдресации.Доступность = ЗаданыТипыОсновногоОбъектаАдресации; 
	Элементы.ОсновнойОбъектАдресации.АвтоОтметкаНезаполненного = ЗаданыТипыОсновногоОбъектаАдресации
		И НЕ ИспользуетсяБезОбъектовАдресации;
	Элементы.ОсновнойОбъектАдресации.ОграничениеТипа = ТипыОсновногоОбъектаАдресации;
		
	Элементы.ДополнительныйОбъектАдресации.Заголовок = Роль.ТипыДополнительногоОбъектаАдресации.Наименование;
	Элементы.ДополнительныйОбъектАдресации.Доступность = ЗаданыТипыДополнительногоОбъектаАдресации; 
	Элементы.ДополнительныйОбъектАдресации.АвтоОтметкаНезаполненного = ЗаданыТипыДополнительногоОбъектаАдресации
		И НЕ ИспользуетсяБезОбъектовАдресации;
	Элементы.ДополнительныйОбъектАдресации.ОграничениеТипа = ТипыДополнительногоОбъектаАдресации;
	                        
КонецПроцедуры

&НаСервере
Функция ПараметрыЗакрытия()
	
	Результат = Новый Структура;
	Результат.Вставить("РольИсполнителя", Роль);
	Результат.Вставить("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
	Результат.Вставить("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
	
	Если Результат.ОсновнойОбъектАдресации <> Неопределено И Результат.ОсновнойОбъектАдресации.Пустая() Тогда
		Результат.ОсновнойОбъектАдресации = Неопределено;
	КонецЕсли;
	
	Если Результат.ДополнительныйОбъектАдресации <> Неопределено И Результат.ДополнительныйОбъектАдресации.Пустая() Тогда
		Результат.ДополнительныйОбъектАдресации = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОсновнойОбъектАдресацииПриИзменении(Элемент)
	ОсновнойОбъектАдресацииПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОсновнойОбъектАдресацииПриИзмененииНаСервере()
	
	СведенияПользователей = РегистрыСведений.СведенияОПользователях.Получить(Новый Структура("Пользователь", Пользователи.АвторизованныйПользователь()));
	ОбслуживающаяОрганизация = СведенияПользователей.ОбслуживающаяОрганизация;
	ЛинияПоддержки = СведенияПользователей.ЛинияПоддержки;
	
	Если ТипыДополнительногоОбъектаАдресации.СодержитТип(Тип("СправочникСсылка.ЛинииПоддержки")) Тогда
		Если ОсновнойОбъектАдресации = ОбслуживающаяОрганизация Тогда
			ДополнительныйОбъектАдресации = ЛинияПоддержки;
		ИначеЕсли ТипыОсновногоОбъектаАдресации.СодержитТип(Тип("СправочникСсылка.ОбслуживающиеОрганизации")) Тогда
			ДополнительныйОбъектАдресации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОсновнойОбъектАдресации, "ПерваяЛинияПоддержки", Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
