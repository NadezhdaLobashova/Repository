
#Область ОбработчикиСобытийФормы
    
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Абонент") Тогда
        ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(АбонентыНаОбслуживании, "ВедущийАбонент", Параметры.Отбор.Абонент);
        ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ГдеОбслуживается, "Абонент", Параметры.Отбор.Абонент);
    КонецЕсли; 
    
КонецПроцедуры

#КонецОбласти 
