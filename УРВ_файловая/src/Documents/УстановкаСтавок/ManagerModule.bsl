Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	 "ВЫБРАТЬ
	 |	УстановкаСтавокСтавки.Ставка КАК Ставка,
	 |	&Подразделение КАК Подразделение,
	 |	УстановкаСтавокСтавки.Ссылка.Регион КАК Регион,
	 |	""СтавкиСотрудниковПоВидамРабот"" КАК ИмяРегистра_,
	 |	&Дата КАК Период,
	 |	УстановкаСтавокСтавки.Оклад КАК Оклад,
	 |	УстановкаСтавокСтавки.ВидРаботы КАК ВидРаботы,
	 |	УстановкаСтавокСтавки.Ссылка.Должность КАК Должность
	 |ИЗ
	 |	Документ.УстановкаСтавок.Ставки КАК УстановкаСтавокСтавки
	 |ГДЕ
	 |	УстановкаСтавокСтавки.Ссылка = &Ссылка";
	 Запрос.УстановитьПараметр("Ссылка",ДокументСсылка);
	 Запрос.УстановитьПараметр("Дата",ДокументСсылка.Дата);
	 Запрос.УстановитьПараметр("Подразделение",ДокументСсылка.Подразделение);
	 
	 ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
     ТаблицыДляДвижений.Вставить("ТаблицаСтавкиСотрудниковПоВидамРабот"			, Запрос.Выполнить().Выгрузить());
КонецПроцедуры	

Процедура ВыполнитьКонтрольРезультатовПроведения(Объект, Отказ) Экспорт
	
	Если Ложь Тогда
		Объект = Документы.УстановкаСтавок.СоздатьДокумент();
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКонтрольРезультатовОтменыПроведения(Объект, Отказ) Экспорт
	
	Если Ложь Тогда
		Объект = Документы.УстановкаСтавок.СоздатьДокумент();
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКонтрольПередПроведением(Объект, Отказ) Экспорт	
	Если Ложь Тогда
		Объект = Документы.УстановкаСтавок.СоздатьДокумент();
	КонецЕсли;
КонецПроцедуры
 