
&НаКлиенте
Процедура ЗагрузитьСсылку(Команда)
    
    ЗагрузитьСсылкуНаСервере();
    Элементы.Список.Обновить();
    
КонецПроцедуры


&НаСервереБезКонтекста
Процедура ЗагрузитьСсылкуНаСервере();
     
	 Ссылка = ИнтеграцияСПартнерскимAPI_1C.ПолучитьИлиЗагрузитьreportUeid(Истина);
     
     Если Ссылка = "" Тогда
         Возврат;     
     КонецЕсли;
     
     ОбщийИнтеграция_API_1C.СделатьЗаписьРС_СсылкаНаЗагрузкуСпискаС_ПартнерскогоAPI_1С(Ссылка);
     
КонецПроцедуры // ()


&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
    
    ТекДанные = Элементы.Список.ТекущиеДанные;
    Если ТекДанные = Неопределено Тогда
        Возврат;    
    КонецЕсли;
    Ссылка = ТекДанные.Ссылка;
    Если Не ЗначениеЗаполнено(Ссылка) Тогда
         ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Загрузиты с партнерского сайта ссылку на список!");
         Возврат;     
     КонецЕсли;
    ЗагрузитьДанныеНаСервере(Ссылка);
    Элементы.Список.Обновить();
    
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеНаСервере(Ссылка);
     
     ИнтеграцияСПартнерскимAPI_1C.ПодключитьсяКПартнерскомуAPIИЗагрузитьДанныеПоСервисамИТС(Ссылка);
     
КонецПроцедуры // ()
 