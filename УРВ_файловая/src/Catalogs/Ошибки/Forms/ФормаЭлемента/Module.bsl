
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
    
    Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
        Воспроизведение.УстановитьФорматированнуюСтроку(Новый ФорматированнаяСтрока(" "));
        ОбходнойПуть.УстановитьФорматированнуюСтроку(Новый ФорматированнаяСтрока(" "));
        Решение.УстановитьФорматированнуюСтроку(Новый ФорматированнаяСтрока(" "));
    КонецЕсли;
	
    ЗаполнитьЗначенияСостояний();
    ЗаполнитьШаблоныДляАвтоЗапуска();
    ЗаполнитьПоказатели();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьТабличныеЧастиПоСпискам(ТекущийОбъект);
	
	ОбщегоНазначенияУСП.ПоместитьФорматированноеОписаниеВХранилище(Описание, ТекущийОбъект.ОписаниеХранилище);
	ТекущийОбъект.Описание = Описание.ПолучитьТекст();
	ОбщегоНазначенияУСП.ПоместитьФорматированноеОписаниеВХранилище(Воспроизведение, ТекущийОбъект.ВоспроизведениеХранилище);
	ТекущийОбъект.Воспроизведение = Воспроизведение.ПолучитьТекст();
	ОбщегоНазначенияУСП.ПоместитьФорматированноеОписаниеВХранилище(ОбходнойПуть, ТекущийОбъект.ОбходнойПутьХранилище);
	ТекущийОбъект.ОбходнойПуть = ОбходнойПуть.ПолучитьТекст();
	ОбщегоНазначенияУСП.ПоместитьФорматированноеОписаниеВХранилище(Решение, ТекущийОбъект.РешениеХранилище);
	ТекущийОбъект.Решение = Решение.ПолучитьТекст();
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ОбращениеОснование", ОбращениеОснование);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Обращение.Ссылка) КАК КоличествоОбращенийДляОбработки
			|ИЗ
			|	Документ.Обращение КАК Обращение
			|ГДЕ
			|	Обращение.КарточкаБазыЗнаний = &Ошибка
			|	И Обращение.Исполнитель <> Обращение.ОбслуживающаяОрганизация.ПерваяЛинияПоддержки";
		
		Запрос.УстановитьПараметр("Ошибка",Объект.Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			КоличествоОбращенийДляОбработки = Выборка.КоличествоОбращенийДляОбработки;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("КарточкаБазыЗнаний_Запись", Объект.Ссылка, ЭтаФорма);
    ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Комментарии, "Владелец", Объект.Ссылка);
    Если КоличествоОбращенийДляОбработки = 0 Тогда
		Отказ = Ложь;
		Если (ИсходноеСостояние = СостояниеЗапланирована И Объект.Состояние = СостояниеРасследование) 
			Или ((ИсходноеСостояние = СостояниеЗапланирована Или ИсходноеСостояние = СостояниеРасследование) И Объект.Состояние = СостояниеНаИсправлении) Тогда
			ИнтерактивныйЗапускБизнесПроцессовКлиент.ВыполнитьИнтерактивныйЗапускБизнесПроцесса(
				ШаблоныДляАвтоЗапускаПринятиеОшибкиКИсполнению, 
				Объект.Ссылка, 
				"ПринятиеОшибкиКИсполнению",
				ЭтаФорма,
				Отказ,
				Ложь);
		ИначеЕсли (ИсходноеСостояние = СостояниеРасследование Или ИсходноеСостояние = СостояниеНаИсправлении) И Объект.Состояние = СостояниеИсправлена Тогда
			ИнтерактивныйЗапускБизнесПроцессовКлиент.ВыполнитьИнтерактивныйЗапускБизнесПроцесса(
				ШаблоныДляАвтоЗапускаЗакрытиеОшибки, 
				Объект.Ссылка, 
				"ЗакрытиеОшибки",
				ЭтаФорма,
				Отказ,
				Ложь);
		КонецЕсли;
		ИсходноеСостояние = Объект.Состояние;
		Возврат;
	КонецЕсли;
	
	Если ИсходноеСостояние <> СостояниеИсправлена И Объект.Состояние = СостояниеИсправлена Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеЗаписиЗавершение", ЭтотОбъект);
        ПараметрыФормы = Новый Структура("КоличествоОбращенийДляОбработки", КоличествоОбращенийДляОбработки);
        ОткрытьФорму("Справочник.Ошибки.Форма.ПомощникЗакрытияОшибки", ПараметрыФормы, ЭтаФорма,,,, Оповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗавершениеРаботы И ТолькоЧтоСозданнаяКарточка И БылПоказанДиалогИнтерактивногоЗапускаПроцесса <> Истина Тогда
		ИнтерактивныйЗапускБизнесПроцессовКлиент.ВыполнитьИнтерактивныйЗапускБизнесПроцесса(
			ШаблоныДляАвтоЗапускаЗакрытиеКарточки, 
			Объект.Ссылка, 
			"ЗакрытиеКарточки",
			ЭтаФорма,
			Отказ,
			Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОписаниеПриИзменении(Элемент)
	
	Объект.ОписаниеДатаИзменения = ТекущаяДата();
	Объект.ОписаниеАвторИзменения = ТекущийПользователь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВоспроизведениеПриИзменении(Элемент)
	
	Объект.ВоспроизведениеДатаИзменения = ТекущаяДата();
	Объект.ВоспроизведениеАвторИзменения = ТекущийПользователь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбходнойПутьПриИзменении(Элемент)
	
	Объект.ОбходнойПутьДатаИзменения = ТекущаяДата();
	Объект.ОбходнойПутьАвторИзменения = ТекущийПользователь;
	
КонецПроцедуры

&НаКлиенте
Процедура РешениеПриИзменении(Элемент)
	
	Объект.РешениеДатаИзменения = ТекущаяДата();
	Объект.РешениеАвторИзменения = ТекущийПользователь;
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеПриИзменении(Элемент)
	
	Отказ = Не Записать();
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СервисСписокПриИзменении(Элемент)
	
	ПриИзмененииСервиса();
	
КонецПроцедуры

&НаКлиенте
Процедура СервисСписокНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеПодбора = СервисСписок.ВыгрузитьЗначения();
	
	Оповещение = Новый ОписаниеОповещения("СервисСписокНачалоВыбораЗавершение", ЭтотОбъект);
	ПараметрыФормы = Новый Структура("ДанныеПодбора", ДанныеПодбора);
	 
	ОткрытьФорму("Справочник.Сервисы.Форма.ФормаПодбора", ПараметрыФормы, Элементы.РазделСписок, УникальныйИдентификатор,,, Оповещение);
	
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
Процедура ОписаниеВставитьКартинкуИзБуфера(Команда)
	
	ВставитьКартинкуИзБуфераВРаздел("Описание");
	
КонецПроцедуры

&НаКлиенте
Процедура РешениеВставитьКартинкуИзБуфера(Команда)
	
	ВставитьКартинкуИзБуфераВРаздел("Решение");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбходнойПутьВставитьКартинкуИзБуфера(Команда)
	
	ВставитьКартинкуИзБуфераВРаздел("ОбходнойПуть");
	
КонецПроцедуры

&НаКлиенте
Процедура ВоспроизведениеВставитьКартинкуИзБуфера(Команда)
	
	ВставитьКартинкуИзБуфераВРаздел("Воспроизведение");
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКомментарий(Команда)
	
	Если ПустаяСтрока(СокрЛП(НовыйКомментарий)) Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Оповещение = Новый ОписаниеОповещения("ДобавитьКомментарийПродолжение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Ошибка не записана. Комментарии можно писать только для записанных ошибок. Записать ошибку?'"), 
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
		Сообщение.Текст = НСтр("ru='Ошибка уже принята в работу.'"); ;
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
		СписокОшибок = Новый Массив;
		СписокОшибок.Добавить(Объект.Ссылка);
		Оповещение = Новый ОписаниеОповещения("ПеренаправитьЗавершение", ЭтотОбъект);
		ОбслуживаниеКлиент.ПеренаправитьОбъекты(СписокОшибок, Тип("СправочникСсылка.Ошибки"), Оповещение);
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
	Если ЗначениеЗаполнено(Объект.Ответственный) Тогда
		СписокВыбора.Добавить(Объект.Ответственный);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ОтветственныйСтрокойНажатиеЗавершение", ЭтотОбъект);
	
	ПоказатьВыборИзМеню(Оповещение, СписокВыбора, Элементы.ГруппаОтветственный);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеЗаписиЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОбработаноОбращений = ОбработатьОбращения(Результат);
		Если ОбработаноОбращений > 0  Тогда
			ЧислоИСлово = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(
                ОбработаноОбращений, НСтр("ru = 'обращение, обращения, обращений,,,,,,0'"));
			ПоказатьОповещениеПользователя(СтрШаблон(НСтр("ru='Обработано %1.'"), ЧислоИСлово)); 
		КонецЕсли; 
	КонецЕсли;
	
	Отказ = Ложь;
	
	Если (ИсходноеСостояние = СостояниеЗапланирована И Объект.Состояние = СостояниеРасследование) 
		Или ((ИсходноеСостояние = СостояниеЗапланирована Или ИсходноеСостояние = СостояниеРасследование) И Объект.Состояние = СостояниеНаИсправлении) Тогда
		ИнтерактивныйЗапускБизнесПроцессовКлиент.ВыполнитьИнтерактивныйЗапускБизнесПроцесса(
			ШаблоныДляАвтоЗапускаПринятиеОшибкиКИсполнению, 
			Объект.Ссылка, 
			"ПринятиеОшибкиКИсполнению",
			ЭтаФорма,
			Отказ,
			Ложь);
	ИначеЕсли (ИсходноеСостояние = СостояниеРасследование Или ИсходноеСостояние = СостояниеНаИсправлении) И Объект.Состояние = СостояниеИсправлена Тогда
		ИнтерактивныйЗапускБизнесПроцессовКлиент.ВыполнитьИнтерактивныйЗапускБизнесПроцесса(
			ШаблоныДляАвтоЗапускаЗакрытиеОшибки, 
			Объект.Ссылка, 
			"ЗакрытиеОшибки",
			ЭтаФорма,
			Отказ,
			Ложь);
	КонецЕсли;
		
	ИсходноеСостояние = Объект.Состояние;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКартинкуИзБуфераВРаздел(ИмяРеквизитаРаздела)
	
	КомпонентаУстановлена = РаботаСКартинкамиКлиент.ПроинициализироватьКомпоненту();
	Если Не КомпонентаУстановлена Тогда
		РаботаСКартинкамиКлиент.УстановитьКомпоненту();
	КонецЕсли;
	
	ПутьКФайлу = КомпонентаПолученияКартинкиИзБуфера.ПолучитьКартинкуИзБуфера();
	
	Если Не ПустаяСтрока(ПутьКФайлу) Тогда
		Картинка = Новый Картинка(ПутьКФайлу);
		АдресКартинки = ПоместитьВоВременноеХранилище(Картинка, АдресКартинки);
		ВставитьКартинкуИзБуфераНаСервере(АдресКартинки, ИмяРеквизитаРаздела);
		Модифицированность = Истина;
	Иначе
		ПоказатьПредупреждение(,НСтр("ru = 'Буфер обмена не содержит картинки'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВставитьКартинкуИзБуфераНаСервере(АдресКартинки, ИмяРеквизитаРаздела)
    
    БазаЗнаний.ВставитьКартинкуИзБуфера(ЭтотОбъект, АдресКартинки, ИмяРеквизитаРаздела);
	
КонецПроцедуры
 
&НаСервере
Процедура ЗаполнитьТабличныеЧастиПоСпискам(ТекущийОбъект)
	
    БазаЗнаний.ЗаполнитьТабличныеЧастиПоСпискам(ТекущийОбъект, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиПоТабличнымЧастям(ТекущийОбъект)
	
    БазаЗнаний.ЗаполнитьСпискиПоТабличнымЧастям(ЭтаФорма, ТекущийОбъект) 
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьШаблоныДляАвтоЗапуска()
	
	ШаблоныДляАвтоЗапускаЗакрытиеКарточки = ИнтерактивныйЗапускБизнесПроцессов.ПолучитьШаблоныДляАвтоЗапуска(
		Перечисления.ВидыИнтерактивныхДействий.ЗакрытиеКарточкиТолькоЧтоСозданнойОшибки, Объект.Ссылка);
		
	ШаблоныДляАвтоЗапускаПринятиеОшибкиКИсполнению = ИнтерактивныйЗапускБизнесПроцессов.ПолучитьШаблоныДляАвтоЗапуска(
		Перечисления.ВидыИнтерактивныхДействий.ИнтерактивноеПринятиеОшибкиКИсполнению, Объект.Ссылка);
		
	ШаблоныДляАвтоЗапускаЗакрытиеОшибки = ИнтерактивныйЗапускБизнесПроцессов.ПолучитьШаблоныДляАвтоЗапуска(
		Перечисления.ВидыИнтерактивныхДействий.ИнтерактивноеЗакрытиеОшибки, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначенияСостояний()
	
	ИсходноеСостояние = Объект.Состояние;
	
	СостояниеЗапланирована = Перечисления.СостоянияОшибок.Запланирована;
	СостояниеРасследование = Перечисления.СостоянияОшибок.Расследование;
	СостояниеНаИсправлении = Перечисления.СостоянияОшибок.НаИсправлении;
	СостояниеИсправлена    = Перечисления.СостоянияОшибок.Исправлена;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСервиса()
	
	ПараметрыДляВыбора = Новый Массив();
	ПараметрыДляВыбора.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СервисСписок.ВыгрузитьЗначения()));
	Элементы.КомпонентСписок.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыДляВыбора);
	
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

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ЗаполнитьСпискиПоТабличнымЧастям(Объект);
	
	РедактируемыйОбъект = РеквизитФормыВЗначение("Объект");
	
	Если Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ОбщегоНазначенияУСП.УстановитьФорматированноеОписаниеИзХранилища(Описание, Параметры.ЗначениеКопирования.ОписаниеХранилище);
		ОбщегоНазначенияУСП.УстановитьФорматированноеОписаниеИзХранилища(Воспроизведение, Параметры.ЗначениеКопирования.ВоспроизведениеХранилище);
		ОбщегоНазначенияУСП.УстановитьФорматированноеОписаниеИзХранилища(ОбходнойПуть, Параметры.ЗначениеКопирования.ОбходнойПутьХранилище);
		ОбщегоНазначенияУСП.УстановитьФорматированноеОписаниеИзХранилища(Решение, Параметры.ЗначениеКопирования.РешениеХранилище);
	ИначеЕсли ЗначениеЗаполнено(Объект.Ссылка) Тогда
        ОбщегоНазначенияУСП.УстановитьФорматированноеОписаниеИзХранилища(Описание, РедактируемыйОбъект.ОписаниеХранилище);
        ОбщегоНазначенияУСП.УстановитьФорматированноеОписаниеИзХранилища(Воспроизведение, РедактируемыйОбъект.ВоспроизведениеХранилище);
        ОбщегоНазначенияУСП.УстановитьФорматированноеОписаниеИзХранилища(ОбходнойПуть, РедактируемыйОбъект.ОбходнойПутьХранилище);
        ОбщегоНазначенияУСП.УстановитьФорматированноеОписаниеИзХранилища(Решение, РедактируемыйОбъект.РешениеХранилище);
	КонецЕсли;
    
КонецПроцедуры

&НаСервере
Функция ОбработатьОбращения(ПараметрыОбработки)
    
    // ПараметрыОбработки - Структура - параметры обработки обращения:
    // * КомментарийЗакрытияОшибки - Строка - комментарий закрытия ошибки.
    // * ДобавитьКомментарийЗакрытияОшибки - Булево - признак добавления в обращения комментария закрытия ошибки.
    // * ПеревестиНаПервуюЛинию - Булево - признак перевода обращения на 1-ю линию.
    // * ЗакрытьОбращения - Булево - признак закрытия обращения.
    
    Запрос = Новый Запрос;
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Обращение.Ссылка КАК Обращение,
		|	Обращение.ОбслуживающаяОрганизация.ПерваяЛинияПоддержки Как ПерваяЛиния
		|ИЗ
		|	Документ.Обращение КАК Обращение
		|ГДЕ
		|	Обращение.КарточкаБазыЗнаний = &Ошибка
		|	И Обращение.Исполнитель <> Обращение.ОбслуживающаяОрганизация.ПерваяЛинияПоддержки";
	
	Запрос.УстановитьПараметр("Ошибка", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	СведенияОПользователе = РегистрыСведений.СведенияОПользователях.СведенияОПользователе(ТекущийПользователь);
	ЛинияПоддержки = СведенияОПользователе.ЛинияПоддержки;
	
	ОбработаноОбращений = 0;
	
	Пока Выборка.Следующий() Цикл
		
		ОбращениеОбъект = Выборка.Обращение.ПолучитьОбъект();
        Если ПараметрыОбработки.ДобавитьКомментарийЗакрытияОшибки Тогда
    		КомментарийОбращения = Справочники.Комментарии.СоздатьЭлемент();
			КомментарийОбращения.ВладелецКомментария = Выборка.Обращение;
    		КомментарийОбращения.Дата = ТекущаяДатаСеанса();
    		КомментарийОбращения.Автор = ТекущийПользователь;
    		КомментарийОбращения.Комментарий = ПараметрыОбработки.КомментарийЗакрытияОшибки; 
    		КомментарийОбращения.ЛинияПоддержки = ЛинияПоддержки;
			КомментарийОбращения.Записать();
        КонецЕсли; 
        Если ПараметрыОбработки.ПеревестиНаПервуюЛинию Тогда
    		ОбращениеОбъект.Исполнитель = Выборка.ПерваяЛиния;
        КонецЕсли; 
        Если ПараметрыОбработки.ЗакрытьОбращения Тогда
            ОбращениеОбъект.Состояние = Перечисления.СостоянияОбращений.Закрыто;
        КонецЕсли; 
		ОбращениеОбъект.Записать();
        
        ОбработаноОбращений = ОбработаноОбращений + 1;
		
	КонецЦикла;
	
	Возврат ОбработаноОбращений;
	
КонецФункции

&НаСервере
Функция ПринятьВРаботуНаСервере()
	
	Возврат БазаЗнаний.ПринятьВРаботу(ЭтотОбъект);
	
КонецФункции

&НаСервере
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

&НаСервере
Процедура ЗаполнитьПоказатели()
	
	Запрос = Новый Запрос;
    Запрос.Текст = 
    	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
        |   ЗначенияПоказателей.ЗначениеОборот КАК КоличествоОбращений
        |ИЗ
        |   РегистрНакопления.ЗначенияПоказателей.Обороты(
        |           ,
        |           ,
        |           ,
        |           Объект = &СсылкаНаОбъект
        |               И Показатель = &КоличествоОбращений) КАК ЗначенияПоказателей";
    
    Запрос.УстановитьПараметр("СсылкаНаОбъект", Объект.Ссылка);
    Запрос.УстановитьПараметр("КоличествоОбращений", Перечисления.ПоказателиКарточек.КоличествоОбращений);
    
    Результат = Запрос.Выполнить();
    Выборка = Результат.Выбрать();
    
    Если Выборка.Следующий() Тогда
        КоличествоОбращений = Выборка.КоличествоОбращений;
    КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

