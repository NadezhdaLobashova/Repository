
#Область ПрограммныйИнтерфейс

Функция ПолучитьОбращения(ПользовательИд, НомерСтраницы, Отбор, Сортировка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		ИмяСобытия = ИмяСобытияЖР() + НСтр("ru = 'Получение списка обращений'");
		
		Параметры = Новый Структура;
		Параметры.Вставить("ИдентификаторПользователя", ПользовательИд);
		Параметры.Вставить("НомерСтраницы", НомерСтраницы);
		Параметры.Вставить("Отбор", Отбор);
		Параметры.Вставить("Сортировка", Сортировка);
		ЗалогироватьВходящиеПараметры(ИмяСобытия, Параметры);
		
		ИдентификаторПользователя = Новый УникальныйИдентификатор(ПользовательИд);
		Пользователь = Справочники.ПользователиСервисов.ПолучитьСсылку(ИдентификаторПользователя);
		Если Пользователь.ПолучитьОбъект() = Неопределено Тогда 
			ВызватьИсключение НСтр("ru = 'Не определен пользователь сервиса'");
		КонецЕсли;
		
		РазмерПорции = ИнтеграцияСИнформационнымЦентром.КоличествоОбращенийВВыборке();
		ПространствоИмен = ИнтеграцияСИнформационнымЦентром.ПространствоИмен_1_0_0_1();
		ТаблицаСОбращениями = ИнтеграцияСИнформационнымЦентром.СписокОбращенийПоПользователю(Пользователь, Отбор, Сортировка, РазмерПорции, НомерСтраницы);
		
		////////////////////////////////////////////////////////////////////////////////
		// Заполнение выходных данных
		ТипПредставленияСпискаОбращений = ФабрикаXDTO.Тип(ПространствоИмен, "IncidentListPresentation");
		ПредставлениеСпискаОбращений = ФабрикаXDTO.Создать(ТипПредставленияСпискаОбращений);
		
		ПредставлениеСпискаОбращений.IsStill = ?(ТаблицаСОбращениями.Количество() <= РазмерПорции, Ложь, Истина);
		
		Для Каждого СтрокаТаблицы Из ТаблицаСОбращениями Цикл 
			
			ПредставлениеОбращения = ОбращениеXDTO(СтрокаТаблицы, СтрокаТаблицы.ЕстьНепросмотренныеВзаимодействия);
			
			ПредставлениеСпискаОбращений.Incidents.Добавить(ПредставлениеОбращения);
			
		КонецЦикла;
		
		Возврат ПредставлениеСпискаОбращений;
		
	Исключение
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписатьОшибку(ИмяСобытия, ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
		
	КонецПопытки;
	
КонецФункции

Функция ПолучитьОбращение(ПользовательИд, ОбращениеИд)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		ИмяСобытия = ИмяСобытияЖР() + НСтр("ru = 'Получение обращения'");
		
		Параметры = Новый Структура;
		Параметры.Вставить("ИдентификаторПользователя", ПользовательИд);
		Параметры.Вставить("ИдентификаторОбращения", ОбращениеИд);
		ЗалогироватьВходящиеПараметры(ИмяСобытия, Параметры);
		
		ИдентификаторПользователя = Новый УникальныйИдентификатор(ПользовательИд);
		Пользователь = Справочники.ПользователиСервисов.ПолучитьСсылку(ИдентификаторПользователя);
		Если Пользователь.ПолучитьОбъект() = Неопределено Тогда 
			ВызватьИсключение НСтр("ru = 'Не определен пользователь сервиса'");
		КонецЕсли;
		
		ИдентификаторОбращения = Новый УникальныйИдентификатор(ОбращениеИд);
		Обращение = Документы.Обращение.ПолучитьСсылку(ИдентификаторОбращения);
		Если Обращение.ПолучитьОбъект() = Неопределено Тогда 
			ВызватьИсключение НСтр("ru = 'Не определено обращение'");
		КонецЕсли;
		
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Обращение, "Ссылка, Состояние, Тема, Дата, НомерСокращенный, Инициатор");
		
		Возврат ОбращениеXDTO(СтруктураРеквизитов);
		
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписатьОшибку(ИмяСобытия, ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
КонецФункции

Функция ПолучитьВзаимодействияПоОбращению(ПользовательИд, ОбращениеИд, НомерСтраницы)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		ИмяСобытия = ИмяСобытияЖР() + НСтр("ru = 'Получение списка взаимодействий по обращению'");
		
		Параметры = Новый Структура;
		Параметры.Вставить("ИдентификаторПользователя", ПользовательИд);
		Параметры.Вставить("ИдентификаторОбращения", ОбращениеИд);
		Параметры.Вставить("НомерСтраницы", НомерСтраницы);
		ЗалогироватьВходящиеПараметры(ИмяСобытия, Параметры);
		
		ИдентификаторПользователя = Новый УникальныйИдентификатор(ПользовательИд);
		Пользователь = Справочники.ПользователиСервисов.ПолучитьСсылку(ИдентификаторПользователя);
		Если Пользователь.ПолучитьОбъект() = Неопределено Тогда 
			ВызватьИсключение НСтр("ru = 'Не определен пользователь сервиса'");
		КонецЕсли;
		
		ИдентификаторОбращения = Новый УникальныйИдентификатор(ОбращениеИд);
		Обращение = Документы.Обращение.ПолучитьСсылку(ИдентификаторОбращения);
		Если Обращение.ПолучитьОбъект() = Неопределено Тогда 
			ВызватьИсключение НСтр("ru = 'Не определено обращение'");
		КонецЕсли;
		
		РазмерПорции = ИнтеграцияСИнформационнымЦентром.КоличествоВзаимодействийВВыборке();
		ПространствоИмен = ИнтеграцияСИнформационнымЦентром.ПространствоИмен_1_0_0_1();
		ТаблицаСВзаимодействиями = ИнтеграцияСИнформационнымЦентром.СписокВзаимодействийПоОбращению(Обращение, Пользователь, РазмерПорции, НомерСтраницы);
		
		////////////////////////////////////////////////////////////////////////////////
		// Заполнение выходных данных
		ТипПредставленияСпискаВзаимодействий = ФабрикаXDTO.Тип(ПространствоИмен, "InteractionListPresintation");
		ПредставлениеСпискаВзаимодействий = ФабрикаXDTO.Создать(ТипПредставленияСпискаВзаимодействий);
		
		ПредставлениеСпискаВзаимодействий.IsStill = ?(ТаблицаСВзаимодействиями.Количество() <= РазмерПорции, Ложь, Истина);
		
		Для Каждого СтрокаТаблицы Из ТаблицаСВзаимодействиями Цикл 
			
			ПредставлениеВзаимодействия = ВзаимодействиеXDTO(СтрокаТаблицы, Пользователь, СтрокаТаблицы.Просмотрено);
			
			ПредставлениеСпискаВзаимодействий.Interactions.Добавить(ПредставлениеВзаимодействия);
			
		КонецЦикла;
		
		Возврат ПредставлениеСпискаВзаимодействий;
		
	Исключение
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписатьОшибку(ИмяСобытия, ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
		
	КонецПопытки;
	
КонецФункции

Функция ПолучитьВзаимодействие(ПользовательИд, ВзаимодействиеИд, ТипВзаимодействия, Входящее)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		ИмяСобытия = ИмяСобытияЖР() + НСтр("ru = 'Получение взаимодействия'");
		
		Параметры = Новый Структура;
		Параметры.Вставить("ИдентификаторПользователя", ПользовательИд);
		Параметры.Вставить("ИдентификаторВзаимодействия", ВзаимодействиеИд);
		Параметры.Вставить("ТипВзаимодействия", ТипВзаимодействия);
		Параметры.Вставить("Входящее", Входящее);
		ЗалогироватьВходящиеПараметры(ИмяСобытия, Параметры);
		
		ИдентификаторПользователя = Новый УникальныйИдентификатор(ПользовательИд);
		Пользователь = Справочники.ПользователиСервисов.ПолучитьСсылку(ИдентификаторПользователя);
		Если Пользователь.ПолучитьОбъект() = Неопределено Тогда 
			ВызватьИсключение НСтр("ru = 'Не определен пользователь сервиса'");
		КонецЕсли;
		
		ИдентификаторВзаимодействия = Новый УникальныйИдентификатор(ВзаимодействиеИд);
		Взаимодействие = Неопределено;
		
		Если ТипВзаимодействия = "Email" Тогда
			Если Входящее Тогда 
				Взаимодействие = Документы.ЭлектронноеПисьмоИсходящее.ПолучитьСсылку(ИдентификаторВзаимодействия).ПолучитьОбъект();
			Иначе
				Взаимодействие = Документы.ЭлектронноеПисьмоВходящее.ПолучитьСсылку(ИдентификаторВзаимодействия).ПолучитьОбъект();
			КонецЕсли;
		ИначеЕсли ТипВзаимодействия = "PhoneCall" Тогда
			Взаимодействие = Документы.ТелефонныйЗвонок.ПолучитьСсылку(ИдентификаторВзаимодействия).ПолучитьОбъект();
		ИначеЕсли ТипВзаимодействия = "Comment" Тогда
			Взаимодействие = Документы.КомментарийПользователя.ПолучитьСсылку(ИдентификаторВзаимодействия).ПолучитьОбъект();
		КонецЕсли;
		
		Если Взаимодействие = Неопределено Тогда 
			ВызватьИсключение НСтр("ru = 'Не определено взаимодействие'");
		КонецЕсли;
		
		Если Не ВзаимодействияУСП.ПоказыватьПользователюВзаимодействие(Взаимодействие.Ссылка) Тогда 
			ВызватьИсключение НСтр("ru = 'Не определено взаимодействие'");
		КонецЕсли;
		
		ВзаимодействияУСП.УдалитьПризнакНеПросмотренности(Взаимодействие.Ссылка, Пользователь);
		
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Взаимодействие.Ссылка, "Ссылка, Дата, Тема");
		
		ПоказыватьСодержаниеВзаимодействия = (ТипВзаимодействия <> "PhoneCall");
		
		Возврат ВзаимодействиеXDTO(СтруктураРеквизитов, Пользователь, Ложь, ПоказыватьСодержаниеВзаимодействия);
		
	Исключение
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписатьОшибку(ИмяСобытия, ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
		
	КонецПопытки;
	
КонецФункции

Функция ДобавитьКомментарий(ПользовательИд, ОбращениеИд, Тема, HTMLТекст, СоздаватьОбращение, Файлы, КодПриложения, АдресЭлектроннойПочтыПользователя)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		ИмяСобытия = ИмяСобытияЖР() + НСтр("ru = 'Добавление комментария'");
		
		Параметры = Новый Структура;
		Параметры.Вставить("ИдентификаторПользователя", ПользовательИд);
		Параметры.Вставить("ИдентификаторОбращения", ОбращениеИд);
		Параметры.Вставить("СоздаватьОбращение", СоздаватьОбращение);
		Параметры.Вставить("КодПриложения", КодПриложения);
		Параметры.Вставить("АдресЭлектроннойПочтыПользователя", АдресЭлектроннойПочтыПользователя);
		ЗалогироватьВходящиеПараметры(ИмяСобытия, Параметры);
		
		ИдентификаторПользователя = Новый УникальныйИдентификатор(ПользовательИд);
		Пользователь = Справочники.ПользователиСервисов.ПолучитьСсылку(ИдентификаторПользователя);
		Если Пользователь.ПолучитьОбъект() = Неопределено Тогда 
			ВызватьИсключение НСтр("ru = 'Не определен пользователь сервиса'");
		КонецЕсли;
		
		Сервис = Пользователь.Владелец;
		Если Сервис.Пустая() Тогда 
			ВызватьИсключение НСтр("ru = 'Не определен сервис'");
		КонецЕсли;
	    
	    Контекст = ВзаимодействияУСП.КонтекстПриложения(HTMLТекст, Сервис);
	    
		ФД = ФорматированныйДокументИзДанных(HTMLТекст, Файлы);
	    
		Если СоздаватьОбращение Тогда 
			НовоеОбращение = Документы.Обращение.СоздатьДокумент();
			НовоеОбращение.Дата = ТекущаяУниверсальнаяДата();
			НовоеОбращение.Сервис = Сервис;
	        Контекст.Свойство("Витрина", НовоеОбращение.Витрина);
	        Если Не ЗначениеЗаполнено(НовоеОбращение.Витрина) Тогда
	            НовоеОбращение.Витрина = БазаЗнанийПовтИсп.ОсновнаяВитринаСервиса(Сервис);
	        КонецЕсли; 
			НовоеОбращение.Инициатор = Пользователь;
            КонтактыПользователя = КонтактнаяИнформацияУСП.АктуальныеАдресаОтправкиПользователяСервиса(Пользователь);
            Если НЕ ПустаяСтрока(АдресЭлектроннойПочтыПользователя) Тогда
                НовоеОбращение.АдресДляПереписки = АдресЭлектроннойПочтыПользователя;
            ИначеЕсли КонтактыПользователя.Количество() > 0 Тогда
                НовоеОбращение.АдресДляПереписки = КонтактыПользователя[0].Адрес;
            КонецЕсли;
			НовоеОбращение.Тема = Тема;
			НовоеОбращение.ОписаниеХранилище = Новый ХранилищеЗначения(ФД);
			НовоеОбращение.Абонент = ?(КодПриложения = 0, АбонентПользователяПоУмолчанию(Пользователь), АбонентПриложенияПоУмолчанию(Сервис, КодПриложения));
			НовоеОбращение.АбонентОбслуживающейОрганизации = Обслуживание.АбонентОбслуживающейОрганизацииАбонента(НовоеОбращение.Абонент);
            Документы.Обращение.УстановитьИсполнителяПоУмолчанию(НовоеОбращение);
            НовоеОбращение.КаналПолучения = Справочники.КаналыПолученияОбращений.ИнформационныйЦентр;
            НовоеОбращение.Записать(РежимЗаписиДокумента.Проведение);
			
            Если Контекст.Свойство("НомерПриложения") Тогда
                ТекстКомментария = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Приложение: %1, %2 (%3)
                                   |Версия платформы: %4'"), 
                                    Контекст.НомерПриложения, 
                                    Контекст.ИмяКонфигурации, 
                                    Контекст.ВерсияКонфигурации, 
                                    Контекст.ВерсияПлатформы);

                НовыйКомментарий = Справочники.Комментарии.СоздатьЭлемент();
				НовыйКомментарий.ВладелецКомментария = НовоеОбращение.Ссылка;
                НовыйКомментарий.Дата = ТекущаяДатаСеанса(); 
                НовыйКомментарий.Автор = Пользователи.АвторизованныйПользователь();
                НовыйКомментарий.Комментарий = ТекстКомментария;
            КонецЕсли;    
                        	        
	    Иначе
			ИдентификаторОбращения = Новый УникальныйИдентификатор(ОбращениеИд);
			СсылкаНаОбращение = Документы.Обращение.ПолучитьСсылку(ИдентификаторОбращения);
			НовоеОбращение = СсылкаНаОбращение.ПолучитьОбъект();
			Если НовоеОбращение = Неопределено Тогда 
				ВызватьИсключение НСтр("ru = 'Не определено обращение'");
	        КонецЕсли;
	        
	        Если НовоеОбращение.Состояние = Перечисления.СостоянияОбращений.Закрыто Тогда
	            // Если обращение было закрыто, то у него нужно изменить статус и перевести на линию поддержки.
	    		НовоеОбращение.Состояние = Перечисления.СостоянияОбращений.Расследование;
	            НовоеОбращение.Исполнитель = НовоеОбращение.ЛинияПоддержки;
	    		НовоеОбращение.Записать(РежимЗаписиДокумента.Проведение);
	        ИначеЕсли НовоеОбращение.Состояние = Перечисления.СостоянияОбращений.ОжиданиеИнициатора Тогда
	            // Если обращение в состояниии "Ожидание инициатора", делаем тоже самое, что выше, но без перевода на линию поддержки.
	    		НовоеОбращение.Состояние = Перечисления.СостоянияОбращений.Расследование;
	    		НовоеОбращение.Записать(РежимЗаписиДокумента.Проведение);
	        КонецЕсли; 
	        
	    КонецЕсли;
		
		Комментарий = Документы.КомментарийПользователя.СоздатьДокумент();
		Комментарий.Автор = Пользователь;
		Комментарий.Дата = ТекущаяУниверсальнаяДата();
		Комментарий.УстановитьНовыйНомер();
		Комментарий.Тема = НовоеОбращение.Тема;
		Комментарий.Предмет = НовоеОбращение.Ссылка;
	    Комментарий.ДополнительныеСвойства.Вставить("Предмет", НовоеОбращение.Ссылка);
		Комментарий.Важность = Перечисления.ВариантыВажностиВзаимодействия.Обычная;
		Комментарий.ОписаниеХранилище = Новый ХранилищеЗначения(ФД);
        
        Если Контекст.Свойство("НомерПриложения") Тогда
            Комментарий.Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
                НСтр("ru='Приложение: %1, %2 (%3)
                     |Версия платформы: %4'"), 
                Контекст.НомерПриложения, 
                Контекст.ИмяКонфигурации, 
                Контекст.ВерсияКонфигурации,
                Контекст.ВерсияПлатформы);
	    КонецЕсли;    
        
        Комментарий.Записать();
		
		Для Каждого ТекущийФайл Из Файлы.Files Цикл 
			
			Если ТекущийФайл.Data.Размер() > ФайловыеФункции.МаксимальныйРазмерФайла() Тогда 
				ВызватьИсключение НСтр("ru = 'Слишком большой файл'");
			КонецЕсли;
			
			АдресХранилища = ПоместитьВоВременноеХранилище(ТекущийФайл.Data);
			РасширениеБезТочки = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(СтрЗаменить(ТекущийФайл.Extension, ".", ""), "");
	        ИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ТекущийФайл.Name, "");
	        
			ПрисоединенныеФайлы.ДобавитьФайл(НовоеОбращение.Ссылка, ИмяФайла, РасширениеБезТочки, , , АдресХранилища);
			ПрисоединенныеФайлы.ДобавитьФайл(Комментарий.Ссылка, ИмяФайла, РасширениеБезТочки, , , АдресХранилища);
			
		КонецЦикла;
		
		Взаимодействия.УстановитьПредмет(Комментарий.Ссылка, НовоеОбращение.Ссылка, Истина);
		
		Если СоздаватьОбращение Тогда 
			
			ВидКИ = Справочники.ВидыКонтактнойИнформации.EmailПользователяСервиса;
			ОсновнойАдрес = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Пользователь, ВидКИ);
			Адрес = ?(ЗначениеЗаполнено(АдресЭлектроннойПочтыПользователя), АдресЭлектроннойПочтыПользователя, ОсновнойАдрес);
			
			Если Не ПустаяСтрока(Адрес) Тогда 
				ДанныеКонтакта = Новый Структура;
				ДанныеКонтакта.Вставить("Контакт", Пользователь);
				ДанныеКонтакта.Вставить("Адрес", Адрес);
				ДанныеКонтакта.Вставить("Представление", Пользователь.Наименование);
				ВзаимодействияУСП.ОтправитьПисьмоОРегистрацииОбращения(НовоеОбращение.Ссылка, ДанныеКонтакта);
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(АдресЭлектроннойПочтыПользователя) Тогда 
			Если Не ЕстьАдресЭлектроннойПочты(Пользователь, АдресЭлектроннойПочтыПользователя) Тогда 
				ВидКИ = Справочники.ВидыКонтактнойИнформации.ДополнительныйEmailПользователяСервиса;
				УправлениеКонтактнойИнформацией.ЗаполнитьКонтактнуюИнформациюОбъекта(Пользователь, ВидКИ, АдресЭлектроннойПочтыПользователя);
			КонецЕсли;
		КонецЕсли;
		
		Возврат Истина;
		
	Исключение
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписатьОшибку(ИмяСобытия, ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
		
	КонецПопытки;
	
КонецФункции

Функция ПолучитьФайлВзаимодействия(ПользовательИд, ВзаимодействиеИд, ФайлИд, ТипВзаимодействия, Входящее)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		ИмяСобытия = ИмяСобытияЖР() + НСтр("ru = 'Получение файла обращения'");
		
		Параметры = Новый Структура;
		Параметры.Вставить("ИдентификаторПользователя", ПользовательИд);
		Параметры.Вставить("ИдентификаторВзаимодействия", ВзаимодействиеИд);
		Параметры.Вставить("ИдентификаторФайла", ФайлИд);
		Параметры.Вставить("ТипВзаимодействия", ТипВзаимодействия);
		Параметры.Вставить("Входящее", Входящее);
		ЗалогироватьВходящиеПараметры(ИмяСобытия, Параметры);
		
		ИдентификаторПользователя = Новый УникальныйИдентификатор(ПользовательИд);
		Пользователь = Справочники.ПользователиСервисов.ПолучитьСсылку(ИдентификаторПользователя);
		Если Пользователь.ПолучитьОбъект() = Неопределено Тогда 
			ВызватьИсключение НСтр("ru = 'Не определен пользователь сервиса'");
		КонецЕсли;
		
		ИдентификаторВзаимодействия = Новый УникальныйИдентификатор(ВзаимодействиеИд);
		Взаимодействие = Неопределено;
		
		Если ТипВзаимодействия = "Email" Тогда 
			Если Входящее Тогда 
				Взаимодействие = Документы.ЭлектронноеПисьмоИсходящее.ПолучитьСсылку(ИдентификаторВзаимодействия).ПолучитьОбъект();
			Иначе
				Взаимодействие = Документы.ЭлектронноеПисьмоВходящее.ПолучитьСсылку(ИдентификаторВзаимодействия).ПолучитьОбъект();
			КонецЕсли;
		ИначеЕсли ТипВзаимодействия = "Comment" Тогда 
			Взаимодействие = Документы.КомментарийПользователя.ПолучитьСсылку(ИдентификаторВзаимодействия).ПолучитьОбъект();
		ИначеЕсли ТипВзаимодействия = "PhoneCall" Тогда 
			Взаимодействие = Документы.ТелефонныйЗвонок.ПолучитьСсылку(ИдентификаторВзаимодействия).ПолучитьОбъект();
		КонецЕсли;
		
		Если Взаимодействие = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'Не определено взаимодействие'");
		КонецЕсли;
		
		ИмяСправочника = РаботаСФайламиСлужебный.ИмяСправочникаХраненияФайлов(Взаимодействие);
		Если ПустаяСтрока(ИмяСправочника) Тогда 
			ВызватьИсключение НСтр("ru = 'Не определено имя справочника, хранящего приложенные файлы взаимодействия'");
		КонецЕсли;
		
		ИдентификаторФайла = Новый УникальныйИдентификатор(ФайлИд);
		СсылкаНаФайл = Справочники[ИмяСправочника].ПолучитьСсылку(ИдентификаторФайла);
		Если СсылкаНаФайл.ПолучитьОбъект() = Неопределено Тогда 
			ВызватьИсключение НСтр("ru = 'Не удалось идентифицировать файл по идентификатору'");
		КонецЕсли;
		
		Если СсылкаНаФайл.ВладелецФайла <> Взаимодействие.Ссылка Тогда
			ВызватьИсключение НСтр("ru = 'Полученный файл не принадлежит выбранному взаимодействию'");
		КонецЕсли;
		
		ПространствоИмен = ИнтеграцияСИнформационнымЦентром.ПространствоИмен_1_0_0_1();
		
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СсылкаНаФайл, "Наименование, Расширение");
		
		ТипФайла = ФабрикаXDTO.Тип(ПространствоИмен, "File");
		Файл = ФабрикаXDTO.Создать(ТипФайла);
		Файл.Name = СтруктураРеквизитов.Наименование;
		Файл.Data = ПрисоединенныеФайлы.ПолучитьДвоичныеДанныеФайла(СсылкаНаФайл);
		Файл.Extension = СтруктураРеквизитов.Расширение;
		
		Возврат Файл;
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписатьОшибку(ИмяСобытия, ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
КонецФункции

Функция УстановитьПризнакПросмотренностиУВзаимодействий(ПользовательИд, СписокВзаимодействий)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		ИмяСобытия = ИмяСобытияЖР() + НСтр("ru = 'Установка признака просмотренности взаимодействия'");
		
		Параметры = Новый Структура;
		Параметры.Вставить("ИдентификаторПользователя", ПользовательИд);
		ЗалогироватьВходящиеПараметры(ИмяСобытия, Параметры);
		
		ИдентификаторПользователя = Новый УникальныйИдентификатор(ПользовательИд);
		Пользователь = Справочники.ПользователиСервисов.ПолучитьСсылку(ИдентификаторПользователя);
		Если Пользователь.ПолучитьОбъект() = Неопределено Тогда 
			ВызватьИсключение НСтр("ru = 'Не определен пользователь сервиса'");
		КонецЕсли;
		
		Для Каждого Взаимодействие Из СписокВзаимодействий.Interactions Цикл 
			
			ИдентификаторВзаимодействия = Новый УникальныйИдентификатор(Взаимодействие.Id);
			
			ОбъектВзаимодействия = Неопределено;
			Если Взаимодействие.Type = "Email" Тогда 
				Если Взаимодействие.Incoming Тогда 
					ОбъектВзаимодействия = Документы.ЭлектронноеПисьмоИсходящее.ПолучитьСсылку(ИдентификаторВзаимодействия).ПолучитьОбъект();
				Иначе
					ОбъектВзаимодействия = Неопределено;
				КонецЕсли;
			ИначеЕсли Взаимодействие.Type = "Comment" Тогда 
				ОбъектВзаимодействия = Документы.КомментарийПользователя.ПолучитьСсылку(ИдентификаторВзаимодействия).ПолучитьОбъект();
			ИначеЕсли Взаимодействие.Type = "PhoneCall" Тогда 
				ОбъектВзаимодействия = Документы.ТелефонныйЗвонок.ПолучитьСсылку(ИдентификаторВзаимодействия).ПолучитьОбъект();
			КонецЕсли;
			
			Если Взаимодействие.Incoming И ОбъектВзаимодействия <> Неопределено Тогда 
				ВзаимодействияУСП.УдалитьПризнакНеПросмотренности(ОбъектВзаимодействия.Ссылка, Пользователь);
			КонецЕсли;
			
		КонецЦикла;
		
		Возврат Истина;
	Исключение
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписатьОшибку(ИмяСобытия, ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
		
	КонецПопытки;
	
КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Функция ОбращениеXDTO(СтрокаТЗ, ЕстьНепросмотренныеВзаимодействия = Ложь)
	
	Пользователь = СтрокаТЗ.Инициатор;
	
	ПространствоИмен = ИнтеграцияСИнформационнымЦентром.ПространствоИмен_1_0_0_1();
	
	ТипОбращения = ФабрикаXDTO.Тип(ПространствоИмен, "Incident");
	ПредставлениеОбращения = ФабрикаXDTO.Создать(ТипОбращения);
	ПредставлениеОбращения.Id = Строка(СтрокаТЗ.Ссылка.УникальныйИдентификатор());
	ПредставлениеОбращения.Date = ПолучитьДатуСеанса(СтрокаТЗ.Дата, Пользователь);
	ПредставлениеОбращения.Name = Лев(СтрокаТЗ.Тема, 500);
	ПредставлениеОбращения.Number = СтрокаТЗ.НомерСокращенный;
	ПредставлениеОбращения.Status = ИмяСостоянияОбращенияДляПользователя(СтрокаТЗ.Состояние);
	
	Если ЕстьНепросмотренныеВзаимодействия Тогда
		НепросмотренныеВзаимодействия = НепросмотренныеВзаимодействияПоОбращению(СтрокаТЗ.Ссылка, Пользователь);
		Для Каждого НеПросмотренноеВзаимодействие Из НепросмотренныеВзаимодействия Цикл 
			ПредставлениеВзаимодействия = ВзаимодействиеXDTO(НеПросмотренноеВзаимодействие, Пользователь, Ложь, Ложь);
			ПредставлениеОбращения.UnreviewedInteractions.Добавить(ПредставлениеВзаимодействия);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ПредставлениеОбращения;
	
КонецФункции

Функция НепросмотренныеВзаимодействияПоОбращению(Обращение, ПользовательСервиса)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПользовательСервиса", ПользовательСервиса);
	Запрос.УстановитьПараметр("Обращение", Обращение);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НепросмотренныеДанныеИнициатором.Объект КАК Ссылка,
		|	НепросмотренныеДанныеИнициатором.Объект.Дата КАК Дата,
		|	НепросмотренныеДанныеИнициатором.Объект.Тема КАК Тема
		|ИЗ
		|	РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НепросмотренныеДанныеИнициатором КАК НепросмотренныеДанныеИнициатором
		|		ПО ПредметыПапкиВзаимодействий.Взаимодействие = НепросмотренныеДанныеИнициатором.Объект
		|ГДЕ
		|	ПредметыПапкиВзаимодействий.Предмет = &Обращение
		|	И НепросмотренныеДанныеИнициатором.ПользовательСервиса = &ПользовательСервиса
		|	И НЕ ПредметыПапкиВзаимодействий.НеПоказыватьПользователю";
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура ЗаполнитьПараметрыHTML(ФорматированныйДокумент, HTMLТекст, HTMLФайлы)
	
	ПространствоИмен = ИнтеграцияСИнформационнымЦентром.ПространствоИмен_1_0_0_1();
	
	СтруктураФайлов = Новый Структура;
	ФорматированныйДокумент.ПолучитьHTML(HTMLТекст, СтруктураФайлов);
	Для Каждого КлючИЗначение Из СтруктураФайлов Цикл 
		
		ТипФайла = ФабрикаXDTO.Тип(ПространствоИмен, "File");
		Файл = ФабрикаXDTO.Создать(ТипФайла);
		
		Файл.Name = КлючИЗначение.Ключ;
		Файл.Data = КлючИЗначение.Значение.ПолучитьДвоичныеДанные();
		
		HTMLФайлы.Добавить(Файл);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ВзаимодействиеXDTO(СтрокаТЗ, Пользователь, Просмотрено = Ложь, ПоказыватьВсеДанные = Ложь)
	
	ПространствоИмен = ИнтеграцияСИнформационнымЦентром.ПространствоИмен_1_0_0_1();
	
	ТипВзаимодействия = ФабрикаXDTO.Тип(ПространствоИмен, "Interaction");
	ПредставлениеВзаимодействия = ФабрикаXDTO.Создать(ТипВзаимодействия);
	ПредставлениеВзаимодействия.Id = Строка(СтрокаТЗ.Ссылка.УникальныйИдентификатор());
	ПредставлениеВзаимодействия.Date = ПолучитьДатуСеанса(СтрокаТЗ.Дата, Пользователь);
	ПредставлениеВзаимодействия.Name = Лев(СтрокаТЗ.Тема, 500);
	ПредставлениеВзаимодействия.Type = ТипВзаимодействияXDTO(СтрокаТЗ.Ссылка);
	ПредставлениеВзаимодействия.Incoming = ВходящееВзаимодействие(СтрокаТЗ.Ссылка);
	ПредставлениеВзаимодействия.Viewed = Просмотрено;
	ПредставлениеВзаимодействия.Description = ОписаниеВзаимодействия(СтрокаТЗ.Ссылка);
	ПредставлениеВзаимодействия.IsFiles = ЕстьВложенныеФайлыПоВзаимодействию(СтрокаТЗ.Ссылка);
	
	Если ПоказыватьВсеДанные Тогда 
		ЗаполнитьПараметрыHTMLВзаимодействия(СтрокаТЗ.Ссылка, ПредставлениеВзаимодействия);
		ЗаполнитьВложенныеФайлыВзаимодействия(СтрокаТЗ.Ссылка, ПредставлениеВзаимодействия);
	КонецЕсли;
	
	Возврат ПредставлениеВзаимодействия;
	
КонецФункции

Функция ОписаниеВзаимодействия(Взаимодействие)
	
	Если ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.КомментарийПользователя") Тогда
		Возврат Лев(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Взаимодействие, "Описание"), 2000);
	ИначеЕсли ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.ТелефонныйЗвонок") Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Взаимодействие, "Тема");
	ИначеЕсли ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Или ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Взаимодействие, "Текст, ТекстHTML");
		Если Не ПустаяСтрока(СтруктураРеквизитов.ТекстHTML) Тогда
			ФД = Новый ФорматированныйДокумент;
			ФД.УстановитьHTML(СтруктураРеквизитов.ТекстHTML, Новый Структура);
			Возврат Лев(ФД.ПолучитьТекст(), 2000);
		Иначе
			Возврат Лев(СтруктураРеквизитов.Текст, 2000);
		КонецЕсли;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Процедура ЗаполнитьВложенныеФайлыВзаимодействия(Взаимодействие, ПредставлениеВзаимодействия)
	
	Если ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Или ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда 
		ТаблицаВложения = УправлениеЭлектроннойПочтой.ПолучитьВложенияЭлектронногоПисьма(Взаимодействие, Истина);
		Если ТаблицаВложения.Количество() > 0 Тогда
			НайденныеСтроки = ТаблицаВложения.НайтиСтроки(Новый Структура("ИДФайлаЭлектронногоПисьма", ""));
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл 
				ДобавитьПрисоединенныйФайлКВзаимодействию(ПредставлениеВзаимодействия, НайденнаяСтрока.Ссылка);
			КонецЦикла;
		КонецЕсли;
	Иначе
		МассивФайлов = Новый Массив;
		ПрисоединенныеФайлы.ПолучитьПрикрепленныеФайлыКОбъекту(Взаимодействие, МассивФайлов);
		Для Каждого ПриложенныйФайл Из МассивФайлов Цикл 
			ДобавитьПрисоединенныйФайлКВзаимодействию(ПредставлениеВзаимодействия, ПриложенныйФайл);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьПрисоединенныйФайлКВзаимодействию(ПредставлениеВзаимодействия, ПрисоединенныйФайл)
	
	ПространствоИмен = ИнтеграцияСИнформационнымЦентром.ПространствоИмен_1_0_0_1();
	
	ТипФайла = ФабрикаXDTO.Тип(ПространствоИмен, "File");
	Файл = ФабрикаXDTO.Создать(ТипФайла);
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПрисоединенныйФайл, "Наименование, Расширение, Размер");
	Файл.Name = СтруктураРеквизитов.Наименование;
	Файл.Extension = СтруктураРеквизитов.Расширение;
	Файл.Size = СтруктураРеквизитов.Размер;
	Файл.Id = Строка(ПрисоединенныйФайл.УникальныйИдентификатор());
	ПредставлениеВзаимодействия.Files.Добавить(Файл);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыHTMLВзаимодействия(Взаимодействие, ПредставлениеВзаимодействия)
	
	ПространствоИмен = ИнтеграцияСИнформационнымЦентром.ПространствоИмен_1_0_0_1();
	
	Если ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.КомментарийПользователя") Тогда 
		ХранилищеСОписанием = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Взаимодействие, "ОписаниеХранилище");
		ФорматированныйДокумент = ХранилищеСОписанием.Получить();
		Если ТипЗнч(ФорматированныйДокумент) = Тип("ФорматированныйДокумент") Тогда 
			ЗаполнитьПараметрыHTML(ФорматированныйДокумент, ПредставлениеВзаимодействия.HTMLText, ПредставлениеВзаимодействия.HTMLFiles);
		КонецЕсли;
	ИначеЕсли ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Или ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда 
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Взаимодействие, "Текст, ТекстHTML");
		Если Не ПустаяСтрока(СтруктураРеквизитов.ТекстHTML) Тогда 
			ПредставлениеВзаимодействия.HTMLText = ОбработатьТекстHTML(СтруктураРеквизитов.ТекстHTML);
			СписокФайлов = Взаимодействия.ПолучитьВложенияПисьмаСНеПустымИД(Взаимодействие);
			Для Каждого ВложенныйФайл Из СписокФайлов Цикл 
				ТипФайла = ФабрикаXDTO.Тип(ПространствоИмен, "File");
				Файл = ФабрикаXDTO.Создать(ТипФайла);
				Файл.Name = ВложенныйФайл.ИДФайлаЭлектронногоПисьма;
				Файл.Data = ПрисоединенныеФайлы.ПолучитьДвоичныеДанныеФайла(ВложенныйФайл.Ссылка);
				ПредставлениеВзаимодействия.HTMLFiles.Добавить(Файл);
			КонецЦикла;
		Иначе
			ВложенияHTML = Новый Структура;
			ФорматированныйДокумент = Новый ФорматированныйДокумент;
			ФорматированныйДокумент.УстановитьФорматированнуюСтроку(Новый ФорматированнаяСтрока(СтруктураРеквизитов.Текст));
			ФорматированныйДокумент.ПолучитьHTML(ПредставлениеВзаимодействия.HTMLText, ВложенияHTML);
		КонецЕсли;
	ИначеЕсли ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.ТелефонныйЗвонок") Тогда 
		ВложенияHTML = Новый Структура;
		Текст = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Взаимодействие, "Описание");
		ФорматированныйДокумент = Новый ФорматированныйДокумент;
		ФорматированныйДокумент.УстановитьФорматированнуюСтроку(Новый ФорматированнаяСтрока(Текст));
		ФорматированныйДокумент.ПолучитьHTML(ПредставлениеВзаимодействия.HTMLText, ВложенияHTML);
	КонецЕсли;
	
КонецПроцедуры

Функция ЕстьВложенныеФайлыПоВзаимодействию(Взаимодействие)
	
	МассивФайлов = Новый Массив;
	ПрисоединенныеФайлы.ПолучитьПрикрепленныеФайлыКОбъекту(Взаимодействие, МассивФайлов);
	
	Возврат (МассивФайлов.Количество() <> 0);
	
КонецФункции

Функция ТипВзаимодействияXDTO(Взаимодействие)
	
	Если ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.КомментарийПользователя") Тогда 
		Возврат "Comment";
	ИначеЕсли ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Тогда 
		Возврат "Email";
	ИначеЕсли ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда 
		Возврат "Email";
	ИначеЕсли ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.ТелефонныйЗвонок") Тогда 
		Возврат "PhoneCall";
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ВходящееВзаимодействие(Взаимодействие)
	
	Если ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.КомментарийПользователя") Тогда 
		Возврат Ложь;
	ИначеЕсли ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Тогда 
		Возврат Ложь;
	ИначеЕсли ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда 
		Возврат Истина;
	ИначеЕсли ТипЗнч(Взаимодействие) = Тип("ДокументСсылка.ТелефонныйЗвонок") Тогда 
		Возврат Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Взаимодействие, "Входящий");;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ИмяСостоянияОбращенияДляПользователя(СостояниеОбращения)
	
	Если СостояниеОбращения = Перечисления.СостоянияОбращений.Закрыто Тогда 
		Возврат "Closed";
	ИначеЕсли СостояниеОбращения = Перечисления.СостоянияОбращений.Исправление Тогда 
		Возврат "InProgress";
	ИначеЕсли СостояниеОбращения = Перечисления.СостоянияОбращений.Расследование Тогда 
		Возврат "InProgress";
	ИначеЕсли СостояниеОбращения = Перечисления.СостоянияОбращений.Новое Тогда 
		Возврат "New";
	ИначеЕсли СостояниеОбращения = Перечисления.СостоянияОбращений.ОжиданиеИнициатора Тогда 
		Возврат "NeedAnswer";
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция ФорматированныйДокументИзДанных(HTMLТекст, Файлы)
	
	СтруктураФайлов = Новый Структура;
	
	ПозицияНачалаДанных = Найти(HTMLТекст, "<!-- @AddInfo");
    Если ПозицияНачалаДанных <> 0 Тогда
		СтрокаДанных = Сред(HTMLТекст, ПозицияНачалаДанных + 13);
        СтрокаДанных = Лев(СтрокаДанных, СтрДлина(СтрокаДанных) - 4);
        ЧтениеJSON = Новый ЧтениеJSON;
        ЧтениеJSON.УстановитьСтроку(СтрокаДанных);
        Данные = ПрочитатьJSON(ЧтениеJSON);
		Если Данные.Свойство("descriptionImages") Тогда
			Изображения = Данные.descriptionImages;
			Для Каждого Изображение Из Изображения Цикл
				ДвоичныеДанные = Base64Значение(Изображение.Значение);
                СтруктураФайлов.Вставить(Изображение.Ключ, Новый Картинка(ДвоичныеДанные));
				
				ТипФайла = ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/InformationCenter/SupportServiceData/1.0.0.1", "File");
				ФайлОбъект = ФабрикаXDTO.Создать(ТипФайла);
				ФайлОбъект.Name = Изображение.Ключ;
				ФайлОбъект.Data = Изображение.Значение;
				ФайлОбъект.Extension = Прав(Изображение.Ключ, СтрНайти(Изображение.Ключ, ".", НаправлениеПоиска.СКонца)-1);
				ФайлОбъект.Size = ДвоичныеДанные.Размер;
				Файлы.Files.Добавить(ФайлОбъект);
			КонецЦикла;
		КонецЕсли;
    КонецЕсли;
	
	ФД = Новый ФорматированныйДокумент;
	ФД.УстановитьHTML(HTMLТекст, СтруктураФайлов);
	
	Возврат ФД;
	
КонецФункции

Функция АбонентПриложенияПоУмолчанию(Сервис, КодПриложения)
	
	Если Сервис.Пустая() Или КодПриложения = 0 Тогда 
		Возврат Справочники.Абоненты.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КодПриложения", КодПриложения);
	Запрос.УстановитьПараметр("Сервис", Сервис);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Приложения.Абонент КАК Абонент
		|ИЗ
		|	Справочник.Приложения КАК Приложения
		|ГДЕ
		|	Приложения.Код = &КодПриложения
		|	И НЕ Приложения.ПометкаУдаления
		|	И Приложения.Владелец = &Сервис";
	ВыборкаАбонентов = Запрос.Выполнить().Выбрать();
	Пока ВыборкаАбонентов.Следующий() Цикл 
		Возврат ВыборкаАбонентов.Абонент;
	КонецЦикла;
	
	Возврат Справочники.Абоненты.ПустаяСсылка();
	
КонецФункции

Функция АбонентПользователяПоУмолчанию(ПользовательСервиса)
	
	Если ПользовательСервиса.Пустая() Тогда 
		Возврат Справочники.Абоненты.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПользовательСервиса", ПользовательСервиса);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПользователиАбонентов.Абонент КАК Абонент
		|ИЗ
		|	РегистрСведений.ПользователиАбонентов КАК ПользователиАбонентов
		|ГДЕ
		|	ПользователиАбонентов.ПользовательСервиса = &ПользовательСервиса
		|	И НЕ ПользователиАбонентов.Абонент.ПометкаУдаления";
	ВыборкаАбонентов = Запрос.Выполнить().Выбрать();
	Пока ВыборкаАбонентов.Следующий() Цикл 
		Возврат ВыборкаАбонентов.Абонент;
	КонецЦикла;
	
	Возврат Справочники.Абоненты.ПустаяСсылка();
	
КонецФункции

Функция ЕстьАдресЭлектроннойПочты(Пользователь, АдресЭлектроннойПочты)
	
	Если Пользователь.Пустая() Или ПустаяСтрока(АдресЭлектроннойПочты) Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(Пользователь);
	
	МассивВидовКИ = Новый Массив;
	МассивВидовКИ.Добавить(Справочники.ВидыКонтактнойИнформации.EmailПользователяСервиса);
	МассивВидовКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ДополнительныйEmailПользователяСервиса);
	
	ТаблицаКИ = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(МассивОбъектов, Неопределено, МассивВидовКИ);
	Если ТаблицаКИ.Количество() = 0 Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	Фильтр = Новый Структура("Представление", АдресЭлектроннойПочты);
	МассивСтрок = ТаблицаКИ.НайтиСтроки(Фильтр);
	
	Возврат (МассивСтрок.Количество() <> 0);
	
КонецФункции

Функция ПолучитьДатуСеанса(Дата, Пользователь)
	
	Возврат МестноеВремя(Дата, ЧасовойПоясСеанса());
	
КонецФункции

Функция ОбработатьТекстHTML(Знач ТекстHTML)
	
	Если СтрЧислоВхождений(ТекстHTML,"<html") = 0 Тогда
		ТекстHTML = "<html>" + ТекстHTML + "</html>"
	КонецЕсли;
	
	Возврат ТекстHTML;
	
КонецФункции

Функция ИмяСобытияЖР()
	
	Возврат ИнтеграцияСИнформационнымЦентром.СобытиеЖурналаРегистрации() + НСтр("ru = 'Обращения пользователей.'");
	
КонецФункции

Процедура ЗаписатьОшибку(ИмяСобытия, Комментарий)
	
	ЗаписьЖурналаРегистрации(ИмяСобытия,
		УровеньЖурналаРегистрации.Ошибка,
		Метаданные.WebСервисы.InformationCenterIntegration_1_0_0_1,
		,
		Комментарий);
	
КонецПроцедуры

Процедура ЗалогироватьВходящиеПараметры(ИмяСобытия, Параметры)
	
	ШаблонПараметра = "%1 = ""%2""";
	
	ТекстКомментария = НСтр("ru = 'Параметры:
                   |'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
	Для Каждого КлючИЗначение Из Параметры Цикл
		
		
		ТекстКомментария = ТекстКомментария
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПараметра, КлючИЗначение.Ключ, КлючИЗначение.Значение)
			+ Символы.ПС;
		
	КонецЦикла;
	
	ЗаписьЖурналаРегистрации(ИмяСобытия,
		УровеньЖурналаРегистрации.Информация,
		Метаданные.WebСервисы.InformationCenterIntegration_1_0_0_1,
		,
		ТекстКомментария);
	
КонецПроцедуры

#КонецОбласти 

