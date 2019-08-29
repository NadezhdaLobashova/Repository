
&НаКлиенте
Процедура ОК(Команда)
	Если Не ПроверитьЗаполнение() Тогда
		ВозВрат;
	КонецЕсли;
	Если Не СоздатьДокументыНаСервере() Тогда
		ВозВрат;
	КонецЕсли;
	СтруктураВозВрата = Новый Структура;
	СтруктураВозВрата.Вставить("РезультатОткрытия"			, Истина);
	Закрыть(СтруктураВозВрата);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	БоР_ОбщийМодуль.ЗаполнитьРеквизитыИзПараметров(ЭтаФорма, Неопределено);
	Если ЭтоАдресВременногоХранилища(Адрес_ДанныеСлотов) Тогда
		ДанныеСлотов = ПолучитьИзВременногоХранилища(Адрес_ДанныеСлотов);
		Если ТипЗнч(ДанныеСлотов) = Тип("Массив") Тогда
			Для каждого СтрокаСотрудника Из ДанныеСлотов Цикл
				Для каждого СтрокаСлота Из СтрокаСотрудника.Слоты Цикл
					СтрокаТаблицаСлотов = ТаблицаСлотов.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТаблицаСлотов, СтрокаСлота);
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	БоР_ОбщийМодуль.ПроверитьЗаполнениеРеквизитаТЧФормы("ДоступныеВидыУслуг", "ВидУслуги", ЭтаФорма, Отказ);
КонецПроцедуры

&НаСервере
Функция СоздатьДокументыНаСервере() Экспорт
	
	ТекущаяДата = ТекущаяДата();
	//Если Списком Тогда
		ТаблицаДляЗаполнения = ТаблицаСлотов.Выгрузить();
	//Иначе
	//	МассивСтрок = Новый Массив;
	//	МассивСтрок.Добавить(ТаблицаСлотов[0]);
	//	//ТаблицаДляЗаполнения = ТаблицаСлотов.Выгрузить(МассивСтрок);
	//	ТаблицаДляЗаполнения = МассивСтрок;
	//КонецЕсли;
	//
	//Если ТаблицаДляЗаполнения.Количество() > 1 Тогда
	//	БоР_ОбщийМодуль.ПронумероватьТЗ(ТаблицаДляЗаполнения);
	//	Если Не ПроверитьСамопересечения(ТаблицаДляЗаполнения) Тогда
	//		ВозВрат Ложь;
	//	КонецЕсли;
	//КонецЕсли;
	
	МассивДокументов = Новый Массив;
	ДокументОбъект = Документы.УстановкаОграниченийЗаписиНаЛК_ПоВидамУслуг.СоздатьДокумент();
	ДокументОбъект.Дата					= ТекущаяДата;
	ДокументОбъект.ИсточникСоздания		= "РасписаниеЛК";
	Для каждого СтрокаТаблицаДляЗаполнения Из ТаблицаДляЗаполнения Цикл
		СтрокаЭлементыРасписания = ДокументОбъект.ЭлементыРасписания.Добавить();
		СтрокаЭлементыРасписания.Сотрудник				= СтрокаТаблицаДляЗаполнения.Сотрудник;
		СтрокаЭлементыРасписания.ДатаВремяНачала		= СтрокаТаблицаДляЗаполнения.ДатаВремяНачала;
	КонецЦикла;
	Для каждого СтрокаДоступныеВидыУслуг Из ДоступныеВидыУслуг Цикл
		СтрокаОграничения = ДокументОбъект.Ограничения.Добавить();
		СтрокаОграничения.ВидУслуги	= СтрокаДоступныеВидыУслуг.ВидУслуги;
	КонецЦикла;
	МассивДокументов.Добавить(ДокументОбъект);
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	Для каждого ДокументОбъект Из МассивДокументов Цикл
		Попытка
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Оперативный);
		Исключение
			ОтменитьТранзакцию();
			#Область Вывод_сообщений
			СообщенияПользователю = ПолучитьСообщенияПользователю(Истина);
			Если СообщенияПользователю.Количество() > 0 Тогда // есть что сказать
				ТекстОшибки = "";
				Для каждого СообщениеПользователю Из СообщенияПользователю Цикл
					ТекстОшибки = ТекстОшибки + ?(ЗначениеЗаполнено(ТекстОшибки), Символы.ПС, "") + СообщениеПользователю.Текст;
				КонецЦикла;
				Сообщить(ТекстОшибки);
			Иначе
				ТекстОшибки = "Ошибка при создании документа " + ДокументОбъект.Метаданные().Синоним + "" + Символы.ПС;
				Сообщить(ТекстОшибки + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецЕсли;
			#КонецОбласти
			ВозВрат Ложь;
		КонецПопытки;
	КонецЦикла;
	ЗафиксироватьТранзакцию();
	
	ВозВрат Истина;

КонецФункции
