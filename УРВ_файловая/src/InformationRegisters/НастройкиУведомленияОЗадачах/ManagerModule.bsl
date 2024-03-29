
#Область ПрограммныйИнтерфейс

// Возвращает настройку пользователя уведомления о сроке задачи
Функция ПолучитьНастройку(Пользователь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиУведомленияОЗадачах.СрокУведомления,
		|	НастройкиУведомленияОЗадачах.ЧастотаПриближениеСрока,
		|	НастройкиУведомленияОЗадачах.ЧастотаПросроченныеЗадачи
		|ИЗ
		|	РегистрСведений.НастройкиУведомленияОЗадачах КАК НастройкиУведомленияОЗадачах
		|ГДЕ
		|	НастройкиУведомленияОЗадачах.Пользователь = &Пользователь";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		
		НастройкаУведомлений = 
			Новый Структура("СрокПодошелСрокЗадачи, ЧастотаПодошелСрокЗадачи, ЧастотаПросроченаЗадача",
			ВыборкаДетальныеЗаписи.СрокУведомления,
			ВыборкаДетальныеЗаписи.ЧастотаПриближениеСрока,
			ВыборкаДетальныеЗаписи.ЧастотаПросроченныеЗадачи);
		
		Возврат НастройкаУведомлений;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Записывает настройку уведомления о сроке задачи
Процедура СохранитьНастройку(Пользователь, СрокУведомления, ЧастотаПриближениеСрока, ЧастотаПросроченныеЗадачи) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.НастройкиУведомленияОЗадачах.СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.Прочитать();
	
	Запись.Пользователь = Пользователь;
	Запись.СрокУведомления = СрокУведомления;
	Запись.ЧастотаПриближениеСрока = ЧастотаПриближениеСрока;
	Запись.ЧастотаПросроченныеЗадачи = ЧастотаПросроченныеЗадачи;
	Запись.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти