
#Область ОбработчикиСобытий
    
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Отбор = Новый Структура("Приложение", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	ОткрытьФорму(
		"РегистрСведений.ПользователиПриложений.Форма.ПользователиПриложения",
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти 
