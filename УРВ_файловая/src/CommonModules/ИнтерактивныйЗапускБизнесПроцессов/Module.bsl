
#Область ПрограммныйИнтерфейс
    
// Получает шаблоны для автозапуска интерактивного
Функция ПолучитьШаблоныДляАвтоЗапуска(ВидИнтерактивногоБизнесСобытия, Объект) Экспорт
	
	ИдентификаторОбъекта = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Объект.Ссылка));
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	НастройкаШаблоновБизнесПроцессов.ШаблонБизнесПроцесса КАК ШаблонБизнесПроцесса,
	               |	НастройкаШаблоновБизнесПроцессов.ИдентификаторОбъекта,
	               |	НастройкаШаблоновБизнесПроцессов.ИнтерактивныйЗапуск,
	               |	НастройкаШаблоновБизнесПроцессов.ВидИнтерактивногоСобытия,
	               |	НастройкаШаблоновБизнесПроцессов.Условие
	               |ИЗ
	               |	РегистрСведений.НастройкаШаблоновБизнесПроцессов КАК НастройкаШаблоновБизнесПроцессов
	               |ГДЕ
	               |	НастройкаШаблоновБизнесПроцессов.ИдентификаторОбъекта = &ИдентификаторОбъекта
	               |	И НастройкаШаблоновБизнесПроцессов.ИнтерактивныйЗапуск = ИСТИНА
	               |	И НастройкаШаблоновБизнесПроцессов.ВидИнтерактивногоСобытия = &ВидИнтерактивногоСобытия";
				   
	Запрос.УстановитьПараметр("ИдентификаторОбъекта", ИдентификаторОбъекта);
	Запрос.УстановитьПараметр("ВидИнтерактивногоСобытия", ВидИнтерактивногоБизнесСобытия);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
	СписокЗначений = Новый СписокЗначений;
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	Для Каждого Строка Из Таблица Цикл
		
		// Проверим условие маршрутизации
		Если РаботаСУсловиямиМаршрутизации.ПроверитьПрименимостьУсловияМаршрутизацииКОбъекту(Объект, Строка.Условие) Тогда
			
			СписокЗначений.Добавить(Строка.ШаблонБизнесПроцесса, Строка(Строка.ШаблонБизнесПроцесса), Истина);
			
		КонецЕсли;
		
	КонецЦикла;	
	
	Возврат СписокЗначений;
	
КонецФункции

#КонецОбласти 
