////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура ПрочитатьЗначенияПараметров()
	
	Представление    = Параметры.Представление;
	НаименованиеВида = Строка(Параметры.Вид);
	
	Для Каждого ЭлементТелефона Из Параметры.ЗначенияПолей Цикл
		ЭтаФорма[ЭлементТелефона.Представление] = ЭлементТелефона.Значение;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗначенияПараметров()
	
	ЗначенияПолей = Новый СписокЗначений;
	ЗначенияПолей.Добавить(КодСтраны,     "КодСтраны");
	ЗначенияПолей.Добавить(КодГорода,     "КодГорода");
	ЗначенияПолей.Добавить(НомерТелефона, "НомерТелефона");
	ЗначенияПолей.Добавить(Добавочный,    "Добавочный");
	ЗначенияПолей.Добавить(Комментарий,   "Комментарий");
	
	Результат = Новый Структура;
	Результат.Вставить("ЗначенияПолей", ЗначенияПолей);
	Результат.Вставить("Представление", Представление);
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПрочитатьЗначенияПараметров();
	
	ПредставлениеСВидом = НаименованиеВида + ": " + Представление;
	Заголовок = НаименованиеВида;
	
	БылиНажатыКнопкиЗакрытия = Ложь;
	
	Если НЕ ПустаяСтрока(Параметры.Заголовок) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность И Не БылиНажатыКнопкиЗакрытия Тогда
		
		ТекстВопроса = НСтр("ru = 'Даные были изменены. Отказаться от изменений?'");
		
		Ответ = Вопрос(ТекстВопроса,  РежимДиалогаВопрос.ОКОтмена);
		
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ПолеПриИзменении(Элемент)
	
	Если Не ПустаяСтрока(КодСтраны) И Лев(КодСтраны, 1) <> "+" Тогда
		КодСтраны = "+" + КодСтраны;
	КонецЕсли;
	
	Представление = УправлениеКонтактнойИнформациейКлиент.СформироватьПредставлениеТелефона(КодСтраны, КодГорода, НомерТелефона, Добавочный, Комментарий);
	ПредставлениеСВидом = НаименованиеВида + ": " + Представление;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОКВыполнить()
	
	БылиНажатыКнопкиЗакрытия = Истина;
	Закрыть(ПолучитьЗначенияПараметров());
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтменаВыполнить()
	
	БылиНажатыКнопкиЗакрытия = Истина;
	Закрыть();
	
КонецПроцедуры

