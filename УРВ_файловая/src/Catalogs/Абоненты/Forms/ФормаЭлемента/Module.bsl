
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтаФорма, Объект, "ГруппаКонтактнаяИнформация", ПоложениеЗаголовкаЭлементаФормы.Лево);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь();
	// {Рарус_shav 2018.09.24 
	ЭтоПолноправныйПользователь = ЭтоПолноправныйПользователь Или (РольДоступна("Экономист") Или РольДоступна("Координатор") Или РольДоступна("РуководительПроектов") Или РольДоступна("РуководительПодразделения"));
	// }Рарус_shav 2018.09.24 
	
	// Отображение контактной информации
	Если Не (РольДоступна(Метаданные.Роли.ЧтениеИзменениеКонтактнойИнформации) Или ЭтоПолноправныйПользователь) Тогда
		Элементы.ГруппаКонтактнаяИнформация.Видимость = Ложь;
	КонецЕсли;
	
	Если ЭтоПолноправныйПользователь Тогда
		Элементы.Наименование.ТолькоПросмотр = Ложь;
		Элементы.Владелец.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВзаимоотношенияАбонентов.ВедущийАбонент
		|ИЗ
		|	РегистрСведений.ВзаимоотношенияАбонентов КАК ВзаимоотношенияАбонентов
		|ГДЕ
		|	ВзаимоотношенияАбонентов.ВедущийАбонент = &Ссылка
		|	И ВзаимоотношенияАбонентов.ВидВзаимоотношений = &ОбслуживающаяОрганизацияАбонент";
	
	Запрос.УстановитьПараметр("Ссылка",Объект.Ссылка);
	Запрос.УстановитьПараметр("ОбслуживающаяОрганизацияАбонент", Перечисления.ВидыВзаимоотношений.ОбслуживающаяОрганизацияАбонент);
	
	Если Запрос.Выполнить().Пустой() Тогда
		Элементы.ИнформацияЭтоОбслуживающаяОрганизация.Видимость = Ложь;
	Иначе
		Элементы.ИнформацияЭтоОбслуживающаяОрганизация.Видимость = Истина;
	КонецЕсли;
    
    // СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, Новый Структура("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты"));
	// Конец СтандартныеПодсистемы.Свойства
	
	// Получение списка доступных наборов свойств.
	НаборыСвойств = УправлениеСвойствамиСлужебный.ПолучитьНаборыСвойствОбъекта(Объект.Ссылка);
	Для каждого Строка Из НаборыСвойств Цикл
		ДоступныеНаборыСвойств.Добавить(Строка.Набор);
	КонецЦикла;
	
   	// Заполнение таблицы значений свойств.
	ЗаполнитьТаблицуЗначенийСвойств(Истина);
	
	Если ТаблицаЗначенийСвойств.Количество() = 0 Тогда
	    Элементы.ТаблицаЗначенийСвойств.Видимость = Ложь;
	    Элементы.ГруппаДополнительныеРеквизиты.ОтображатьЗаголовок = Ложь;
    КонецЕсли;
    
// Лобашова 04.03.2018 82241 +
	Элемент 			= ЭтаФорма.Элементы.Добавить("ОсновнойПроект", Тип("ПолеФормы"), ЭтаФорма);
    Элемент.Вид 		= ВидПоляФормы.ПолеВвода;
    Элемент.Заголовок 	= "Основной проект";
    Элемент.ПутьКДанным = "Объект.ОсновнойПроект";
// Лобашова 04.03.2018 82241 -
        
	
// {Рарус_shav 2018.09.18 72230
	Элемент 			        = ЭтаФорма.Элементы.Добавить("ИНН", Тип("ПолеФормы"), ЭтаФорма);
    Элемент.Вид 		        = ВидПоляФормы.ПолеВвода;
    Элемент.Заголовок 	        = "ИНН";
    Элемент.ПутьКДанным         = "Объект.ИНН";
// {Рарус_shav 2018.09.18 72230

// { ++ aleves <2019-06-10>
    Элемент 			= ЭтаФорма.Элементы.Добавить("КПП", Тип("ПолеФормы"), ЭтаФорма);
    Элемент.Вид 		= ВидПоляФормы.ПолеВвода;
    Элемент.Заголовок 	= "КПП";
    Элемент.ПутьКДанным = "Объект.КПП";
// } -- aleves <2019-06-10

// { ++ aleves <2019-07-02>
    Элемент 			= ЭтаФорма.Элементы.Добавить("GUID_НСИ", Тип("ПолеФормы"), ЭтаФорма);
    Элемент.Вид 		= ВидПоляФормы.ПолеВвода;
    Элемент.Заголовок 	= "GUID НСИ";
    Элемент.ПутьКДанным = "Объект.Эталон";
	Элемент.ТолькоПросмотр = Истина;
// } -- aleves <2019-07-02>

// {Рарус_shav 2018.09.18 72230	
	Элемент 			= ЭтаФорма.Элементы.Добавить("GUIDОБД", Тип("ПолеФормы"), ЭтаФорма);
    Элемент.Вид 		= ВидПоляФормы.ПолеВвода;
    Элемент.Заголовок 	= "GUID ОБД";
    Элемент.ПутьКДанным = "Объект.GUIDОБД";
	Элемент.ТолькоПросмотр = Истина;
// }Рарус_shav 2018.09.18 72230

//astyul, 15.10.2018, 72626
    СформироватьДанныеОПодпискахИДоговорахОБД();
//astyul, 15.10.2018, 72626



КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
    
    // СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
    
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
    
    // СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
    
  	ЗаписатьЗначенияСвойств();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
    
    // СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
// {Рарус_shav 2018.09.19 	
	Если ИмяСобытия = "ИзменениеДанныхОБДПоАбоненту" Тогда
		Объект.GUIDОБД       = Новый УникальныйИдентификатор(Параметр.GUIDОБД);
		Объект.Наименование  = Параметр.Наименование;
		Объект.ИНН           = Параметр.ИНН;
        Объект.КПП           = Параметр.КПП;
		УстановитьВидимостьДоступность();
	КонецЕсли;
// }Рарус_shav 2018.09.19     
КонецПроцедуры

#Область СтандартныеПодсистемы_КонтактнаяИнформация

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат)
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	
	УправлениеКонтактнойИнформациейКлиент.ПредставлениеПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Результат = УправлениеКонтактнойИнформациейКлиент.ПредставлениеНачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
	ОбновитьКонтактнуюИнформацию(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	
	Результат = УправлениеКонтактнойИнформациейКлиент.ПредставлениеОчистка(ЭтотОбъект, Элемент.Имя);
	ОбновитьКонтактнуюИнформацию(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	
	Результат = УправлениеКонтактнойИнформациейКлиент.ПодключаемаяКоманда(ЭтотОбъект, Команда.Имя);
	ОбновитьКонтактнуюИнформацию(Результат);
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуВводаАдреса(ЭтотОбъект, Результат);
	
КонецПроцедуры

&НаСервере
Функция ОбновитьКонтактнуюИнформацию(Результат = Неопределено)
	
	Возврат УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
    
    ПриИзмененииСервиса();
    
КонецПроцедуры
    
#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаЗначенийСвойств

&НаКлиенте
Процедура ТаблицаЗначенийСвойствПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗначенийСвойствПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗначенийСвойствПередУдалением(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.НомерКартинки = -1 Тогда
		Отказ = Истина;
		Элемент.ТекущиеДанные.Значение = Элемент.ТекущиеДанные.ТипЗначения.ПривестиЗначение(Неопределено);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗначенийСвойствПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Элемент.ПодчиненныеЭлементы.ТаблицаЗначенийСвойствЗначение.ОграничениеТипа
		= Элемент.ТекущиеДанные.ТипЗначения;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства

&НаКлиенте

Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)

	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);

КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Процедура ПриИзмененииСервиса()
	
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры
 
// СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#Область СлужебныеПроцедурыИФункцииСвойства

&НаСервереБезКонтекста
Функция ПрочитатьЗначенияСвойствИзРегистраСведений(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДополнительныеСведения.Свойство,
	|	ДополнительныеСведения.Значение
	|ИЗ
	|	РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
	|ГДЕ
	|	ДополнительныеСведения.Объект = &Объект";
	Запрос.УстановитьПараметр("Объект", Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуЗначенийСвойств(ИзОбработчикаПриСоздании) // Исправлено УНФ
	
	// Заполнение дерева значениями свойств.
	Если ИзОбработчикаПриСоздании Тогда
		ЗначенияСвойств = ПрочитатьЗначенияСвойствИзРегистраСведений(Объект.Ссылка);
	Иначе
		ЗначенияСвойств = ПолучитьТекущиеЗначенияСвойств();
		ТаблицаЗначенийСвойств.Очистить();
	КонецЕсли;
	
	ПроверяемаяТаблица = "РегистрСведений.ДополнительныеСведения";
	ЗначениеДоступа = Тип("ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения");
	
	Таблица = УправлениеСвойствамиСлужебный.ЗначенияСвойств(
		ЗначенияСвойств, ДоступныеНаборыСвойств, Истина);
	
	МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
	ПроверятьПрава = Не Пользователи.ЭтоПолноправныйПользователь() И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом");
	Если ПроверятьПрава Тогда
		ПроверяемыеСвойства = Таблица.ВыгрузитьКолонку("Свойство");
		РазрешенныеСвойства = МодульУправлениеДоступомСлужебный.РазрешенныеЗначенияДляДинамическогоСписка(
			ПроверяемаяТаблица,
			ЗначениеДоступа,
			ПроверяемыеСвойства);
	КонецЕсли;
	
	Для Каждого Строка Из Таблица Цикл
		ДоступноДляИзменения = Истина;
		Если ПроверятьПрава Тогда
			// Проверка на чтение свойства.
			Если РазрешенныеСвойства.Найти(Строка.Свойство) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			// Проверка на запись свойства.
			НачатьТранзакцию();
			Попытка
				Набор = РегистрыСведений.ДополнительныеСведения.СоздатьНаборЗаписей();
				Набор.Отбор.Объект.Установить(Параметры.Ссылка);
				Набор.Отбор.Свойство.Установить(Строка.Свойство);
				
				Запись = Набор.Добавить();
				Запись.Свойство = Строка.Свойство;
				Запись.Объект = Параметры.Ссылка;
				Набор.ОбменДанными.Загрузка = Истина;
				Набор.Записать(Истина);
				
				ОтменитьТранзакцию();
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
				ОтменитьТранзакцию();
				ДоступноДляИзменения = Ложь;
			КонецПопытки;
		КонецЕсли;
		
		НоваяСтрока = ТаблицаЗначенийСвойств.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		
		НоваяСтрока.НомерКартинки = ?(Строка.Удалено, 0, -1);
		НоваяСтрока.ДоступноДляИзменения = ДоступноДляИзменения;
		
		Если Строка.Значение = Неопределено
			И ОбщегоНазначения.ОписаниеТипаСостоитИзТипа(Строка.ТипЗначения, Тип("Булево")) Тогда
			НоваяСтрока.Значение = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьНаборСвойствВРегистр(Знач Ссылка, Знач ЗначенияСвойств)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для каждого Строка Из ЗначенияСвойств Цикл
		Запись = РегистрыСведений.ДополнительныеСведения.СоздатьМенеджерЗаписи();
		Запись.Свойство = Строка.Свойство;
		Запись.Значение = Строка.Значение;
		Запись.Объект   = Ссылка;
		Запись.Записать();
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекущиеЗначенияСвойств()
	
	ЗначенияСвойств = Новый ТаблицаЗначений;
	ЗначенияСвойств.Колонки.Добавить("Свойство");
	ЗначенияСвойств.Колонки.Добавить("Значение");
	
	Для каждого Строка Из ТаблицаЗначенийСвойств Цикл
		
		Если ЗначениеЗаполнено(Строка.Значение) И (Строка.Значение <> Ложь) Тогда
			НоваяСтрока = ЗначенияСвойств.Добавить();
			НоваяСтрока.Свойство = Строка.Свойство;
			НоваяСтрока.Значение = Строка.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЗначенияСвойств;
	
КонецФункции

&НаСервере
Процедура ЗаписатьЗначенияСвойств()
	
	// Запись значений свойств в регистр сведений.
	ЗначенияСвойств = Новый Массив;
	
	Для каждого Строка Из ТаблицаЗначенийСвойств Цикл
		
		Если ЗначениеЗаполнено(Строка.Значение)
		  И (Строка.Значение <> Ложь) Тогда
			
			Значение = Новый Структура("Свойство, Значение", Строка.Свойство, Строка.Значение);
			ЗначенияСвойств.Добавить(Значение);
		КонецЕсли;
	КонецЦикла;
	
	ЗаписатьНаборСвойствВРегистр(Объект.Ссылка, ЗначенияСвойств);
	
КонецПроцедуры


#КонецОбласти  

#КонецОбласти 

#Область Подписки_И_Договора_ОБД

&НаСервере
Процедура СформироватьДанныеОПодпискахИДоговорахОБД()
    
    // { ++ aleves <2019-06-05>
    Если Не ЗначениеЗаполнено(Объект.GUIDОБД) Тогда
        Возврат;
    КонецЕсли; 
    // } -- aleves <2019-06-05>
	
	Попытка
		Прокси = URMExchangeСервер.УстановитьПодключениеКВебСервису();
	Исключение
		Элементы.Декорация1.Заголовок   = "Не установлено подключение с ОБД.";
		Элементы.ДекорацияИнформация1.Видимость = Ложь;
		Элементы.ДекорацияИнформация2.Видимость = Истина;
		Элементы.Декорация1.Доступность         = Ложь;
		Элементы.Декорация1.ЦветТекста          = Новый Цвет(255,0,0);
		Возврат;
	КонецПопытки;
	
	ДанныеОБД = Прокси.CetSubscription(СокрЛП(Объект.GUIDОБД));
	
 	Если НЕ ДанныеОБД.Result Тогда
		Элементы.Декорация1.Заголовок = ДанныеОБД.Message;
		Элементы.Декорация1.Доступность = Ложь;
		Возврат
	КонецЕсли;
	
	Для Каждого строкаПодпискиXDTO Из ДанныеОБД.Subscriptions Цикл
		строкаПодписка                     = Подписки.Добавить();
		строкаПодписка.ВидПодписки         = строкаПодпискиXDTO.Type;
		строкаПодписка.ПрограммныйПродукт  = строкаПодпискиXDTO.Product;
		строкаПодписка.Серия               = строкаПодпискиXDTO.Series;
		строкаПодписка.Срок                = строкаПодпискиXDTO.Period;
		строкаПодписка.ДатаНачала          = строкаПодпискиXDTO.StartDate;
		строкаПодписка.ДатаОкончания       = строкаПодпискиXDTO.EndDate;
	КонецЦикла;
	Подписки.Сортировать("ДатаОкончания убыв");
	
	Для Каждого строкаДоговораXDTO Из ДанныеОБД.Сontracts Цикл
		строкаДоговор               = Договора.Добавить();
		строкаДоговор.Номер         = строкаДоговораXDTO.Number;
		строкаДоговор.Дата          = строкаДоговораXDTO.Date;
		строкаДоговор.ВидОперации   = строкаДоговораXDTO.OperationType;
		строкаДоговор.ДатаНачала    = строкаДоговораXDTO.StartDate;
		строкаДоговор.ДатаОкончания = строкаДоговораXDTO.EndDate;
	КонецЦикла;
	Договора.Сортировать("ДатаОкончания убыв");
	
	ЛатинскоеНаименование = ДанныеОБД.LatinName;
	Регион                = ДанныеОБД.Region;
	Группа                = ДанныеОБД.Group;
	
	ЗапросОсновнойМенеджер = Новый Запрос("ВЫБРАТЬ
	                                      |	Пользователи.Ссылка КАК Ссылка
	                                      |ИЗ
	                                      |	Справочник.Пользователи КАК Пользователи
	                                      |ГДЕ
	                                      |	Пользователи.GUIDОБД = &GUIDОБД");
	ЗапросОсновнойМенеджер.УстановитьПараметр("GUIDОБД", Новый УникальныйИдентификатор(ДанныеОБД.ManagerGUID));
	Результат = ЗапросОсновнойМенеджер.Выполнить();
	Если Результат.Пустой() ИЛИ ДанныеОБД.ManagerGUID = "00000000-0000-0000-0000-000000000000" Тогда
		ОсновнойМенеджер = ДанныеОБД.ManagerName;
	Иначе
		тзРезультат = Результат.Выгрузить();
		ОсновнойМенеджер = тзРезультат[0].Ссылка;
	КонецЕсли;
	
	Для Каждого СтрокаПродуктXDTO Из ДанныеОБД.SoftwareProducts Цикл
		СтрокаПродукт = ПрограммныеПродукты.Добавить();
		СтрокаПродукт.Продукт = СтрокаПродуктXDTO.Product;
		СтрокаПродукт.Серия   = СтрокаПродуктXDTO.Series;
	КонецЦикла;	
	
	НетДействующейПодписки = ?(Подписки.Количество() = 0 И Договора.Количество() = 0, Истина, Ложь);
	
	Если НетДействующейПодписки Тогда
		УстановитьНадписьОПодписке();
	Иначе
		ВыбиратьДействующийДоговор = Ложь;
		Если НЕ Подписки.Количество() = 0 Тогда
			Если Подписки[0].ДатаОкончания > ТекущаяДата() ИЛИ Подписки[0].ДатаОкончания = Дата(1,1,1) Тогда 
				Элементы.Декорация1.Заголовок = СокрЛП(Подписки[0].ВидПодписки) + " до " + Формат(Подписки[0].ДатаОкончания, "ДЛФ=Д");
			Иначе
				ВыбиратьДействующийДоговор = Истина;
			КонецЕсли;
		Иначе
			ВыбиратьДействующийДоговор = Истина;
		КонецЕсли;
		
		Если ВыбиратьДействующийДоговор Тогда
			Если НЕ Договора.Количество() = 0 Тогда
				Если Договора[0].ДатаОкончания >= ТекущаяДата() ИЛИ Договора[0].ДатаОкончания = Дата(1,1,1) Тогда
					Элементы.Декорация1.Заголовок = СокрЛП(Договора[0].ВидОперации) + " до " + Формат(Договора[0].ДатаОкончания, "ДЛФ=Д");
				Иначе
					УстановитьНадписьОПодписке();
				КонецЕсли;	
			Иначе
				УстановитьНадписьОПодписке();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНадписьОПодписке()
	Элементы.Декорация1.Заголовок = "Нет действующей подписки.";
	Элементы.ДекорацияИнформация1.Видимость = Ложь;
	Элементы.ДекорацияИнформация2.Видимость = Истина;
	Элементы.Декорация1.ЦветТекста          = Новый Цвет(255,0,0);
КонецПроцедуры	

&НаКлиенте
Процедура Декорация1Нажатие(Элемент)
	
	МассивПодписки = Новый Массив;
	СформироватьМассивИзТаблицы("Подписки", МассивПодписки);
	
	МассивДоговор = Новый Массив;
	СформироватьМассивИзТаблицы("Договора", МассивДоговор);
	
	МассивПродукты = Новый Массив;
	СформироватьМассивИзТаблицы("ПрограммныеПродукты", МассивПродукты);
	
	СтруктураОбщиеДанные = Новый Структура("ЛатинскоеНаименование, Группа, ОсновнойМенеджер, Регион", ЛатинскоеНаименование, Группа, ОсновнойМенеджер, Регион);
	
    ОткрытьФорму("Справочник.Абоненты.Форма.ФормаПодпискиОБД",Новый Структура("Контрагент, МассивПодписки, МассивДоговор, МассивПродукты, СтруктураОбщиеДанные",Объект.Ссылка,МассивПодписки,МассивДоговор, МассивПродукты, СтруктураОбщиеДанные));
КонецПроцедуры

&НаСервере
Процедура СформироватьМассивИзТаблицы(НаименованиеТаблицы,МассивДанных)
	тз = ЭтотОбъект[НаименованиеТаблицы].Выгрузить(); 
	Для Каждого СтрокаДанных Из тз Цикл
		СтруктураДанных = Новый Структура;
		Для Каждого Колонка Из тз.Колонки Цикл
			СтруктураДанных.Вставить(Колонка.Имя,СтрокаДанных[Колонка.Имя]);
		КонецЦикла;
		МассивДанных.Добавить(СтруктураДанных);
	КонецЦикла;	
КонецПроцедуры	

#КонецОбласти

// {Рарус_shav 2018.09.19 
&НаКлиенте
Процедура УстановитьВидимостьДоступность()
	Если ЗначениеЗаполнено(Объект.GUIDОБД) Тогда
		//Лобашова 29.04.2019 85267 +
		  Элементы.Наименование.РедактированиеТекста = Ложь;
		  Элементы.ИНН.РедактированиеТекста = Ложь;
		//Элементы.Наименование.Доступность = Ложь;
		//Элементы.ИНН.Доступность          = Ложь;
		//Лобашова 29.04.2019 85267 -
        // { ++ aleves <2019-06-10>
        Элементы.КПП.РедактированиеТекста = Ложь;
        // } -- aleves <2019-06-10>
    КонецЕсли;
    
    // { ++ aleves <2019-06-10>
    
    Если Не Объект.РегистрационныеНомера.Количество() Тогда
       Элементы.РегистрационныеНомера.Видимость = Ложь; 
   КонецЕсли;
   
   Если Не Объект.Аккаунты.Количество() Тогда
       Элементы.Аккаунты.Видимость = Ложь; 
    КонецЕсли;
    // } -- aleves <2019-06-10>
    
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьДоступность();
КонецПроцедуры


// }Рарус_shav 2018.09.19 
