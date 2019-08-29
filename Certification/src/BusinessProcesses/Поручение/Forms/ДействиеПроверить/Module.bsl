
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Для нового объекта выполняем код инициализации формы в ПриСозданииНаСервере.
	// Для существующего - в ПриЧтенииНаСервере.
	Если Объект.Ссылка.Пустая() Тогда
		ИнициализацияФормы();
	КонецЕсли;
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	БизнесПроцессыИЗадачиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ВыполнитьЗадачу = Ложь;
	Если НЕ (ПараметрыЗаписи.Свойство("ВыполнитьЗадачу", ВыполнитьЗадачу) И ВыполнитьЗадачу) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПоручениеВыполнено И НЕ ПоручениеПодтверждено 
		И НЕ ЗначениеЗаполнено(ТекущийОбъект.РезультатВыполнения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Укажите причину, по которой задача возвращается на доработку.'"),,
			"Объект.РезультатВыполнения",,
			Отказ);
		Возврат;
	ИначеЕсли НЕ ПоручениеВыполнено И ПоручениеПодтверждено 
		И НЕ ЗначениеЗаполнено(ТекущийОбъект.РезультатВыполнения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Укажите причину, по которой задача отменяется.'"),,
			"Объект.РезультатВыполнения",,
			Отказ);		
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ПоручениеОбъект = ТекущийОбъект.БизнесПроцесс.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(ПоручениеОбъект.Ссылка);
	
	ПоручениеОбъект.ДополнительныеСвойства.Вставить("ТекущаяЗадача", Объект.Ссылка);
	ПоручениеОбъект.ДополнительныеСвойства.Вставить("ОтправленоНаДоработку", Не ПоручениеВыполнено);
	ПоручениеОбъект.Выполнено = ПоручениеВыполнено;
	ПоручениеОбъект.Подтверждено = ПоручениеПодтверждено;
	
	Если ЗначениеЗаполнено(Исполнитель) И ПоручениеОбъект.Исполнитель <> Исполнитель Тогда
		ПоручениеОбъект.Исполнитель = Исполнитель;
	КонецЕсли;
	
	ПоручениеОбъект.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИнициализацияФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	БизнесПроцессыИЗадачиКлиент.ФормаЗадачиОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	Если ИмяСобытия = "Запись_Поручение" Тогда
		Если (Источник = ПоручениеСсылка ИЛИ (ТипЗнч(Источник) = Тип("Массив") 
			И Источник.Найти(ПоручениеСсылка) <> Неопределено)) Тогда
			Прочитать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СрокНачалаИсполненияПриИзменении(Элемент)
	
	Если Объект.ДатаНачала = НачалоДня(Объект.ДатаНачала) Тогда
		Объект.ДатаНачала = КонецДня(Объект.ДатаНачала);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(,Объект.Предмет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Выполнено(Команда)
	
	ПоручениеПодтверждено = Истина;
	ПоручениеВыполнено = Истина;
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Возвращено(Команда)
	
	ПараметрыФормы = Новый Структура("БизнесПроцесс, ТочкаМаршрута, ВозвратНаДоработку", Объект.БизнесПроцесс, Объект.ТочкаМаршрута, Истина);
	Оповещение = Новый ОписаниеОповещения("ВозвращеноЗавершение", ЭтотОбъект);
	 
	ОткрытьФорму("БизнесПроцесс.Поручение.Форма.РезультатВыполнения", ПараметрыФормы, ЭтаФорма,,,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвращеноЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Объект.РезультатВыполнения = Результат.РезультатВыполнения;
	Исполнитель = Результат.Исполнитель;
	
	ПоручениеПодтверждено = Ложь;
	ПоручениеВыполнено = Ложь;
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Отменено(Команда)
	
	ПоручениеПодтверждено = Истина;
	ПоручениеВыполнено = Ложь;
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПоручениеВыполнить(Команда)
	
	Записать();
	ПоказатьЗначение(,ПоручениеСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Дополнительно(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОткрытьДопИнформациюОЗадаче(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ПринятьЗадачуКИсполнению(ЭтотОбъект, ТекущийПользователь);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОтменитьПринятиеЗадачиКИсполнению(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализацияФормы()
	
	НачальныйПризнакВыполнения = Объект.Выполнена;
	ПрочитатьРеквизитыБизнесПроцесса();
	УстановитьСостояниеЭлементов();
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокНачалаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ДатаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.СрокИсполнения);
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.Дата);
	
	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(ЭтотОбъект, Объект, 
		Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);
	Элементы.ОписаниеРезультата.ТолькоПросмотр = Объект.Выполнена;
	Исполнитель = ?(ЗначениеЗаполнено(Объект.Исполнитель), Объект.Исполнитель, Объект.РольИсполнителя);
	
	Если ПравоДоступа("Изменение", Метаданные.БизнесПроцессы.Поручение) Тогда
		Элементы.Выполнено.Доступность = Истина;
		Элементы.Отменено.Доступность = Истина;
		Элементы.Возвращено.Доступность = Истина;
	Иначе
		Элементы.Выполнено.Доступность = Ложь;
		Элементы.Отменено.Доступность = Ложь;
		Элементы.Возвращено.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьРеквизитыБизнесПроцесса()
	
	ЗадачаОбъект = РеквизитФормыВЗначение("Объект");
	
	УстановитьПривилегированныйРежим(Истина);
	ПоручениеОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
	ПоручениеВыполнено = ПоручениеОбъект.Выполнено;
	ПоручениеСсылка = ПоручениеОбъект.Ссылка;
	ПоручениеПодтверждено = ПоручениеОбъект.Подтверждено;
	ПоручениеСодержание = ПоручениеОбъект.СодержаниеХранилище.Получить();
	
	Если Не ПустаяСтрока(ПоручениеОбъект.РезультатВыполнения) Тогда
		ИсторияВыполнения = НСтр("ru='
			|
			|-------------------------------------
			|История выполнения:
			|
			|'") + ПоручениеОбъект.РезультатВыполнения;
		ИсторияФорматированная = Новый ФорматированныйДокумент;
		ИсторияФорматированная.Добавить(ИсторияВыполнения, Тип("ТекстФорматированногоДокумента"));
		ВзаимодействияУСП.ДобавитьФорматированныйДокументКФорматированномуДокументу(ПоручениеСодержание, ИсторияФорматированная);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеЭлементов()
	
	БизнесПроцессы.Поручение.УстановитьСостояниеЭлементовФормыЗадачи(ЭтотОбъект);
	
КонецПроцедуры	

#КонецОбласти
