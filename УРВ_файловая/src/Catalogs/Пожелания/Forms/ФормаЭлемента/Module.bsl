
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
    БазаЗнаний.ПриСозданииНаСервере(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
    КонецЕсли;
	
	ЗаполнитьЗначенияСостояний();
    
    ЗаполнитьПоказатели(Объект.Ссылка);
    
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьТабличныеЧастиПоСпискам(ТекущийОбъект);
	
	ОбщегоНазначенияУСП.ПоместитьФорматированноеОписаниеВХранилище(Описание, ТекущийОбъект.ОписаниеХранилище);
	ТекущийОбъект.Описание = Описание.ПолучитьТекст();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("КарточкаБазыЗнаний_Запись", Объект.Ссылка, ЭтаФорма);
    ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Комментарии, "Владелец", Объект.Ссылка);
	
    Если КоличествоОбращений = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ИсходноеСостояние <> СостояниеРеализовано И Объект.Состояние = СостояниеРеализовано Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеЗаписиЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru='Перевести обращения по пожеланию на первую линию?'"), РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОписаниеПриИзменении(Элемент)
	
	Объект.ОписаниеДатаИзменения = ТекущаяДата();
	Объект.ОписаниеАвторИзменения = ТекущийПользователь;
	
КонецПроцедуры

&НаКлиенте
Процедура СервисПриИзменении(Элемент)
	
	ПриИзмененииСервиса();
	
КонецПроцедуры

&НаКлиенте
Процедура СервисОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
		
	Если Объект.Сервис <> ВыбранноеЗначение Тогда
		КомпонентСписок.Очистить();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВитринаСписокПриИзменении(Элемент)
    
    ВитринаСписокПриИзмененииНаСервере();
    
КонецПроцедуры

&НаКлиенте
Процедура ВитринаСписокНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеПодбора = ВитринаСписок.ВыгрузитьЗначения();
	ПараметрыФормы = Новый Структура("ДанныеПодбора", ДанныеПодбора);
	
	Оповещение = Новый ОписаниеОповещения("ВитринаСписокНачалоВыбораЗавершение", ЭтотОбъект);
	 
	ОткрытьФорму("Справочник.Витрины.Форма.ФормаПодбора", ПараметрыФормы, Элементы.ВитринаСписок, УникальныйИдентификатор,,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура КомпонентСписокНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеПодбора = КомпонентСписок.ВыгрузитьЗначения();
	
	Оповещение = Новый ОписаниеОповещения("КомпонентСписокНачалоВыбораЗавершение", ЭтотОбъект);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДанныеПодбора", ДанныеПодбора);
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Владелец", Новый ФиксированныйМассив(СервисСписок.ВыгрузитьЗначения())));
	 
	ОткрытьФорму("Справочник.КомпонентыСервиса.Форма.ФормаПодбора", ПараметрыФормы, Элементы.КомпонентСписок, УникальныйИдентификатор,,, Оповещение);
	
КонецПроцедуры
 
&НаКлиенте
Процедура РазделСписокНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеПодбора = РазделСписок.ВыгрузитьЗначения();
	
	ПараметрыФормы = Новый Структура("ДанныеПодбора", ДанныеПодбора);
	ПараметрыФормы.Вставить("Сервисы", СервисСписок.ВыгрузитьЗначения());
	ПараметрыФормы.Вставить("Компоненты", КомпонентСписок.ВыгрузитьЗначения());
	
	Оповещение = Новый ОписаниеОповещения("РазделСписокНачалоВыбораЗавершение", ЭтотОбъект);
	 
	ОткрытьФорму("Справочник.Разделы.Форма.ФормаПодбора", ПараметрыФормы, Элементы.РазделСписок, УникальныйИдентификатор,,, Оповещение);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормыКомментарии

&НаКлиенте
Процедура КомментарииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Ссылка) Тогда
		ПараметрыФормы = Новый Структура("Дата, Автор, ЛинияПоддержки, Комментарий, ВнутренняяПереписка");
		ЗаполнитьЗначенияСвойств(ПараметрыФормы, Объект.Комментарии.НайтиПоИдентификатору(ВыбраннаяСтрока));
		ПараметрыФормы.Вставить("ВыбраннаяСтрока", ВыбраннаяСтрока);
		ОткрытьФорму("ОбщаяФорма.ФормаКомментария", ПараметрыФормы, Элементы.Комментарии);
	Иначе
		ПараметрыФормы = Новый Структура("Ключ", Элемент.ТекущиеДанные.Ссылка);
		ОткрытьФорму("Справочник.Комментарии.Форма.ФормаЭлемента", ПараметрыФормы, Элементы.Комментарии);
	КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура КомментарииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Элементы.Комментарии.Обновить();
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УдалитьКомментарий(Команда)
	
	ТекущиеДанные = Элементы.Комментарии.ТекущиеДанные;
	Если ТекущиеДанные <>Неопределено И ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		УдалитьКомментарийНаСервере(ТекущиеДанные.Ссылка);
		Элементы.Комментарии.Обновить();
	Иначе
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьКомментарийНаСервере(СсылкаНаКомментарий)
	КомментарийОбъект = СсылкаНаКомментарий.ПолучитьОбъект();
	КомментарийОбъект.ПометкаУдаления = Истина;
	КомментарийОбъект.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКартинкуИзБуфера(Команда)
	
	КомпонентаУстановлена = РаботаСКартинкамиКлиент.ПроинициализироватьКомпоненту();
	Если Не КомпонентаУстановлена Тогда
		РаботаСКартинкамиКлиент.УстановитьКомпоненту();
	КонецЕсли;
	
	ПутьКФайлу = КомпонентаПолученияКартинкиИзБуфера.ПолучитьКартинкуИзБуфера();
	
	Если Не ПустаяСтрока(ПутьКФайлу) Тогда
		Картинка = Новый Картинка(ПутьКФайлу);
		АдресКартинки = ПоместитьВоВременноеХранилище(Картинка, АдресКартинки);
		ВставитьКартинкуИзБуфераНаСервере(АдресКартинки);
		Модифицированность = Истина;
	Иначе
		ПоказатьПредупреждение(,НСтр("ru = 'Буфер обмена не содержит картинки'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКомментарий(Команда)
	
	Если ПустаяСтрока(СокрЛП(НовыйКомментарий)) Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Оповещение = Новый ОписаниеОповещения("ДобавитьКомментарийПродолжение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Документ не записан. Комментарии можно писать только для записанных документов. Записать документ?'"), 
			РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Нет, , КодВозвратаДиалога.Нет);
	Иначе
		ДобавитьКомментарийЗавершение();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКомментарийПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		РезультатЗаписи = Записать();
		Если РезультатЗаписи Тогда
			Комментарии.Параметры.УстановитьЗначениеПараметра("Владелец", Объект.Ссылка);
			ДобавитьКомментарийЗавершение();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКомментарийЗавершение()
	
	ДобавитьКомментарийНаСервере();
	Элементы.Комментарии.Обновить();
	НовыйКомментарий = "";
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКомментарийНаСервере()
	НоваяСтрока = Справочники.Комментарии.СоздатьЭлемент();
	НоваяСтрока.ВладелецКомментария = Объект.Ссылка;
	НоваяСтрока.Дата = ТекущаяДата();
	НоваяСтрока.Автор = ТекущийПользователь;
	НоваяСтрока.ЛинияПоддержки = ЛинияПоддержки;
	НоваяСтрока.Комментарий = НовыйКомментарий;
	НоваяСтрока.ВнутренняяПереписка = ВнутренняяПереписка;
	НоваяСтрока.Записать();
КонецПроцедуры


&НаКлиенте
Процедура ПринятьВРаботу(Команда)
	
	Если Объект.Ответственный = ТекущийПользователь Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Пожелание уже принято в работу.'"); ;
		Сообщение.Сообщить(); 
		Возврат;
	КонецЕсли; 
	
	Результат = ПринятьВРаботуНаСервере();
	Если Результат = Истина Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеревестиНаЛинию(Команда)
	
	Если Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Результат = ПеревестиНаЛиниюНаСервере();
		Если Результат = Истина Тогда
			ОповеститьОбИзменении(Объект.Ссылка);
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура Перенаправить(Команда)
	
	Если Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СписокПожеланий = Новый Массив;
		СписокПожеланий.Добавить(Объект.Ссылка);
		Оповещение = Новый ОписаниеОповещения("ПеренаправитьЗавершение", ЭтотОбъект);
		ОбслуживаниеКлиент.ПеренаправитьОбъекты(СписокПожеланий, Тип("СправочникСсылка.Пожелания"), Оповещение);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренаправитьЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат <> Неопределено Тогда
		Если Результат.Ответственный <> ТекущийПользователь Тогда
			Закрыть();
		Иначе
			Прочитать();
			Элементы.Комментарии.Обновить();
		КонецЕсли;
		ОповеститьОбИзменении(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УказатьТрудозатраты(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УказатьТрудозатратыЗавершение", ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПоказатьВопрос(Оповещение, НСтр("ru='Данные еще не записаны.
			|Указать трудозатраты можно только после записи данных.
			|Данные будут записаны.'"), РежимДиалогаВопрос.ОКОтмена, 60, КодВозвратаДиалога.ОК,, КодВозвратаДиалога.Отмена);  
	Иначе
	    ВыполнитьОбработкуОповещения(Оповещение, КодВозвратаДиалога.ОК);
	КонецЕсли; 
		
КонецПроцедуры

&НаКлиенте
Процедура УказатьТрудозатратыЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Отказ = Истина;
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Отказ = Не Записать();
		Иначе
			Отказ = Ложь;
		КонецЕсли; 
	КонецЕсли;
			
	Если Не Отказ Тогда
		УчетВремениКлиент.ДобавитьВОтчетКлиент(ТекущаяДата(), Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйСтрокойНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокВыбора = Новый СписокЗначений;
	Если ЗначениеЗаполнено(Объект.ОбслуживающаяОрганизация) Тогда
		СписокВыбора.Добавить(Объект.ОбслуживающаяОрганизация);
	КонецЕсли; 
	Если ЗначениеЗаполнено(Объект.ЛинияПоддержки) Тогда
		СписокВыбора.Добавить(Объект.ЛинияПоддержки);
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.Ответственный) И Объект.Ответственный <> Объект.ЛинияПоддержки Тогда
		СписокВыбора.Добавить(Объект.Ответственный);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ОтветственныйСтрокойНажатиеЗавершение", ЭтотОбъект);
	
	ПоказатьВыборИзМеню(Оповещение, СписокВыбора, Элементы.ГруппаОтветственный);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеЗаписиЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПереведеноОбращений = ПеревестиОбращенияПоПожеланиюНаПервуюЛинию();
		
		Если ПереведеноОбращений > 0  Тогда
			
			ПрописьЧисла     = ЧислоПрописью(ПереведеноОбращений, "Л = ru_RU", НСтр("ru = ',,,,,,,,0'"));
			ПрописьЧислаИСлова = ЧислоПрописью(ПереведеноОбращений, "Л = ru_RU", НСтр("ru = 'обращение, обращения, обращений,,,,,,0'"));
			ЧислоИСлово = СтрЗаменить(ПрописьЧислаИСлова, ПрописьЧисла, Формат(ПереведеноОбращений, "ЧГ=") + " ");
			
			ПоказатьОповещениеПользователя(СтрШаблон(НСтр("ru='На первую линию переведено %1.'"), ЧислоИСлово)); 
			
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВставитьКартинкуИзБуфераНаСервере(АдресКартинки)
	
    БазаЗнаний.ВставитьКартинкуИзБуфера(ЭтотОбъект, АдресКартинки, "Описание");
	
КонецПроцедуры
 
&НаКлиенте
Процедура ПриИзмененииСервиса()
	
	ПараметрыДляВыбора = Новый Массив();
	ПараметрыДляВыбора.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СервисСписок.ВыгрузитьЗначения()));
	Элементы.КомпонентСписок.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыДляВыбора);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТабличныеЧастиПоСпискам(ТекущийОбъект)
	
    БазаЗнаний.ЗаполнитьТабличныеЧастиПоСпискам(ТекущийОбъект, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиПоТабличнымЧастям(ТекущийОбъект)
	
    БазаЗнаний.ЗаполнитьСпискиПоТабличнымЧастям(ЭтаФорма, ТекущийОбъект) 
	
КонецПроцедуры

&НаКлиенте
Процедура СервисСписокНачалоВыбораЗавершение(Результат, ПараметрыДляВыбора) Экспорт
	
	Если Результат <> Неопределено Тогда
		СервисСписок.ЗагрузитьЗначения(Результат);
	КонецЕсли;
	
	ПриИзмененииСервиса();
	
КонецПроцедуры

&НаКлиенте
Процедура ВитринаСписокНачалоВыбораЗавершение(Результат, ПараметрыДляВыбора) Экспорт
	
	Если Результат <> Неопределено Тогда
		ВитринаСписок.ЗагрузитьЗначения(Результат);
        ВитринаСписокПриИзмененииНаСервере()
    КонецЕсли;
    
    Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РазделСписокНачалоВыбораЗавершение(Результат, ПараметрыДляВыбора) Экспорт
	
	Если Результат <> Неопределено Тогда
		РазделСписок.ЗагрузитьЗначения(Результат);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КомпонентСписокНачалоВыбораЗавершение(Результат, ПараметрыДляВыбора) Экспорт
	
	Если Результат <> Неопределено Тогда
		КомпонентСписок.ЗагрузитьЗначения(Результат);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СервисНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеПодбора = СервисСписок.ВыгрузитьЗначения();
	
	Оповещение = Новый ОписаниеОповещения("СервисСписокНачалоВыбораЗавершение", ЭтотОбъект);
	ПараметрыФормы = Новый Структура("ДанныеПодбора", ДанныеПодбора);
	 
	ОткрытьФорму("Справочник.Сервисы.Форма.ФормаПодбора", ПараметрыФормы, Элементы.РазделСписок, УникальныйИдентификатор,,, Оповещение);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ЗаполнитьСпискиПоТабличнымЧастям(Объект);
	
	РедактируемыйОбъект = РеквизитФормыВЗначение("Объект");
	
	Если Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ОбщегоНазначенияУСП.УстановитьФорматированноеОписаниеИзХранилища(Описание, Параметры.ЗначениеКопирования.ОписаниеХранилище);
	ИначеЕсли ЗначениеЗаполнено(Объект.Ссылка) Тогда
    	ОбщегоНазначенияУСП.УстановитьФорматированноеОписаниеИзХранилища(Описание, РедактируемыйОбъект.ОписаниеХранилище);
	КонецЕсли; 
    
КонецПроцедуры

&НаСервере
Функция ПеревестиОбращенияПоПожеланиюНаПервуюЛинию()
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Обращение.Ссылка КАК Обращение,
		|	Обращение.ОбслуживающаяОрганизация.ПерваяЛинияПоддержки Как ПерваяЛиния
		|ИЗ
		|	Документ.Обращение КАК Обращение
		|ГДЕ
		|	Обращение.КарточкаБазыЗнаний = &Объект
		|	И Обращение.Исполнитель <> Обращение.ОбслуживающаяОрганизация.ПерваяЛинияПоддержки";
	
	Запрос.УстановитьПараметр("Объект", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	СведенияОПользователе = РегистрыСведений.СведенияОПользователях.СведенияОПользователе(ТекущийПользователь);
	ЛинияПоддержки = СведенияОПользователе.ЛинияПоддержки;
	
	ПереведеноОбращений = 0;
	
	Пока Выборка.Следующий() Цикл
		
		ОбращениеОбъект = Выборка.Обращение.ПолучитьОбъект();
		ОбращениеОбъект.Исполнитель = Выборка.ПерваяЛиния;
		
		КомментарийОбращения = Справочники.Комментарии.СоздатьЭлемент();
		КомментарийОбращения.ВладелецКомментария = Выборка.Обращение;
		КомментарийОбращения.Дата = ТекущаяДатаСеанса();
		КомментарийОбращения.Автор = ТекущийПользователь;
		КомментарийОбращения.Комментарий = НСтр("ru='Пожелание реализовано'"); 
		КомментарийОбращения.ЛинияПоддержки = ЛинияПоддержки;
		КомментарийОбращения.Записать();
		
		ОбращениеОбъект.Записать();
		
		ПереведеноОбращений = ПереведеноОбращений + 1;
		
	КонецЦикла;
	
	Возврат ПереведеноОбращений;
	
КонецФункции

&НаСервере 
Процедура ЗаполнитьЗначенияСостояний()
	
	СостояниеЗапланировано = Перечисления.СостоянияПожеланий.Запланировано;
	СостояниеОтклонено = Перечисления.СостоянияПожеланий.Отклонено;
	СостояниеРассматривается = Перечисления.СостоянияПожеланий.Рассматривается;
	СостояниеРеализовано = Перечисления.СостоянияПожеланий.Реализовано;
	
КонецПроцедуры

&НаСервере
Функция ПринятьВРаботуНаСервере()
	
	Возврат БазаЗнаний.ПринятьВРаботу(ЭтотОбъект);
	
КонецФункции

Функция ПеревестиНаЛиниюНаСервере()
	
	Возврат БазаЗнаний.ПеревестиНаЛинию(ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Процедура ОтветственныйСтрокойНажатиеЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат <> Неопределено Тогда
		ПоказатьЗначение(, Результат.Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоказатели(СсылкаНаОбъект)
	
	Запрос = Новый Запрос;
    
    Запрос.Текст = 
    	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
        |   СУММА(ВЫБОР
        |           КОГДА ЗначенияПоказателей.Показатель = &КоличествоКомментариев
        |               ТОГДА ЗначенияПоказателей.ЗначениеОборот
        |           ИНАЧЕ 0
        |       КОНЕЦ) КАК КоличествоКомментариев,
        |   СУММА(ВЫБОР
        |           КОГДА ЗначенияПоказателей.Показатель = &СуммаГолосов
        |               ТОГДА ЗначенияПоказателей.ЗначениеОборот
        |           ИНАЧЕ 0
        |       КОНЕЦ) КАК СуммаГолосов,
        |   СУММА(ВЫБОР
        |           КОГДА ЗначенияПоказателей.Показатель = &КоличествоОбращений
        |               ТОГДА ЗначенияПоказателей.ЗначениеОборот
        |           ИНАЧЕ 0
        |       КОНЕЦ) КАК КоличествоОбращений
        |ИЗ
        |   РегистрНакопления.ЗначенияПоказателей.Обороты(, , , Объект = &Объект) КАК ЗначенияПоказателей";
    
    Запрос.УстановитьПараметр("Объект", СсылкаНаОбъект);
    Запрос.УстановитьПараметр("КоличествоКомментариев", Перечисления.ПоказателиКарточек.КоличествоКомментариев);
    Запрос.УстановитьПараметр("СуммаГолосов", Перечисления.ПоказателиКарточек.СуммаГолосов);
    Запрос.УстановитьПараметр("КоличествоОбращений", Перечисления.ПоказателиКарточек.КоличествоОбращений);
    
    Результат = Запрос.Выполнить();
    Выборка = Результат.Выбрать();
    
    Если Выборка.Следующий() Тогда
        КоличествоКомментариев = Выборка.КоличествоКомментариев;
        СуммаГолосов = Выборка.СуммаГолосов;
        КоличествоОбращений = Выборка.КоличествоОбращений;
    КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
    
    ЗаполнитьПоказатели(ТекущийОбъект.Ссылка);
    
КонецПроцедуры

&НаСервере
Процедура ВитринаСписокПриИзмененииНаСервере()
    
    Запрос = Новый Запрос;
    Запрос.Текст = 
    	"ВЫБРАТЬ РАЗЛИЧНЫЕ
        |	Витрины.Владелец КАК Сервис
        |ИЗ
        |	Справочник.Витрины КАК Витрины
        |ГДЕ
        |	Витрины.Ссылка В (&Витрины)";
    
    Запрос.УстановитьПараметр("Витрины", ВитринаСписок.ВыгрузитьЗначения());
    
    Результат = Запрос.Выполнить();
    СервисСписок.ЗагрузитьЗначения(Результат.Выгрузить().ВыгрузитьКолонку("Сервис"));
    
КонецПроцедуры

#КонецОбласти 

