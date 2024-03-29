#Область ПРОЦЕДУРЫ_ОБРАБОТЧИКИ_СОБЫТИЙ_ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ИмяОперации") Тогда
		ЭтотОбъект.ИмяОперации = Параметры.ИмяОперации;
	КонецЕсли;
		
	Если ЗначениеЗаполнено(ЭтотОбъект.ИмяОперации) Тогда
	    ПолучитьЗначенияизURMНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура ПолучитьЗначенияизURMНаСервере()
	СписокXDTO = РеквизитФормыВЗначение("Объект").ЗагрузкаДанныхИзURM(ЭтотОбъект.ИмяОперации);
	
	Если СписокXDTO = Неопределено Тогда
		Возврат;
	КонецЕСли; 
	
	Если  ИмяОперации = "GetProject" Тогда
		ИмяТаблицы = "ДанныеProject";
		ПолеСортировки = "NameProject";
	ИначеЕсли ИмяОперации = "GetPartner" ИЛИ ИмяОперации = "GetPartnerA" Тогда
		ИмяТаблицы = "ДанныеPartner";
		ПолеСортировки = "Name";
	ИначеЕсли ИмяОперации = "GetEmployee" Тогда
		ИмяТаблицы = "ДанныеEmployee";
		ПолеСортировки = "Name";
	Иначе
		Сообщить("Таблица данных не обнаружена!");
		Возврат;
	КонецЕсли;
	
	Для Каждого ЗначениеXDTO из СписокXDTO Цикл
		СтрокаОбъект = Объект[ИмяТаблицы].Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаОбъект,ЗначениеXDTO);
	КонецЦикла;	
	Объект[ИмяТаблицы].Сортировать(ПолеСортировки);
КонецПроцедуры	

#КонецОбласти

#Область СЛУЖЕБНЫЕ_ПРОЦЕДУРЫ_И_ФУНКЦИИ

&НаКлиенте
Процедура УстановитьВидимостьДоступность()
	Элементы.ГруппаПроект.Видимость       = ?(ЭтотОбъект.ИмяОперации = "GetProject"            , Истина , Ложь );
	Элементы.ГруппаКонтрагент.Видимость   = ?(ЭтотОбъект.ИмяОперации = "GetPartner" ИЛИ ЭтотОбъект.ИмяОперации = "GetPartnerA"            , Истина , Ложь );
	Элементы.ГруппаПользователи.Видимость = ?(ЭтотОбъект.ИмяОперации = "GetEmployee"           , Истина , Ложь );
	Элементы.Ошибка.Видимость             = ?(Не ЗначениеЗаполнено(ЭтотОбъект.ИмяОперации)     , Истина , Ложь );
КонецПроцедуры	

&НаСервере
Процедура СоздатьСсылкуНовогоОбъекта(ИмяОбъекта, СтруктураДанных)
	ОбъектСсылка  =   Справочники[ИмяОбъекта].СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(ОбъектСсылка,СтруктураДанных);
	Попытка
	    ОбъектСсылка.Записать();
	Исключение
	КонецПопытки;	
	СсылкаНаОбъект = ОбъектСсылка.Ссылка;
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьДокументНаСервере(ИмяОбъекта, ДанныеФормы, СтруктураДанных)
	ОбъектСсылка = ДанныеФормыВЗначение(ДанныеФормы, Тип("СправочникОбъект." + ИмяОбъекта)); 

	ОбъектСсылка = Справочники[ИмяОбъекта].СоздатьЭлемент();
	
	ЗаполнитьЗначенияСвойств(ОбъектСсылка,СтруктураДанных);
	ОбъектСсылка.GUIDОБД = Новый УникальныйИдентификатор(СтруктураДанных.GUIDОБД);
	ЗначениеВДанныеФормы(ОбъектСсылка,ДанныеФормы); 
КонецПроцедуры	

&НаСервере                                                   
Процедура НайтиОбъектПоDUID(ОбъектName, GUIDТекст)
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	" + ОбъектName + ".Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник." + ОбъектName + "  КАК 	" + ОбъектName + "
	                      |ГДЕ
	                      |		" + ОбъектName + ".GUIDОБД = &УникальныйИдентификатор");
	Запрос.УстановитьПараметр("УникальныйИдентификатор", Новый УникальныйИдентификатор(GUIDТекст));
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		СсылкаНаОбъект = Выборка.Ссылка;
	Иначе
		СсылкаНаОбъект = Неопределено;
	КонецЕсли;	  	
КонецПроцедуры	

&НаСервере
Процедура НайтиПроектПоDUID(ОбъектName, GUIDТекст)
	Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	Проекты.Ссылка
		                      |ИЗ
		                      |	Справочник.Проекты КАК Проекты
		                      |ГДЕ
		                      |	(ВЫРАЗИТЬ(Проекты.GUIDОБД КАК СТРОКА(16))) = &GUIDОБД");
		Запрос.УстановитьПараметр("GUIDОБД", GUIDТекст);
		Результат = Запрос.Выполнить();
		Если Не Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			СсылкаНаОбъект = Выборка.Ссылка;
		Иначе
			СсылкаНаОбъект = Неопределено;
		КонецЕсли;
Конецпроцедуры	

&НаКлиенте
Процедура ОткрытьФормуВЗначении(СсылкаНаОбъект)
	ОткрытьЗначение(СсылкаНаОбъект);
КонецПроцедуры
	
&НаСервере
Функция ПолучитьСписокВозможныхПроектовНаСервере(ВозможноеНаименование)
	Запрос = Новый запрос("ВЫБРАТЬ
	                      |	Проекты.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.Проекты КАК Проекты
	                      |ГДЕ
	                      |	Проекты.Наименование ПОДОБНО &Наименование");
	Запрос.УстановитьПараметр("Наименование", "%" + ВозможноеНаименование + "%");
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка")	
КонецФункции

&НаСервере
Функция ПолучитьСписокВозможныхКонтрагентовНаСервере(ВозможноеНаименование)
	Запрос = Новый запрос("ВЫБРАТЬ
	                      |	Контрагенты.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.Контрагенты КАК Контрагенты
	                      |ГДЕ
	                      |	Контрагенты.Наименование ПОДОБНО &Наименование");
	Запрос.УстановитьПараметр("Наименование", "%" + ВозможноеНаименование + "%");
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка")	
КонецФункции

&НаСервере
Функция ПолучитьСписокВозможныхАбонентовНаСервере(ВозможноеНаименование)
	Запрос = Новый запрос("ВЫБРАТЬ
	                      |	Абоненты.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.Абоненты КАК Абоненты
	                      |ГДЕ
	                      |	Абоненты.Наименование ПОДОБНО &Наименование");
	Запрос.УстановитьПараметр("Наименование", "%" + ВозможноеНаименование + "%");
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка")	
КонецФункции

&НаСервере
Функция ПолучитьСписокВозможныхПользователейНаСервере(ВозможноеНаименование)
	Запрос = Новый запрос("ВЫБРАТЬ
	                      |	Пользователи.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.Пользователи КАК Пользователи
	                      |ГДЕ
	                      |	Пользователи.Наименование ПОДОБНО &Наименование");
	Запрос.УстановитьПараметр("Наименование", "%" + ВозможноеНаименование + "%");
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка")	
КонецФункции

&НаКлиенте
Процедура СоздатьЭлементЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(Результат.ВыбранныйОбъект) = Тип("СправочникСсылка.Проекты") Тогда
		Если ЗначениеЗаполнено(Результат.ВыбранныйОбъект) Тогда
			ОткрытьЗначение(Результат.ВыбранныйОбъект);
			Оповестить("ИзменениеДанныхОБДПоПроекту",ЭтотОбъект.СтрукутраОБД);
		Иначе
			ПолучитьФормуПоТипуОбъекта("Проекты", ЭтотОбъект.СтрукутраОБД); 
		КонецЕсли;
	КонецЕсли;
	Если ТипЗнч(Результат.ВыбранныйОбъект) = Тип("СправочникСсылка.Контрагенты") Тогда
		Если ЗначениеЗаполнено(Результат.ВыбранныйОбъект) Тогда
			ОткрытьЗначение(Результат.ВыбранныйОбъект);
			Оповестить("ИзменениеДанныхОБДПоКонтрагенту",ЭтотОбъект.СтрукутраОБД);
		Иначе
			ПолучитьФормуПоТипуОбъекта("Контрагенты", ЭтотОбъект.СтрукутраОБД); 
		КонецЕсли;
	КонецЕсли;
	Если ТипЗнч(Результат.ВыбранныйОбъект) = Тип("СправочникСсылка.Абоненты") Тогда
		Если ЗначениеЗаполнено(Результат.ВыбранныйОбъект) Тогда
			ОткрытьЗначение(Результат.ВыбранныйОбъект);
			Оповестить("ИзменениеДанныхОБДПоАбоненту",ЭтотОбъект.СтрукутраОБД);
		Иначе
			ПолучитьФормуПоТипуОбъекта("Абоненты", ЭтотОбъект.СтрукутраОБД); 
		КонецЕсли;
	КонецЕсли;
	Если ТипЗнч(Результат.ВыбранныйОбъект) = Тип("СправочникСсылка.Пользователи") Тогда
		Если ЗначениеЗаполнено(Результат.ВыбранныйОбъект) Тогда
			ОткрытьЗначение(Результат.ВыбранныйОбъект);
			Оповестить("ИзменениеДанныхОБДПоПользователю",ЭтотОбъект.СтрукутраОБД);
		Иначе
			ПолучитьФормуПоТипуОбъекта("Пользователи", ЭтотОбъект.СтрукутраОБД); 
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьФормуПоТипуОбъекта(ОбъектИмя, СтруктураОтвета)
	Форма = ПолучитьФорму("Справочник." + ОбъектИмя + ".ФормаОбъекта");
	ДанныеФормы = Форма.Объект; 
	ЗаполнитьДокументНаСервере(ОбъектИмя, ДанныеФормы, СтруктураОтвета);
	Если ОбъектИмя = "Пользователи" Тогда
		Форма.ПользовательИБАутентификацияСтандартная = Истина;
		Форма.ПользовательИБПользовательОС            = СтруктураОтвета.ПользовательИнфБазыПользовательОС;
		Форма.ДоступКИнформационнойБазеРазрешен       = Истина;
		Форма.ПользовательИБИмя                       = СтруктураОтвета.ПользовательИнфБазыИмя;
	КонецЕсли;	
	КопироватьДанныеФормы(ДанныеФормы, Форма.Объект); 
	Форма.Открыть();
КонецПроцедуры

#КонецОбласти

#Область КОМАНДЫ_ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	
	СтруктураОтвета = Новый Структура();
	
	ЭтоНовый  = Истина;
	
	Если ИмяОперации = "GetProject" Тогда
		
		ТекДанные = Элементы.ДанныеProject.ТекущиеДанные;
		Если ТекДанные = Неопределено Тогда
			Возврат
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ТекДанные.GUIDProject) Тогда
			Сообщить("В выбранной строке не заполнен уникальный идентификатор!");
			Возврат
		КонецЕсли;	  	

		
		НайтиПроектПоDUID("Проекты", ТекДанные.GUIDProject);
		
		Если НЕ ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
			
			МассивВозможныхПроектов = ПолучитьСписокВозможныхПроектовНаСервере(ТекДанные.NameProject);
			Если НЕ МассивВозможныхПроектов.Количество() = 0 Тогда
				
				Режим = РежимДиалогаВопрос.ДаНет;
		        Ответ = Вопрос("В базе обнаружены похожие проекты. Показать список?", Режим, 0);
				Если Ответ = КодВозвратаДиалога.Да Тогда
					
					МассивПроектов = Новый Массив;
					Для Каждого ЗначениеМассива ИЗ МассивВозможныхПроектов Цикл
						СтруктураПроектов = Новый Структура;
						СтруктураПроектов.Вставить("Ссылка", ЗначениеМассива);
						
						ЭтотОбъект.СтрукутраОБД = Новый структура;
						ЭтотОбъект.СтрукутраОБД.Вставить("Наименование"  , ТекДанные.NameProject);
						ЭтотОбъект.СтрукутраОБД.Вставить("ДатаНачала"    , ТекДанные.StartDate);
						ЭтотОбъект.СтрукутраОБД.Вставить("ДатаОкончания" , ТекДанные.EndDate);
						ЭтотОбъект.СтрукутраОБД.Вставить("GUIDОБД"       , ТекДанные.GUIDProject);
						
						МассивПроектов.Добавить(СтруктураПроектов);
					КонецЦикла;
					ОткрытьФорму("Обработка.СозданиеОбъектовURMExchange.Форма.ПромежуточнаяФорма",Новый Структура("МассивПроектов",МассивПроектов),,,,,Новый ОписаниеОповещения("СоздатьЭлементЗавершение", ЭтаФорма),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 
					Возврат
					
				КонецЕсли;
				
			КонецЕсли;	
			
			СтруктураОтвета.Вставить("Наименование"    , ТекДанные.NameProject                                    );
			СтруктураОтвета.Вставить("ДатаНачала"      , ТекДанные.StartDate                                      );
			СтруктураОтвета.Вставить("ДатаОкончания"   , ТекДанные.EndDate                                        );
			СтруктураОтвета.Вставить("GUIDОБД"         , Новый УникальныйИдентификатор(ТекДанные.GUIDProject)     );
		Иначе
			ЭтоНовый = Ложь;
		КонецЕСли;	
				
		ФормаДляСоздания = "Справочник.Проекты.ФормаОбъекта";
		ОбъектИмя = "Проекты";
		
	ИначеЕсли ИмяОперации = "GetPartner" Тогда
		
		ТекДанные = Элементы.ДанныеPartner.ТекущиеДанные;
		Если ТекДанные = Неопределено Тогда
			Возврат
		КонецЕсли;
		
		НайтиОбъектПоDUID("Контрагенты", ТекДанные.GUIDPartner);
		
		Если Не ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
			
			МассивВозможныхКонтрагентов = ПолучитьСписокВозможныхКонтрагентовНаСервере(ТекДанные.Name);
			Если НЕ МассивВозможныхКонтрагентов.Количество() = 0 Тогда
				
				Режим = РежимДиалогаВопрос.ДаНет;
				Ответ = Вопрос("В базе обнаружены похожие контрагенты. Показать список?", Режим, 0);
				Если Ответ = КодВозвратаДиалога.Да Тогда
					
					МассивКонтрагентов = Новый Массив;
					Для Каждого ЗначениеМассива ИЗ МассивВозможныхКонтрагентов Цикл
						СтруктураКонтрагентов = Новый Структура;
						СтруктураКонтрагентов.Вставить("Ссылка", ЗначениеМассива);
						
						ЭтотОбъект.СтрукутраОБД = Новый структура;
						ЭтотОбъект.СтрукутраОБД.Вставить("Наименование"  , ТекДанные.Name);
						ЭтотОбъект.СтрукутраОБД.Вставить("ИНН"           , ТекДанные.INN);
						ЭтотОбъект.СтрукутраОБД.Вставить("GUIDОБД"       , ТекДанные.GUIDPartner);
						
						МассивКонтрагентов.Добавить(СтруктураКонтрагентов);
					КонецЦикла;
					ОткрытьФорму("Обработка.СозданиеОбъектовURMExchange.Форма.ПромежуточнаяФорма",Новый Структура("МассивКонтрагентов",МассивКонтрагентов),,,,,Новый ОписаниеОповещения("СоздатьЭлементЗавершение", ЭтаФорма),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 
					Возврат
					
				КонецЕсли;
				
			КонецЕсли;
			
			СтруктураОтвета.Вставить("Наименование"    , ТекДанные.Name                                            );
			СтруктураОтвета.Вставить("ИНН"             , ТекДанные.INN                                             );
			СтруктураОтвета.Вставить("GUIDОБД"         , Новый УникальныйИдентификатор(ТекДанные.GUIDPartner)      );
		Иначе
			ЭтоНовый = Ложь;
		КонецЕСли;
		
		ОбъектИмя = "Контрагенты";
		ФормаДляСоздания = "Справочник.Контрагенты.ФормаОбъекта";
	ИначеЕсли ИмяОперации = "GetPartnerA" Тогда
		
		ТекДанные = Элементы.ДанныеPartner.ТекущиеДанные;
		Если ТекДанные = Неопределено Тогда
			Возврат
		КонецЕсли;
		
		НайтиОбъектПоDUID("Абоненты", ТекДанные.GUIDPartner);
		
		Если Не ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
			
			МассивВозможныхАбонентов = ПолучитьСписокВозможныхАбонентовНаСервере(ТекДанные.Name);
			Если НЕ МассивВозможныхАбонентов.Количество() = 0 Тогда
				
				Режим = РежимДиалогаВопрос.ДаНет;
				Ответ = Вопрос("В базе обнаружены похожие абоненты. Показать список?", Режим, 0);
				Если Ответ = КодВозвратаДиалога.Да Тогда
					
					МассивАбонентов = Новый Массив;
					Для Каждого ЗначениеМассива ИЗ МассивВозможныхАбонентов Цикл
						СтруктураАбонентовв = Новый Структура;
						СтруктураАбонентовв.Вставить("Ссылка", ЗначениеМассива);
						
						ЭтотОбъект.СтрукутраОБД = Новый структура;
						ЭтотОбъект.СтрукутраОБД.Вставить("Наименование"  , ТекДанные.Name);
						ЭтотОбъект.СтрукутраОБД.Вставить("ИНН"           , ТекДанные.INN);
						ЭтотОбъект.СтрукутраОБД.Вставить("GUIDОБД"       , ТекДанные.GUIDPartner);
						
						МассивАбонентов.Добавить(СтруктураАбонентовв);
					КонецЦикла;
					ОткрытьФорму("Обработка.СозданиеОбъектовURMExchange.Форма.ПромежуточнаяФорма",Новый Структура("МассивАбонентов",МассивАбонентов),,,,,Новый ОписаниеОповещения("СоздатьЭлементЗавершение", ЭтаФорма),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 
					Возврат
					
				КонецЕсли;
				
			КонецЕсли;
			
			СтруктураОтвета.Вставить("Наименование"    , ТекДанные.Name                                            );
			СтруктураОтвета.Вставить("ИНН"             , ТекДанные.INN                                             );
			СтруктураОтвета.Вставить("GUIDОБД"         , Новый УникальныйИдентификатор(ТекДанные.GUIDPartner)      );
		Иначе
			ЭтоНовый = Ложь;
		КонецЕСли;
		
		ОбъектИмя = "Абоненты";
		ФормаДляСоздания = "Справочник.Абоненты.ФормаОбъекта";
	
	ИначеЕсли ИмяОперации = "GetEmployee" Тогда
		
	    ТекДанные = Элементы.ДанныеEmployee.ТекущиеДанные;
		Если ТекДанные = Неопределено Тогда
			Возврат
		КонецЕсли;
		
		НайтиОбъектПоDUID("Пользователи", ТекДанные.GUID);
		
		Если НЕ ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
			
			МассивВозможныхПользователей = ПолучитьСписокВозможныхПользователейНаСервере(ТекДанные.Name);
			Если НЕ МассивВозможныхПользователей.Количество() = 0 Тогда
				
				Режим = РежимДиалогаВопрос.ДаНет;
				Ответ = Вопрос("В базе обнаружены похожие пользователи. Показать список?", Режим, 0);
				Если Ответ = КодВозвратаДиалога.Да Тогда
					
					МассивПользователей = Новый Массив;
					Для Каждого ЗначениеМассива ИЗ МассивВозможныхПользователей Цикл
						СтруктураПользователи = Новый Структура;
						СтруктураПользователи.Вставить("Ссылка", ЗначениеМассива);
						                                                                                                     
						ЭтотОбъект.СтрукутраОБД = Новый структура;
						ЭтотОбъект.СтрукутраОБД.Вставить("Наименование"                       , ТекДанные.Name);
						ЭтотОбъект.СтрукутраОБД.Вставить("GUIDОБД"                            , ТекДанные.GUID);
						ЭтотОбъект.СтрукутраОБД.Вставить("ПользовательИнфБазыПользовательОС"  , ТекДанные.authentication);
						ЭтотОбъект.СтрукутраОБД.Вставить("ПользовательИнфБазыИмя"             , ТекДанные.Name);
						
						МассивПользователей.Добавить(СтруктураПользователи);
					КонецЦикла;
					ОткрытьФорму("Обработка.СозданиеОбъектовURMExchange.Форма.ПромежуточнаяФорма",Новый Структура("МассивПользователей",МассивПользователей),,,,,Новый ОписаниеОповещения("СоздатьЭлементЗавершение", ЭтаФорма),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 
					Возврат
					
				КонецЕсли;
				
			КонецЕсли;
			
			
			СтруктураОтвета.Вставить("Наименование"                       , ТекДанные.Name                               );
			СтруктураОтвета.Вставить("GUIDОБД"                            , Новый УникальныйИдентификатор(ТекДанные.GUID));
			СтруктураОтвета.Вставить("ПользовательИнфБазыПользовательОС"  , ТекДанные.authentication                     );
			СтруктураОтвета.Вставить("ПользовательИнфБазыИмя"             , ТекДанные.Name                               );
			
		Иначе
			ЭтоНовый = Ложь;
		КонецЕСли;
		
		ФормаДляСоздания = "Справочник.Пользователи.ФормаОбъекта";
		ОбъектИмя = "Пользователи";
		
	Иначе
		Сообщить("Не Задано значение метода.");
		Возврат
	КонецЕсли;
	
	Если ЭтоНовый Тогда
		ПолучитьФормуПоТипуОбъекта(ОбъектИмя, СтруктураОтвета);
	Иначе
		Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Вопрос("Объект уже создан. Открыть его?", Режим, 0);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
		ОткрытьФормуВЗначении(СсылкаНаОбъект);
	КонецЕсли;
	

КонецПроцедуры

#КонецОбласти





