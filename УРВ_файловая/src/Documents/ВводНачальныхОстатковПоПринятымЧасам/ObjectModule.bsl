
Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр ПринятыеЧасы Приход
	Движения.ПринятыеЧасы.Записывать = Истина;
	Для Каждого ТекСтрокаСотрудники Из Сотрудники Цикл
		Движение = Движения.ПринятыеЧасы.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Проект = Проект;
		Движение.ЭтапПроекта = ТекСтрокаСотрудники.ЭтапПроекта;
		Движение.Дата = Дата;
		Движение.Сотрудник = ТекСтрокаСотрудники.Сотрудник;
		Движение.Часы = ТекСтрокаСотрудники.Часы;
		Движение.Сумма = ТекСтрокаСотрудники.Сумма;
	КонецЦикла;

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры
