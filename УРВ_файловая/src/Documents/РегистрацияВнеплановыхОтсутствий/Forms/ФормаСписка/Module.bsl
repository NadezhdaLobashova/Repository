
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ РольДоступна("ПолныеПрава") Тогда    		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Сотрудник", ПараметрыСеанса.ТекущийПользователь, ВидСравненияКомпоновкиДанных.Равно);
	КонецЕсли;   	
КонецПроцедуры



