

//==================================================================================================
#Область СобытияФормы
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		Для каждого текЭлемент Из ВыбранноеЗначение Цикл
		
			Если ТипЗнч(текЭлемент) = Тип("СправочникСсылка.ВидыУслуг") Тогда
				строкиТЗ = ТЗ_ВидыУслуг.НайтиСтроки(Новый Структура("ВидУслуги", текЭлемент));
				Если строкиТЗ.Количество() = 0 Тогда
					строкаТЗ = ТЗ_ВидыУслуг.Добавить();
					строкаТЗ.ВидУслуги = текЭлемент;
				КонецЕсли;
				
			ИначеЕсли ТипЗнч(текЭлемент) = Тип("СправочникСсылка.Абоненты") Тогда
				строкиТЗ = ТЗ_Контрагенты.НайтиСтроки(Новый Структура("Контрагент", текЭлемент));
				Если строкиТЗ.Количество() = 0 Тогда
					строкаТЗ = ТЗ_Контрагенты.Добавить();
					строкаТЗ.Контрагент = текЭлемент;
				КонецЕсли;
				
			КонецЕсли;
		
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


//==================================================================================================
#Область СобытияЭлементовФормы
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура КомандаПодборВидовУслуг(Команда)
	
	//ФормаПодбора = Справочники.ВидыУслуг.ПолучитьФормуВыбора(, ЭтаФорма);
	ФормаПодбора = ПолучитьФорму("Справочник.ВидыУслуг.ФормаВыбора",,ЭтаФорма);
	ФормаПодбора.ПараметрВыборГруппИЭлементов	= ИспользованиеГруппИЭлементов.Элементы;
	ФормаПодбора.МножественныйВыбор           	= Истина;
	ФормаПодбора.ЗакрыватьПриВыборе           	= Ложь;
	ФормаПодбора.ЗакрыватьПриЗакрытииВладельца	= Истина;
	ФормаПодбора.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПодборКонтрагенты(Команда)
	
	//ФормаПодбора = Справочники..ПолучитьФормуВыбора(, ЭтаФорма);
	ФормаПодбора = ПолучитьФорму("Справочник.Абоненты.ФормаВыбора",,ЭтаФорма);
	ФормаПодбора.ПараметрВыборГруппИЭлементов	= ИспользованиеГруппИЭлементов.Элементы;
	ФормаПодбора.МножественныйВыбор           	= Истина;
	ФормаПодбора.ЗакрыватьПриВыборе           	= Ложь;
	ФормаПодбора.ЗакрыватьПриЗакрытииВладельца	= Истина;
	ФормаПодбора.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавитьВДокумент(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ВидыУслуг = Новый Массив;
	ТЗ_ВидыУслуг.Сортировать("ВидУслуги");
	Для каждого строкаТЗ Из ТЗ_ВидыУслуг Цикл
		ВидыУслуг.Добавить(строкаТЗ.ВидУслуги);
	КонецЦикла;
	
	Контрагенты = Новый Массив;
	ТЗ_Контрагенты.Сортировать("Контрагент");
	Для каждого строкаТЗ Из ТЗ_Контрагенты Цикл
		Контрагенты.Добавить(строкаТЗ.Контрагент);
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("ДатаНачала"		, ДатаНачала);
	Результат.Вставить("ДатаОкончания"	, ДатаОкончания);
	Результат.Вставить("Отменить"		, Отменить);
	Результат.Вставить("ВидыУслуг"		, ВидыУслуг);
	Результат.Вставить("Контрагенты"	, Контрагенты);
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

//==================================================================================================
#Область СобытияОбщегоНазначения
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ


#КонецОбласти


//==================================================================================================
   
   

