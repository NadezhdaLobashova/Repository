#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет запись по переданным параметрам
//
Процедура ДобавитьЗапись(Обращение, ОбслуживающаяОрганизация) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Менеджер = РегистрыСведений.РазрешенияДоступаКОбращениям.СоздатьМенеджерЗаписи();
	Менеджер.Обращение = Обращение;
	Менеджер.ОбслуживающаяОрганизация = ОбслуживающаяОрганизация;
	Менеджер.Записать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли