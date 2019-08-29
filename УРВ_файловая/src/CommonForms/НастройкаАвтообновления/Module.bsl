
#Область ОбработчикиСобытийФормы
    
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Автообновление") Тогда
		Автообновление = Параметры.Автообновление;
		Если Параметры.Свойство("ПериодАвтообновления") Тогда
			ПериодАвтообновления = Параметры.ПериодАвтообновления;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ПериодАвтообновления.Доступность = Автообновление;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы
    
&НаКлиенте
Процедура АвтообновлениеПриИзменении(Элемент)
	Элементы.ПериодАвтообновления.Доступность = Автообновление;
	Если ПериодАвтообновления < 10 Тогда
		ПериодАвтообновления = 300; // Значение по умолчанию если период еще не задан
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПериодАвтообновленияПриИзменении(Элемент)
	Если ПериодАвтообновления < 10 Тогда
		ПериодАвтообновления = 10; // Не меньше 10 секунд
	КонецЕсли;
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы
    
&НаКлиенте
Процедура Установить(Команда)
	Результат = Новый Структура;
	Результат.Вставить("Автообновление", Автообновление);
	Результат.Вставить("ПериодАвтообновления", ПериодАвтообновления);
	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

#КонецОбласти 
