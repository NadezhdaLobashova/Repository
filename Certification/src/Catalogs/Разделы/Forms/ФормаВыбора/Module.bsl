
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		
		Возврат; 
		
	КонецЕсли;
	
	Если Параметры.Свойство("Сервис") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Сервисы.Сервис", Параметры.Сервис, ВидСравненияКомпоновкиДанных.Равно, "Сервис", Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	КонецЕсли;
	
	Если Параметры.Свойство("Компонент") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Компоненты.Компонент", Параметры.Компонент, ВидСравненияКомпоновкиДанных.Равно, "Сервис", Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	КонецЕсли;
	
КонецПроцедуры
