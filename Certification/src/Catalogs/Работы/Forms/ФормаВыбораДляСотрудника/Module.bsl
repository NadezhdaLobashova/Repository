
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	 Список.Параметры.УстановитьЗначениеПараметра("Должность",Параметры.Должность);
	 Список.Параметры.УстановитьЗначениеПараметра("Подразделение",Параметры.Подразделение);
	 Список.Параметры.УстановитьЗначениеПараметра("ДатаСреза",КонецМесяца(Параметры.ДатаСреза));
КонецПроцедуры
