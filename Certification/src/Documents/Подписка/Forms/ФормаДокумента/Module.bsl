
#Область ОбработчикиСобытийФормы
    
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

    Отбор = ?(ЗначениеЗаполнено(Объект.Ссылка), Объект.Ссылка, Неопределено);
    ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ПодпискиНаРасширения, "ОсновнаяПодписка", Отбор);
    СвойстваТарифа = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Тариф, "РасширениеТарифа, ОписаниеДляОбслуживающихОрганизаций");
    Если СвойстваТарифа.РасширениеТарифа = Истина Тогда
        Элементы.СтраницаРасширения.Видимость = Ложь;
        Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
    КонецЕсли;
    
    Если ПустаяСтрока(СвойстваТарифа.ОписаниеДляОбслуживающихОрганизаций) Тогда
        Элементы.СтраницаОписание.Картинка = Новый Картинка;
    КонецЕсли;
    
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
    
    ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ПодпискиНаРасширения, "ОсновнаяПодписка", Объект.Ссылка);
    
КонецПроцедуры

#КонецОбласти 
