
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Контрагент") Тогда
		ЭтаФорма.Заголовок = "Подписки ИТС " + сокрЛП(Параметры.Контрагент);
	КонецЕсли;
	Если Параметры.Свойство("МассивПодписки") Тогда
		Для Каждого структураПодписка Из Параметры.МассивПодписки Цикл
			строкаПодписка = Подписки.Добавить();
			ЗаполнитьЗначенияСвойств(строкаПодписка,структураПодписка);
			Если строкаПодписка.ДатаОкончания >=  ТекущаяДата() Тогда
				строкаПодписка.Активный = Истина;
			КонецеСли;	
		КонецЦикла;
	КонецЕсли;
	Если Параметры.Свойство("МассивДоговор") Тогда
		Для Каждого структураДоговор Из Параметры.МассивДоговор Цикл
			строкаДоговор = Договора.Добавить();
			ЗаполнитьЗначенияСвойств(строкаДоговор,структураДоговор);
			Если строкаДоговор.ДатаОкончания >= ТекущаяДата() Тогда
				строкаДоговор.Активная = Истина;
			КонецеСли;	
		КонецЦикла;
	КонецЕсли;
	Если Параметры.Свойство("МассивПродукты") Тогда
		Для Каждого структураПродукт Из Параметры.МассивПродукты Цикл
			строкаПродукт = ПрограммныеПродукты.Добавить();
			ЗаполнитьЗначенияСвойств(строкаПродукт,структураПродукт);
		КонецЦикла;
	КонецЕсли;
	Если Параметры.Свойство("СтруктураОбщиеДанные") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,Параметры.СтруктураОбщиеДанные);
		Если ТипЗнч(Параметры.СтруктураОбщиеДанные.ОсновнойМенеджер) = Тип("СправочникСсылка.Пользователи") Тогда
			ОсновнойМенеджер = Параметры.СтруктураОбщиеДанные.ОсновнойМенеджер;
			Элементы.ОсновнойМенеджерНаименование.Видимость = Ложь;
		Иначе
			ОсновнойМенеджерНаименование = Параметры.СтруктураОбщиеДанные.ОсновнойМенеджер;
			Элементы.ОсновнойМенеджер.Видимость = Ложь;
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры
