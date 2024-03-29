Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОперативныйПрогнозПоказатели.Период КАК ПериодПланирования,
	|	&Проект КАК Проект,
	|	&ПериодПрогноза КАК ПериодПрогноза,
	|	ОперативныйПрогнозПоказатели.Ссылка.ЭтапПроекта КАК ЭтапПроекта,
	|	ОперативныйПрогнозПоказатели.Статья КАК Статья,
	|	ОперативныйПрогнозПоказатели.Подразделение КАК Подразделение,
	|	ОперативныйПрогнозПоказатели.Сотрудник КАК Сотрудник,
	|	ОперативныйПрогнозПоказатели.КонтрагентАбонент КАК КонтрагентАбонент,
	|	ОперативныйПрогнозПоказатели.Время КАК Время,
	|	ОперативныйПрогнозПоказатели.Сумма КАК Сумма,
	|	""ПланированиеПроектов_ОперативныйПлан"" КАК ИмяРегистра_,
	|	&Период КАК Период
	|ИЗ
	|	Документ.ОперативныйПрогноз.Показатели КАК ОперативныйПрогнозПоказатели
	|ГДЕ
	|	ОперативныйПрогнозПоказатели.Ссылка = &Ссылка";
	 Запрос.УстановитьПараметр("Ссылка",ДокументСсылка);
	 Запрос.УстановитьПараметр("Период",ДокументСсылка.Дата);
	 Запрос.УстановитьПараметр("Проект",ДокументСсылка.Проект);
	 Запрос.УстановитьПараметр("ПериодПрогноза",ДокументСсылка.ПериодПрогноза);
	 
	 ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
     ТаблицыДляДвижений.Вставить("ТаблицаПланированиеПроектов_ОперативныйПлан"			, Запрос.Выполнить().Выгрузить());
КонецПроцедуры	
 
Процедура ВыполнитьКонтрольРезультатовПроведения(Объект, Отказ) Экспорт
	
	Если Ложь Тогда
		Объект = Документы.ОперативныйПрогноз.СоздатьДокумент();
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКонтрольРезультатовОтменыПроведения(Объект, Отказ) Экспорт
	
	Если Ложь Тогда
		Объект = Документы.ОперативныйПрогноз.СоздатьДокумент();
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКонтрольПередПроведением(Объект, Отказ) Экспорт
	
	Если Ложь Тогда
		Объект = Документы.ОперативныйПрогноз.СоздатьДокумент();
	КонецЕсли;
КонецПроцедуры
