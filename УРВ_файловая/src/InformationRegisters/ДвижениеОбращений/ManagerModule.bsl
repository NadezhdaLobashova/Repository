#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет движения по обращению.
//
// Параметры:
//  ПериодЗаписи - Дата - период записи движения.
//  ЭтотОбъект   - ДокументОбъект.Обращение - документ обращения.
//
Процедура ДобавитьЗапись(ПериодЗаписи, ЭтотОбъект) Экспорт
    
    Запрос = Новый Запрос;
    Запрос.Текст = 
        "ВЫБРАТЬ
        |   ДвижениеОбращенийСрезПоследних.Период
        |ИЗ
        |   РегистрСведений.ДвижениеОбращений.СрезПоследних(&ПериодЗаписи, Обращение = &Обращение) КАК ДвижениеОбращенийСрезПоследних
        |ГДЕ
        |   ДвижениеОбращенийСрезПоследних.ОбслуживающаяОрганизация = &ОбслуживающаяОрганизация
        |   И ДвижениеОбращенийСрезПоследних.ЛинияПоддержки = &ЛинияПоддержки
        |   И ДвижениеОбращенийСрезПоследних.Исполнитель = &Исполнитель
        |   И ДвижениеОбращенийСрезПоследних.Состояние = &Состояние";
        
    Запрос.УстановитьПараметр("ПериодЗаписи", ПериодЗаписи);
    Запрос.УстановитьПараметр("Обращение", ЭтотОбъект.Ссылка);
    Запрос.УстановитьПараметр("ОбслуживающаяОрганизация", ЭтотОбъект.ОбслуживающаяОрганизация);
    Запрос.УстановитьПараметр("ЛинияПоддержки", ЭтотОбъект.ЛинияПоддержки);
    Запрос.УстановитьПараметр("Исполнитель", ЭтотОбъект.Исполнитель);
    Запрос.УстановитьПараметр("Состояние", ЭтотОбъект.Состояние);
    
    Выборка = Запрос.Выполнить().Выбрать();
    
    Если Не Выборка.Следующий() Тогда
        Менеджер = РегистрыСведений.ДвижениеОбращений.СоздатьМенеджерЗаписи();
        ЗаполнитьЗначенияСвойств(Менеджер, ЭтотОбъект, "ОбслуживающаяОрганизация, ЛинияПоддержки, Исполнитель, Состояние");
        Менеджер.Обращение = ЭтотОбъект.Ссылка;
        Менеджер.Период = ПериодЗаписи;
        Менеджер.Записать();
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти
    
#КонецЕсли
 