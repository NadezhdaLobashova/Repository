
&НаКлиенте
Процедура ОК(Команда)
	
	ВыбраннаяСтрока = Элементы.ТаблицаРасписания.ТекущиеДанные;
	Если ВыбраннаяСтрока = Неопределено Тогда
		ВозВрат;
	КонецЕсли;
	
	ОбработатьВыборСтроки(ВыбраннаяСтрока)
КонецПроцедуры
	
&НаКлиенте
Процедура ОбработатьВыборСтроки(ВыбраннаяСтрока)
	СтруктураВозВрата = Новый Структура;
	СтруктураВозВрата.Вставить("Сотрудник"			, ВыбраннаяСтрока.Сотрудник);
	СтруктураВозВрата.Вставить("Работа"				, ВыбраннаяСтрока.Работа);
	СтруктураВозВрата.Вставить("Проект"				, ВыбраннаяСтрока.Проект);
	//СтруктураВозВрата.Вставить("Задание"			, ВыбраннаяСтрока.Задание);
	СтруктураВозВрата.Вставить("ДатаВремяНачала"	, ВыбраннаяСтрока.ДатаВремяНачала);
	СтруктураВозВрата.Вставить("Контрагент"			, ВыбраннаяСтрока.Контрагент);
	СтруктураВозВрата.Вставить("КонтактноеЛицо"		, ВыбраннаяСтрока.КонтактноеЛицо);
	СтруктураВозВрата.Вставить("ВидУслуги"			, ВыбраннаяСтрока.ВидУслуги);
	СтруктураВозВрата.Вставить("ТемаВопроса"		, ВыбраннаяСтрока.ТемаВопроса);
	Закрыть(СтруктураВозВрата);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуРасписанияНаСервере()
	
	ТекущаяДата = ТекущаяДата();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	
	#Область Запрос
	"ВЫБРАТЬ
	|	РасписаниеКонсультацийСрезПоследних.Сотрудник КАК Сотрудник,
	|	РасписаниеКонсультацийСрезПоследних.Работа КАК Работа,
	|	РасписаниеКонсультацийСрезПоследних.Проект КАК Проект,
	|	РасписаниеКонсультацийСрезПоследних.Задание КАК Задание,
	|	РасписаниеКонсультацийСрезПоследних.ДатаВремяНачала КАК ДатаВремяНачала,
	|	РасписаниеКонсультацийСрезПоследних.Контрагент,
	|	РасписаниеКонсультацийСрезПоследних.КонтактноеЛицо,
	|	РасписаниеКонсультацийСрезПоследних.НеДействует,
	|	РасписаниеКонсультацийСрезПоследних.Состояние,
	|	РасписаниеКонсультацийСрезПоследних.ДатаВремяОкончания,
	|	РасписаниеКонсультацийСрезПоследних.Продолжительность,
	|	РасписаниеКонсультацийСрезПоследних.ВидУслуги,
	|	РасписаниеКонсультацийСрезПоследних.ТемаВопроса
	|ИЗ
	|	РегистрСведений.РасписаниеКонсультаций.СрезПоследних(
	|			&Момент,
	|			&УсловиеПоСотруднику
	|				И ДатаВремяНачала >= &ДатаНачала
	|				И ДатаВремяНачала <= &ДатаОкончания) КАК РасписаниеКонсультацийСрезПоследних
	|ГДЕ
	|	НЕ РасписаниеКонсультацийСрезПоследних.НеДействует
	|	И РасписаниеКонсультацийСрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЭлементаРасписанияЛК.Запланировано)
	|	И РасписаниеКонсультацийСрезПоследних.Работа.РаботаПоРасписанию
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сотрудник,
	|	ДатаВремяНачала";
	#КонецОбласти
	
	Если ЗначениеЗаполнено(ДокументСсылка) Тогда
		Момент = Новый Граница(Новый МоментВремени(ДатаАктуальности, ДокументСсылка), ВидГраницы.Исключая);
	ИначеЕсли НачалоДня(ДатаАктуальности) = НачалоДня(ТекущаяДата) Тогда
		Момент = Неопределено;
	Иначе
		Момент = ДатаАктуальности;
	КонецЕсли;
	
	ДР = Бор_ПовторноеИспользованиеКлиентСервер.ПолучитьДоступностьРолей();
	ДоступностьПодчиненныхПодразделенийЛК	= Истина;
	ДоступностьСвоегоПодразделенияЛК		= Истина;
	ДоступностьВсегоДляПП					= БоР_ОбщийМодульКлиентСервер.ВБулево(БоР_ОбщийМодуль.ПолучитьНастройку("ЛК_ПолнымПравамДоступныВсеСотрудники"));
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоСотруднику", "Сотрудник = &Сотрудник");
		Запрос.УстановитьПараметр("Сотрудник"		, Сотрудник);
	ИначеЕсли ДР.ПолныеПрава И ДоступностьВсегоДляПП Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоСотруднику", "ИСТИНА");
	Иначе // все доступные
		// возможно, надо заменить "В" на соединения с ВТ, но при малом объеме списка - и так неплохо
		МассивСотрудников = РегистрыСведений.РолиСотрудниковЛК.ПолучитьМассивДоступныхСотрудников(ДоступностьПодчиненныхПодразделенийЛК, ДоступностьСвоегоПодразделенияЛК);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоСотруднику", "Сотрудник В (&МассивСотрудников)");
		Запрос.УстановитьПараметр("МассивСотрудников"			, МассивСотрудников);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Момент"			, Момент);
	Запрос.УстановитьПараметр("ДатаНачала"		, НачалоДня(Дата));
	Запрос.УстановитьПараметр("ДатаОкончания"	, КонецДня(Дата));
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	РезультатЗапроса = РезультатыЗапроса[РезультатыЗапроса.Количество() - 1];
	
	ТаблицаРасписания.Загрузить(РезультатЗапроса.Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	БоР_ОбщийМодуль.ЗаполнитьРеквизитыИзПараметров(ЭтаФорма, Неопределено);
	ЗаполнитьТаблицуРасписанияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	ЗаполнитьТаблицуРасписанияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРасписанияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОбработатьВыборСтроки(Элементы.ТаблицаРасписания.ДанныеСтроки(ВыбраннаяСтрока));
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ЗаполнитьТаблицуРасписанияНаСервере();
КонецПроцедуры
