#Область Процедуры_Команды_На_Форме
&НаКлиенте
Процедура ЗаполнитьGUID(Команда)
   ЗаполнитьGUIDНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура ВыполинтьЗаполнениеGUIDУРВ(Команда)
	ВыполинтьЗаполнениеGUIDУРВНпСервере();
КонецПроцедуры

#КонецОбласти

#Область Общие_Процедуры_И_Функции
Процедура ЗаполнитьGUIDНаСервере()
	Попытка
		Подключение = УстановитьПодключениеКВебСервису();
	Исключение
		СообщитьПользователю("Подключение не установлено. Обратитесь к администратору.");
		Возврат 
	КонецПопытки;
	
	//получим список проектов
	ОбъектXDTO = Подключение.GetProject();
	СписокXDTO = ОбъектXDTO.TablePr;
	ЗаполнитьТаблицуПроекты(СписокXDTO);
	
	//получим список пользователей
	ОбъектXDTO = Подключение.GetEmployee();
	СписокXDTO = ОбъектXDTO.TableEmp;
	ЗаполнитьТаблицуПользователей(СписокXDTO);
	
	//Получим список контрагентов
	ОбъектXDTO = Подключение.GetPartner();
	СписокXDTO = ОбъектXDTO.TablePar;
	ЗаполинтьТаблицуКонтрагентов(СписокXDTO);
	
	СообщитьПользователю("Заполнение таблиц завершено.");
КонецПроцедуры

Функция УстановитьПодключениеКВебСервису()
	
	Порт = Константы.ОБД_Порт.Получить();
	//Порт = ?(ЗначениеЗаполнено(ПортКонстанта),ПортКонстанта,"http://shangtsung/rarus_copy/ws/OBDExchange?wsdl");
	
	Пользователь = Константы.ОБД_Пользователь.Получить();
	//Пользователь = ?(ЗначениеЗаполнено(ПользовательКонстанта),ПользовательКонстанта,"wedServerUser");
	
	Пароль = Константы.ОБД_Пароль.Получить();
	//Пароль = ?(ЗначениеЗаполнено(ПарольКонстанта),ПарольКонстанта,"1");
	
	Определение = Новый WSОпределения(Порт, Пользователь, Пароль);
		
	Прокси = Новый WSПрокси(Определение, URMExchangeСервер.ПолучитьПространствоИмен(), "OBDExchange",  Определение.Сервисы[0].ТочкиПодключения[0].Имя);
	Прокси.Пользователь = Пользователь;
	Прокси.Пароль = Пароль;
		
	Возврат Прокси;
	
КонецФункции

Процедура ЗаполнитьТаблицуПроекты(СписокXDTO)
	Для Каждого ЗначениеXDTO из СписокXDTO Цикл
		СтрокаДанных           = ЭтотОбъект.ТаблицаПроекты.Добавить();
		СтрокаДанных.ПроектОБД = ЗначениеXDTO.NameProject;
		СтрокаДанных.GUID      = ЗначениеXDTO.GUIDProject;
	КонецЦикла;	
КонецПроцедуры	

Процедура ЗаполнитьТаблицуПользователей(СписокXDTO)
	Для Каждого ЗначениеXDTO из СписокXDTO Цикл
		СтрокаДанных              = ЭтотОбъект.ТаблицаПользователей.Добавить();
		СтрокаДанных.Пользователь = ЗначениеXDTO.Name;
		СтрокаДанных.GUID         = ЗначениеXDTO.GUID;
	КонецЦикла;	
КонецПроцедуры

Процедура ЗаполинтьТаблицуКонтрагентов(СписокXDTO)
	Для Каждого ЗначениеXDTO из СписокXDTO Цикл
		СтрокаДанных               = ЭтотОбъект.ТаблицаКонтрагенты.Добавить();
		СтрокаДанных.КонтрагентОБД = ЗначениеXDTO.Name;
		СтрокаДанных.GUID          = ЗначениеXDTO.GUIDPartner;
	КонецЦикла;	
КонецПроцедуры

Процедура ВыполинтьЗаполнениеGUIDУРВНпСервере()
	МассивПользователей = ЭтотОбъект.ТаблицаПользователей.НайтиСтроки(Новый Структура("Выбрать",Истина));
	Для Каждого СтрокаПользователь из МассивПользователей Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаПользователь.ПользовательУРВ) или Не ЗначениеЗаполнено(СтрокаПользователь.GUID) Тогда
			Продолжить;
		КонецЕсли;
		ПользовательСсылка         = СтрокаПользователь.ПользовательУРВ.ПолучитьОбъект();
		ПользовательСсылка.GUIDОБД = Новый УникальныйИдентификатор(СтрокаПользователь.GUID);
		Попытка
			ПользовательСсылка.Записать();
		Исключение
			СообщитьПользователю("Не удалось записать GUID ОБД для " + СокрЛП(СтрокаПользователь.ПользовательУРВ));
			Продолжить;
		КонецПопытки;	
	КонецЦикла;
	
	МассивПроектов = ЭтотОбъект.ТаблицаПроекты.НайтиСтроки(Новый Структура("Выбрать",Истина));
	Для Каждого СтрокаПроект из МассивПроектов Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаПроект.ПроектУРВ) или Не ЗначениеЗаполнено(СтрокаПроект.GUID) Тогда
			Продолжить;
		КонецЕсли;
		ПроектСсылка         = СтрокаПроект.ПроектУРВ.ПолучитьОбъект();
		ПроектСсылка.GUIDОБД =  Новый УникальныйИдентификатор(СтрокаПроект.GUID);
		Попытка
			ПроектСсылка.Записать();
		Исключение
			СообщитьПользователю("Не удалось записать GUID ОБД для " + СокрЛП(ПроектСсылка.ПроектУРВ));
			Продолжить;
		КонецПопытки;	
	КонецЦикла;
	
	МассивКонтрагентов = ЭтотОбъект.ТаблицаКонтрагенты.НайтиСтроки(Новый Структура("Выбрать",Истина));
	Для Каждого СтрокаКонтрагент из МассивКонтрагентов Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаКонтрагент.КонтрагентУРВ) или Не ЗначениеЗаполнено(СтрокаКонтрагент.GUID) Тогда
			Продолжить;
		КонецЕсли;
		КонтрагентСсылка         = СтрокаКонтрагент.КонтрагентУРВ.ПолучитьОбъект();
		КонтрагентСсылка.GUIDОБД =  Новый УникальныйИдентификатор(СтрокаКонтрагент.GUID);
		Попытка
			ПроектСсылка.Записать();
		Исключение
			СообщитьПользователю("Не удалось записать GUID ОБД для " + СокрЛП(СтрокаКонтрагент.КонтрагентУРВ));
			Продолжить;
		КонецПопытки;	
	КонецЦикла;

	
КонецПроцедуры	
#КонецОбласти

#Область СООБЩЕНИЯ_ПОЛЬЗОВАТЕЛЮ
Процедура СообщитьПользователю(ТекстСообщения)
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщения;
	Сообщение.УстановитьДанные(ЭтотОбъект);
	Сообщение.Сообщить();
КонецПроцедуры


#КонецОбласти
