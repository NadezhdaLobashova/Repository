#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
    
#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
    
    Если ЭтотОбъект.Значение = Константы.НеИспользоватьНесколькоВитринСервисов.Получить() Тогда
        Константы.НеИспользоватьНесколькоВитринСервисов.Установить(Не ЭтотОбъект.Значение);
    КонецЕсли;
    
КонецПроцедуры
    
#КонецОбласти

#КонецЕсли
