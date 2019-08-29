
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("ТелефонПользователя", Справочники.ВидыКонтактнойИнформации.ТелефонПользователяСервиса);
	Список.Параметры.УстановитьЗначениеПараметра("ПочтаПользователя", Справочники.ВидыКонтактнойИнформации.EmailПользователяСервиса);
	Список.Параметры.УстановитьЗначениеПараметра("АдресАбонента", Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресАбонента);
	Список.Параметры.УстановитьЗначениеПараметра("ОбслуживающаяОрганизацияАбонент", Перечисления.ВидыВзаимоотношений.ОбслуживающаяОрганизацияАбонент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы 

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Закрыть(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Закрыть(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Закрыть(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти 
