
#Область ПрограммныйИнтерфейс
    
Функция ПолучитьПожелания(ФильтрПоГруппе, ФильтрыПоПредмету, ТипСортировки, НомерСтраницы, СтроковыйИдентификаторПользователя, КоличествоПожеланийНаСтранице)
	
	УстановитьПривилегированныйРежим(Истина);
	// Оперделение пользователя
	ИдентификаторПользователя = Новый УникальныйИдентификатор(СтроковыйИдентификаторПользователя);
	Пользователь = Справочники.ПользователиСервисов.ПолучитьСсылку(ИдентификаторПользователя);
	Если Пользователь.ПолучитьОбъект() = Неопределено Тогда 
		ТекстИсключения = НСтр("ru = 'Не найден пользователь по идентификатору'");
		ИмяСобытия = ЦентрИдей.ИмяСобытияДляЖурналаРегистрации();
		ЦентрИдей.ЗаписатьОшибкуВЖурнал(ИмяСобытия, ТекстИсключения);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	// Определение списка доступных предметов пользователю
	ДоступныеКомпонентыПожеланий = ЦентрИдей.ДоступныеКомпонентыПожеланий(Пользователь);
	Если ДоступныеКомпонентыПожеланий.Количество() = 0 Тогда 
		ТекстИсключения = НСтр("ru = 'Нет доступных предметов идей'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	// Определение количества пожеланий в списке
	МаксимальноеЧислоВыбранныхПожеланий = ЦентрИдей.МаксимальноеЧислоВыбранныхПожеланий();
	КоличествоПожеланийВВыборке = КоличествоПожеланийНаСтранице*НомерСтраницы + 1; // Плюс один делается, чтобы знать: есть ли еще пожелания после или нет.
	Если КоличествоПожеланийВВыборке > МаксимальноеЧислоВыбранныхПожеланий Тогда 
		КоличествоПожеланийВВыборке = МаксимальноеЧислоВыбранныхПожеланий;
	КонецЕсли;
	
	// Определение фильтров по предмету
	СписокПредметов = ЦентрИдей.ОтфильтрованныеКомпоненты(ДоступныеКомпонентыПожеланий, ФильтрыПоПредмету);
	
	Если ФильтрПоГруппе = "plan" Тогда
		РезультатЗапросов = ЦентрИдей.СписокЗапланированныхКРеализацииПожеланий(Пользователь, СписокПредметов, ТипСортировки, КоличествоПожеланийВВыборке);
	ИначеЕсли ФильтрПоГруппе = "voiting" Тогда 
		РезультатЗапросов = ЦентрИдей.СписокПожеланийНаГолосовании(Пользователь, СписокПредметов, ТипСортировки, КоличествоПожеланийВВыборке);
	ИначеЕсли ФильтрПоГруппе = "deviation" Тогда
		РезультатЗапросов = ЦентрИдей.СписокОтклоненныхПожеланий(Пользователь, СписокПредметов, ТипСортировки, КоличествоПожеланийВВыборке);
	ИначеЕсли ФильтрПоГруппе = "realization" Тогда
		РезультатЗапросов = ЦентрИдей.СписокРеализованныхПожеланий(Пользователь, СписокПредметов, ТипСортировки, КоличествоПожеланийВВыборке);
	ИначеЕсли ФильтрПоГруппе = "favorites" Тогда 
		РезультатЗапросов = ЦентрИдей.СписокИзбранныхПожеланий(Пользователь, СписокПредметов, ТипСортировки, КоличествоПожеланийВВыборке);
	Иначе
		ТекстИсключения = НСтр("ru = 'Не определен фильтр по статусам идей'");
		ИмяСобытия = ЦентрИдей.ИмяСобытияДляЖурналаРегистрации();
		ЦентрИдей.ЗаписатьОшибкуВЖурнал(ИмяСобытия, ТекстИсключения);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	КоличествоЗапросов = РезультатЗапросов.Количество();
	
	////////////////////////////////////////////////////////////////////////////////
	// Заполнение выходных данных
	ТипКонтейнераСписка = ФабрикаXDTO.Тип(ЦентрИдей.ПространствоИмен_1_0_0_1(), "IdeaListPresentation");
	КонтейнерСписка = ФабрикаXDTO.Создать(ТипКонтейнераСписка);
	
	// Заполнение списка пожеланий по пользователю
	Пожелания = РезультатЗапросов.Получить(КоличествоЗапросов - 1).Выгрузить();
	НачальныйЭлемент = НомерСтраницы * КоличествоПожеланийНаСтранице - КоличествоПожеланийНаСтранице;
	Итерация = 0;
	Для Каждого Пожелание Из Пожелания Цикл 
		Если Итерация < НачальныйЭлемент Тогда 
			Итерация = Итерация + 1;
			Продолжить;
		КонецЕсли;
		ПожеланиеXDTO = ПожеланиеXDTO(Пожелание);
		КонтейнерСписка.IdeasList.Добавить(ПожеланиеXDTO);
		Итерация = Итерация + 1;
	КонецЦикла;
	
	// Заполнение количества пожеланий всего
	НомерЗапроса = КоличествоЗапросов - 4;
	Если РезультатЗапросов.Получить(НомерЗапроса).Пустой() Тогда 
		КонтейнерСписка.IdeasCount = 0;
	Иначе
		КонтейнерСписка.IdeasCount = РезультатЗапросов.Получить(НомерЗапроса).Выгрузить().Получить(0).КоличествоПожеланий;
	КонецЕсли;
	
	// Заполнение доступных предметов
	Для Каждого ДоступныйПредмет Из ДоступныеКомпонентыПожеланий Цикл 
		КонтейнерСписка.SubjectsList.Добавить(ДоступныйПредмет.Наименование);
	КонецЦикла;
	
	Возврат КонтейнерСписка;
	
КонецФункции

Функция ПолучитьПожелание(СтроковыйИдентификаторПожелания, СтроковыйИдентификаторПользователя, НомерСтраницыКомментариев, КоличествоКомментариевНаСтранице)
	
	УстановитьПривилегированныйРежим(Истина);
	// Оперделение пользователя
	ИдентификаторПользователя = Новый УникальныйИдентификатор(СтроковыйИдентификаторПользователя);
	Пользователь = Справочники.ПользователиСервисов.ПолучитьСсылку(ИдентификаторПользователя);
	Если Пользователь.ПолучитьОбъект() = Неопределено Тогда 
		ТекстИсключения = НСтр("ru = 'Не найден пользователь по идентификатору'");
		ИмяСобытия = ЦентрИдей.ИмяСобытияДляЖурналаРегистрации();
		ЦентрИдей.ЗаписатьОшибкуВЖурнал(ИмяСобытия, ТекстИсключения);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	// Получение пожелания
	ИдентификаторПожелания = Новый УникальныйИдентификатор(СтроковыйИдентификаторПожелания);
	Пожелание = Справочники.Пожелания.ПолучитьСсылку(ИдентификаторПожелания);
	Если Пожелание.Пустая() Тогда 
		ТекстИсключения = НСтр("ru = 'Не найдена Пожелание пользователя'");
		ИмяСобытия = ЦентрИдей.ИмяСобытияДляЖурналаРегистрации();
		ЦентрИдей.ЗаписатьОшибкуВЖурнал(ИмяСобытия, ТекстИсключения);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////////
	// Заполнение выходных данных
	ТипПредставленияПожелания = ФабрикаXDTO.Тип(ЦентрИдей.ПространствоИмен_1_0_0_1(), "IdeaPresentation");
	ПредставлениеПожелания = ФабрикаXDTO.Создать(ТипПредставленияПожелания);
	
	// Заполнение пожелания 
	РезультатЗапросовПоПожеланием = ЦентрИдей.ПолучитьПредставлениеПожелания(Пожелание, Пользователь);
	КоличествоЗапросов = РезультатЗапросовПоПожеланием.Количество();
	Пожелания = РезультатЗапросовПоПожеланием.Получить(КоличествоЗапросов - 1).Выгрузить();
	ПредставлениеПожелания.Idea = ПожеланиеXDTO(Пожелания.Получить(0), Истина);
	
	// Заполнение комментариев по пожеланию
	НачальныйЭлемент = НомерСтраницыКомментариев * КоличествоКомментариевНаСтранице - КоличествоКомментариевНаСтранице;
	Итерация = 0;
	
	// Определение количества комментариев для списка
	МаксимальноеЧислоВыбранныхКомментариев = ЦентрИдей.МаксимальноеЧислоВыбранныхКомментариевКПожеланием();
	КоличествоКомментариевВВыборке = КоличествоКомментариевНаСтранице*НомерСтраницыКомментариев + 1; 
	Если КоличествоКомментариевВВыборке > МаксимальноеЧислоВыбранныхКомментариев Тогда 
		КоличествоКомментариевВВыборке = МаксимальноеЧислоВыбранныхКомментариев;
	КонецЕсли;
	
	РезультатЗапросовПоКомментариям = ЦентрИдей.КомментраииПоПожеланию(Пожелание, КоличествоКомментариевВВыборке);
	КомментраииПоПожеланию = РезультатЗапросовПоКомментариям.Получить(1).Выгрузить();
	Для Каждого Комментарий Из КомментраииПоПожеланию Цикл 
		Если Итерация < НачальныйЭлемент Тогда 
			Итерация = Итерация + 1;
			Продолжить;
		КонецЕсли;
		ОбъектКомментария = ЗаполнитьКомментарий(Комментарий.Комментарий);
		ПредставлениеПожелания.CommentsList.Добавить(ОбъектКомментария);
		
		Итерация = Итерация + 1;
	КонецЦикла;
	
	// Заполнение количества комментариев по пожеланию
	Если РезультатЗапросовПоКомментариям.Получить(0).Пустой() Тогда 
		ПредставлениеПожелания.IdeaCommentsCount = 0;
	Иначе
		ПредставлениеПожелания.IdeaCommentsCount = РезультатЗапросовПоКомментариям.Получить(0).Выгрузить().Получить(0).КоличествоКомментариев;
	КонецЕсли;
	
	Возврат ПредставлениеПожелания;
	
КонецФункции

Функция ДобавитьПожелание(СтроковыйИдентификаторПользователя, Содержание, Вложения, ИмяПредмета, Наименование)
	
	УстановитьПривилегированныйРежим(Истина);
	ИдентификаторПользователя = Новый УникальныйИдентификатор(СтроковыйИдентификаторПользователя);
	Пользователь = Справочники.ПользователиСервисов.ПолучитьСсылку(ИдентификаторПользователя);
	Если Пользователь.ПолучитьОбъект() = Неопределено Тогда 
		ТекстИсключения = НСтр("ru = 'Не найден пользователь по идентификатору'");
		ИмяСобытия = ЦентрИдей.ИмяСобытияДляЖурналаРегистрации();
		ЦентрИдей.ЗаписатьОшибкуВЖурнал(ИмяСобытия, ТекстИсключения);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	СтруктураВложений = ПривестиВложения(Вложения);
	
	Предмет = ЦентрИдей.ПредметПоНаименованию(ИмяПредмета);
	
	// Добавление нового пожелания
	Пожелание = ЦентрИдей.ДобавитьПожелание(Наименование, Содержание, СтруктураВложений, Предмет, Пользователь, ТекущаяДата());
	
	// Добавление голоса к пожеланию пользователя
	МассивПользователей = Новый Массив;
	МассивПользователей.Добавить(Пользователь);
	ЦентрИдей.ДобавитьГолосаПользователейКПожеланию(МассивПользователей, Пожелание);
	
	Возврат Истина;
	
КонецФункции

Функция ДобавитьГолос(СтроковыйИдентификаторПожелания, СтроковыйИдентификаторПользователя, Голос)
	
	УстановитьПривилегированныйРежим(Истина);
	ИдентификаторПользователя = Новый УникальныйИдентификатор(СтроковыйИдентификаторПользователя);
	Пользователь = Справочники.ПользователиСервисов.ПолучитьСсылку(ИдентификаторПользователя);
	Если Пользователь.ПолучитьОбъект() = Неопределено Тогда 
		ТекстИсключения = НСтр("ru = 'Не найден пользователь по идентификатору'");
		ИмяСобытия = ЦентрИдей.ИмяСобытияДляЖурналаРегистрации();
		ЦентрИдей.ЗаписатьОшибкуВЖурнал(ИмяСобытия, ТекстИсключения);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ИдентификаторПожелания = Новый УникальныйИдентификатор(СтроковыйИдентификаторПожелания);
	Пожелание = Справочники.Пожелания.ПолучитьСсылку(ИдентификаторПожелания);
	Если Пожелание.Пустая() Тогда 
		ТекстИсключения = НСтр("ru = 'Не найдена Пожелание по идентификатору'");
		ИмяСобытия = ЦентрИдей.ИмяСобытияДляЖурналаРегистрации();
		ЦентрИдей.ЗаписатьОшибкуВЖурнал(ИмяСобытия, ТекстИсключения);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	МассивПользователей = Новый Массив;
	МассивПользователей.Добавить(Пользователь);
	ЦентрИдей.ДобавитьГолосаПользователейКПожеланию(МассивПользователей, Пожелание, Голос);
	
	Возврат Истина;
	
КонецФункции

Функция ДобавитьКомментарийКПожеланию(СтроковыйИдентификаторПожелания, СтроковыйИдентификаторПользователя, СтроковыйИдентификаторКомментария, ТекстHTML)
	
	УстановитьПривилегированныйРежим(Истина);
	ИдентификаторПользователя = Новый УникальныйИдентификатор(СтроковыйИдентификаторПользователя);
	Пользователь = Справочники.ПользователиСервисов.ПолучитьСсылку(ИдентификаторПользователя);
	Если Пользователь.ПолучитьОбъект() = Неопределено Тогда 
		ТекстИсключения = НСтр("ru = 'Не найден пользователь по идентификатору'");
		ИмяСобытия = ЦентрИдей.ИмяСобытияДляЖурналаРегистрации();
		ЦентрИдей.ЗаписатьОшибкуВЖурнал(ИмяСобытия, ТекстИсключения);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ИдентификаторПожелания = Новый УникальныйИдентификатор(СтроковыйИдентификаторПожелания);
	Пожелание = Справочники.Пожелания.ПолучитьСсылку(ИдентификаторПожелания);
	Если Пожелание.ПолучитьОбъект() = Неопределено Тогда 
		ТекстИсключения = НСтр("ru = 'Не найдено Пожелание по идентификатору'");
		ИмяСобытия = ЦентрИдей.ИмяСобытияДляЖурналаРегистрации();
		ЦентрИдей.ЗаписатьОшибкуВЖурнал(ИмяСобытия, ТекстИсключения);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если Не ПустаяСтрока(СтроковыйИдентификаторКомментария) Тогда 
		ИдентификаторКомментария = Новый УникальныйИдентификатор(СтроковыйИдентификаторКомментария);
		ОсновнойКомментарий = Документы.КомментарийПользователя.ПолучитьСсылку(ИдентификаторКомментария);
	Иначе
		ОсновнойКомментарий = Документы.КомментарийПользователя.ПустаяСсылка();
	КонецЕсли;
	
	ЦентрИдей.ДобавитьКомментрийКПожеланию(Пожелание, Пользователь, ОсновнойКомментарий, ТекстHTML, ТекущаяДата());
	
	Возврат Истина;
	
КонецФункции

Функция НайтиПожелания(ПоисковыйЗапрос, ФильтрПоГруппе, ФильтрыПоПредмету, ТипСортировки, НомерСтраницы, СтроковыйИдентификаторПользователя, КоличествоПожеланийНаСтранице)
	
	УстановитьПривилегированныйРежим(Истина);
	// Оперделение пользователя
	ИдентификаторПользователя = Новый УникальныйИдентификатор(СтроковыйИдентификаторПользователя);
	Пользователь = Справочники.ПользователиСервисов.ПолучитьСсылку(ИдентификаторПользователя);
	Если Пользователь.ПолучитьОбъект() = Неопределено Тогда 
		ТекстИсключения = НСтр("ru = 'Не найден пользователь по идентификатору'");
		ИмяСобытия = ЦентрИдей.ИмяСобытияДляЖурналаРегистрации();
		ЦентрИдей.ЗаписатьОшибкуВЖурнал(ИмяСобытия, ТекстИсключения);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	// Определение списка доступных предметов пользователю
	ДоступныеКомпонентыПожеланий = ЦентрИдей.ДоступныеКомпонентыПожеланий(Пользователь);
	Если ДоступныеКомпонентыПожеланий.Количество() = 0 Тогда 
		ТекстИсключения = НСтр("ru = 'Нет доступных предметов идей'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	// Определение фильтров по предмету
	СписокПредметов = ЦентрИдей.ОтфильтрованныеКомпоненты(ДоступныеКомпонентыПожеланий, ФильтрыПоПредмету);
	
	////////////////////////////////////////////////////////////////////////////////
	// Заполнение выходных данных
	ТипКонтейнераСписка = ФабрикаXDTO.Тип(ЦентрИдей.ПространствоИмен_1_0_0_1(), "IdeaListPresentation");
	КонтейнерСписка = ФабрикаXDTO.Создать(ТипКонтейнераСписка);
	
	// Определение количества пожеланий для списка
	МаксимальноеЧислоВыбранныхПожеланий = ЦентрИдей.МаксимальноеЧислоВыбранныхПожеланий();
	КоличествоПожеланийВВыборке = КоличествоПожеланийНаСтранице*НомерСтраницы + 1; // Плюс один делается, чтобы знать: есть ли еще пожелания после или нет.
	Если КоличествоПожеланийВВыборке > МаксимальноеЧислоВыбранныхПожеланий Тогда 
		КоличествоПожеланийВВыборке = МаксимальноеЧислоВыбранныхПожеланий;
	КонецЕсли;
	
	// Заполнение списка пожеланий по пользователю предметов
	РезультатЗапросов = ЦентрИдей.НайтиПожелания(ПоисковыйЗапрос, Пользователь, СписокПредметов, КоличествоПожеланийВВыборке);
	
	КоличествоЗапросов = РезультатЗапросов.Количество();
	
	////////////////////////////////////////////////////////////////////////////////
	// Заполнение выходных данных
	ТипКонтейнераСписка = ФабрикаXDTO.Тип(ЦентрИдей.ПространствоИмен_1_0_0_1(), "IdeaListPresentation");
	КонтейнерСписка = ФабрикаXDTO.Создать(ТипКонтейнераСписка);
	
	// Заполнение списка пожеланий по пользователю
	СписокПожеланий = РезультатЗапросов.Получить(КоличествоЗапросов - 1).Выгрузить();
	НачальныйЭлемент = НомерСтраницы * КоличествоПожеланийНаСтранице - КоличествоПожеланийНаСтранице;
	Итерация = 0;
	Для Каждого ЭлементПожелания Из СписокПожеланий Цикл 
		Если Итерация < НачальныйЭлемент Тогда 
			Итерация = Итерация + 1;
			Продолжить;
		КонецЕсли;
		ПожеланиеXDTO = ПожеланиеXDTO(ЭлементПожелания);
		КонтейнерСписка.IdeasList.Добавить(ПожеланиеXDTO);
		Итерация = Итерация + 1;
	КонецЦикла;
	
	// Заполнение количества пожеланий всего
	НомерЗапроса = КоличествоЗапросов - 4;
	Если РезультатЗапросов.Получить(НомерЗапроса).Пустой() Тогда 
		КонтейнерСписка.IdeasCount = 0;
	Иначе
		КонтейнерСписка.IdeasCount = РезультатЗапросов.Получить(НомерЗапроса).Выгрузить().Получить(0).КоличествоПожеланий;
	КонецЕсли;
	
	// Заполнение доступных предметов
	Для Каждого ДоступныйПредмет Из ДоступныеКомпонентыПожеланий Цикл 
		КонтейнерСписка.SubjectsList.Добавить(ДоступныйПредмет.Наименование);
	КонецЦикла;
	
	Возврат КонтейнерСписка;
	
КонецФункции

Функция УдалитьКомментарийКПожеланию(СтроковыйИдентификаторКомментария)
	
	УстановитьПривилегированныйРежим(Истина);
	ИдентификаторКомментария = Новый УникальныйИдентификатор(СтроковыйИдентификаторКомментария);
	Комментарий = Документы.КомментарийПользователя.ПолучитьСсылку(ИдентификаторКомментария);
	Если Комментарий.Пустая() Тогда 
		ТекстИсключения = НСтр("ru = 'Не найден комментарий'");
		ИмяСобытия = ЦентрИдей.ИмяСобытияДляЖурналаРегистрации();
		ЦентрИдей.ЗаписатьОшибкуВЖурнал(ИмяСобытия, ТекстИсключения);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ЦентрИдей.УдалитьКомментарий(Комментарий);
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Функция ПожеланиеXDTO(Знач ДанныеПожелания, Знач ЗаполнятьВложения = Ложь)
	
	ТипXDTO = ФабрикаXDTO.Тип(ЦентрИдей.ПространствоИмен_1_0_0_1(), "Idea");
	ОбъектXDTO = ФабрикаXDTO.Создать(ТипXDTO);
    
    СоответствиеПолей = Новый Структура;
    // Поля для подстановки без обработки
    СоответствиеПолей.Вставить("CreateDate", "ДатаРегистрации");
    СоответствиеПолей.Вставить("ClosingDate", "ДатаЗакрытия");
    СоответствиеПолей.Вставить("DeveloperComment", "КомментарийРазработчика");
    СоответствиеПолей.Вставить("Text", "Описание");
    СоответствиеПолей.Вставить("Subject", "КомпонентыСтрока");
    СоответствиеПолей.Вставить("PlanMadeDate", "ПлановаяДатаРеализации");
    // Поля, требующие обработку до подстановки
    СоответствиеПолей.Вставить("Пользователь", "Автор");
    СоответствиеПолей.Вставить("ИмяПользователя", "Автор.Наименование");
    СоответствиеПолей.Вставить("Состояние", "Состояние");
    СоответствиеПолей.Вставить("ПлановаяДатаРеализации", "ПлановаяДатаРеализации");
    СоответствиеПолей.Вставить("УточнениеДатыРеализации", "УточнениеДатыРеализации");
    СоответствиеПолей.Вставить("ОписаниеХранилище", "ОписаниеХранилище");
    
    ЗначенияПолей = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеПожелания.Пожелание, СоответствиеПолей);
    ЗаполнитьЗначенияСвойств(ОбъектXDTO, ЗначенияПолей);
    
    Описание = ЗначенияПолей.ОписаниеХранилище.Получить();
    ВложенияПожелания = Новый Структура;
    ТекстHTML = "";
    Если ТипЗнч(Описание) = Тип("ФорматированныйДокумент") Тогда
        Описание.ПолучитьHTML(ТекстHTML, ВложенияПожелания);
    КонецЕсли;
    	
	ОбъектXDTO.Id = Строка(ДанныеПожелания.Пожелание.УникальныйИдентификатор());
	ОбъектXDTO.Name = ЦентрИдей.ПредставлениеПожелания(ДанныеПожелания.Пожелание);
	ОбъектXDTO.UserId = Строка(ЗначенияПолей.Пользователь.УникальныйИдентификатор());;
	ОбъектXDTO.UserName = ?(ТипЗнч(ЗначенияПолей.ИмяПользователя) = Тип("Строка"), ЗначенияПолей.ИмяПользователя, "");
	ОбъектXDTO.CommentsCount = ДанныеПожелания.КоличествоКомментариев;
	ОбъектXDTO.HTMLText = ТекстHTML;
	ОбъектXDTO.Status = ПолучитьСтатусXDTO(ЗначенияПолей.Состояние);
	ОбъектXDTO.PlanMadeDatePresentation = ЦентрИдей.ПредставлениеДатыРеализации(ЗначенияПолей.ПлановаяДатаРеализации, ЗначенияПолей.УточнениеДатыРеализации);
	ОбъектXDTO.PositiveVotesSum = ДанныеПожелания.СуммаПоложительныхГолосов;
	ОбъектXDTO.NegativeVotesSum = ДанныеПожелания.СуммаОтрицательныхГолосов;
	ОбъектXDTO.Vote = ДанныеПожелания.ГолосПользователя;
	ОбъектXDTO.Rating = ДанныеПожелания.Рейтинг;
	
	Если ЗаполнятьВложения Тогда 
		Для Каждого Вложение Из ВложенияПожелания Цикл 
            
            Попытка
			    ДанныеВложения = Вложение.Значение.ПолучитьДвоичныеДанные();
            Исключение
				Продолжить;
			КонецПопытки;
			
			ТипВложения = ФабрикаXDTO.Тип(ЦентрИдей.ПространствоИмен_1_0_0_1(), "Attachment");
			ОбъектВложения = ФабрикаXDTO.Создать(ТипВложения);
			ОбъектВложения.Name = Вложение.Ключ;
			ОбъектВложения.Data = ДанныеВложения;
			
			ОбъектXDTO.Attachments.Добавить(ОбъектВложения);
			
		КонецЦикла;
	КонецЕсли;
	
	Возврат ОбъектXDTO;
	
КонецФункции

Функция ЗаполнитьКомментарий(Знач Комментарий)
	
	ТипКомментария = ФабрикаXDTO.Тип(ЦентрИдей.ПространствоИмен_1_0_0_1(), "IdeaComment");
	ОбъектКомментария = ФабрикаXDTO.Создать(ТипКомментария);
    
    СоответствиеПолей = Новый Структура;
    СоответствиеПолей.Вставить("Date", "Дата");
    СоответствиеПолей.Вставить("Text", "Описание");
    СоответствиеПолей.Вставить("UserName", "Автор.Наименование");
    СоответствиеПолей.Вставить("ОсновнойКомментарий", "ВзаимодействиеОснование");
    СоответствиеПолей.Вставить("Автор", "Автор");
    СоответствиеПолей.Вставить("Входящий", "Входящий");
    
    ЗначенияПолей = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Комментарий, СоответствиеПолей);
    ЗаполнитьЗначенияСвойств(ОбъектКомментария, ЗначенияПолей);
    
    ОбъектКомментария.IsSupport = Не ЗначенияПолей.Входящий;
	ОбъектКомментария.UserId = Строка(ЗначенияПолей.Автор.УникальныйИдентификатор());
	ОбъектКомментария.Id = Строка(Комментарий.УникальныйИдентификатор());
	Если ЗначениеЗаполнено(ЗначенияПолей.ОсновнойКомментарий) И ТипЗнч(ЗначенияПолей.ОсновнойКомментарий) = Тип("ДокументСсылка.КомментарийПользователя") Тогда 
		ОбъектКомментария.MainIdeaComment = ЗаполнитьКомментарий(ЗначенияПолей.ОсновнойКомментарий);
	Иначе
		ОбъектКомментария.MainIdeaComment = Неопределено;
	КонецЕсли;
	
	Возврат ОбъектКомментария;
	
КонецФункции

Функция ПривестиВложения(Знач Вложения)
	
	СтруктрураВложнеий = Новый Структура;
	Для Каждого Вложение Из Вложения.AttachmentElement Цикл 
		СтруктрураВложнеий.Вставить(Вложение.Name, Вложение.Data);
	КонецЦикла;
	
	Возврат СтруктрураВложнеий;
	
КонецФункции

Функция ПолучитьСтатусXDTO(Знач Статус)
	
	Если Статус = Перечисления.СостоянияПожеланий.Запланировано Тогда 
		Возврат "plan";
	ИначеЕсли Статус = Перечисления.СостоянияПожеланий.НаГолосовании Тогда 
		Возврат "voiting";
	ИначеЕсли Статус = Перечисления.СостоянияПожеланий.Отклонено Тогда 
		Возврат "deviation";
	ИначеЕсли Статус = Перечисления.СостоянияПожеланий.Реализовано Тогда 
		Возврат "realization";
	ИначеЕсли Статус = Перечисления.СостоянияПожеланий.Рассматривается Тогда 
		Возврат "consideration";
	КонецЕсли;
	
КонецФункции

#КонецОбласти


