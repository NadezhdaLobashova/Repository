
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
КонецПроцедуры


Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	ПроведениеСервер.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольПередПроведением(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ, "ПринятыеЧасы");
	ПроведениеСервер.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ, "ОтработанноеВремя");
	ПроведениеСервер.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ, "ПланированиеПроектов_Факт");
	ПроведениеСервер.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ, "АктыПринятыхЧасов");
	ПроведениеСервер.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ, "ПринятыеЧасыВСчетБудущихАктов");
	
	Движения.Записать();

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры
