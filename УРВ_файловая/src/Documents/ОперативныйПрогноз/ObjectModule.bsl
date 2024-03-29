
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	ПроведениеСервер.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольПередПроведением(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ, "ПланированиеПроектов_ОперативныйПлан");
	
	Движения.Записать();

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ЭтотОбъект.ПериодПрогноза < ЭтотОбъект.Проект.ДатаНачала Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Период прогноза не может быть меньше, чем дата начала проекта";
		Сообщение.Поле = "ПериодПрогноза";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	Если ЭтотОбъект.ПериодПрогноза > ЭтотОбъект.Проект.ДатаОкончания Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Период прогноза не может быть больше, чем дата окончания проекта";
		Сообщение.Поле = "ПериодПрогноза";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	СтрокаДатаНачала    = ?(ЭтотОбъект.Проект.ОперативныйПрогнозПоДням, "Указанная дата","Дата начала периода");
	СтрокаДатаОкончания = ?(ЭтотОбъект.Проект.ОперативныйПрогнозПоДням, "Указанная дата","Дата окончания периода");

	Для Каждого СтрокаПоказателя из ЭтотОбъект.Показатели Цикл
		Если СтрокаПоказателя.Период < ЭтотОбъект.Проект.ДатаНачала Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтрокаДатаНачала + " меньше, чем дата начала проекта";
			Сообщение.Поле = "Показатели[" + (СтрокаПоказателя.НомерСтроки - 1) + "].Период";
			Сообщение.ПутьКДанным = "Объект";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
		Если СтрокаПоказателя.Период > ЭтотОбъект.Проект.ДатаОкончания Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтрокаДатаОкончания + " больше, чем дата окончания проекта";
			Сообщение.Поле = "Показатели[" + (СтрокаПоказателя.НомерСтроки - 1) + "].Период";
			Сообщение.ПутьКДанным = "Объект";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
		Если СтрокаПоказателя.Время > 8 и ЭтотОбъект.Проект.ОперативныйПрогнозПоДням Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Количество часов в день не может превышать 8";
			Сообщение.Поле = "Показатели[" + (СтрокаПоказателя.НомерСтроки -1) + "].Время";
			Сообщение.ПутьКДанным = "Объект";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;	

КонецПроцедуры

	