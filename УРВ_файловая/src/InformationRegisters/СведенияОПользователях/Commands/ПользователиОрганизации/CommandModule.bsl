
#Область ОбработчикиСобытий
    
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Отбор = Новый Структура("ОбслуживающаяОрганизация", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	ОткрытьФорму(
		"РегистрСведений.СведенияОПользователях.Форма.ПользователиОрганизации",
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти 
