

//==================================================================================================
#Область СобытияФормы
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Цвет = БоР_ОбщийМодуль.ЗначениеИзXML(ТекЗапись.ЦветТекста);
	Если ТипЗнч(Цвет) = Тип("Цвет") Тогда
		Элементы.Образец.ЦветТекста = Цвет;
	КонецЕсли;
	
	Цвет = БоР_ОбщийМодуль.ЗначениеИзXML(ТекЗапись.ЦветФона);
	Если ТипЗнч(Цвет) = Тип("Цвет") Тогда
		Элементы.Образец.ЦветФона = Цвет;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	//
	//ТекЗапись.ЦветТекста	= БоР_ОбщийМодуль.ЗначениеВXML(Элементы.Образец.ЦветТекста);
	//ТекЗапись.ЦветФона 	= БоР_ОбщийМодуль.ЗначениеВXML(Элементы.Образец.ЦветФона);
	
КонецПроцедуры

#КонецОбласти


//==================================================================================================
#Область СобытияЭлементовФормы
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ВыбратьЦветФона(Команда)
	
	ДиалогВыбораЦвета = Новый ДиалогВыбораЦвета;
	ДиалогВыбораЦвета.Цвет = Элементы.Образец.ЦветФона;
	ДиалогВыбораЦвета.Показать(Новый ОписаниеОповещения("ВыбратьЦветФона_Завершение", ЭтаФорма));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЦветФона_Завершение(ВыбранныйЦвет, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(ВыбранныйЦвет) = Тип("Цвет") Тогда
		Элементы.Образец.ЦветФона 	= ВыбранныйЦвет;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ВыбратьЦветТекста(Команда)
	
	ДиалогВыбораЦвета = Новый ДиалогВыбораЦвета;
	ДиалогВыбораЦвета.Цвет = Элементы.Образец.ЦветТекста;
	ДиалогВыбораЦвета.Показать(Новый ОписаниеОповещения("ВыбратьЦветТекста_Завершение", ЭтаФорма));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЦветТекста_Завершение(ВыбранныйЦвет, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(ВыбранныйЦвет) = Тип("Цвет") Тогда
		Элементы.Образец.ЦветТекста	= ВыбранныйЦвет;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ТекЗапись.ЦветТекста	= БоР_ОбщийМодуль.ЗначениеВXML(Элементы.Образец.ЦветТекста);
	ТекЗапись.ЦветФона 	= БоР_ОбщийМодуль.ЗначениеВXML(Элементы.Образец.ЦветФона);
КонецПроцедуры

#КонецОбласти

//==================================================================================================
#Область СобытияОбщегоНазначения
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ


#КонецОбласти


//==================================================================================================



