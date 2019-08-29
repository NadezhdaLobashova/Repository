
#Область ПРОЦЕДУРЫ_ОБРАБОТЧИКИ_СОБЫТИЙ_ФОРМЫ
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Или Не ЗначениеЗаполнено(Объект.ПериодПрогноза) Тогда
		Объект.ПериодПрогноза = НачалоМесяца(ТекущаяДата());;
	КонецЕсли;
	ЭтотОбъект.ПериодПрогнозаСтрокой = Формат(Объект.ПериодПрогноза, "ДФ = ""гггг ММММ""");
	
	Для Каждого СтрокаПоказатель из Объект.Показатели Цикл
		Если НЕ ЗначениеЗаполнено(Объект.Ссылка) или НЕ ЗначениеЗаполнено(СтрокаПоказатель.Период) Тогда
			СтрокаПоказатель.Период = ?(Объект.Проект.ОперативныйПрогнозПоДням,ТекущаяДата(),НачалоМесяца(ТекущаяДата()));
		КонецЕсли;
		Если НЕ Объект.Проект.ОперативныйПрогнозПоДням Тогда
			СтрокаПоказатель.ПериодСтрокой = Формат(СтрокаПоказатель.Период, "ДФ = ""гггг ММММ""");
		КонецЕсли;	
	КонецЦикла;
	
    УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПериодПрогнозаСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Направление = 1 Тогда
		Объект.ПериодПрогноза = КонецМесяца(Объект.ПериодПрогноза) + 1;
	Иначе
		Объект.ПериодПрогноза = НачалоМесяца(НачалоМесяца(Объект.ПериодПрогноза) - 1);
	КонецЕсли;
	
	ЭтотОбъект.ПериодПрогнозаСтрокой = Формат(Объект.ПериодПрогноза, "ДФ = ""гггг ММММ""");
	
	ПроверитьПериодПрогнозаНаПериод();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Для Каждого СтрокаСотрудник из Объект.Показатели Цикл
		ЗаполнитьДанныеПоСотруднику(СтрокаСотрудник.НомерСтроки-1);
		Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
			ПересчитатьСуммуПоСтроке(СтрокаСотрудник.Ставка,СтрокаСотрудник.Оклад,СтрокаСотрудник.Время,СтрокаСотрудник.Период);
		КонецЕсли;
	КонецЦикла;
	ИтогоПоПроекту = Объект.Показатели.Итог("Сумма");
	ИтогоПоЧасам   = Объект.Показатели.Итог("Время");
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если Не Копирование И НоваяСтрока Тогда
		ТекДанные = Элементы.Показатели.ТекущиеДанные;
		//ТекДанные.Статья = ЗаполнитьСтатьюНаСервере();
		ТекДанные.Период = ?(ОперативныйПрогнозПоДням(),ТекущаяДата(),НачалоМесяца(ТекущаяДата()));
		ТекДанные.ПериодСтрокой = Формат(ТекДанные.Период, "ДФ = ""гггг ММММ""");
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиСотрудникПриИзменении(Элемент)
	ТекущиеДанные               = Элементы.Показатели.ТекущиеДанные;
	ЗаполнитьДанныеПоСотруднику(ТекущиеДанные.НомерСтроки - 1);
	ПересчитатьСуммуПоСтроке(ТекущиеДанные.Ставка,ТекущиеДанные.Оклад,ТекущиеДанные.Время,ТекущиеДанные.Период);
	ИтогоПоПроекту              = Объект.Показатели.Итог("Сумма");
	ИтогоПоЧасам                = Объект.Показатели.Итог("Время");
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиВремяПриИзменении(Элемент)
    ТекущиеДанные        = Элементы.Показатели.ТекущиеДанные;
	Если ТекущиеДанные.Время > 8 и ОперативныйПрогнозПоДням() Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Количество часов в день не может превышать 8";
		Сообщение.Поле = "Показатели[" + (ТекущиеДанные.НомерСтроки -1) + "].Время";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;	
	ТекущиеДанные.Сумма  = ПересчитатьСуммуПоСтроке(ТекущиеДанные.Ставка,ТекущиеДанные.Оклад,ТекущиеДанные.Время,ТекущиеДанные.Период);
	ИтогоПоПроекту       = Объект.Показатели.Итог("Сумма");
	ИтогоПоЧасам         = Объект.Показатели.Итог("Время");
КонецПроцедуры

&НаКлиенте
Процедура ПроектПриИзменении(Элемент)
	УстановитьВидимостьДоступность();
	ОчиститьКонтрагентовНаСервере();
	Если ЗначениеЗаполнено(Объект.Проект) Тогда
		Объект.ЭтапПроекта = УРВСервер.НайтиОсновнойЭтапДляПодстановкиВДокументы(Объект.Проект);
	Иначе
		Объект.ЭтапПроекта = ПредопределенноеЗначение("Справочник.ЭтапыПроектов.ПустаяСсылка");
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиПериодПриИзменении(Элемент)
	ТекСтрока = Элементы.Показатели.ТекущаяСтрока;
	ПроверитьПериодПоПроекту(ТекСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Для Каждого СтрокаСотрудник из Объект.Показатели Цикл
		ЗаполнитьДанныеПоСотруднику(СтрокаСотрудник.НомерСтроки-1);
		СтрокаСотрудник.ПериодСтрокой = Формат(СтрокаСотрудник.Период, "ДФ = ""гггг ММММ""");
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиПериодСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекСтрока = Элементы.Показатели.ТекущиеДанные;
	Если Направление = 1 Тогда
		ТекСтрока.Период = КонецМесяца(ТекСтрока.Период) + 1;
	Иначе
		ТекСтрока.Период = НачалоМесяца(НачалоМесяца(ТекСтрока.Период) - 1);
	КонецЕсли;
	
	ТекСтрока.ПериодСтрокой = Формат(ТекСтрока.Период, "ДФ = ""гггг ММММ""");
	
	ПроверитьПериодПоПроекту(ТекСтрока.НомерСтроки - 1);	

КонецПроцедуры


#КонецОбласти

#Область СЛУЖЕБНЫЕ_ПРОЦЕДУРЫ_И_ФУНКЦИИ
&НаСервере
Процедура ОчиститьКонтрагентовНаСервере()
	Если НЕ Объект.Проект.УчетПоКонтрагентам Тогда
		Для Каждого СтрокаТЧ из Объект.Показатели Цикл
			СтрокаТЧ.КонтрагентАбонент = Справочники.Абоненты.ПустаяСсылка();
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Процедура УстановитьВидимостьДоступность()
	Элементы.ПоказателиКонтрагентАбонент.Видимость  = Объект.Проект.УчетПоКонтрагентам;
	Элементы.ПоказателиПериод.Видимость        		= Объект.Проект.ОперативныйПрогнозПоДням;
	Элементы.ПоказателиПериодСтрокой.Видимость 		= НЕ Объект.Проект.ОперативныйПрогнозПоДням;
	
	//Если Не РольДоступна("ПолныеПрава") Тогда
	//	Для Каждого Элемент Из Элементы.ПоказателиКоманднаяПанель.ПодчиненныеЭлементы Цикл
	//		Если Элемент.Имя = "ПоказателиДобавить" Тогда
	//			Элемент.Видимость = Ложь;
	//		КонецЕсли;
	//	КонецЦикла;
	//КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьСотрудниковЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат
	КонецЕсли;
	Для Каждого СтрокаМассива из Результат.МассивДанных Цикл
		СтрокаПоказатели = Объект.Показатели.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПоказатели,СтрокаМассива);
		//СтрокаПоказатели.Статья = ЗаполнитьСтатьюНаСервере();
		ЗаполнитьДанныеПоСотруднику(СтрокаПоказатели.НомерСтроки-1);
		ПересчитатьСуммуПоСтроке(СтрокаПоказатели.Ставка,СтрокаПоказатели.Оклад,СтрокаПоказатели.Время,СтрокаПоказатели.Период);
		СтрокаПоказатели.Период = ТекущаяДата();
		СтрокаПоказатели.ПериодСтрокой = Формат(СтрокаПоказатели.Период, "ДФ = ""гггг ММММ""");
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеПоСотруднику(НомерСтроки)
	Структура_                                   = СотрудникиСервер.ТекущаяСтавкаСотрудникаДолжностьПодразделение(Объект.Показатели[НомерСтроки].Сотрудник,Объект.Дата,Объект.Показатели[НомерСтроки].Статья);
	Объект.Показатели[НомерСтроки].Ставка        = Структура_.Ставка;
	Объект.Показатели[НомерСтроки].Оклад         = Структура_.Оклад;
	Объект.Показатели[НомерСтроки].Должность     = Структура_.Должность;
	//Объект.Показатели[НомерСтроки].Подразделение = Структура_.Подразделение;
	//Объект.Показатели[НомерСтроки].Период        = ТекущаяДата();
КонецПроцедуры	

&НаСервере
Функция ЗаполнитьСтатьюНаСервере()
	Возврат Объект.Проект.ОсновнаяСтатья;
КонецФункции	

&НаСервере
Функция ПересчитатьСуммуПоСтроке(Ставка, Оклад, Время, Период)
	Если Период = Дата(1,1,1) Тогда
		Возврат 0
	КонецЕсли;
	НормаЧасовВМесяц = СотрудникиСервер.ПолучитьНормуЧасовВПериоде(НачалоМесяца(Период),КонецМесяца(Период));
	Возврат (Ставка * Время) + (Оклад * Время/НормаЧасовВМесяц);
КонецФункции	

&НаСервере
Функция ПроверитьПериодПоПроекту(ТекСтрока)
	СтрокаДатаНачала = ?(Объект.Проект.ОперативныйПрогнозПоДням, "Указанная дата","Дата начала периода");
	СтрокаДатаОкончания = ?(Объект.Проект.ОперативныйПрогнозПоДням, "Указанная дата","Дата окончания периода");
	Если Объект.Показатели[ТекСтрока].Период < Объект.Проект.ДатаНачала Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтрокаДатаНачала + " меньше, чем дата начала проекта";
		Сообщение.Поле = "Показатели[" + (ТекСтрока) + "].Период";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Сообщить();
	КонецЕсли;
	Если Объект.Показатели[ТекСтрока].Период > Объект.Проект.ДатаОкончания Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтрокаДатаОкончания + " больше, чем дата окончания проекта";
		Сообщение.Поле = "Показатели[" + (ТекСтрока) + "].Период";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Сообщить();
	КонецЕсли;
КонецФункции

&НаСервере
Процедура ПроверитьПериодПрогнозаНаПериод()
	Если Объект.ПериодПрогноза < Объект.Проект.ДатаНачала Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Период прогноза не может быть меньше, чем дата начала проекта";
		Сообщение.Поле = "ПериодПрогноза";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Сообщить();
	КонецЕсли;
	Если Объект.ПериодПрогноза > Объект.Проект.ДатаОкончания Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Период прогноза не может быть больше, чем дата окончания проекта";
		Сообщение.Поле = "ПериодПрогноза";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Сообщить();
	КонецЕсли;
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьПоПрогнозуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат
	КонецЕсли;	
	ЗаполнитьПоПрогнозуНаСервере(Результат);
КонецПроцедуры	

Процедура ЗаполнитьПоПрогнозуНаСервере(ПрогнозСсылка) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ПрогнозПроектаПоказатели.НомерСтроки КАК НомерСтроки,
	                      |	ПрогнозПроектаПоказатели.Период КАК Период,
	                      |	ПрогнозПроектаПоказатели.Статья КАК Статья,
	                      |	ПрогнозПроектаПоказатели.Подразделение КАК Подразделение,
	                      |	ПрогнозПроектаПоказатели.Сотрудник КАК Сотрудник,
	                      |	ПрогнозПроектаПоказатели.Проект КАК Проект,
	                      |	ПрогнозПроектаПоказатели.КонтрагентАбонент КАК КонтрагентАбонент,
	                      |	ВЫБОР
	                      |		КОГДА ПрогнозПроектаПоказатели.Ссылка.Проект.ОперативныйПрогнозПоДням
	                      |			ТОГДА 0
	                      |		ИНАЧЕ ПрогнозПроектаПоказатели.Время
	                      |	КОНЕЦ КАК Время,
	                      |	ВЫБОР
	                      |		КОГДА ПрогнозПроектаПоказатели.Ссылка.Проект.ОперативныйПрогнозПоДням
	                      |			ТОГДА 0
	                      |		ИНАЧЕ ПрогнозПроектаПоказатели.Сумма
	                      |	КОНЕЦ КАК Сумма
	                      |ИЗ
	                      |	Документ.ПрогнозПроекта.Показатели КАК ПрогнозПроектаПоказатели
	                      |ГДЕ
	                      |	ПрогнозПроектаПоказатели.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("ссылка",ПрогнозСсылка);
	Объект.Показатели.Загрузить(Запрос.Выполнить().Выгрузить());
	Для Каждого СтрокаПоказателя из Объект.Показатели Цикл
		Структура_ = СотрудникиСервер.ТекущаяСтавкаСотрудникаДолжностьПодразделение(СтрокаПоказателя.Сотрудник,Объект.Дата,СтрокаПоказателя.Статья);
		ЗаполнитьЗначенияСвойств(СтрокаПоказателя,Структура_);
		СтрокаПоказателя.ПериодСтрокой = Формат(СтрокаПоказателя.Период, "ДФ = ""гггг ММММ""");
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ОперативныйПрогнозПоДням()
	Возврат Объект.Проект.ОперативныйПрогнозПоДням
КонецФункции	
#КонецОбласти


#Область КОМАНДЫ_ФОРМЫ
&НаКлиенте
Процедура Подбор(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаПодбораСотрудников", , ,,,, Новый ОписаниеОповещения("ПодобратьСотрудниковЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПрогнозу(Команда)
	Отбор = Новый Структура;
	Если ЗначениеЗаполнено(Объект.Проект) Тогда
		Отбор.Вставить("Проект",Объект.Проект);
	КонецЕсли;	
	ОткрытьФорму("Документ.ПрогнозПроекта.ФормаВыбора",Отбор , ,,,, Новый ОписаниеОповещения("ЗаполнитьПоПрогнозуЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	ЭтаФорма.ОбновитьОтображениеДанных();
КонецПроцедуры


#КонецОбласти

