
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Владелец) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// {Рарус_shav 2019.03.28 
	//Если Объект.ПредопределеннаяПапка Тогда
	//	ТолькоПросмотр = Истина;
	//	Возврат;
	//КонецЕсли;
	// }Рарус_shav 2019.03.28 
	
	ЕстьПравоНаВедениеПапок = Взаимодействия.ПользовательЯвляетсяОтветственнымЗаВедениеПапок(Объект.Владелец);

	Если НЕ ЕстьПравоНаВедениеПапок Тогда
		Если Объект.Ссылка.Пустая() Тогда
			Отказ = Истина;
		Иначе
			ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПапкиЭлектронныхПисем", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти
