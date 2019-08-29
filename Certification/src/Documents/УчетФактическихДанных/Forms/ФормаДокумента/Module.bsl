#Область СЛУЖЕБНЫЕ_ПРОЦЕДУРЫ_И_ФУНКЦИИ

&НаСервере
Функция ПолучитьПроект(Задача)
	СтруктураПроекта = Новый Структура;
	СтруктураПроекта.Вставить("Проект", Задача.Владелец);
	СтруктураПроекта.Вставить("ЭтапПроекта", Задача.ЭтапПроекта);
	СтруктураПроекта.Вставить("Контрагент", Задача.Контрагент);
	
	Возврат СтруктураПроекта;	
КонецФункции

//+ Котова А.Ю. 31.07.2019 ТЗ№ 90717 {
&НаСервере
Функция ПолучитьПроектПоОбращению(Обращение)
	СтруктураПроекта = Новый Структура;
	СтруктураПроекта.Вставить("Проект", Обращение.Проект);
	СтруктураПроекта.Вставить("ЭтапПроекта", Обращение.ЭтапПроекта);
	СтруктураПроекта.Вставить("Абонент", Обращение.Абонент);
	
	Возврат СтруктураПроекта;	
КонецФункции
//- Котова А.Ю. 31.07.2019 ТЗ№ 90717 }

&НаСервере
Функция ПолучитьОсновнойВидРаботы()
	Возврат Константы.ОсновнойВидРаботы.Получить();	
КонецФункции	

&НаСервере
Процедура ЗаполнитьДанныеПоЗадаче(Строка)
	Если НЕ ЗначениеЗаполнено(Объект.Время[Строка-1].Задача) тогда
		Возврат
	КонецЕсли;	
	Запрос = Новый Запрос( "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                       |	ЕСТЬNULL(ОтработанноеВремя.Часы, 0) КАК Время
	                       |ИЗ
	                       |	РегистрНакопления.ОтработанноеВремя КАК ОтработанноеВремя
	                       |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УчетФактическихДанных.Время КАК УчетФактическихДанныхВремя
	                       |		ПО ОтработанноеВремя.Регистратор = УчетФактическихДанныхВремя.Ссылка
	                       |			И ОтработанноеВремя.НомерСтроки = УчетФактическихДанныхВремя.НомерСтроки
	                       |ГДЕ
	                       |	УчетФактическихДанныхВремя.Ссылка <> &ТекущийДок
	                       |	И УчетФактическихДанныхВремя.Задача = &Задача");
	Запрос.УстановитьПараметр("Задача",Объект.Время[Строка-1].Задача);
	Запрос.УстановитьПараметр("ТекущийДок",Объект.Ссылка);
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат.Количество() = 0  Тогда
		ЗатраченоОбщее = 0;
	Иначе
		ЗатраченоОбщее = Результат.Итог("Время");
	КонецЕсли;
	МассивЗадач = Объект.Время.НайтиСтроки(Новый Структура("Задача",Объект.Время[Строка - 1].Задача));
	Для Каждого Задача из МассивЗадач Цикл
		ЗатраченоОбщее = ЗатраченоОбщее + Задача.Часов;
	КонецЦикла;
	Объект.Время[Строка - 1].Затрачено = ЗатраченоОбщее;
	Объект.Время[Строка-1].Оценка = Объект.Время[Строка-1].Задача.ОценкаВремени;
КонецПроцедуры	

&НаКлиенте
Процедура ВремяРаботаНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    ТекДанные = Элементы.Время.ТекущиеДанные;
    ТекДанные.Работа = Результат;
	ТекДанные.Сумма = РассчитатьСуммуПоСтроке(ТекДанные.Дата, ТекДанные.Работа, ТекДанные.Часов, ТекДанные.ВидРабочегоВремени);
КонецПроцедуры

&НаКлиенте
Процедура ВремяЗадачаНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    ТекДанные = Элементы.Время.ТекущиеДанные;
    ТекДанные.Задача = Результат;
	СтруктураПроекта = ПолучитьПроект(ТекДанные.Задача);
	ТекДанные.Проект = СтруктураПроекта.Проект;
	ТекДанные.ЭтапПроекта = СтруктураПроекта.ЭтапПроекта;
	ЗаполнитьДанныеПоЗадаче(ТекДанные.НомерСтроки);
	УстановитьЗначениеПоЗадаче(ТекДанные.НомерСтроки);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеПоТаблицеВремя() 
	
	СписокЗадач = Новый СписокЗначений;
	Массив = Объект.Время.Выгрузить().ВыгрузитьКолонку("Задача");
    СписокЗадач.ЗагрузитьЗначения(Массив);
	
	Запрос = Новый Запрос( "ВЫБРАТЬ
	                       |	ВТ_Задачи.Задача КАК Задача,
	                       |	ВТ_Задачи.НомерСтроки КАК НомерСтроки
	                       |ПОМЕСТИТЬ ВТ_ДанныеПоДокументу
	                       |ИЗ
	                       |	&ВТ_Задачи КАК ВТ_Задачи
	                       |;
	                       |
	                       |////////////////////////////////////////////////////////////////////////////////
	                       |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                       |	СУММА(ОтработанноеВремя.Часы) КАК Время,
	                       |	ОтработанноеВремя.Задача КАК Задача
	                       |ПОМЕСТИТЬ ВТ_ДанныеПоРН
	                       |ИЗ
	                       |	РегистрНакопления.ОтработанноеВремя КАК ОтработанноеВремя
	                       |ГДЕ
	                       |	ОтработанноеВремя.Задача В(&СписокЗадач)
	                       |	И ОтработанноеВремя.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	                       |    И ОтработанноеВремя.Регистратор <> &ТекущийДок
	                       |СГРУППИРОВАТЬ ПО
	                       |	ОтработанноеВремя.Задача
	                       |;
	                       |
	                       |////////////////////////////////////////////////////////////////////////////////
	                       |ВЫБРАТЬ
	                       |	ВТ_ДанныеПоДокументу.НомерСтроки КАК НомерСтроки,
	                       |	ЕСТЬNULL(ВТ_ДанныеПоРН.Время, 0) КАК Время
	                       |ИЗ
	                       |	ВТ_ДанныеПоДокументу КАК ВТ_ДанныеПоДокументу
	                       |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДанныеПоРН КАК ВТ_ДанныеПоРН
	                       |		ПО ВТ_ДанныеПоДокументу.Задача = ВТ_ДанныеПоРН.Задача");
	Запрос.УстановитьПараметр("СписокЗадач",СписокЗадач);
	Запрос.УстановитьПараметр("ВТ_Задачи"  ,Объект.Время.Выгрузить(,"Задача,НомерСтроки"));
	Запрос.УстановитьПараметр("ТекущийДок" ,Объект.Ссылка);
	Результат = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаРезультат из Результат Цикл
		Если НЕ ЗначениеЗаполнено(Объект.Время[СтрокаРезультат.НомерСтроки - 1].Задача) Тогда
			Продолжить;
		КонецЕсли;	
		Объект.Время[СтрокаРезультат.НомерСтроки - 1].Оценка = Объект.Время[СтрокаРезультат.НомерСтроки - 1].Задача.ОценкаВремени;
		//Объект.Время[СтрокаРезультат.НомерСтроки - 1].Затрачено = СтрокаРезультат.Время + Объект.Время[СтрокаРезультат.НомерСтроки - 1].Часов;
		МассивЗадач = Объект.Время.НайтиСтроки(Новый Структура("Задача",Объект.Время[СтрокаРезультат.НомерСтроки - 1].Задача));
		ЗатраченоОбщее = СтрокаРезультат.Время;
		Для Каждого Задача из МассивЗадач Цикл
			ЗатраченоОбщее = ЗатраченоОбщее + Задача.Часов;
		КонецЦикла;	
		Объект.Время[СтрокаРезультат.НомерСтроки - 1].Затрачено = ЗатраченоОбщее;
	КонецЦикла;	

КонецПроцедуры

&НаСервере
Функция ПроверитьАктуальностьПроекта(Проект)
	Возврат ?(Проект.ДатаОкончания < Объект.Месяц или Проект.ДатаНачала > Объект.Месяц,Ложь,Истина)		
КонецФункции

&НаСервере
Функция ПроверитьВидРаботы(Работа)
	Возврат ?(Работа.ВидыРабот.ВидРаботы = Перечисления.ВидыРабот.РегламентированнаяРабота, Истина, Ложь)
КонецФункции	

&НаКлиенте
Процедура УстановитьЗначениеПоЗадаче(НомерСтроки)
	 ЭтотОбъект.Затрачено = Объект.Время[НомерСтроки-1].Затрачено;
	 ЭтотОбъект.ОценкаПоЗадаче = Объект.Время[НомерСтроки-1].Оценка;
 КонецПроцедуры	
 
&НаСервере
Процедура УстановитьВидимостьДоступность()
	Элементы.Сотрудник.ТолькоПросмотр = НЕ РольДоступна("ПолныеПрава");
	Элементы.ВремяЗадача.Видимость    = РольДоступна("СотрудникОР") или  РольДоступна("ПолныеПрава");
КонецПроцедуры	

&НаКлиенте
Процедура ОбновитьЗатраченноеВремяЗаДень()
	СуммаЗатрачено = 0;
	Для Каждого СтрокаВремя из Объект.Время Цикл
		Если НачалоДня(СтрокаВремя.Дата) = НачалоДня(Текущаядата()) Тогда
			СуммаЗатрачено = СуммаЗатрачено + СтрокаВремя.Часов;
		КонецЕсли;
	КонецЦикла;
	ЗатраченоВремениЗаДень = СуммаЗатрачено;
КонецПроцедуры	

&НасЕрвере
Функция ВводПроектаНаСервере(Текст)
	Текст = СтрЗаменить(Текст, "  ", " ");
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Проекты.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.Проекты КАК Проекты
	                      |ГДЕ
	                      |	Проекты.ДатаОкончания >= &ТекущаяДата
	                      |	И Проекты.Наименование ПОДОБНО """ + Текст + "%""");
	Запрос.УстановитьПараметр("ТекущаяДата",ТекущаяДата());
	Результат = Запрос.Выполнить();
	Список = Новый СписокЗначений;
    Если НЕ Результат.Пустой() Тогда 
       Список.ЗагрузитьЗначения(Результат.Выгрузить().ВыгрузитьКолонку("Ссылка"));
   КонецЕсли;
   Возврат Список
КонецФункции	

&НаСервере
Функция ПроверитьСуммуЧасовПоПроизводственномуКалендарю()
  Запрос = Новый Запрос("ВЫБРАТЬ
                        |	ТЧ_ДанныеВремя.Дата КАК Дата,
                        |	ТЧ_ДанныеВремя.Часов КАК Время
                        |ПОМЕСТИТЬ ВТ_ДанныеПоТЧ
                        |ИЗ
                        |	&ТЧ_ДанныеВремя КАК ТЧ_ДанныеВремя
                        |;
                        |
                        |////////////////////////////////////////////////////////////////////////////////
                        |ВЫБРАТЬ РАЗРЕШЕННЫЕ
                        |	ВЫБОР
                        |		КОГДА ПраздничныеВыходныеДни.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейКалендаря.Рабочий)
                        |			ТОГДА 8
                        |		ИНАЧЕ 0
                        |	КОНЕЦ КАК ЧасыПоКалендарю,
                        |	ВТ_ДанныеПоТЧ.Дата КАК Дата
                        |ПОМЕСТИТЬ ВТ_ДанныеПоПроизводКалендарю
                        |ИЗ
                        |	ВТ_ДанныеПоТЧ КАК ВТ_ДанныеПоТЧ
                        |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПраздничныеВыходныеДни КАК ПраздничныеВыходныеДни
                        |		ПО (НАЧАЛОПЕРИОДА(ВТ_ДанныеПоТЧ.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(ПраздничныеВыходныеДни.Дата, ДЕНЬ))
                        |;
                        |
                        |////////////////////////////////////////////////////////////////////////////////
                        |ВЫБРАТЬ РАЗРЕШЕННЫЕ
                        |	СУММА(УчетФактическихДанныхВремя.Часов) КАК Часов,
                        |	УчетФактическихДанныхВремя.Дата КАК Дата,
                        |	УчетФактическихДанныхВремя.Ссылка
                        |ПОМЕСТИТЬ ВТ_ДругиеЛУРВ
                        |ИЗ
                        |	Документ.УчетФактическихДанных.Время КАК УчетФактическихДанныхВремя
                        |ГДЕ
                        |	УчетФактическихДанныхВремя.Ссылка.Сотрудник = &Сотрудник
                        |	И УчетФактическихДанныхВремя.Ссылка <> &ТекущийДок
                        |	И УчетФактическихДанныхВремя.Ссылка.Месяц = &Месяц
                        |
                        |СГРУППИРОВАТЬ ПО
                        |	УчетФактическихДанныхВремя.Дата,
                        |	УчетФактическихДанныхВремя.Ссылка
                        |;
                        |
                        |////////////////////////////////////////////////////////////////////////////////
                        |ВЫБРАТЬ РАЗРЕШЕННЫЕ
                        |	СУММА(ВТ_ДанныеПоТЧ.Время + ЕСТЬNULL(ВТ_ДругиеЛУРВ.Часов, 0)) КАК ЧасыПоЛУРВ,
                        |	ВТ_ДанныеПоТЧ.Дата КАК Дата,
                        |	ВТ_ДругиеЛУРВ.Ссылка
                        |ПОМЕСТИТЬ ВТ_ДанныеПоЛурв
                        |ИЗ
                        |	ВТ_ДанныеПоТЧ КАК ВТ_ДанныеПоТЧ
                        |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДругиеЛУРВ КАК ВТ_ДругиеЛУРВ
                        |		ПО (НАЧАЛОПЕРИОДА(ВТ_ДанныеПоТЧ.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(ВТ_ДругиеЛУРВ.Дата, ДЕНЬ))
                        |
                        |СГРУППИРОВАТЬ ПО
                        |	ВТ_ДанныеПоТЧ.Дата,
                        |	ВТ_ДругиеЛУРВ.Ссылка
                        |;
                        |
                        |////////////////////////////////////////////////////////////////////////////////
                        |ВЫБРАТЬ
                        |	ВТ_ДанныеПоЛурв.Дата КАК Дата,
                        |	ВЫБОР
                        |		КОГДА ВТ_ДанныеПоЛурв.ЧасыПоЛУРВ > ВТ_ДанныеПоПроизводКалендарю.ЧасыПоКалендарю
                        |			ТОГДА ИСТИНА
                        |		ИНАЧЕ ЛОЖЬ
                        |	КОНЕЦ КАК Отказ
                        |ИЗ
                        |	ВТ_ДанныеПоЛурв КАК ВТ_ДанныеПоЛурв
                        |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДанныеПоПроизводКалендарю КАК ВТ_ДанныеПоПроизводКалендарю
                        |		ПО ВТ_ДанныеПоЛурв.Дата = ВТ_ДанныеПоПроизводКалендарю.Дата");
	Запрос.УстановитьПараметр("ТЧ_ДанныеВремя", Объект.Время.Выгрузить());
	Запрос.УстановитьПараметр("ТекущийДок",Объект.Ссылка);
	Запрос.УстановитьПараметр("Сотрудник",Объект.Сотрудник);
	Запрос.УстановитьПараметр("Месяц",Объект.Ссылка.Месяц);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.Отказ Тогда
			Возврат Выборка.Дата
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено
КонецФункции

&НаКлиенте
Процедура ОбновитьДанныеПоЗадаче(НомерСтроки)
	
	ЗатраченоОбщееПоЗадаче = Объект.Время[НомерСтроки - 1].Часов + Объект.Время[НомерСтроки - 1].Затрачено;
	Объект.Время[НомерСтроки - 1].Затрачено = ЗатраченоОбщееПоЗадаче; 

	МассивЗадач = Объект.Время.НайтиСтроки(Новый Структура("Задача",Объект.Время[НомерСтроки - 1].Задача));
	Для Каждого ЗначЗадача из МассивЗадач Цикл
		Объект.Время[ЗначЗадача.НомерСтроки - 1].Затрачено = ЗатраченоОбщееПоЗадаче;
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Функция ДоступностьРолиСотрудникОР()
	Возврат (РольДоступна("СотрудникОР") или РольДоступна("ПолныеПрава"))
КонецФункции	

&НаКлиенте
Процедура РаботыЗаданиеНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    ТекДанные = Элементы.Время.ТекущиеДанные;
    ТекДанные.Задание = Результат;
КонецПроцедуры

&НаСервере
Функция РассчитатьСуммуПоСтроке(Дата, Работа, Часов, ВидРабочегоВремени)
	Если Работа.ВидыРабот.ВидРаботы <> Перечисления.ВидыРабот.РегламентированнаяРабота И Работа.ВидыРабот.ВидРаботы <> Перечисления.ВидыРабот.ОкладнаяРабота Тогда
		Возврат 0
	КонецЕсли;	
	Возврат Документы.УчетФактическихДанных.РассчитатьСуммуНаСервере(Объект.Сотрудник,КонецДня(Дата), Работа.ВидыРабот, Часов, Объект.Дата, ВидРабочегоВремени); 
КонецФункции	

&НаСервере
Функция ОсновнаяСтатьяНаСервере(Работа)
	Возврат Работа.ВидыРабот.ОсновнаяСтатья
КонецФункции	

&НаСервере
Функция РассчитатьКоличествоЧасов(ДатаНачала,ДатаОкончания)
	Запрос = Новый Запрос("ВЫБРАТЬ
  	                      |	ЕСТЬNULL(РАЗНОСТЬДАТ(&ДатаНачала, &ДатаОкончания, МИНУТА), 0) КАК Минут");
	Запрос.УстановитьПараметр("ДатаНачала"    , ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания" , ДатаОкончания);
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат.Количество() = 0 Тогда
		Возврат 0
	КонецЕсли;
	Возврат Результат[0].Минут / 60
КонецФункции	

&НаСервере
Процедура ЗаполнитьСписокВыборкаВидовРабот()
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	МАКСИМУМ(СтавкиСотрудниковПоВидамРаботСрезПоследних.Период) КАК Период,
	                      |	СтавкиСотрудниковПоВидамРаботСрезПоследних.Подразделение КАК Подразделение,
	                      |	СтавкиСотрудниковПоВидамРаботСрезПоследних.Регион КАК Регион,
	                      |	СтавкиСотрудниковПоВидамРаботСрезПоследних.Должность КАК Должность
	                      |ПОМЕСТИТЬ ВТ_ПоследнийДокументПоСтавке
	                      |ИЗ
	                      |	РегистрСведений.СтавкиСотрудниковПоВидамРабот.СрезПоследних(&датаСреза, ) КАК СтавкиСотрудниковПоВидамРаботСрезПоследних
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	СтавкиСотрудниковПоВидамРаботСрезПоследних.Регион,
	                      |	СтавкиСотрудниковПоВидамРаботСрезПоследних.Должность,
	                      |	СтавкиСотрудниковПоВидамРаботСрезПоследних.Подразделение
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	СтавкиСотрудниковПоВидамРабот.ВидРаботы,
	                      |	СтавкиСотрудниковПоВидамРабот.Должность,
	                      |	СтавкиСотрудниковПоВидамРабот.Подразделение,
	                      |	СтавкиСотрудниковПоВидамРабот.Регион,
	                      |	СтавкиСотрудниковПоВидамРабот.Ставка,
	                      |	СтавкиСотрудниковПоВидамРабот.Оклад
	                      |ПОМЕСТИТЬ ВТ_Ставки
	                      |ИЗ
	                      |	ВТ_ПоследнийДокументПоСтавке КАК ВТ_ПоследнийДокументПоСтавке
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиСотрудниковПоВидамРабот КАК СтавкиСотрудниковПоВидамРабот
	                      |		ПО ВТ_ПоследнийДокументПоСтавке.Период = СтавкиСотрудниковПоВидамРабот.Период
	                      |			И ВТ_ПоследнийДокументПоСтавке.Подразделение = СтавкиСотрудниковПоВидамРабот.Подразделение
	                      |			И ВТ_ПоследнийДокументПоСтавке.Регион = СтавкиСотрудниковПоВидамРабот.Регион
	                      |			И ВТ_ПоследнийДокументПоСтавке.Должность = СтавкиСотрудниковПоВидамРабот.Должность
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	                      |	Работы.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Справочник.Работы КАК Работы
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Ставки КАК ВТ_Ставки
	                      |		ПО Работы.ВидыРабот = ВТ_Ставки.ВидРаботы
	                      |ГДЕ
	                      |	ВЫБОР
	                      |			КОГДА Работы.ВидРаботы = ЗНАЧЕНИЕ(Перечисление.ВидыРабот.РегламентированнаяРабота)
	                      |				ТОГДА ВТ_Ставки.Должность = &Должность
	                      |						И ВТ_Ставки.Подразделение = &Подразделение
	                      |						И ВТ_Ставки.Регион = &Регион
	                      |						И (ЕСТЬNULL(ВТ_Ставки.Ставка, 0) > 0
	                      |							ИЛИ ЕСТЬNULL(ВТ_Ставки.Оклад, 0) > 0)
	                      |			КОГДА Работы.ВидРаботы = ЗНАЧЕНИЕ(Перечисление.ВидыРабот.ОкладнаяРабота)
	                      |				ТОГДА ВТ_Ставки.Должность = &Должность
	                      |						И ВТ_Ставки.Подразделение = &Подразделение
	                      |						И ВТ_Ставки.Регион = &Регион
	                      |						И ЕСТЬNULL(ВТ_Ставки.Оклад, 0) > 0
	                      |			ИНАЧЕ Работы.ВидРаботы <> ЗНАЧЕНИЕ(Перечисление.ВидыРабот.РегламентированнаяРабота)
	                      |		КОНЕЦ
	                      |	И НЕ Работы.ПометкаУдаления
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Ссылка
	                      |АВТОУПОРЯДОЧИВАНИЕ");
	Запрос.УстановитьПараметр("Должность"     	, ТекущаяДолжность);
	Запрос.УстановитьПараметр("Подразделение" 	, ТекущееПодразделение);
	Запрос.УстановитьПараметр("Регион" 			, ТекущийРегион);
	Запрос.УстановитьПараметр("ДатаСреза"     	, ?(Объект.Дата = Дата(1,1,1), Текущаядата(), Объект.Дата));
	Элементы.ВремяРабота.СписокВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
КонецПроцедуры	

&НаСервере
Функция ПроверкаНаКорректныеВидыРабот()
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Таблицаработ.НомерСтроки,
	                      |	Таблицаработ.Работа
	                      |ПОМЕСТИТЬ ВТ_Работы
	                      |ИЗ
	                      |	&Таблицаработ КАК Таблицаработ
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВТ_Работы.НомерСтроки
	                      |ИЗ
	                      |	ВТ_Работы КАК ВТ_Работы
	                      |ГДЕ
	                      |	НЕ ВТ_Работы.Работа В (&СписокРабот)");
	Запрос.УстановитьПараметр("Таблицаработ", Объект.Время.Выгрузить());
	Запрос.УстановитьПараметр("СписокРабот" , Элементы.ВремяРабота.СписокВыбора.ВыгрузитьЗначения());
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Истина
	КонецЕсли;
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Указанный вид работы не доступен!";
		Сообщение.Поле  = "Объект.Время[" + СокрЛП(Выборка.НомерСтроки - 1) + "].Работа";
		Сообщение.Сообщить();
	КонецЦикла;
	Возврат Ложь
КонецФункции	

&НаСервере
Процедура ЗаполнитьПоОбращениямНаСервере()
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	РегистрСведенийФактическиеТрудозатраты.Источник КАК Источник,
	                      |	РегистрСведенийФактическиеТрудозатраты.ДатаРаботы КАК Дата,
	                      |	РегистрСведенийФактическиеТрудозатраты.Длительность / 3600 КАК Часов,
	                      |	РегистрСведенийФактическиеТрудозатраты.ОписаниеРаботы КАК ОписаниеРаботы,
	                      |	РегистрСведенийФактическиеТрудозатраты.ВремяНачала КАК ВремяНачала,
	                      |	РегистрСведенийФактическиеТрудозатраты.ВремяОкончания КАК ВремяОкончания,
	                      |	РегистрСведенийФактическиеТрудозатраты.Работа КАК Работа
	                      |ИЗ
	                      |	РегистрСведений.ФактическиеТрудозатраты КАК РегистрСведенийФактическиеТрудозатраты
	                      |ГДЕ
	                      |	РегистрСведенийФактическиеТрудозатраты.Пользователь = &Пользователь
	                      |	И РегистрСведенийФактическиеТрудозатраты.ДатаРаботы >= &ДатаНачала
	                      |	И РегистрСведенийФактическиеТрудозатраты.ДатаРаботы <= &ДатаОкончания");
						 
		Запрос.УстановитьПараметр("Пользователь"   , Объект.Сотрудник);
		
		Запрос.УстановитьПараметр("ДатаНачала"     , НачалоДня(Объект.Дата));
		Запрос.УстановитьПараметр("ДатаОкончания"  , КонецДня(Объект.Дата));
		
		Объект.Время.Очистить();
		
		Выборка = Запрос.Выполнить().Выгрузить();
		ТЧВремя =  Объект.Время;
		Для каждого Стр из Выборка Цикл
			
			НоваяСтрока 		 				= ТЧВремя.Добавить();
			НоваяСтрока.Дата	 				= Стр.Дата;
			НоваяСтрока.Часов 	 				= Стр.Часов;
			НоваяСтрока.Описание 				= Стр.ОписаниеРаботы;
			НоваяСтрока.Проект   				= Стр.Источник.Проект;
			НоваяСтрока.ВидРабочегоВремени 		= Справочники.ВидыРабочегоВремени.РаботаВОсновноеВремя;
			НоваяСтрока.Работа 	 				= Стр.Работа;
			НоваяСтрока.ВремяНачала 	 		= Стр.ВремяНачала;
			НоваяСтрока.ВремяОкончания		 	= Стр.ВремяОкончания;			
			НоваяСтрока.Сумма 					= РассчитатьСуммуПоСтроке(НоваяСтрока.Дата, НоваяСтрока.Работа, НоваяСтрока.Часов, НоваяСтрока.ВидРабочегоВремени);
			
			Если ТипЗнч(Стр.Источник) = Тип("ДокументСсылка.Обращение") Тогда	
				НоваяСтрока.ЭтапПроекта 		= Стр.Источник.ЭтапПроекта;	
				НоваяСтрока.КонтрагентАбонент 	= Стр.Источник.Абонент;
				НоваяСтрока.Обращение 			= Стр.Источник;
			КонецЕсли;
			
		КонецЦикла;
		
КонецПроцедуры	

&НаКлиенте
Процедура ЗаполнитьПоОбращениямОкончание(Результат, Параметры) Экспорт
 
    Если Результат = КодВозвратаДиалога.Да Тогда
        ЗаполнитьПоОбращениямНаСервере();
    КонецЕсли;	
 
КонецПроцедуры

#КонецОбласти


#Область ПРОЦЕДУРЫ_ОБРАБОТЧИКИ_СОБЫТИЙ_ФОРМЫ

&НаКлиенте
Процедура ВремяПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если Не Копирование И НоваяСтрока Тогда
		ТекДанные = Элементы.Время.ТекущиеДанные;
		Если ОбщегоНазначения.РольДоступнаСервер("СотрудникОР")Тогда
			ОсновнойВидРаботы = ПолучитьОсновнойВидРаботы();
			Найденное = Элементы.ВремяРабота.СписокВыбора.НайтиПоЗначению(ОсновнойВидРаботы);
			Если Найденное <> Неопределено Тогда
		    	ТекДанные.Работа = Найденное.Значение;
			КонецЕсли;	
		КонецЕсли;	
		ТекДанные.Проект = ПолучитьЗначениеОсновнойПроект(ТекДанные.Работа);
		ТекДанные.Дата = ТекущаяДата();
		Если Не ЗначениеЗаполнено(ТекДанные.ВидРабочегоВремени) Тогда
			ТекДанные.ВидРабочегоВремени = ПредопределенноеЗначение("Справочник.ВидыРабочегоВремени.РаботаВОсновноеВремя");	
		КонецЕсли;	
	КонецЕсли;	
	Если Копирование Тогда
		// копируем какую-то существующую строку
		Элемент.ТекущиеДанные.ИдентификаторСтроки = "";
		Элемент.ТекущиеДанные.ВремяНачала = Элемент.ТекущиеДанные.ВремяОкончания;
		Элемент.ТекущиеДанные.ВремяОкончания = Элемент.ТекущиеДанные.ВремяНачала + Элемент.ТекущиеДанные.Часов * 3600;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗначениеОсновнойПроект(Работа)
	Возврат Работа.ВидыРабот.ОсновнойПроект
КонецФункции	

&НаКлиенте
Процедура ПриОткрытии(Отказ)
   ОбновитьЗатраченноеВремяЗаДень();
   
КонецПроцедуры

&НаКлиенте
Процедура ВремяЗадачаПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Время.ТекущиеДанные; 
	СтруктураПроекта = ПолучитьПроект(ТекущаяСтрока.Задача);
	ТекущаяСтрока.Проект = СтруктураПроекта.Проект;
	ТекущаяСтрока.ЭтапПроекта = СтруктураПроекта.ЭтапПроекта;
	ТекущаяСтрока.КонтрагентАбонент = СтруктураПроекта.Контрагент;
	
	Если Не ПроверитьАктуальностьПроекта(ТекущаяСтрока.Проект) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Данный проект находится в архиве!";
		Сообщение.Поле = "Время[" + (ТекущаяСтрока.НомерСтроки - 1) + "].Проект";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Сообщить();
	КонецЕсли;
	ЗаполнитьДанныеПоЗадаче(ТекущаяСтрока.НомерСтроки);
	УстановитьЗначениеПоЗадаче(ТекущаяСтрока.НомерСтроки);
	
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.ЭтапПроекта) Тогда 
		Если ЗначениеЗаполнено(ТекущаяСтрока.Проект) Тогда
			ТекущаяСтрока.ЭтапПроекта = УРВСервер.НайтиОсновнойЭтапДляПодстановкиВДокументы(ТекущаяСтрока.Проект);
		Иначе
			ТекущаяСтрока.ЭтапПроекта = ПредопределенноеЗначение("Справочник.ЭтапыПроектов.ПустаяСсылка");
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ВремяРаботаПриИзменении(Элемент)
	
	ТекДанные = Элементы.Время.ТекущиеДанные;
	
	Если Не ЗначениеЗаполнено(ТекДанные.проект) Тогда
		ТекДанные.Проект = ПолучитьЗначениеОсновнойПроект(ТекДанные.Работа);
		ТекДанные.ЭтапПроекта = УРВСервер.НайтиОсновнойЭтапДляПодстановкиВДокументы(ТекДанные.Проект);
	КонецЕсли;
	
	Если ТекДанные.Часов = 0 или ТекДанные.Дата = Дата(1,1,1) Тогда
		Возврат
	КонецЕСли;
	
	ТекДанные.Сумма = РассчитатьСуммуПоСтроке(ТекДанные.Дата, ТекДанные.Работа, ТекДанные.Часов, ТекДанные.ВидРабочегоВремени); 
КонецПроцедуры

&НаКлиенте
Процедура ВремяПриАктивизацииСтроки(Элемент)
	ТекущаяСтрока = Элементы.Время.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат
	КонецЕсли;	
	УстановитьЗначениеПоЗадаче(ТекущаяСтрока.НомерСтроки);
	ВыделенныеСтроки = Элементы.Время.ВыделенныеСтроки;
	Сумма = 0;
	Для Каждого Стр Из ВыделенныеСтроки Цикл
		Сумма = Сумма + Объект.Время.НайтиПоИдентификатору(Стр).Часов;
	КонецЦикла;
	
	СуммаВыделенныхСтрок = Сумма;
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Или Не ЗначениеЗаполнено(Объект.Месяц) Тогда
		Объект.Месяц = НачалоМесяца(ТекущаяДата());
	КонецЕсли;	
	ЭтотОбъект.МесяцСтрокой = Формат(Объект.Месяц, "ДФ = ""гггг ММММ""");		
	
	Прогноз.Параметры.УстановитьЗначениеПараметра("Сотрудник"	    , Объект.Сотрудник);
	Прогноз.Параметры.УстановитьЗначениеПараметра("ДатаНачала"		, НачалоМесяца(Объект.Месяц));
	Прогноз.Параметры.УстановитьЗначениеПараметра("ДатаОкончания"   , КонецМесяца(Объект.Месяц));
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект,Документы.УчетФактическихДанных.ТекущиеДанныеПоСотруднику(Объект.Сотрудник,?(Объект.Дата = Дата(1,1,1), ТекущаяДата(), Объект.Дата)));
	
	Если РольДоступна("СотрудникОР") или РольДоступна("ПолныеПрава") Тогда
	   ЗаполнитьДанныеПоТаблицеВремя();
   КонецЕсли; 
   
   //{Рарус kruser 2018.12.21 78092
   Элементы.ВремяРабота.СписокВыбора.ЗагрузитьЗначения(УРВСервер.ЗаполнитьСписокВыборкаВидовРабот(Объект.Сотрудник, Объект.Дата));
   //ЗаполнитьСписокВыборкаВидовРабот();
   //}Рарус kruser 2018.12.21 78092
	
   УстановитьВидимостьДоступность();
КонецПроцедуры


&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	Прогноз.Параметры.УстановитьЗначениеПараметра("Сотрудник"			, Объект.Сотрудник);
КонецПроцедуры


&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	СотрудникПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Направление = 1 Тогда
		Объект.Месяц = КонецМесяца(Объект.Месяц) + 1;
	Иначе
		Объект.Месяц = НачалоМесяца(НачалоМесяца(Объект.Месяц) - 1);
	КонецЕсли;
	
	ЭтотОбъект.МесяцСтрокой = Формат(Объект.Месяц, "ДФ = ""гггг ММММ""");
	
	Прогноз.Параметры.УстановитьЗначениеПараметра("ДатаНачала"		, НачалоМесяца(Объект.Месяц));
	Прогноз.Параметры.УстановитьЗначениеПараметра("ДатаОкончания"   , КонецМесяца(Объект.Месяц));

КонецПроцедуры

&НаКлиенте
Процедура ВремяЧасовПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Время.ТекущиеДанные;
	
	ТекущаяСтрока.Сумма = РассчитатьСуммуПоСтроке(ТекущаяСтрока.Дата, ТекущаяСтрока.Работа, ТекущаяСтрока.Часов, ТекущаяСтрока.ВидРабочегоВремени);
	
	Если ДоступностьРолиСотрудникОР() Тогда
		ОбновитьДанныеПоЗадаче(ТекущаяСтрока.НомерСтроки);
		
		УстановитьЗначениеПоЗадаче(ТекущаяСтрока.НомерСтроки);
		ОбновитьЗатраченноеВремяЗаДень();
	КонецЕсли;
	
	Если ТекущаяСтрока.ВремяНачала = Дата(1,1,1) ИЛИ ТекущаяСтрока.ВремяОкончания = Дата(1,1,1) ИЛИ ТекущаяСтрока.Часов = 0 тогда
		Возврат
	КонецЕсли;
	Часов = РассчитатьКоличествоЧасов(ТекущаяСтрока.ВремяНачала, ТекущаяСтрока.ВремяОкончания);
	Если Часов <> ТекущаяСтрока.Часов Тогда
		Сообщение       = Новый СообщениеПользователю;
		Сообщение.Текст = "Временной интервал не соответствует количеству указанных часов.";
		Сообщение.Поле  = "Объект.Время[" + (ТекущаяСтрока.НомерСтроки - 1) + "].ВремяНачала";
		Сообщение.Сообщить();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяВыходнойПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Время.ТекущиеДанные;
	
	ТекущаяСтрока.Сумма = РассчитатьСуммуПоСтроке(ТекущаяСтрока.Дата, ТекущаяСтрока.Работа, ТекущаяСтрока.Часов, ТекущаяСтрока.ВидРабочегоВремени);
КонецПроцедуры

&НаКлиенте
Процедура ВремяРаботаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//Если ОбщегоНазначения.РольДоступнаСервер("Сотрудник") Тогда
	//	СтандартнаяОбработка = Ложь;
	//	ОткрытьФорму("Справочник.Работы.Форма.ФормаВыбораДляСотрудника", Новый Структура("Подразделение,Должность,ДатаСреза", ТекущееПодразделение,ТекущаяДолжность,Объект.Дата),,,,, Новый ОписаниеОповещения("ВремяРаботаНачалоВыбораЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	//КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ВремяРаботаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
    а = 0;	
КонецПроцедуры

&НаКлиенте
Процедура ВремяЗадачаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//Если ОбщегоНазначения.РольДоступнаСервер("Сотрудник") Тогда
		СтандартнаяОбработка = Ложь;
		ТекСтрока = Элементы.Время.ТекущиеДанные;
		СтруктураОтбора = Новый Структура;
		//СтруктураОтбора.Вставить("ДатаСреза", Объект.Месяц);
		СтруктураОтбора.Вставить("Проект", ТекСтрока.Проект);
		
		ОткрытьФорму("Справочник.Задачи.ФормаВыбора", СтруктураОтбора,,,,, Новый ОписаниеОповещения("ВремяЗадачаНачалоВыбораЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВремяПроектПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Время.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.Проект) Тогда
		ТекущаяСтрока.ЭтапПроекта = УРВСервер.НайтиОсновнойЭтапДляПодстановкиВДокументы(ТекущаяСтрока.Проект);
	Иначе
		ТекущаяСтрока.ЭтапПроекта = ПредопределенноеЗначение("Справочник.ЭтапыПроектов.ПустаяСсылка");
	КонецЕсли;	
	
	Если НЕ ПроверитьВидРаботы(ТекущаяСтрока.Работа) Тогда
		Возврат
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.Проект) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Необходимо указать проект!";
		Сообщение.Поле = "Время[" + (ТекущаяСтрока.НомерСтроки - 1) + "].Проект";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Сообщить();
		Возврат
	КонецЕсли;

	Если Не ПроверитьАктуальностьПроекта(ТекущаяСтрока.Проект) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Данный проект находится в архиве!";
		Сообщение.Поле = "Время[" + (ТекущаяСтрока.НомерСтроки - 1) + "].Проект";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ТекущаяСтрока.Часов = 0  или ТекущаяСтрока.Дата = Дата(1,1,1) Тогда
		Возврат
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОсновнаяСтатьяНаСервере(ТекущаяСтрока.Работа)) Тогда
		ТекущаяСтрока.Сумма = РассчитатьСуммуПоСтроке(ТекущаяСтрока.Дата, ТекущаяСтрока.Работа, ТекущаяСтрока.Часов, ТекущаяСтрока.ВидРабочегоВремени);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяДатаПриИзменении(Элемент)
	
	ТекДанные = Элементы.Время.ТекущиеДанные;
	
	Если Не ЗначениеЗаполнено(ТекДанные.проект) Тогда
		ТекДанные.Проект = ПолучитьЗначениеОсновнойПроект(ТекДанные.Работа);
	КонецЕсли;
	
	Если ТекДанные.Часов = 0 или ТекДанные.Дата = Дата(1,1,1) Тогда
		Возврат
	КонецЕСли;
	
	ТекДанные.Сумма = РассчитатьСуммуПоСтроке(ТекДанные.Дата, ТекДанные.Работа, ТекДанные.Часов, ТекДанные.ВидРабочегоВремени);
	
	ОбновитьЗатраченноеВремяЗаДень();
КонецПроцедуры

&НаКлиенте
Функция ВремяПроектАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	//решили пока убрать
	//СтандартнаяОбработка = Ложь;
	//Список = ВводПроектаНаСервере(Текст);
	//ЭлСписка = ЭтаФорма.ВыбратьИзСписка(Список, Элемент);
	//Если ЭлСписка <> Неопределено Тогда
	//	ТекСтрока = Элементы.Время.ТекущаяСтрока;
	//    Объект.Время[ТекСтрока].Проект = ЭлСписка.Значение;
	// КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ДатаПревышения = ПроверитьСуммуЧасовПоПроизводственномуКалендарю();
		Если НЕ ДатаПревышения = Неопределено Тогда
			Ответ = Вопрос("Указанные на дату " + Формат(ДатаПревышения,"ДЛФ=Д") + " часы превышают установленные календарем - Провести документ?",
			РежимДиалогаВопрос.ДаНет,0);
			
			Если Ответ = КодВозвратаДиалога.Да Тогда
				Отказ = Ложь;
			Иначе
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
		
		//astyul, 72157, 13.09.2018
		Если НЕ ПроверкаНаКорректныеВидыРабот() Тогда
			Отказ = Истина;
		КонецЕсли;
		//astyul, 72157, 13.09.2018
		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ВремяПослеУдаления(Элемент)
	Если ДоступностьРолиСотрудникОР() Тогда
		Если НЕ Объект.Время.Количество() = 0 Тогда
			ЗаполнитьДанныеПоТаблицеВремя();
			ТекущаяСтрока = Элементы.Время.ТекущиеДанные;
			УстановитьЗначениеПоЗадаче(ТекущаяСтрока.НомерСтроки);
		КонецЕсли; 
		ОбновитьЗатраченноеВремяЗаДень();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВремяЗаданиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь; 
	ОткрытьФорму("Документ.Задание.Форма.ФормаВыбораЗадания", Новый Структура("Сотрудник", Объект.Сотрудник),,,,, Новый ОписаниеОповещения("РаботыЗаданиеНачалоВыбораЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

&НаКлиенте
Процедура ВремяВремяНачалаПриИзменении(Элемент)
	ТекДанные = Элементы.Время.ТекущиеДанные;
	Если ТекДанные.ВремяНачала = Дата(1,1,1) ИЛИ ТекДанные.ВремяОкончания = Дата(1,1,1) тогда
		Возврат
	КонецЕсли;
	//Если ТекДанные.ВремяНачала > ТекДанные.ВремяОкончания Тогда
	//	Сообщение       = Новый СообщениеПользователю;
	//	Сообщение.Текст = "Время начала не может быть больше времени окончания.";
	//	Сообщение.Поле  = "Объект.Время[" + (ТекДанные.НомерСтроки - 1) + "].ВремяНачала";
	//	Сообщение.Сообщить();
	//КонецЕсли;
	ТекДанные.Часов = РассчитатьКоличествоЧасов(ТекДанные.ВремяНачала, ТекДанные.ВремяОкончания);
	ТекДанные.Сумма = РассчитатьСуммуПоСтроке(ТекДанные.Дата, ТекДанные.Работа, ТекДанные.Часов, ТекДанные.ВидРабочегоВремени);
	
	ОбновитьЗатраченноеВремяЗаДень();
КонецПроцедуры

&НаКлиенте
Процедура ВремяВремяОкончанияПриИзменении(Элемент)
	ТекДанные = Элементы.Время.ТекущиеДанные;
	Если ТекДанные.ВремяНачала = Дата(1,1,1) ИЛИ ТекДанные.ВремяОкончания = Дата(1,1,1) тогда
		Возврат
	КонецЕсли;
	Если ТекДанные.ВремяНачала > ТекДанные.ВремяОкончания Тогда
		Сообщение       = Новый СообщениеПользователю;
		Сообщение.Текст = "Время окончания не может быть меньше времени начала.";
		Сообщение.Поле  = "Объект.Время[" + (ТекДанные.НомерСтроки - 1) + "].ВремяОкончания";
		Сообщение.Сообщить();
	КонецЕсли;
	ТекДанные.Часов = РассчитатьКоличествоЧасов(ТекДанные.ВремяНачала, ТекДанные.ВремяОкончания);
	ТекДанные.Сумма = РассчитатьСуммуПоСтроке(ТекДанные.Дата, ТекДанные.Работа, ТекДанные.Часов, ТекДанные.ВидРабочегоВремени);
	ОбновитьЗатраченноеВремяЗаДень();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
     Элементы.Прогноз.Обновить();	
КонецПроцедуры

&НаКлиенте
Процедура ВремяВидРабочегоВремениПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Время.ТекущиеДанные;
	
	ТекущаяСтрока.Сумма = РассчитатьСуммуПоСтроке(ТекущаяСтрока.Дата, ТекущаяСтрока.Работа, ТекущаяСтрока.Часов, ТекущаяСтрока.ВидРабочегоВремени);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОбращениям(Команда)
	Если Объект.Время.Количество() > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьПоОбращениямОкончание",ЭтотОбъект);
		ПоказатьВопрос(Оповещение,"Табличная часть будет очищена. Продолжить?", РежимДиалогаВопрос.ДаНетОтмена);
	Иначе
		ЗаполнитьПоОбращениямНаСервере();
	КонецЕСли;	
КонецПроцедуры

//+ Котова А.Ю. 31.07.2019 ТЗ№ 90717 {
&НаКлиенте
Процедура ВремяОбращениеПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Время.ТекущиеДанные; 
	СтруктураПроекта = ПолучитьПроектПоОбращению(ТекущаяСтрока.Обращение);
	ТекущаяСтрока.Проект = СтруктураПроекта.Проект;
	ТекущаяСтрока.ЭтапПроекта = СтруктураПроекта.ЭтапПроекта;
	ТекущаяСтрока.КонтрагентАбонент = СтруктураПроекта.Абонент;
	
	Если Не ПроверитьАктуальностьПроекта(ТекущаяСтрока.Проект) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Данный проект находится в архиве!";
		Сообщение.Поле = "Время[" + (ТекущаяСтрока.НомерСтроки - 1) + "].Проект";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.ЭтапПроекта) Тогда 
		Если ЗначениеЗаполнено(ТекущаяСтрока.Проект) Тогда
			ТекущаяСтрока.ЭтапПроекта = УРВСервер.НайтиОсновнойЭтапДляПодстановкиВДокументы(ТекущаяСтрока.Проект);
		Иначе
			ТекущаяСтрока.ЭтапПроекта = ПредопределенноеЗначение("Справочник.ЭтапыПроектов.ПустаяСсылка");
		КонецЕсли;
	КонецЕсли;	

КонецПроцедуры
//- Котова А.Ю. 31.07.2019 ТЗ№ 90717 }
#КонецОбласти
