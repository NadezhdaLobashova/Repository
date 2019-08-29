
////////////////////////////////////////////////////////////////////////////////
// Redmine

Функция ПараметрыПодключенияRedmine()

	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("Ключ", "23416e5537507dc14346cda828a22e59c3c72128");
	ПараметрыПодключения.Вставить("Сервер", "bt.rarus.ru");
	ПараметрыПодключения.Вставить("Порт", 443);
	ПараметрыПодключения.Вставить("Путь", "/redmine");
	ПараметрыПодключения.Вставить("РазмерПорции", 100);
	
	Возврат ПараметрыПодключения;
	
КонецФункции

Функция ПолучитьЗадачиПоПроекту(RedmineProjectId) Экспорт

	МассивЗадач = Новый Массив;
	
	Смещение = 0;
	РазмерПорции = ПараметрыПодключенияRedmine().РазмерПорции;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("status_id", "*"); //Получать как открытые, так и закрытые задачи
	ПараметрыЗапроса.Вставить("offset", Смещение);
	ПараметрыЗапроса.Вставить("limit", РазмерПорции);
	ПараметрыЗапроса.Вставить("project_id", RedmineProjectId);
	
	ВсегоЗадач = 0;
	СчитаноЗадач = 0;	
	ПерваяИтерация = Истина;
	
	//Получить все задачи с использованием постраничной навигации
	Пока ВсегоЗадач > СчитаноЗадач ИЛИ ПерваяИтерация Цикл
		
		Ответ = GetЗапрос("issues", ПараметрыЗапроса);
		Если ПустаяСтрока(Ответ) Тогда
			ВызватьИсключение "Сервер вернул пустой ответ";			
		КонецЕсли;
		Данные = СтруктураИзФайлаXML(Ответ, "issues");
		
		Если ПерваяИтерация Тогда
			Если Данные.Свойство("total_count") Тогда
				ВсегоЗадач = Число(Данные["total_count"]); //to-do: необходимо конвертировать с помощью xdto				
			КонецЕсли;
			ПерваяИтерация = Ложь;
		КонецЕсли;
		
		Если НЕ Данные.Свойство("issue") Тогда
			Прервать;							
		КонецЕсли;
		
		КоллекцияЗадач = Данные["issue"];
		//Если загружена одна задача - она возвращается структурой
		Если ТипЗнч(КоллекцияЗадач) = Тип("Структура") Тогда
			МассивЗадач.Добавить(КоллекцияЗадач);
			КоличествоСчитанныхЗадач = 1; 	
		Иначе
			//Добавляем каждую задачу в результирующий массив 
			Для каждого Задача Из КоллекцияЗадач Цикл
				МассивЗадач.Добавить(Задача);
			КонецЦикла; 
			КоличествоСчитанныхЗадач = КоллекцияЗадач.Количество();
		КонецЕсли;
		
		СчитаноЗадач = СчитаноЗадач + КоличествоСчитанныхЗадач;					
		Смещение = Смещение + РазмерПорции;
		ПараметрыЗапроса.Вставить("offset", Смещение);
		
	КонецЦикла;
	
	// обработка массива задач для дальнейшего использования
	Результат = Новый Массив;
	
	Для Каждого ЗадачаRedmine Из МассивЗадач Цикл
		Задача = Новый Структура("RedmineIssueId, ДатаСоздания, ДатаЗакрытия, Тема, Описание, Задача, Импортировать");
		Задача.RedmineIssueId = "к" + Формат(ЗадачаRedmine["id"], "ЧГ=");
		Задача.ДатаСоздания = КонвертироватьДату(ЗадачаRedmine["created_on"]);
		Задача.ДатаЗакрытия = КонвертироватьДату(ЗадачаRedmine["closed_on"]);
		Задача.Тема = ЗадачаRedmine["subject"];
		Задача.Описание = ЗадачаRedmine["description"];
		
		// постобработка описания
		Пока Найти(Задача.Описание, "  ") Цикл
			Задача.Описание = СтрЗаменить(Задача.Описание, "  ", " ");
		КонецЦикла;
		Пока Найти(Задача.Описание, Символы.ПС + Символы.ПС + Символы.ПС) Цикл
			Задача.Описание = СтрЗаменить(Задача.Описание, Символы.ПС + Символы.ПС + Символы.ПС, Символы.ПС + Символы.ПС);
		КонецЦикла;
		
		// подбор задач из базы
		ЗадачаСсылка = Справочники.Задачи.НайтиПоРеквизиту("RedmineIssueId", Задача.RedmineIssueId);
		Задача.Задача = ЗадачаСсылка;
		//Задача.Импортировать = НЕ ЗначениеЗаполнено(Задача.Задача);
		Задача.Импортировать = Ложь;
		
		Результат.Добавить(Задача);
	КонецЦикла; 
	
	Возврат Результат;

КонецФункции // ПолучитьВсеЗадачиПоКодуПроекта()

Функция КонвертироватьДату(Знач ДатаСтрокой)
	
	Если ТипЗнч(ДатаСтрокой) <> Тип("Строка") Тогда
		Возврат Дата(1, 1, 1);	
	КонецЕсли;
	
	//2014-01-02T08:12:32Z	
	ДатаСтрокой = СтрЗаменить(ДатаСтрокой, "-", "");
	ДатаСтрокой = СтрЗаменить(ДатаСтрокой, ":", "");
	ДатаСтрокой = СтрЗаменить(ДатаСтрокой, "T", "");
	ДатаСтрокой = СтрЗаменить(ДатаСтрокой, "Z", "");
	
	Возврат Дата(ЛЕВ(ДатаСтрокой, 14));

КонецФункции

Функция GetЗапрос(Путь, ПараметрыЗапроса = Неопределено)
	
	СтрокаПараметров = "";
	Если НЕ ПараметрыЗапроса = Неопределено Тогда
		Для каждого КлючИЗначение Из ПараметрыЗапроса Цикл
			СтрокаПараметров = СтрокаПараметров + ?(ПустаяСтрока(СтрокаПараметров), "", "&") + КлючИЗначение.Ключ + "=" + КлючИЗначение.Значение;
		КонецЦикла;
	КонецЕсли;
	СтрокаПараметров = ?(ПустаяСтрока(СтрокаПараметров), "", "?" + СтрокаПараметров);
		
	Если ПараметрыПодключенияRedmine().Порт=443 Тогда
		Соединение = Новый HTTPСоединение(ПараметрыПодключенияRedmine().Сервер,
										 	ПараметрыПодключенияRedmine().Порт , , , , , 
										 	Новый ЗащищенноеСоединениеOpenSSL());		
	Иначе
		Соединение = Новый HTTPСоединение(ПараметрыПодключенияRedmine().Сервер,
											ПараметрыПодключенияRedmine().Порт);
	КонецЕсли;
	
	Шаблон = "%1/%2.xml%3";
	ТекстЗапроса = СтрЗаменить(Шаблон, "%1", ПараметрыПодключенияRedmine().Путь);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%2", Путь);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%3", СтрокаПараметров);

	ЗапросКСайту = Новый HTTPЗапрос(ТекстЗапроса, ЗаголовокЗапроса());
	HTTPОтвет = Соединение.Получить(ЗапросКСайту);
	Возврат HTTPОтвет.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	
КонецФункции

Функция ЗаголовокЗапроса(ДопЗаголовоки = Неопределено)
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type","application/xml");
	Заголовки.Вставить("X-Redmine-API-Key", ПараметрыПодключенияRedmine().Ключ);
	Если ДопЗаголовоки <> Неопределено Тогда
		Для Каждого КлючИЗначение Из ДопЗаголовоки Цикл
			Заголовки.Вставить(КлючИЗначение.Ключ,КлючИЗначение.Значение);	
		КонецЦикла;	
	КонецЕсли;
	Возврат Заголовки;
КонецФункции

Функция СтруктураИзОбъектаXDTO(АнализируемыйОбъект)
	СтруктураОбъекта = Новый Структура();
	Для каждого СвойстваОбъекта Из АнализируемыйОбъект.Свойства() Цикл
		Если ТипЗнч(АнализируемыйОбъект[СвойстваОбъекта.Имя])=Тип("Строка") Тогда
			СтруктураОбъекта.Вставить(СвойстваОбъекта.Имя,АнализируемыйОбъект[СвойстваОбъекта.Имя]);
		ИначеЕсли ТипЗнч(АнализируемыйОбъект[СвойстваОбъекта.Имя])=Тип("ОбъектXDTO") Тогда
			СтруктураОбъекта.Вставить(СвойстваОбъекта.Имя, СтруктураИзОбъектаXDTO(АнализируемыйОбъект[СвойстваОбъекта.Имя]));
		ИначеЕсли ТипЗнч(АнализируемыйОбъект[СвойстваОбъекта.Имя])=Тип("СписокXDTO") Тогда
			МассивОбъектов = Новый Массив;
			Для каждого текОбъект Из АнализируемыйОбъект[СвойстваОбъекта.Имя] Цикл
				МассивОбъектов.Добавить(СтруктураИзОбъектаXDTO(текОбъект));
			КонецЦикла;
			СтруктураОбъекта.Вставить(СвойстваОбъекта.Имя,МассивОбъектов);
		КонецЕсли;
	КонецЦикла;
	Возврат СтруктураОбъекта;
КонецФункции

Функция СтруктураИзФайлаXML(ТекстФайла, ТипОбъекта)
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ТекстФайла);
	ТипДанныхXDTO = ФабрикаXDTO.Тип("http://www.rarus.redmine.ru", ТипОбъекта);
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ТипДанныхXDTO);
	СтруктураОбъекта = СтруктураИзОбъектаXDTO(ОбъектXDTO);	
	ЧтениеXML.Закрыть();
	Возврат СтруктураОбъекта;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// 

Процедура ФоноваяСинхронизацияЗадач() Экспорт

	ДатаПрошлойЗагрузки = НачалоДня(Константы.ДатаСинхронизацииЗадачRedmineКорп.Получить());
	ДатаТекущейЗагрузки = ТекущаяДата();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Проекты.Ссылка КАК Проект,
	               |	Проекты.RedmineProjectId
	               |ИЗ
	               |	Справочник.Проекты КАК Проекты
	               |ГДЕ
	               |	Проекты.RedmineProjectId <> """"";
	ТаблицаПроектов = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаПроектов Из ТаблицаПроектов Цикл
		
		Попытка
			МассивЗадач = ПолучитьЗадачиПоПроекту(СтрокаПроектов.RedmineProjectId);
			Для Каждого ЗадачаRedmine Из МассивЗадач Цикл
				Если ЗначениеЗаполнено(ЗадачаRedmine.ДатаЗакрытия) Тогда
					ЗакрытьЗадачу(ЗадачаRedmine);
				ИначеЕсли ЗадачаRedmine.ДатаСоздания > ДатаПрошлойЗагрузки Тогда
					ИмпортироватьЗадачу(ЗадачаRedmine, СтрокаПроектов.Проект);
				КонецЕсли;
			КонецЦикла;
		Исключение
			ЗаписьЖурналаРегистрации("ИспортЗадачRedmine", УровеньЖурналаРегистрации.Ошибка, , , "Возникла ошибка при загрузке задач по проекту: " + СтрокаПроектов.Проект + Символы.ПС + ОписаниеОшибки());
		КонецПопытки;
		
	КонецЦикла;
	
	Константы.ДатаСинхронизацииЗадачRedmineКорп.Установить(ДатаТекущейЗагрузки);

КонецПроцедуры

Процедура ЗакрытьЗадачу(ЗадачаRedmine) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ЗадачаRedmine.Задача) Тогда
		// не нашли в базе сопоставленную задачу, значит и закрыть ее не можем
		// решил не спамить в ЖР, таких ситуаций может быть потенциально много и отслеживать их не обязательно
		//ЗаписьЖурналаРегистрации("ИспортЗадачRedmine", УровеньЖурналаРегистрации.Ошибка, , , "Не удалось закрыть задачу, так как она отсутствует в базе. Redmine Issue Id = " + ЗадачаRedmine.RedmineIssueId);
		Возврат;
	КонецЕсли;
	
	Если ЗадачаRedmine.Задача.Закрыта Тогда
		Возврат;
	КонецЕсли;
	
	ЗадачаОбъект = ЗадачаRedmine.Задача.ПолучитьОбъект();
	ЗадачаОбъект.Окончание = ЗадачаRedmine.ДатаЗакрытия;
	ЗадачаОбъект.Закрыта = Истина;
	ЗадачаОбъект.Записать();
	
КонецПроцедуры

Процедура ИмпортироватьЗадачу(ЗадачаRedmine, Проект) Экспорт
	
	Если ЗначениеЗаполнено(ЗадачаRedmine.Задача) Тогда
		Возврат;
	КонецЕсли;
	
	ЗадачаОбъект = Справочники.Задачи.СоздатьЭлемент();
	ЗадачаОбъект.Код = Формат(ЗадачаRedmine.RedmineIssueId, "ЧГ=");
	ЗадачаОбъект.Наименование = ЗадачаRedmine.Тема;
	ЗадачаОбъект.Владелец = Проект;
	ЗадачаОбъект.ДатаСоздания = ЗадачаRedmine.ДатаСоздания;
	ЗадачаОбъект.Описание = ЗадачаRedmine.Описание;
	ЗадачаОбъект.RedmineIssueId = ЗадачаRedmine.RedmineIssueId;
	ЗадачаОбъект.Записать();
	
КонецПроцедуры

