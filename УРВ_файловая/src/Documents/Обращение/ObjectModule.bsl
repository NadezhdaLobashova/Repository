#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;  
    КонецЕсли;
    
    ДатаИзменения = ТекущаяУниверсальнаяДата();
	
	Если НЕ ЭтоНовый() Тогда
		ИсходныеРеквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, 
			"Описание, Тема, ПометкаУдаления,ОбслуживающаяОрганизация, ЛинияПоддержки, 
			|Исполнитель, Состояние, Сервис, Компонент, Раздел, КарточкаБазыЗнаний, ПодпискаНаТариф, Инициатор, КаналПолучения");
	Иначе 
		ИсходныеРеквизиты = Новый Структура;
		ИсходныеРеквизиты.Вставить("Описание", "");
		ИсходныеРеквизиты.Вставить("Тема", "");
		ИсходныеРеквизиты.Вставить("ПометкаУдаления", Ложь);
		ИсходныеРеквизиты.Вставить("ОбслуживающаяОрганизация", Справочники.ОбслуживающиеОрганизации.ПустаяСсылка());
		ИсходныеРеквизиты.Вставить("ЛинияПоддержки", Справочники.ЛинииПоддержки.ПустаяСсылка());
		ИсходныеРеквизиты.Вставить("Исполнитель", Неопределено);
		ИсходныеРеквизиты.Вставить("Состояние", Перечисления.СостоянияОбращений.ПустаяСсылка());
		ИсходныеРеквизиты.Вставить("Сервис", Справочники.Сервисы.ПустаяСсылка());
		ИсходныеРеквизиты.Вставить("Компонент", Справочники.КомпонентыСервиса.ПустаяСсылка()); 
		ИсходныеРеквизиты.Вставить("Раздел", Справочники.Разделы.ПустаяСсылка());
		ИсходныеРеквизиты.Вставить("КарточкаБазыЗнаний", Неопределено);
		ИсходныеРеквизиты.Вставить("ПодпискаНаТариф", Документы.Подписка.ПустаяСсылка());
        ИсходныеРеквизиты.Вставить("Инициатор", Справочники.ПользователиСервисов.ПустаяСсылка());
	    ИсходныеРеквизиты.Вставить("КаналПолучения", Справочники.КаналыПолученияОбращений.ПустаяСсылка());
		
	КонецЕсли;
	
	// Установим дополнительные свойства. Они понадобятся нам при записи документа.
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("ДатаЗаписи", ТекущаяУниверсальнаяДата());
	ДополнительныеСвойства.Вставить("ИсходнаяПометкаУдаления", ИсходныеРеквизиты.ПометкаУдаления);
	ДополнительныеСвойства.Вставить("ИсходнаяТема", ИсходныеРеквизиты.Тема);
	ДополнительныеСвойства.Вставить("ИсходноеОписание", ИсходныеРеквизиты.Описание);
	ДополнительныеСвойства.Вставить("ИсходныйСервис", ИсходныеРеквизиты.Сервис);
	ДополнительныеСвойства.Вставить("ИсходныйКомпонент", ИсходныеРеквизиты.Компонент);
	ДополнительныеСвойства.Вставить("ИсходныйРаздел", ИсходныеРеквизиты.Раздел);
	ДополнительныеСвойства.Вставить("ИсходнаяЛинияПоддержки", ИсходныеРеквизиты.ЛинияПоддержки);
	ДополнительныеСвойства.Вставить("ИсходныйИсполнитель", ИсходныеРеквизиты.Исполнитель);
	ДополнительныеСвойства.Вставить("ИсходнаяОрганизация", ИсходныеРеквизиты.ОбслуживающаяОрганизация);
	ДополнительныеСвойства.Вставить("ИсходноеСостояние", ИсходныеРеквизиты.Состояние);
	ДополнительныеСвойства.Вставить("ИсходнаяКарточкаБазыЗнаний", ИсходныеРеквизиты.КарточкаБазыЗнаний);
	ДополнительныеСвойства.Вставить("ИсходнаяПодпискаНаТариф", ИсходныеРеквизиты.ПодпискаНаТариф);
	ДополнительныеСвойства.Вставить("ИзменилисьРеквизитыАдресации", Ложь);
    ДополнительныеСвойства.Вставить("ИсходныйИнициатор", ИсходныеРеквизиты.Инициатор);
    ДополнительныеСвойства.Вставить("ИсходныйКаналПолучения", ИсходныеРеквизиты.КаналПолучения);
	
	//{Рарус kruser 22.05.2019 86182
	Если ВнутреннееОбращение Тогда
		ДополнительныеСвойства.Вставить("ИсходныйВнешниеОбращения", ПолучитьИсходныеВнешниеОбращения(Ссылка));	
	КонецЕсли;
	//}Рарус kruser 22.05.2019 86182

    Если Не ДополнительныеСвойства.Свойство("КорректировкаДвижений") Тогда
        ДополнительныеСвойства.Вставить("КорректировкаДвижений", Ложь);
    КонецЕсли; 
	
	Если Не ЭтоНовый() Тогда
		
		ДополнительныеСвойства.ИзменилисьРеквизитыАдресации = 
            (ИсходныеРеквизиты.ОбслуживающаяОрганизация <> ОбслуживающаяОрганизация
		     Или ИсходныеРеквизиты.Исполнитель <> Исполнитель);

        Если ИсходныеРеквизиты.Сервис <> Сервис И ЗначениеЗаполнено(Номер) Тогда
			УстановитьНовыйНомер();
		КонецЕсли;
		Если ИсходныеРеквизиты.ПометкаУдаления И Не ПометкаУдаления Тогда
			РежимЗаписи = РежимЗаписиДокумента.Проведение;
		КонецЕсли;
		
		Если ИсходныеРеквизиты.ПометкаУдаления <> ПометкаУдаления Тогда
			ОбработатьПометкуУдаленияВзаимодействий(ПометкаУдаления);
		КонецЕсли;
				
	КонецЕсли;
	
    Если Состояние = Перечисления.СостоянияОбращений.Закрыто И ИсходныеРеквизиты.Состояние <> Состояние Тогда
        // Ожидание оценки устанавливается в момент закрытия обращения.
        ОжиданиеОценки = Истина;
    КонецЕсли;
    
	Если ЗначениеЗаполнено(КарточкаБазыЗнаний) И ДополнительныеСвойства.ИсходнаяКарточкаБазыЗнаний <> КарточкаБазыЗнаний Тогда
		КтоПрикрепилКарточку = Пользователи.АвторизованныйПользователь();
	ИначеЕсли Не ЗначениеЗаполнено(КарточкаБазыЗнаний) Тогда
		КтоПрикрепилКарточку = Неопределено;
	КонецЕсли;
    
	Если ИсходныеРеквизиты.Состояние <> Перечисления.СостоянияОбращений.Закрыто И Состояние = Перечисления.СостоянияОбращений.Закрыто Тогда
		ДатаЗакрытия = ТекущаяУниверсальнаяДата();
	ИначеЕсли ИсходныеРеквизиты.Состояние = Перечисления.СостоянияОбращений.Закрыто И Состояние <> Перечисления.СостоянияОбращений.Закрыто Тогда
		ДатаЗакрытия = '00010101';
	КонецЕсли;
    
    // Установка значений по умолчанию, если объект заполнен частично.
    // Создание взаимодействия выполняется из нескольких источников:
    //   1. Вручную
    //   2. При получении нового письма, по которому еще нет обращения
    //   3. При получении комментария через API InformationCenterIntegration
    // При любом варианте обращение должно корректно заполняться, если где то обращение заполняется некорректно,
    // эта процедура призвана исправить некорректное заполнение и дозаполнить, что не заполнено.
    УстановитьЗначенияРеквизитовПоУмолчанию();
    
	НомерСокращенный = ПрефиксацияОбъектов.УдалитьЛидирующиеНулиИзНомераОбъекта(Номер);
    
    // Установка текста описания для полнотекстового поиска
	ЗначениеОписания = ОписаниеХранилище.Получить();
	Если ТипЗнч(ЗначениеОписания) = Тип("ФорматированныйДокумент") Тогда 
		Описание = ЗначениеОписания.ПолучитьТекст();
    КонецЕсли;
    
    Если Не ЗначениеЗаполнено(КарточкаБазыЗнаний) Тогда
        КарточкаБазыЗнаний = Неопределено;
    КонецЕсли; 
	
    Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВитринСервисов") И Не ЗначениеЗаполнено(Витрина) Тогда
        Витрина = БазаЗнанийПовтИсп.ОсновнаяВитринаСервиса(Сервис);
    КонецЕсли; 
	
	//{Рарус kruser 22.05.2019 86182
	УстановитьСвязиВнешнихОбращений();
	//}Рарус kruser 22.05.2019 86182

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПериодЗаписи = ДополнительныеСвойства.ДатаЗаписи;
    
    ОбращениеПереоткрыто = ДополнительныеСвойства.ИсходноеСостояние = Перечисления.СостоянияОбращений.Закрыто 
							И Состояние <> Перечисления.СостоянияОбращений.Закрыто;
	
    ИзменилсяИсполнитель = (ДополнительныеСвойства.ИсходнаяЛинияПоддержки <> ЛинияПоддержки
		                    Или ДополнительныеСвойства.ИсходныйИсполнитель <> Исполнитель
		                    Или ДополнительныеСвойства.ИсходнаяОрганизация <> ОбслуживающаяОрганизация);
    
     //+ Котова А.Ю. 12.12.2018 ТЗ№ 77274 {
	Если ОбращениеПереоткрыто Тогда
		Если НЕ ЗначениеЗаполнено(Исполнитель) Тогда
			  Исполнитель = ДополнительныеСвойства.ИсходныйИсполнитель;
		КонецЕсли;
	КонецЕсли;
	//- Котова А.Ю. 12.12.2018 ТЗ№ 77274 }
	
    РегистрыСведений.СостоянияОбращений.ДобавитьЗапись(Ссылка);
	РегистрыСведений.НаличиеОбновленийОбращений.ДобавитьЗапись(Ссылка, Ложь);
	
    Если ДополнительныеСвойства.ИсходноеСостояние <> Состояние Тогда
		
		РегистрыСведений.ИсторияСостоянийОбращений.ДобавитьЗапись(ДополнительныеСвойства.ДатаЗаписи, Ссылка, Состояние);
		Если Состояние = Перечисления.СостоянияОбращений.Закрыто Тогда
			Документы.Обращение.ОтправитьПисьмоОЗакрытииОбращения(Ссылка);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбращениеПереоткрыто Тогда
		ДополнительныеСвойства.Вставить("КомментарийПеренаправления", НСтр("ru='Возврат обращения в работу.'")); 
		ЗарегистрироватьПеренаправление();
	ИначеЕсли ДополнительныеСвойства.ИзменилисьРеквизитыАдресации Тогда 
		ЗарегистрироватьПеренаправление();
	КонецЕсли;
	
	ЗарегистрироватьБизнесСобытияПоОбращению();
	УстановитьПривилегированныйРежим(Истина);
    РегистрыСведений.ДвижениеОбращений.ДобавитьЗапись(ПериодЗаписи, ЭтотОбъект);
    
	Если ДополнительныеСвойства.ЭтоНовый Тогда
		
		РегистрыСведений.ДлительностьОбработкиОбращений.ДобавитьТочкуОтсчета(ПериодЗаписи, ЭтотОбъект);
		
	ИначеЕсли ИзменилсяИсполнитель Или ДополнительныеСвойства.ИсходноеСостояние <> Состояние
		Или ДополнительныеСвойства.ИсходнаяКарточкаБазыЗнаний <> КарточкаБазыЗнаний Тогда
		
		Если ОбращениеПереоткрыто И (ИзменилсяИсполнитель Или ДополнительныеСвойства.ИсходноеСостояние <> Состояние) Тогда
			РегистрыСведений.ДлительностьОбработкиОбращений.ДобавитьТочкуОтсчета(ПериодЗаписи, ЭтотОбъект);
		КонецЕсли;
		
		Если ДополнительныеСвойства.ИсходноеСостояние <> Перечисления.СостоянияОбращений.Закрыто Тогда
			РегистрыСведений.ДлительностьОбработкиОбращений.ВыполнитьРасчет(ПериодЗаписи - 1, Ссылка);
			Если (ИзменилсяИсполнитель Или ДополнительныеСвойства.ИсходноеСостояние <> Состояние)
				И Состояние <> Перечисления.СостоянияОбращений.Закрыто Тогда
				РегистрыСведений.ДлительностьОбработкиОбращений.ДобавитьТочкуОтсчета(ПериодЗаписи, ЭтотОбъект);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
    
    // Если обращение закрыто, нужно закрыть остатки и рассчитать длительность обработки до закрытия.
	Если ДополнительныеСвойства.ИсходноеСостояние <> Перечисления.СостоянияОбращений.Закрыто 
		И Состояние = Перечисления.СостоянияОбращений.Закрыто Тогда
		РегистрыСведений.ДлительностьОбработкиОбращений.ВыполнитьРасчет(ПериодЗаписи, Ссылка);
	КонецЕсли;
	
	// Добавим запись в регистр разрешений доступа к обращению
	Если ДополнительныеСвойства.ИсходнаяОрганизация <> ОбслуживающаяОрганизация Тогда
		РегистрыСведений.РазрешенияДоступаКОбращениям.ДобавитьЗапись(Ссылка, ОбслуживающаяОрганизация);
	КонецЕсли;
	
    // Установим сроки обращения принудительно, если выполнен перевод от Пользователя на Линию поддержки в рамках одной линии.
    Принудительно = (ДополнительныеСвойства.ИсходныйИсполнитель <> Исполнитель 
                     И ДополнительныеСвойства.ИсходнаяЛинияПоддержки = ЛинияПоддержки
                     И Исполнитель = ЛинияПоддержки);
                     
    ЭтоПереоткрытие = (ДополнительныеСвойства.ИсходноеСостояние = Перечисления.СостоянияОбращений.Закрыто И Состояние <> Перечисления.СостоянияОбращений.Закрыто);
    
    Если Не ДополнительныеСвойства.КорректировкаДвижений Тогда
	    Соглашения.УстановитьСрокОбращения(Ссылка, ДополнительныеСвойства.ДатаЗаписи, Принудительно, ЭтоПереоткрытие);
    КонецЕсли;
    
    Если Не ДополнительныеСвойства.ИсходнаяПометкаУдаления И ПометкаУдаления Тогда
        ЗаписьЖурналаРегистрации("Установлена пометка удаления обращения.", 
            УровеньЖурналаРегистрации.Информация, Метаданные.Документы.Обращение, Ссылка);
    КонецЕсли; 
	
	//{Рарус kruser 22.05.2019 86182
	УстановитьСвязиВнутреннихОбращений(ДополнительныеСвойства);
	//}Рарус kruser 22.05.2019 86182

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Дата = ТекущаяУниверсальнаяДата();
	НомерСокращенный = "";
	Исполнитель = Пользователи.АвторизованныйПользователь();
	
	СведенияПользователей = РегистрыСведений.СведенияОПользователях.Получить(Новый Структура("Пользователь", Исполнитель));
	ОбслуживающаяОрганизация = СведенияПользователей.ОбслуживающаяОрганизация;
	ЛинияПоддержки = СведенияПользователей.ЛинияПоддержки;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
        |   Обращение.Сервис,
        |   Обращение.Витрина
        |ИЗ
        |   Документ.Обращение КАК Обращение
        |ГДЕ
        |   НЕ Обращение.ПометкаУдаления
        |
        |УПОРЯДОЧИТЬ ПО
        |   Обращение.Дата УБЫВ";
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	КонецЕсли; 
	
	//{Рарус kruser 23.04.2019 84132
	//Сервис = Справочники.Сервисы.СервисПоУмолчанию(Сервис);	
	Если Не ДанныеЗаполнения = Неопределено И ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Обращение") Тогда
		
		Сервис = Справочники.Сервисы.СервисПоУмолчанию(Неопределено, Истина);
		
		//{Рарус kruser 08.05.2019 86181
		Проект 			= ДанныеЗаполнения.Проект;
		ЭтапПроекта 	= ДанныеЗаполнения.ЭтапПроекта;
		Абонент 		= ДанныеЗаполнения.Абонент;
		//}Рарус kruser 08.05.2019 86181
		
		ВнутреннееОбращение = Истина;
		НоваяСтрока = ВнешниеОбращения.Добавить();
		НоваяСтрока.Обращение = ДанныеЗаполнения; 
		
	Иначе 
		Сервис = Справочники.Сервисы.СервисПоУмолчанию(Неопределено);		
	КонецЕсли;
	//}Рарус kruser 23.04.2019 84132
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Ошибки = Неопределено;
	
    Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВитринСервисов") Тогда
        ПроверяемыеРеквизиты.Добавить("Витрина");
    КонецЕсли;
    
    ЗапрещеноИзменение = Не ЭтоНовый() И Не Пользователи.ЭтоПолноправныйПользователь()
	    И (ТипЗнч(Исполнитель) = Тип("СправочникСсылка.ЛинииПоддержки")  
        ИЛИ Пользователи.АвторизованныйПользователь() <> Исполнитель);
        
    Если ЗапрещеноИзменение Тогда
        КонтролируемыеСвойства = "НомерСокращенный, Дата, Сервис, Компонент, Раздел, Тема,
                                 |ТипОбращения, Состояние, Инициатор, КаналПолучения, КарточкаБазыЗнаний, 
                                 |Описание, Абонент, АбонентОбслуживающейОрганизации";
                                 
        ЗначенияКонтролируемыхСвойств = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, КонтролируемыеСвойства);
        Для каждого Свойство Из ЗначенияКонтролируемыхСвойств Цикл
            Если ЭтотОбъект[Свойство.Ключ] <> Свойство.Значение Тогда
                Если Свойство.Ключ = "КарточкаБазыЗнаний" И Не ЗначениеЗаполнено(Свойство.Значение) И Не ЗначениеЗаполнено(ЭтотОбъект[Свойство.Ключ]) Тогда
                    Продолжить;    
                КонецЕсли; 
                ОписаниеОшибки = НСтр("ru = 'Нельзя изменить обращение без принятия в работу.'");
        		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"Объект." + Свойство.Ключ, ОписаниеОшибки,
        			"Объект." + Свойство.Ключ,, ОписаниеОшибки);
	            ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
                Возврат;
            КонецЕсли;    
        КонецЦикла; 
    КонецЕсли;
    //Котова 72209 19.09.2018  +
	//Временная заглушка
	//Если Состояние = Перечисления.СостоянияОбращений.Закрыто 
	//	Или Состояние = Перечисления.СостоянияОбращений.Исправление Тогда
	Если Состояние = Перечисления.СостоянияОбращений.Исправление Тогда

	//Котова 72209 19.09.2018  -
		ПроверяемыеРеквизиты.Добавить("КарточкаБазыЗнаний");
	КонецЕсли; 
    
    ИсходныеРеквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Состояние, Исполнитель");
	ИсходноеСостояние = ИсходныеРеквизиты.Состояние;
	ИсходныйИсполнитель = ИсходныеРеквизиты.Исполнитель;

	Если ЗначениеЗаполнено(Состояние) И Состояние <> Перечисления.СостоянияОбращений.Новое 
	  И Состояние <> Перечисления.СостоянияОбращений.ОжиданиеИнициатора Тогда
		Если ИсходноеСостояние <> Перечисления.СостоянияОбращений.Новое Тогда
			Если УправлениеДоступомУСПВызовСервера.ДоступныПользователиСервиса() Тогда
				// Лобашова 09.11.2018 75506 временная заглушка проверки Реквизита "Инициатор" при записи
				//ПроверяемыеРеквизиты.Добавить("Инициатор");
			КонецЕсли;
			ПроверяемыеРеквизиты.Добавить("Тема");
		КонецЕсли;
		Если Не (ТипЗнч(ИсходныйИсполнитель) = Тип("СправочникСсылка.ЛинииПоддержки") И ТипЗнч(Исполнитель) = Тип("СправочникСсылка.Пользователи")) Тогда
			//Котова 72207,72208 19.09.2018  +
			//Временная заглушка
			// Лобашова №73325 03.10.2018  +
			//Если ЗначениеЗаполнено(Состояние) И Состояние <> Перечисления.СостоянияОбращений.Закрыто  Тогда
			//Котова 72207,72208 19.09.2018  -
			Если ЗначениеЗаполнено(Состояние) И Состояние <> Перечисления.СостоянияОбращений.Закрыто
				И Состояние <> Перечисления.СостоянияОбращений.Расследование Тогда 
				// Лобашова №73325 03.10.2018 -
				ПроверяемыеРеквизиты.Добавить("Компонент");
				ПроверяемыеРеквизиты.Добавить("Раздел");
			//Котова 72207,72208 19.09.2018  +
			КонецЕсли;
			//Котова 72207,72208 19.09.2018  -
	    КонецЕсли;
    КонецЕсли;
    
    // При закрытии обращения нужно проверять, что все взаимодействия по обращению рассмотрены.
    Если ПолучитьФункциональнуюОпцию("ИспользоватьПризнакРассмотрено") 
       И ИсходноеСостояние <> Перечисления.СостоянияОбращений.Закрыто 
       И Состояние = Перечисления.СостоянияОбращений.Закрыто Тогда
        НеРассмотрено = ВзаимодействияУСП.КоличествоНеРассмотренныхВзаимодействий(Ссылка);
        Если НеРассмотрено > 0 Тогда
            ОписаниеОшибки = СтрШаблон(НСтр("ru = 'По обращению есть не рассмотренные взаимодействия (%1).
            |Нельзя закрыть обращение с не рассмотренными взаимодействиями.'"), НеРассмотрено);
    		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"ВзаимодействияСписок", ОписаниеОшибки,
    			"Взаимодействия",, ОписаниеОшибки);
        КонецЕсли;
    КонецЕсли;    
	
	Если (Состояние = Перечисления.СостоянияОбращений.ОжиданиеИнициатора ИЛИ Состояние = Перечисления.СостоянияОбращений.Закрыто)
		И Исполнитель <> ИсходныйИсполнитель И Исполнитель <> ЛинияПоддержки И Исполнитель <> Пользователи.АвторизованныйПользователь() Тогда
        
        ОписаниеОшибки = СтрШаблон(НСтр("ru = 'Нельзя перенаправить обращение в статусе ""%1"".'"), Состояние);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"Объект.Состояние", ОписаниеОшибки,
			"Объект.Состояние",, ОписаниеОшибки);
    КонецЕсли;
        
    Если ЗначениеЗаполнено(КарточкаБазыЗнаний) Тогда
        ОписаниеОшибки = НСтр("ru='Тип карточки базы знаний ""%1"" не соответствует типу обращения ""%2""'"); 
        Если ТипЗнч(КарточкаБазыЗнаний) = Тип("СправочникСсылка.Консультации") И ТипОбращения <> Перечисления.ТипыОбращений.Консультация Тогда
    		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"Объект.КарточкаБазыЗнаний", 
                СтрШаблон(ОписаниеОшибки, "Консультация", ТипОбращения), "Объект.КарточкаБазыЗнаний",, ОписаниеОшибки);
        ИначеЕсли ТипЗнч(КарточкаБазыЗнаний) = Тип("СправочникСсылка.Ошибки") И ТипОбращения <> Перечисления.ТипыОбращений.Ошибка Тогда
    		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"Объект.КарточкаБазыЗнаний", 
                СтрШаблон(ОписаниеОшибки, "Ошибка", ТипОбращения), "Объект.КарточкаБазыЗнаний",, ОписаниеОшибки);
        ИначеЕсли ТипЗнч(КарточкаБазыЗнаний) = Тип("СправочникСсылка.Пожелания") И ТипОбращения <> Перечисления.ТипыОбращений.Пожелание Тогда
    		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"Объект.КарточкаБазыЗнаний", 
                СтрШаблон(ОписаниеОшибки, "Пожелание", ТипОбращения), "Объект.КарточкаБазыЗнаний",, ОписаниеОшибки);
        КонецЕсли;
    КонецЕсли;
		
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
    
    РегистрыНакопления.ДвиженияОбращений.ДобавитьДвижения(Движения.ДвиженияОбращений);
    
    // Добавим движение по количеству обращений.
    Если ЗначениеЗаполнено(КарточкаБазыЗнаний) Тогда
        РегистрыНакопления.ЗначенияПоказателей.ДобавитьДвижение(Движения.ЗначенияПоказателей, 
            Дата, КарточкаБазыЗнаний, Перечисления.ПоказателиКарточек.КоличествоОбращений, 1);
    КонецЕсли;
    
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = ТекущаяУниверсальнаяДата();
	НомерСокращенный = "";
	Исполнитель = Пользователи.АвторизованныйПользователь();
	СведенияПользователей = РегистрыСведений.СведенияОПользователях.СведенияОПользователе(Исполнитель);
	ОбслуживающаяОрганизация = СведенияПользователей.ОбслуживающаяОрганизация;
	ЛинияПоддержки = СведенияПользователей.ЛинияПоддержки;
	
	Состояние = Перечисления.СостоянияОбращений.Новое;
	КарточкаБазыЗнаний = Неопределено;
	ОжиданиеОценки = Ложь;
	Оценка = 0;
	
	ОписаниеХранилище = Новый ХранилищеЗначения(ОбъектКопирования.ОписаниеХранилище.Получить(), Новый СжатиеДанных(9));
	ОписаниеАвторИзменения = Неопределено;
	ОписаниеДатаИзменения = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Делает запись бизнес-события перенаправления Обращения,
// а также добавляет запись в регистр сведений ИсторияПеренаправленийОбращений.
//
Процедура ЗарегистрироватьПеренаправление()
	
	ВидСобытия = Справочники.ВидыБизнесСобытий.ПеренаправлениеОбращения;
	
	Если ДополнительныеСвойства.Свойство("ПеренаправлениеЗарегистрировано") Тогда
		Возврат
	Иначе
		ДополнительныеСвойства.Вставить("ПеренаправлениеЗарегистрировано", Истина);
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("КомментарийПеренаправления") Тогда
		КомментарийПеренаправления = ДополнительныеСвойства.КомментарийПеренаправления;
	Иначе
		КомментарийПеренаправления = "";
	КонецЕсли;
	
	ПараметрыСобытия = Новый Структура;
	ПараметрыСобытия.Вставить("ИсходнаяОрганизация", ДополнительныеСвойства.ИсходнаяОрганизация);
	ПараметрыСобытия.Вставить("ИсходнаяЛинияПоддержки", ДополнительныеСвойства.ИсходнаяЛинияПоддержки);
	ПараметрыСобытия.Вставить("ИсходныйИсполнитель", ДополнительныеСвойства.ИсходныйИсполнитель);
	ПараметрыСобытия.Вставить("Организация", ОбслуживающаяОрганизация);
	ПараметрыСобытия.Вставить("ЛинияПоддержки", ЛинияПоддержки);
	ПараметрыСобытия.Вставить("Исполнитель", Исполнитель);
	ПараметрыСобытия.Вставить("Комментарий", КомментарийПеренаправления);
	
	КонтекстСтрокой = Строка(ВидСобытия);
	
	Если ДополнительныеСвойства.ИсходнаяОрганизация <> ОбслуживающаяОрганизация Тогда
		КонтекстСтрокой = КонтекстСтрокой + СтрШаблон(НСтр("ru='Организация: ""%1"" → ""%2""'"),
			БизнесСобытия.ПредставлениеЗначения(ДополнительныеСвойства.ИсходнаяОрганизация), 
			БизнесСобытия.ПредставлениеЗначения(ОбслуживающаяОрганизация));
	КонецЕсли;
	
	
	Если ДополнительныеСвойства.ИсходнаяЛинияПоддержки <> ЛинияПоддержки Тогда
		КонтекстСтрокой = КонтекстСтрокой + ?(ПустаяСтрока(КонтекстСтрокой), "", Символы.ПС)
            			+ СтрШаблон(НСтр("ru='Линия поддержки: ""%1"" → ""%2""'"),
            			    БизнесСобытия.ПредставлениеЗначения(ДополнительныеСвойства.ИсходнаяЛинияПоддержки), 
            				БизнесСобытия.ПредставлениеЗначения(ЛинияПоддержки));
	КонецЕсли;
	
	Если ДополнительныеСвойства.ИсходныйИсполнитель <> Исполнитель Тогда
		КонтекстСтрокой = КонтекстСтрокой + ?(ПустаяСтрока(КонтекстСтрокой), "", Символы.ПС)
			            + СтрШаблон(НСтр("ru='Исполнитель: ""%1"" → ""%2""'"),
            				БизнесСобытия.ПредставлениеЗначения(ДополнительныеСвойства.ИсходныйИсполнитель), 
            				БизнесСобытия.ПредставлениеЗначения(Исполнитель));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КомментарийПеренаправления) Тогда
		КонтекстСтрокой = КонтекстСтрокой + ?(ПустаяСтрока(КонтекстСтрокой), "", Символы.ПС)
			            + СтрШаблон(НСтр("ru='Комментарий: %1'"), КомментарийПеренаправления);
	КонецЕсли; 
	
	КонтекстСобытия = БизнесСобытия.СформироватьКонтекстСобытия(ПараметрыСобытия);
	БизнесСобытия.ЗарегистрироватьСобытие(Ссылка, ВидСобытия, КонтекстСобытия,, КонтекстСтрокой, 
		ДополнительныеСвойства.ИсходныйИсполнитель, Исполнитель);
		
	// Запишем историю перенаправления
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Период", ДополнительныеСвойства.ДатаЗаписи);
	ПараметрыЗаписи.Вставить("Обращение", Ссылка);
	ПараметрыЗаписи.Вставить("ИсходнаяОбслуживающаяОрганизация", ДополнительныеСвойства.ИсходнаяОрганизация);
	ПараметрыЗаписи.Вставить("ИсходнаяЛинияПоддержки", ДополнительныеСвойства.ИсходнаяЛинияПоддержки);
	ПараметрыЗаписи.Вставить("ИсходныйИсполнитель", ДополнительныеСвойства.ИсходныйИсполнитель);
	ПараметрыЗаписи.Вставить("ОбслуживающаяОрганизация", ОбслуживающаяОрганизация);
	ПараметрыЗаписи.Вставить("ЛинияПоддержки", ЛинияПоддержки);
	ПараметрыЗаписи.Вставить("Исполнитель", Исполнитель);
	
	РегистрыСведений.ИсторияПеренаправленийОбращений.ДобавитьЗапись(ПараметрыЗаписи);
	
КонецПроцедуры

Процедура ОбработатьПометкуУдаленияВзаимодействий(ПометкаУдаления)

	// Пометим\Снимем пометку на удаление у взаимодействий по обращению.
    // Это нужно, чтобы удалить обращение и связанные с ним взаимодействия.
    // Иначе удаление невозможно из-за записей регистра сведений ПредметыПапкиВзаимодействий.
    // Если взаимодействия не нужно удалять, то сначала взаимодействие нужно открепить от обращения.
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПредметыПапкиВзаимодействий.Взаимодействие
		|ИЗ
		|	РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
		|ГДЕ
		|	ПредметыПапкиВзаимодействий.Предмет = &Предмет
		|	И ПредметыПапкиВзаимодействий.Взаимодействие.ПометкаУдаления <> &ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Предмет", Ссылка);
	Запрос.УстановитьПараметр("ПометкаУдаления", ПометкаУдаления);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Попытка
			Если ТипЗнч(Выборка.Взаимодействие) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда
				ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.Взаимодействие, "ПометкаУдаления, СтатусПисьма");
				Если Не РольДоступна(Метаданные.Роли.ПолныеПрава) И Не ЗначенияРеквизитов.ПометкаУдаления
					И ЗначенияРеквизитов.СтатусПисьма <> Перечисления.СтатусыИсходящегоЭлектронногоПисьма.Черновик Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			ВзаимодействиеОбъект = Выборка.Взаимодействие.ПолучитьОбъект();
			ВзаимодействиеОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
			ВзаимодействиеОбъект.Записать();
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru='Обслуживание.Пометка удаления обращения'", 
                ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Предупреждение, 
                Выборка.Взаимодействие.Метаданные(), Выборка.Взаимодействие, ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗарегистрироватьБизнесСобытияПоОбращению()
	
	Если ДополнительныеСвойства.ЭтоНовый Тогда
		БизнесСобытия.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.СозданиеОбращения);
	ИначеЕсли Не ПометкаУдаления Тогда
		БизнесСобытия.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ИзменениеОбращения);
	КонецЕсли;
	
	Если ДополнительныеСвойства.ИсходнаяКарточкаБазыЗнаний <> КарточкаБазыЗнаний И ЗначениеЗаполнено(КарточкаБазыЗнаний) Тогда
		БизнесСобытия.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ОбращениеПривязаноККарточкеБЗ,,,, КарточкаБазыЗнаний);
    КонецЕсли;
    
	Если Не ЗначениеЗаполнено(КарточкаБазыЗнаний) И ЗначениеЗаполнено(ДополнительныеСвойства.ИсходнаяКарточкаБазыЗнаний) Тогда
		БизнесСобытия.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ОбращениеОтвязаноОтКарточкиБЗ,,,, 
            ДополнительныеСвойства.ИсходнаяКарточкаБазыЗнаний);
	КонецЕсли;

		
	Если ЗначениеЗаполнено(ДополнительныеСвойства.ИсходноеСостояние) И Состояние <> ДополнительныеСвойства.ИсходноеСостояние Тогда
		
		ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеСостоянияОбращения;
		
		ДанныеКонтекста = Новый Структура;
		ДанныеКонтекста.Вставить("ИсходноеСостояние", ДополнительныеСвойства.ИсходноеСостояние);
		ДанныеКонтекста.Вставить("НовоеСостояние", Состояние);
		
		КонтекстСобытия = БизнесСобытия.СформироватьКонтекстСобытия(ДанныеКонтекста);
		
		БизнесСобытия.ЗарегистрироватьСобытие(Ссылка, ВидСобытия, КонтекстСобытия,,
			СтрШаблон(НСтр("ru='%1%2""%3"" → ""%4""'"), Строка(ВидСобытия), Символы.ПС,
				БизнесСобытия.ПредставлениеЗначения(ДополнительныеСвойства.ИсходноеСостояние),
				БизнесСобытия.ПредставлениеЗначения(Состояние)));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДополнительныеСвойства.ИсходнаяПодпискаНаТариф) И ПодпискаНаТариф <> ДополнительныеСвойства.ИсходнаяПодпискаНаТариф Тогда
		
		ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеАктивнойПодпискиНаТариф;
		
		ДанныеКонтекста = Новый Структура;
		ДанныеКонтекста.Вставить("ИсходнаяПодпискаНаТариф", ДополнительныеСвойства.ИсходнаяПодпискаНаТариф);
		ДанныеКонтекста.Вставить("НоваяПодпискаНаТариф", ПодпискаНаТариф);
		
		КонтекстСобытия = БизнесСобытия.СформироватьКонтекстСобытия(ДанныеКонтекста);
		
		БизнесСобытия.ЗарегистрироватьСобытие(Ссылка, ВидСобытия, КонтекстСобытия,,
			СтрШаблон(НСтр("ru='%1%2""%3"" → ""%4""'"), Строка(ВидСобытия), Символы.ПС,
				БизнесСобытия.ПредставлениеЗначения(ДополнительныеСвойства.ИсходнаяПодпискаНаТариф),
				БизнесСобытия.ПредставлениеЗначения(ПодпискаНаТариф)));
	КонецЕсли;
    
    Если ДополнительныеСвойства.ИсходныйИнициатор <> Инициатор Тогда
        
        ВидСобытия = Справочники.ВидыБизнесСобытий.ИзмененИнициаторОбращения;

        ДанныеКонтекста = Новый Структура;
		ДанныеКонтекста.Вставить("ИсходныйИнициатор", ДополнительныеСвойства.ИсходныйИнициатор);
		ДанныеКонтекста.Вставить("Инициатор", Инициатор);
		
		КонтекстСобытия = БизнесСобытия.СформироватьКонтекстСобытия(ДанныеКонтекста);
		
		БизнесСобытия.ЗарегистрироватьСобытие(Ссылка, ВидСобытия, КонтекстСобытия,,
			СтрШаблон(НСтр("ru='%1%2""%3"" → ""%4""'"), Строка(ВидСобытия), Символы.ПС,
				БизнесСобытия.ПредставлениеЗначения(ДополнительныеСвойства.ИсходныйИнициатор),
				БизнесСобытия.ПредставлениеЗначения(Инициатор)),
                ДополнительныеСвойства.ИсходныйИнициатор, Инициатор);
    КонецЕсли; 

    Если Не ДополнительныеСвойства.ЭтоНовый И (ДополнительныеСвойства.ИсходныйКомпонент <> Компонент 
		Или ДополнительныеСвойства.ИсходныйРаздел <> Раздел 
		Или ДополнительныеСвойства.ИсходныйСервис <> Сервис
        Или ДополнительныеСвойства.ИсходныйКаналПолучения <> КаналПолучения) Тогда
		
		ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеПринадлежностиОбращения;
		
		ДанныеКонтекста = Новый Структура;
		ДанныеКонтекста.Вставить("ИсходныйСервис", ДополнительныеСвойства.ИсходныйСервис);
		ДанныеКонтекста.Вставить("ИсходныйКомпонент", ДополнительныеСвойства.ИсходныйКомпонент);
		ДанныеКонтекста.Вставить("ИсходныйРаздел", ДополнительныеСвойства.ИсходныйРаздел);
		ДанныеКонтекста.Вставить("ИсходныйКаналПолучения", ДополнительныеСвойства.ИсходныйКаналПолучения);
		ДанныеКонтекста.Вставить("Сервис", Сервис);
		ДанныеКонтекста.Вставить("Компонент", Компонент);
		ДанныеКонтекста.Вставить("Раздел", Раздел);
		ДанныеКонтекста.Вставить("КаналПолучения", КаналПолучения);
		
		КонтекстСобытия = БизнесСобытия.СформироватьКонтекстСобытия(ДанныеКонтекста);
		
		КонтекстСтрокой = Строка(ВидСобытия);
		
		Если ДополнительныеСвойства.ИсходныйСервис <> Сервис Тогда
			КонтекстСтрокой = КонтекстСтрокой + СтрШаблон(НСтр("ru='Сервис: ""%1"" → ""%2""'"),
				БизнесСобытия.ПредставлениеЗначения(ДополнительныеСвойства.ИсходныйСервис), 
				БизнесСобытия.ПредставлениеЗначения(Сервис));
		КонецЕсли;
			
		Если ДополнительныеСвойства.ИсходныйКомпонент <> Компонент Тогда
			КонтекстСтрокой = КонтекстСтрокой + ?(ПустаяСтрока(КонтекстСтрокой), "", Символы.ПС)
				            + СтрШаблон(НСтр("ru='Компонент: ""%1"" → ""%2""'"), 
            					БизнесСобытия.ПредставлениеЗначения(ДополнительныеСвойства.ИсходныйКомпонент),
            					БизнесСобытия.ПредставлениеЗначения(Компонент));
		КонецЕсли;
		
		Если ДополнительныеСвойства.ИсходныйРаздел <> Раздел Тогда
			КонтекстСтрокой = КонтекстСтрокой + ?(ПустаяСтрока(КонтекстСтрокой), "", Символы.ПС) 
				            + СтрШаблон(НСтр("ru='Раздел: ""%1"" → ""%2""'"), 
            					БизнесСобытия.ПредставлениеЗначения(ДополнительныеСвойства.ИсходныйРаздел),
            					БизнесСобытия.ПредставлениеЗначения(Раздел));
		КонецЕсли;
		
		Если ДополнительныеСвойства.ИсходныйКаналПолучения <> КаналПолучения Тогда
			КонтекстСтрокой = КонтекстСтрокой + ?(ПустаяСтрока(КонтекстСтрокой), "", Символы.ПС) 
				            + СтрШаблон(НСтр("ru='Канал получения: ""%1"" → ""%2""'"), 
            					БизнесСобытия.ПредставлениеЗначения(ДополнительныеСвойства.ИсходныйКаналПолучения),
            					БизнесСобытия.ПредставлениеЗначения(КаналПолучения));
		КонецЕсли;
        
        БизнесСобытия.ЗарегистрироватьСобытие(Ссылка, ВидСобытия, КонтекстСобытия,, КонтекстСтрокой);
		
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.ЭтоНовый И (ДополнительныеСвойства.ИсходнаяТема <> Тема 
		Или ДополнительныеСвойства.ИсходноеОписание <> Описание) Тогда
		
		ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеОписанияОбращения; 
		ДанныеКонтекста = Новый Структура;
		ДанныеКонтекста.Вставить("ИсходнаяТема", ДополнительныеСвойства.ИсходнаяТема);
		ДанныеКонтекста.Вставить("ИсходноеОписание", ДополнительныеСвойства.ИсходноеОписание);
		ДанныеКонтекста.Вставить("Тема", Тема);
		ДанныеКонтекста.Вставить("Описание", Описание);
		
		КонтекстСобытия = БизнесСобытия.СформироватьКонтекстСобытия(ДанныеКонтекста);
		
		КонтекстСтрокой = Строка(ВидСобытия);
		
		Если ДополнительныеСвойства.ИсходнаяТема <> Тема Тогда
			КонтекстСтрокой = КонтекстСтрокой + ?(ПустаяСтрока(КонтекстСтрокой), "", Символы.ПС) 
				            + СтрШаблон(НСтр("ru='Тема: ""%1"" → ""%2""'"), 
            					БизнесСобытия.ПредставлениеЗначения(ДополнительныеСвойства.ИсходнаяТема),
            					БизнесСобытия.ПредставлениеЗначения(Тема));
		КонецЕсли;
		
		Если ДополнительныеСвойства.ИсходноеОписание <> Описание Тогда
			КонтекстСтрокой = КонтекстСтрокой + ?(ПустаяСтрока(КонтекстСтрокой), "", Символы.ПС) 
				            + СтрШаблон(НСтр("ru='Описание: ""%1"" → ""%2""'"), 
            					БизнесСобытия.ПредставлениеЗначения(ДополнительныеСвойства.ИсходноеОписание),
            					БизнесСобытия.ПредставлениеЗначения(Описание));
		КонецЕсли;
		
		БизнесСобытия.ЗарегистрироватьСобытие(Ссылка, ВидСобытия, КонтекстСобытия,, КонтекстСтрокой);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьЗначенияРеквизитовПоУмолчанию()
    
    Если ДополнительныеСвойства.ЭтоНовый Тогда
        
        Если Не ЗначениеЗаполнено(Номер) Тогда
    		УстановитьНовыйНомер();
        КонецЕсли;
        
        Если Не ЗначениеЗаполнено(Дата) Тогда
    		Дата = ТекущаяУниверсальнаяДата();
        КонецЕсли;
        
        Если Не ЗначениеЗаполнено(ТипОбращения) Тогда
            ТипОбращения = Перечисления.ТипыОбращений.Консультация;
        КонецЕсли;
        
        Если Не ЗначениеЗаполнено(Состояние) Тогда
            Состояние = Перечисления.СостоянияОбращений.Новое;
        КонецЕсли;
        
        Если Не ЗначениеЗаполнено(Важность) Тогда
            Важность = Перечисления.ВариантыВажности.ОбычнаяВажность;
        КонецЕсли;
        
        Если ПолучитьФункциональнуюОпцию("ИспользоватьТарифы") Тогда
            Если Не ЗначениеЗаполнено(ПодпискаНаТариф) 
                И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сервис, "ИспользоватьТарифы") = Истина Тогда
                ПодпискаНаТариф = Документы.Подписка.АктивнаяПодпискаАбонента(Абонент);
            КонецЕсли;
        КонецЕсли;
    
    КонецЕсли;
    
КонецПроцедуры

//{Рарус kruser 22.05.2019 86182
Процедура УстановитьСвязиВнутреннихОбращений(ДополнительныеСвойства)
	
	Если ВнутреннееОбращение И ДополнительныеСвойства.Свойство("ИсходныйВнешниеОбращения") Тогда
		
		МассивВнешниеОбращения = ДополнительныеСвойства.ИсходныйВнешниеОбращения;

		Для каждого СтрокаВнешниеОбращения Из ВнешниеОбращения Цикл
		
			Если МассивВнешниеОбращения.Найти(СтрокаВнешниеОбращения.Обращение) = Неопределено Тогда			
								
				ОбъектОбращение = СтрокаВнешниеОбращения.Обращение.ПолучитьОбъект();
				ОбъектОбращение.Записать();
				
			КонецЕсли;
		
		КонецЦикла;
		
		Для каждого СтрокаМассивВнешниеОбращения Из МассивВнешниеОбращения Цикл
			
			Если ВнешниеОбращения.НайтиСтроки(Новый Структура("Обращение", СтрокаМассивВнешниеОбращения)).Количество() = 0 Тогда			
				
				ОбъектОбращение = СтрокаМассивВнешниеОбращения.ПолучитьОбъект();
				ОбъектОбращение.Записать();
				
			КонецЕсли;			
			
		КонецЦикла;		
							
	КонецЕсли;
			
КонецПроцедуры
//}Рарус kruser 22.05.2019 86182

//{Рарус kruser 22.05.2019 86182
Процедура УстановитьСвязиВнешнихОбращений()
	
	Если ВнутреннееОбращение Тогда
		
		Если ВнешниеОбращения.Количество() > 0 Тогда			
			ИмеетСвязьСВнешними = Истина;	
		Иначе
			ИмеетСвязьСВнешними = Ложь;			
		КонецЕсли;
		
	Иначе 
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ОбращениеВнешниеОбращения.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.Обращение.ВнешниеОбращения КАК ОбращениеВнешниеОбращения
		|ГДЕ
		|	ОбращениеВнешниеОбращения.Обращение = &ДокументОснование
		|	И ОбращениеВнешниеОбращения.Ссылка.ВнутреннееОбращение";
		
		Запрос.УстановитьПараметр("ДокументОснование", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда		
			ИмеетСвязьСВнутренними = Ложь;
		Иначе 
			ИмеетСвязьСВнутренними = Истина;		
		КонецЕсли;
		
	КонецЕсли;
			
КонецПроцедуры
//}Рарус kruser 22.05.2019 86182

//{Рарус kruser 22.05.2019 86182
Функция ПолучитьИсходныеВнешниеОбращения(Ссылка)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОбращениеВнешниеОбращения.Ссылка КАК Ссылка,
	|	ОбращениеВнешниеОбращения.Обращение КАК Обращение
	|ИЗ
	|	Документ.Обращение.ВнешниеОбращения КАК ОбращениеВнешниеОбращения
	|ГДЕ
	|	ОбращениеВнешниеОбращения.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Обращение");

	Возврат РезультатЗапроса;  

КонецФункции 
//}Рарус kruser 22.05.2019 86182

#КонецОбласти

#КонецЕсли
