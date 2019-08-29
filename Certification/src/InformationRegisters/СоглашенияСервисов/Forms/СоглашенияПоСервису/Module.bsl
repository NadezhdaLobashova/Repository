
#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок
    
&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
    
    Сервис = Элемент.ТекущиеДанные.Сервис;
    
КонецПроцедуры

&НаКлиенте
Процедура СписокПослеУдаления(Элемент) Экспорт
    
    Оповещение = Новый ОписаниеОповещения("ПослеУдаленияСоглашенияПоСервисуЗавершение", ЭтотОбъект, Сервис);
    
    ПоказатьВопрос(Оповещение, НСтр("ru='Пересчитать сроки открытых обращений по сервису?'"), 
                   РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
    
КонецПроцедуры
 
#КонецОбласти 

#Область СлужебныеПроцедурыИФункции
    
&НаКлиенте
Процедура ПослеУдаленияСоглашенияПоСервисуЗавершение(Результат, Сервис) Экспорт
    
    Если Результат = КодВозвратаДиалога.Да Тогда
        ПослеУдаленияСоглашенияПоСервисуЗавершениеНаСервере(Сервис);
    КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеУдаленияСоглашенияПоСервисуЗавершениеНаСервере(Сервис) Экспорт
    
    Справочники.Соглашения.ЗапуститьРасчетСроковОбращенийВФоне(Сервис);
    
КонецПроцедуры

#КонецОбласти 
