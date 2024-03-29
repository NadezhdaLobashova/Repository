
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзменениеДанныхОБДПоКонтрагенту" Тогда
		Объект.GUIDОБД       = Новый УникальныйИдентификатор(Параметр.GUIDОБД);
		Объект.Наименование  = Параметр.Наименование;
		Объект.ИНН           = Параметр.ИНН;
		УстановитьВидимостьДоступность();
	КонецЕсли;
КонецПроцедуры	

&НаКлиенте
Процедура ОбновитьДанные(Команда)
	ОбновитьДанныеНаСервере();
КонецПроцедуры

#Область СлужебныеПроцедуры_и_функции

&НаКлиенте
Процедура УстановитьВидимостьДоступность()
	Если ЗначениеЗаполнено(Объект.GUIDОБД) Тогда
		Элементы.Наименование.Доступность = Ложь;
		Элементы.ИНН.Доступность          = Ложь;
	КонецЕсли;
	Элементы.ФормаОбновитьДанные.Доступность = ЗначениеЗаполнено(Объект.GUIDОБД);
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеНаСервере()
	Если НЕ URMExchangeСервер.ПолучитьКонстантуОбменСОБД() Тогда
		  Сообщение = Новый СообщениеПользователю;
		  Сообщение.Текст = "Обновление контрагента из ОБД не предусмотрено!";
		  Сообщение.Сообщить();
		  Возврат;
	КонецЕсли;
	ОбработкаОбъект = Обработки.СозданиеОбъектовURMExchange.Создать();
	таблицаXDTO = ОбработкаОбъект.ЗагрузкаДанныхИзURM("GetPartner",Строка(Объект.GUIDОБД));
	Если таблицаXDTO.Количество() = 0 Тогда
		Сообщить("Данные по контрагенту не найдены.");
		Возврат
	КонецЕсли;
	строкаXDTO = таблицаXDTO[0];
	ИзмененияДоступны = Ложь;
	Если строкаXDTO.Name <> Объект.Наименование Тогда
		Объект.Наименование = строкаXDTO.Name;
		ИзмененияДоступны = Истина;
	КонецЕсли;
	Если строкаXDTO.INN <> Объект.ИНН Тогда
		Объект.INN = строкаXDTO.ИНН;
		ИзмененияДоступны = Истина;
	КонецЕсли;
	Если ИзмененияДоступны Тогда
		Модифицированность = Истина;
	Иначе
		Сообщить("Данные не изменились.");
	КонецЕсли;	
КонецПроцедуры	

#КонецОбласти