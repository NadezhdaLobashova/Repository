
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.КоррекцияДоМестногоВремени.Подсказка = 
		ОбщегоНазначенияУСПКлиентСервер.ПредставлениеСмещенияВремени(Запись.КоррекцияДоМестногоВремени);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоррекцияДоМестногоВремениПриИзменении(Элемент)
	
	Элементы.КоррекцияДоМестногоВремени.Подсказка = 
		ОбщегоНазначенияУСПКлиентСервер.ПредставлениеСмещенияВремени(Запись.КоррекцияДоМестногоВремени);
	
КонецПроцедуры

#КонецОбласти

