#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
    
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
    
    РегистрыСведений.ГолосаПользователейЗаПожелания.ДобавитьДвижение(Движения, Дата, Пожелание, Пользователь, Голос);
	
    РегистрыНакопления.ЗначенияПоказателей.ДобавитьДвижение(
        Движения.ЗначенияПоказателей, Дата, Пожелание, Перечисления.ПоказателиКарточек.СуммаГолосов, Голос);
        
    Если Голос < 0 Тогда
        РегистрыНакопления.ЗначенияПоказателей.ДобавитьДвижение(
            Движения.ЗначенияПоказателей, Дата, Пожелание, Перечисления.ПоказателиКарточек.СуммаОтрицательныхГолосов, -Голос);
    Иначе
        РегистрыНакопления.ЗначенияПоказателей.ДобавитьДвижение(
            Движения.ЗначенияПоказателей, Дата, Пожелание, Перечисления.ПоказателиКарточек.СуммаПоложительныхГолосов, Голос);
    КонецЕсли; 
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	НоваяЗапись = РегистрыСведений.ИзбранныеПожелания.СоздатьМенеджерЗаписи();
	НоваяЗапись.Пожелание = Пожелание;
	НоваяЗапись.Пользователь = Пользователь;
	НоваяЗапись.ДатаИзменения = ТекущаяУниверсальнаяДата();
	НоваяЗапись.Записать();
    
КонецПроцедуры

#КонецОбласти

#КонецЕсли