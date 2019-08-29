
// Возвращает первую линию службы поддержки обслуживающей организации.
//
// Параметры:
//  ОбслуживающаяОрганизация - СправочникСсылка.ОбслуживающиеОрганизации
// 
// Возвращаемое значение:
//  СправочникСсылка.ЛинииПоддержки - первая линия службы поддержки.
//
Функция ПерваяЛинияПоддержки(ОбслуживающаяОрганизация) Экспорт
    
    Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбслуживающаяОрганизация, "ПерваяЛинияПоддержки");
    
КонецФункции
