
#Область ПрограммныйИнтерфейс
    
// Возвращает подразделение для переданного пользователя.
//
Функция ЛинияПоддержкиПользователя(Пользователь) Экспорт 

	Если Не ЗначениеЗаполнено(Пользователь) Тогда 
		Возврат Справочники.ЛинииПоддержки.ПустаяСсылка();
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СведенияОПользователях.ЛинияПоддержки КАК ЛинияПоддержки
	|ИЗ
	|	РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
	|ГДЕ
	|	СведенияОПользователях.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", Пользователь);

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Справочники.ЛинииПоддержки.ПустаяСсылка();
	КонецЕсли;

	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.ЛинияПоддержки;

КонецФункции

// Возвращает руководителя для переданного пользователя.
//
Функция РуководительПользователя(Пользователь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СведенияОПользователях.ЛинияПоддержки КАК ЛинияПоддержки,
	|	СведенияОПользователях.ЛинияПоддержки.Руководитель КАК Руководитель
	|ИЗ
	|	РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
	|ГДЕ
	|	СведенияОПользователях.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	ЛинияПоддержки = Выборка.ЛинияПоддержки;
	Если Выборка.Руководитель <> Пользователь Тогда 
		Возврат Выборка.Руководитель;
	КонецЕсли;
	
	Пока ЗначениеЗаполнено(ЛинияПоддержки.Родитель)  Цикл
		ЛинияПоддержки = ЛинияПоддержки.Родитель;
		Если ЛинияПоддержки.Руководитель <> Пользователь Тогда 
			Возврат ЛинияПоддержки.Руководитель;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЛинияПоддержки.Руководитель;
	
КонецФункции

// По части наименования формирует список для выбора пользователей и ролей пользователей.
// Параметры:
//		Текст - часть наименования, по которому выполняется поиск.
//		ВключатьАвтоподстановку - флаг, показывающий необходимость использования функций
//                                автоподстановки для получения значений для выбора.
//		ИменаПредметовДляФункций - массив ссылок на имена предметов для функций, 
//                                 получающих данные из предметов процессов.
// Возвращает:
//		СписокЗначений, содержащий ссылки на найденные по части наименования объекты.
Функция СформироватьДанныеВыбораИсполнителя(Текст, ВключатьАвтоподстановку = Ложь) Экспорт
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Пользователи.Ссылка КАК Ссылка,
		|	СведенияОПользователях.ЛинияПоддержки КАК ЛинияПоддержки
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
		|		ПО Пользователи.Ссылка = СведенияОПользователях.Пользователь
		|ГДЕ
		|	Пользователи.Наименование ПОДОБНО &Текст
		|	И Пользователи.Недействителен = ЛОЖЬ
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РолиИсполнителей.Ссылка,
		|	NULL
		|ИЗ
		|	Справочник.РолиИсполнителей КАК РолиИсполнителей
		|ГДЕ
		|	РолиИсполнителей.Наименование ПОДОБНО &Текст";
		
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Подразделение) Тогда 
			ДанныеВыбора.Добавить(Выборка.Ссылка, Строка(Выборка.Ссылка) + " (" + Строка(Выборка.ЛинияПоддержки) + ")");
		Иначе	
			ДанныеВыбора.Добавить(Выборка.Ссылка);
		КонецЕсли;	
	КонецЦикла;	
	
	Если ВключатьАвтоподстановку Тогда 
		ДоступныеФункции = ШаблоныБизнесПроцессов.СписокДоступныхФункций();
		Для Каждого ЭлементСписка Из ДоступныеФункции Цикл
			Если НРег(Лев(ЭлементСписка.Представление, СтрДлина(Текст))) = НРег(Текст) Тогда 
				ДанныеВыбора.Добавить(ЭлементСписка.Представление);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ДанныеВыбора;
	
КонецФункции

// Возвращает пользователей переданного подразделения.
//
// Параметры:
//  ЛинияПоддержки - СправочникСсылка.ЛинииПоддержки - Линия поддержки, пользователи которого возвращаются.
//  СУчетомИерархии - Булево - если Истина, то возвращаются пользователи переданного и подчиненных подразделений,
//                             если Ложь, то только пользователи переданного подразделения, по умолчанию - Ложь.
//
// Возвращаемое значение:
//  Массив - массив пользователей подразделения.
//
Функция ПользователиЛинииПоддержки(ЛинияПоддержки, СУчетомИерархии = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СправочникПользователи.Ссылка
	|ИЗ
	|	Справочник.Пользователи КАК СправочникПользователи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
	|		ПО СправочникПользователи.Ссылка = СведенияОПользователях.Пользователь
	|ГДЕ
	|	НЕ СправочникПользователи.ПометкаУдаления
	|	И НЕ СправочникПользователи.Недействителен";
	
	Если СУчетомИерархии Тогда 
		Запрос.Текст = Запрос.Текст + 
			" И СведенияОПользователях.ЛинияПоддержки В ИЕРАРХИИ (&ЛинияПоддержки) ";
	Иначе
		Запрос.Текст = Запрос.Текст + 
			" И СведенияОПользователях.ЛинияПоддержки = &ЛинияПоддержки ";
	КонецЕсли;	
		
	Запрос.УстановитьПараметр("ЛинияПоддержки", ЛинияПоддержки);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Формирует параметры роли для формы выбора или подбора исполнителя.
//
Функция ПараметрыРоли(Роль, Подразделение) Экспорт
	
	ТипыОсновногоОбъектаАдресации = Неопределено;
	Если Роль.ТипыОсновногоОбъектаАдресации.ТипЗначения <> Неопределено Тогда
		ТипыОсновногоОбъектаАдресации = Роль.ТипыОсновногоОбъектаАдресации.ТипЗначения.Типы();
	КонецЕсли;	
	
	ТипыДополнительногоОбъектаАдресации = Неопределено;
	Если Роль.ТипыДополнительногоОбъектаАдресации.ТипЗначения <> Неопределено Тогда
		ТипыДополнительногоОбъектаАдресации = Роль.ТипыДополнительногоОбъектаАдресации.ТипЗначения.Типы();
	КонецЕсли;	
	
	ИспользуетсяСОбъектамиАдресации = Роль.ИспользуетсяСОбъектамиАдресации;
	ИспользуетсяБезОбъектовАдресации = Роль.ИспользуетсяБезОбъектовАдресации;
	
	ОсновнойОбъектАдресации = Неопределено;
	ДополнительныйОбъектАдресации = Неопределено;
	
	Если Подразделение <> Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		               |	ИсполнителиЗадач.ОсновнойОбъектАдресации
		               |ИЗ
		               |	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
		               |		ПО ИсполнителиЗадач.Исполнитель = СведенияОПользователях.Пользователь
		               |ГДЕ
		               |	ИсполнителиЗадач.РольИсполнителя = &РольИсполнителя
		               |	И СведенияОПользователях.Подразделение = &Подразделение";
		
		Запрос.УстановитьПараметр("РольИсполнителя", Роль);
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
		
		Таблица = Запрос.Выполнить().Выгрузить();
		Если Таблица.Количество() = 1 Тогда
			ОсновнойОбъектАдресации = Таблица[0].ОсновнойОбъектАдресации;
		КонецЕсли;	
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		               |	ИсполнителиЗадач.ДополнительныйОбъектАдресации
		               |ИЗ
		               |	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
		               |		ПО ИсполнителиЗадач.Исполнитель = СведенияОПользователях.Пользователь
		               |ГДЕ
		               |	ИсполнителиЗадач.РольИсполнителя = &РольИсполнителя
		               |	И СведенияОПользователях.Подразделение = &Подразделение";
		
		Запрос.УстановитьПараметр("РольИсполнителя", Роль);
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
		
		Таблица = Запрос.Выполнить().Выгрузить();
		Если Таблица.Количество() = 1 Тогда
			ДополнительныйОбъектАдресации = Таблица[0].ДополнительныйОбъектАдресации;
		КонецЕсли;	
		
	КонецЕсли;	
	
	Возврат Новый Структура("ТипыОсновногоОбъектаАдресации, ТипыДополнительногоОбъектаАдресации, ИспользуетсяСОбъектамиАдресации, ИспользуетсяБезОбъектовАдресации, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации",
		ТипыОсновногоОбъектаАдресации, ТипыДополнительногоОбъектаАдресации, ИспользуетсяСОбъектамиАдресации, 
		ИспользуетсяБезОбъектовАдресации, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации);
	
КонецФункции

// Получает список пользователей, входящих в группу пользователей.
//
Функция ПользователиГруппыПользователей(ГруппаПользователей, СУчетомИерархии = Истина) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ГруппыПользователей.Ссылка
		|ИЗ
		|	Справочник.ГруппыПользователей КАК ГруппыПользователей
		|ГДЕ";
		
	Если СУчетомИерархии Тогда
		Запрос.Текст = Запрос.Текст + " ГруппыПользователей.Ссылка В ИЕРАРХИИ (&Ссылка)";	
	Иначе
		Запрос.Текст = Запрос.Текст + " ГруппыПользователей.Ссылка = &Ссылка";
	КонецЕсли;
	Запрос.УстановитьПараметр("Ссылка", ГруппаПользователей);
    МассивГрупп = Запрос.Выполнить().Выгрузить();	
	Для Каждого Группа из МассивГрупп Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	СоставыГруппПользователей.Пользователь
			|ИЗ
			|	РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
			|ГДЕ
			|	СоставыГруппПользователей.ГруппаПользователей = &ГруппаПользователей";

		Запрос.УстановитьПараметр("ГруппаПользователей", Группа.Ссылка);

		РезультатЗапроса = Запрос.Выполнить().Выгрузить();
		
		Для Каждого ЭлементСостава Из РезультатЗапроса Цикл
			Если Результат.Найти(ЭлементСостава.Пользователь) = Неопределено Тогда
				Результат.Добавить(ЭлементСостава.Пользователь);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;

	Возврат Результат;
	
КонецФункции

// Определяет, является ли пользователь руководителем.
//
Функция ЭтоРуководитель(Пользователь) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИСТИНА КАК Поле1
	|ИЗ
	|	Справочник.ЛинииПоддержки КАК ЛинииПоддержки
	|ГДЕ
	|	НЕ ЛинииПоддержки.ПометкаУдаления
	|	И ЛинииПоддержки.Руководитель = &Пользователь";
		
	Запрос.Параметры.Вставить("Пользователь", Пользователь);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции	

#КонецОбласти 
