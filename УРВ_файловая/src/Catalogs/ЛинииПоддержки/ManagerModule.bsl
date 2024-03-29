#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает обслуживающую организацию по линии.
//
// Параметры:
//  ЛинияПоддержки - СправочникСсылка.ЛинииПоддержки - линия поддержки.
// 
// Возвращаемое значение:
//  СправочникСсылка.ОбслуживающиеОрганизации - обслуживающая организация линии поддержки.
//
Функция ОбслуживающаяОрганизация(ЛинияПоддержки) Экспорт
    
    Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЛинияПоддержки, "Владелец");
	
КонецФункции

#КонецОбласти

#КонецЕсли