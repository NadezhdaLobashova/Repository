#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    ТекущаяДатаКлиента = ТекущаяДата();
	
	Список.Параметры.УстановитьЗначениеПараметра("СекундДоМестногоВремени",
		ТекущаяДатаКлиента - УниверсальноеВремя(ТекущаяДатаКлиента));
        
КонецПроцедуры

#КонецОбласти 
