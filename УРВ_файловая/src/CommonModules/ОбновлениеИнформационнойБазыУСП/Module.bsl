////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы конфигурации УСП (УправлениеСлужбойПоддержки).
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Сведения о конфигурации

// См. описание в общем модуле ОбновлениеИнформационнойБазыБСП.
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя = Метаданные.Имя;
	Описание.Версия = Метаданные.Версия;
	
	// Требуется библиотека стандартных подсистем.
	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления информационной базы.

// См. описание в общем модуле ОбновлениеИнформационнойБазыБСП.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
    
    #Область Версия_1_0_1
    Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.1";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыУСП.ОбновитьПредопределенныеВидыКонтактнойИнформации";
	Обработчик.ВыполнятьВГруппеОбязательных = Истина;
	Обработчик.Приоритет = 99;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.1";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыУСП.УстановитьРеквизитыРолиСотрудникЛинииПоддержки";
	Обработчик.ВыполнятьВГруппеОбязательных = Истина;
	Обработчик.Приоритет = 99;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.1";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыУСП.УстановитьГруппыДоступаСлужбыПоддержки";
	Обработчик.ВыполнятьВГруппеОбязательных = Истина;
	Обработчик.Приоритет = 99;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.1";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыУСП.УстановитьЗначенияКонстантПоУмолчанию";
	Обработчик.ВыполнятьВГруппеОбязательных = Истина;
	Обработчик.Приоритет = 99;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.1";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыУСП.ЗаполнитьШаблоныЭлектронныхПисемПоУмолчанию";
	Обработчик.ВыполнятьВГруппеОбязательных = Истина;
	Обработчик.Приоритет = 99;
    #КонецОбласти 

    #Область Версия_1_0_5
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.5.1";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "ВариантыОтчетов.ПеренестиПользовательскиеИзСтандартногоХранилища";
	Обработчик.ВыполнятьВГруппеОбязательных = Истина;
	Обработчик.Приоритет = 99;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.5.1";
	Обработчик.Процедура = "ДополнительныеОтчетыИОбработки.ОбновитьПользовательскиеНастройкиДоступаКОбработкам";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.5.1";
	Обработчик.Процедура = "ДополнительныеОтчетыИОбработки.ЗаполнитьИменаОбъектов";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.5.1";
	Обработчик.Процедура = "ДополнительныеОтчетыИОбработки.ЗаменитьИменаОбъектовМетаданныхНаСсылки";
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Обработчик = Обработчики.Добавить();
		Обработчик.ВыполнятьВГруппеОбязательных = Истина;
		Обработчик.ОбщиеДанные                  = Истина;
		Обработчик.УправлениеОбработчиками      = Ложь;
		Обработчик.МонопольныйРежим             = Истина;
		Обработчик.Версия    = "1.0.5.1";
		Обработчик.Процедура = "ДополнительныеОтчетыИОбработки.ВключитьФункциональнуюОпцию";
	КонецЕсли;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.5.1";
	Обработчик.Процедура = "ДополнительныеОтчетыИОбработки.ЗаполнитьРежимСовместимостиРазрешений";
    #КонецОбласти 
    
    #Область Версия_1_0_7
    Обработчик = Обработчики.Добавить();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Версия = "1.0.7.7";
	Обработчик.Процедура = "Справочники.ОбслуживающиеОрганизации.ЗаполнитьНачальныеДанныеПоЧасовымПоясам";
    #КонецОбласти 
    
    #Область Версия_1_0_10
    Обработчик = Обработчики.Добавить();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Версия = "1.0.10.1";
	Обработчик.Процедура = "Справочники.Витрины.ЗаполнитьОсновныеВитрины_1_0_10_1";
    
    Обработчик = Обработчики.Добавить();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Версия = "1.0.10.1";
	Обработчик.Процедура = "Справочники.Витрины.ЗаполнитьВитринуВОткрытыхОбращениях_1_0_10_1";
    
    Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.10.1";
	Обработчик.Процедура = "Справочники.Витрины.ЗаполнитьВитринуВШаблонахТекстов_1_0_10_1";
	Обработчик.НачальноеЗаполнение = Истина;
    
    Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.10.1";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет значение витрины в закрытых обращениях'");
	Обработчик.Процедура = "Справочники.Витрины.ЗаполнитьВитринуВЗакрытыхОбращениях_1_0_10_1";
    
    Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.10.2";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет значение витрины в помеченных на удаление обращениях'");
	Обработчик.Процедура = "Справочники.Витрины.ЗаполнитьВитринуВПомеченныхНаУдалениеОбращениях_1_0_10_2";
    #КонецОбласти 

    #Область Версия_1_0_11
    Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.11.1";
	Обработчик.Процедура = "Справочники.Витрины.СинхронизироватьЗначенияЗависимыхКонстант_1_0_11_1";
	Обработчик.НачальноеЗаполнение = Истина;
    
    Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.11.1";
	Обработчик.Процедура = "Справочники.Витрины.ЗаполнитьВитриныВКарточкахБазыЗнаний_1_0_11_1";
	Обработчик.НачальноеЗаполнение = Истина;
    
    Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.11.1";
	Обработчик.Процедура = "Обслуживание.ЗаполнитьЛинииПоддержкиКарточекБазыЗнаний_1_0_11_1";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Заполнение реквизита ""Линия поддержки"" в карточках базы знаний.'");
    
    Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.11.1";
	Обработчик.Процедура = "Документы.КомментарийПользователя.ЗаполнитьПризнакВходящийИПринадлежностьОбъектов_1_0_11_1";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Заполнение реквизита ""Входящий"", ""Сервис"" и ""Витрина"" в комментариях пользователей.'");
    #КонецОбласти 
    
    #Область Версия_1_0_13
    Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.13.11";
	Обработчик.Процедура = "Справочники.ОбслуживающиеОрганизации.ЗаполнитьОтклоненияПоЧасовымПоясам";
    
    Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.13.11";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет показатель ""Количество обращений"" по карточкам базы знаний.'");
	Обработчик.Процедура = "Документы.Обращение.ЗаполнитьПоказательКоличествоОбращений";
    
    Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.13.13";
	Обработчик.Процедура = "Справочники.Сервисы.ЗаполнитьПервыеЛинииСервисов";
    
    #КонецОбласти 
	// {Рарус_shav 2018.06.06 
	
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "2.0.1.8";
	//Обработчик.Процедура = "ОбновлениеИнформационнойБазы.ПерейтиНаВерсию_2_0_1_8";

	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "2.0.1.9";
	//Обработчик.Процедура = "ОбновлениеИнформационнойБазы.ПерейтиНаВерсию_2_0_1_9";

	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "2.0.1.10";
	//Обработчик.Процедура = "ОбновлениеИнформационнойБазы.ПерейтиНаВерсию_2_0_1_10";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.14.4";
	//Обработчик.Процедура = "ОбновлениеИнформационнойБазы.ПерейтиНаВерсию_1_0_14_4_ДоработкаРегион";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.14.4";
	//Обработчик.Процедура = "ОбновлениеИнформационнойБазы.ПерейтиНаВерсию_1_0_14_4";
	
	// }Рарус_shav 2018.06.06 
	
	
    #Область Версия_1_0_15
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.15.27";
	Обработчик.Процедура = "Справочники.ПапкиЭлектронныхПисем.ЗаполнитьПризнакиСозданияОбращений";
	#КонецОбласти
	
	#Область Версия_1_0_17
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.17.1";
	Обработчик.Процедура = "Справочники.Комментарии.ПеренестиКомментарииАктивныхОбращений";
			
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.17.1";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("301d4867-5fb2-45ff-9d32-dc3e5da008d1");
	Обработчик.Процедура = "Справочники.Комментарии.ПеренестиКомментарииВФоне";
	Обработчик.ПроцедураПроверки    = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();
	Приоритет = Обработчик.ПриоритетыВыполнения.Добавить();
	Приоритет.Процедура = "Справочники.Комментарии.ПеренестиКомментарииАктивныхОбращений";
	Приоритет.Порядок = "Любой";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет перенос комментариев обращений и карточек базы знаний в отдельный справочник.'");
	#КонецОбласти


КонецПроцедуры

/// См. описание в общем модуле ОбновлениеИнформационнойБазыБСП.
Процедура ПриФормированииОчередейОтложенныхОбработчиков(Обработчики) Экспорт
		
КонецПроцедуры

// См. описание в общем модуле ОбновлениеИнформационнойБазыБСП.
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
КонецПроцедуры

// См. описание в общем модуле ОбновлениеИнформационнойБазыБСП.
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
КонецПроцедуры

// См. описание в общем модуле ОбновлениеИнформационнойБазыБСП.
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
	
	
КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - 
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует
//        указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(ПредыдущееИмяКонфигурации, ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
	
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииВидовДоступа.
Процедура ПриЗаполненииВидовДоступа(ВидыДоступа) Экспорт
	
	ВидДоступа = ВидыДоступа.Добавить();
	ВидДоступа.Имя                    = "Сервисы";
	ВидДоступа.Представление          = НСтр("ru = 'Сервисы'");
	ВидДоступа.ТипЗначений            = Тип("СправочникСсылка.Сервисы");
			
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обновляет значения реквизитов предопределенных видов контактной информации
Процедура ОбновитьПредопределенныеВидыКонтактнойИнформации() Экспорт

	ПараметрыПроверкиАдреса = Новый Структура;
	ПараметрыПроверкиАдреса.Вставить("АдресТолькоРоссийский", Ложь);
	ПараметрыПроверкиАдреса.Вставить("ПроверятьКорректность", Ложь);
	ПараметрыПроверкиАдреса.Вставить("ЗапрещатьВводНекорректного", Ложь);
	ПараметрыПроверкиАдреса.Вставить("СкрыватьНеактуальныеАдреса", Ложь);
	ПараметрыПроверкиАдреса.Вставить("ВключатьСтрануВПредставление", Ложь);
	
	ПараметрыПроверкиEmail = Новый Структура;
	ПараметрыПроверкиEmail.Вставить("ПроверятьКорректность", Истина);
	ПараметрыПроверкиEmail.Вставить("ЗапрещатьВводНекорректного", Истина);
	
	// Справочник "ОбслуживающиеОрганизации"
	ПараметрыПроверкиЮрАдреса = Новый Структура;
	ПараметрыПроверкиЮрАдреса.Вставить("АдресТолькоРоссийский", Ложь);
	ПараметрыПроверкиЮрАдреса.Вставить("ПроверятьКорректность", Ложь);
	ПараметрыПроверкиЮрАдреса.Вставить("ЗапрещатьВводНекорректного", Ложь);
	ПараметрыПроверкиЮрАдреса.Вставить("СкрыватьНеактуальныеАдреса", Ложь);
	ПараметрыПроверкиЮрАдреса.Вставить("ВключатьСтрануВПредставление", Ложь);
	
	МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
	//+++Шаблон
	//ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("АдресЭлектроннойПочты");
	//ПараметрыВида.Вид = "EmailПользователя";
	//ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	//ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	//ПараметрыВида.Порядок = 1;
	//МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	//---Шаблон
	
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = "ЮрАдресОбслуживающейОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 1;
	ПараметрыВида.НастройкиПроверки = ПараметрыПроверкиЮрАдреса;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//	Справочники.ВидыКонтактнойИнформации.ЮрАдресОбслуживающейОрганизации, 
	//	Перечисления.ТипыКонтактнойИнформации.Адрес,
	//	НСтр("ru='Юридический адрес обслуживающей организации'"), Истина, Ложь, Ложь, 1,, ПараметрыПроверкиЮрАдреса);
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = "ФактАдресОбслуживающейОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 2;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//	Справочники.ВидыКонтактнойИнформации.ФактАдресОбслуживающейОрганизации, 
	//	Перечисления.ТипыКонтактнойИнформации.Адрес,
	//	НСтр("ru='Фактический адрес обслуживающей организации'"), Истина, Ложь, Ложь, 2);
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = "ПочтовыйАдресОбслуживающейОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 3;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//	Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресОбслуживающейОрганизации, 
	//	Перечисления.ТипыКонтактнойИнформации.Адрес,
	//	НСтр("ru='Почтовый адрес обслуживающей организации'"), Истина, Ложь, Ложь, 3);
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Телефон");
	ПараметрыВида.Вид = "ТелефонОбслуживающейОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 4;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//	Справочники.ВидыКонтактнойИнформации.ТелефонОбслуживающейОрганизации, 
	//	Перечисления.ТипыКонтактнойИнформации.Телефон,
	//	НСтр("ru='Телефон обслуживающей организации'"), Истина, Ложь, Ложь, 4);
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("АдресЭлектроннойПочты");
	ПараметрыВида.Вид = "EmailОбслуживающейОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 5;
	ПараметрыВида.НастройкиПроверки = ПараметрыПроверкиEmail;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//	Справочники.ВидыКонтактнойИнформации.EmailОбслуживающейОрганизации, 
	//	Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,
	//	НСтр("ru='Адрес электронной почты обслуживающей организации'"), Истина, Ложь, Ложь, 5, Истина, ПараметрыПроверкиEmail);
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Другое");
	ПараметрыВида.Вид = "ДругаяИнформацияОбслуживающейОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 6;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//	Справочники.ВидыКонтактнойИнформации.ДругаяИнформацияОбслуживающейОрганизации, 
	//	Перечисления.ТипыКонтактнойИнформации.Другое,
	//	НСтр("ru='Прочая информация'"), Истина, Ложь, Ложь, 6);
		
	// Справочник "Абоненты"
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("АдресЭлектроннойПочты");
	ПараметрыВида.Вид = "EmailАбонента";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 1;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//    Справочники.ВидыКонтактнойИнформации.EmailАбонента,
	//    Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,
	//    НСтр("ru='Основной адрес электронной почты абонента'"), Истина, Ложь, Ложь, 1, Ложь);
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("АдресЭлектроннойПочты");
	ПараметрыВида.Вид = "ДополнительныйEmailАбонента";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 2;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//    Справочники.ВидыКонтактнойИнформации.ДополнительныйEmailАбонента,
	//    Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,
	//    НСтр("ru='Дополнительный адрес электронной почты абонента'"),Истина, Ложь, Ложь, 2, Истина);
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Телефон");
	ПараметрыВида.Вид = "ТелефонАбонента";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 3;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//    Справочники.ВидыКонтактнойИнформации.ТелефонАбонента,
	//    Перечисления.ТипыКонтактнойИнформации.Телефон,
	//    НСтр("ru='Контактный телефон абонента'"), Истина, Ложь, Ложь, 3, Ложь);
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Телефон");
	ПараметрыВида.Вид = "ДополнительныйТелефонАбонента";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 4;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//    Справочники.ВидыКонтактнойИнформации.ДополнительныйТелефонАбонента,
	//    Перечисления.ТипыКонтактнойИнформации.Телефон,
	//    НСтр("ru='Дополнительный контактный телефон абонента'"), Истина, Ложь, Ложь, 4, Истина);
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("ВебСтраница");
	ПараметрыВида.Вид = "СайтАбонента";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 5;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);	
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//    Справочники.ВидыКонтактнойИнформации.СайтАбонента,
	//    Перечисления.ТипыКонтактнойИнформации.ВебСтраница,
	//    НСтр("ru='Сайт абонента'"), Истина, Ложь, Ложь, 5, Ложь);
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = "ПочтовыйАдресАбонента";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 6;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);	
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//    Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресАбонента,
	//    Перечисления.ТипыКонтактнойИнформации.Адрес,
	//    НСтр("ru='Почтовый адрес абонента'"), Истина, Ложь, Ложь, 6, Ложь);
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Другое");
	ПараметрыВида.Вид = "ДругаяИнформацияАбонента";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 7;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);	
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//	Справочники.ВидыКонтактнойИнформации.ДругаяИнформацияАбонента, 
	//	Перечисления.ТипыКонтактнойИнформации.Другое,
	//	НСтр("ru='Прочая информация'"), Истина, Ложь, Ложь, 7, Ложь);
	
	// Справочник "Пользователи сервиса"
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("АдресЭлектроннойПочты");
	ПараметрыВида.Вид = "EmailПользователяСервиса";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 1;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);	
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//    Справочники.ВидыКонтактнойИнформации.EmailПользователяСервиса,
	//    Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,
	//    НСтр("ru='Основной адрес электронной почты пользователя сервиса'"), Истина, Ложь, Ложь, 1, Ложь);
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("АдресЭлектроннойПочты");
	ПараметрыВида.Вид = "ДополнительныйEmailПользователяСервиса";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 2;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//    Справочники.ВидыКонтактнойИнформации.ДополнительныйEmailПользователяСервиса,
	//    Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,
	//    НСтр("ru='Дополнительный адрес электронной почты пользователя сервиса'"), Истина, Ложь, Ложь, 2, Истина);
	
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Телефон");
	ПараметрыВида.Вид = "ТелефонПользователяСервиса";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 3;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//    Справочники.ВидыКонтактнойИнформации.ТелефонПользователяСервиса,
	//    Перечисления.ТипыКонтактнойИнформации.Телефон,
	//    НСтр("ru='Контактный телефон пользователя сервиса'"), Истина, Ложь, Ложь, 3, Ложь);
	
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Телефон");
	ПараметрыВида.Вид = "ДополнительныйТелефонПользователяСервиса";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 4;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//    Справочники.ВидыКонтактнойИнформации.ДополнительныйТелефонПользователяСервиса,
	//    Перечисления.ТипыКонтактнойИнформации.Телефон,
	//    НСтр("ru='Дополнительный контактный телефон пользователя сервиса'"), Истина, Ложь, Ложь, 4, Истина);
		
	// Справочник "Линии поддержки"
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("АдресЭлектроннойПочты");
	ПараметрыВида.Вид = "EmailЛинииПоддержки";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 3;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	//УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
	//    Справочники.ВидыКонтактнойИнформации.EmailЛинииПоддержки,
	//    Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,
	//    НСтр("ru='Адрес электронной почты линии поддержки'"), Истина, Ложь, Ложь, 3, Ложь);
	
	
КонецПроцедуры

// Устанавливает параметры роли исполнителей "Сотрудник линии поддержки"
Процедура УстановитьРеквизитыРолиСотрудникЛинииПоддержки() Экспорт
	
	Объект = Справочники.РолиИсполнителей.СотрудникЛинииПоддержки.ПолучитьОбъект();
	Объект.ИспользуетсяСОбъектамиАдресации = Истина;
	Объект.ТипыОсновногоОбъектаАдресации = ПланыВидовХарактеристик.ОбъектыАдресацииЗадач.ОбслуживающаяОрганизация;
	Объект.ТипыДополнительногоОбъектаАдресации = ПланыВидовХарактеристик.ОбъектыАдресацииЗадач.ЛинияПоддержки;
	Объект.Записать();
	
КонецПроцедуры

// Устанавливает группы доступа предопределенной обслуживающей организации "Служба поддержки"
//
Процедура УстановитьГруппыДоступаСлужбыПоддержки() Экспорт
	
	Объект = Справочники.ОбслуживающиеОрганизации.СлужбаПоддержки.ПолучитьОбъект();
	Объект.Записать();
	
КонецПроцедуры

Процедура ЗаполнитьШаблоныЭлектронныхПисемПоУмолчанию() Экспорт
	
	ИмяФайла = ПолучитьИмяВременногоФайла("xml");
	ДанныеДляЗагрузки = ПолучитьОбщийМакет("ШаблоныПисемПоУмолчанию");
	ДанныеДляЗагрузки.Записать(ИмяФайла);
	
	ОбработкаЗагрузки = Обработки.ВыгрузкаЗагрузкаДанныхXML.Создать();
	ОбработкаЗагрузки.ВыполнитьЗагрузку(ИмяФайла);
	
КонецПроцедуры

Процедура УстановитьЗначенияКонстантПоУмолчанию() Экспорт
	
	Константы.ИспользоватьПризнакРассмотрено.Установить(Истина);
	Константы.ИспользоватьГруппыПользователей.Установить(Истина);
	Константы.ОграничиватьДоступНаУровнеЗаписей.Установить(Истина);
	Константы.ИспользоватьБизнесПроцессыИЗадачи.Установить(Истина);
	Константы.ИспользоватьПочтовыйКлиент.Установить(Истина);
	Константы.ОтправлятьПисьмаВФорматеHTML.Установить(Истина);
	Константы.ИспользоватьПрочиеВзаимодействия.Установить(Истина);
	
КонецПроцедуры

#КонецОбласти