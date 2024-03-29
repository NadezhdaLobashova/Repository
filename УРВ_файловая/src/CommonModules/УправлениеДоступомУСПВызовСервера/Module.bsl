
#Область ПрограммныйИнтерфейс
    
// Признак доступности пользователей сервиса
// 
// Возвращаемое значение:
//  Булево - признак доступности.
//
Функция ДоступныПользователиСервиса() Экспорт
	
	Если Пользователи.ЭтоПолноправныйПользователь() Или РольДоступна(Метаданные.Роли.ЧтениеПользователейСервиса) 
	 Или РольДоступна(Метаданные.Роли.ДобавлениеИзменениеПользователейСервиса) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Признак доступности абонентов
// 
// Возвращаемое значение:
//  Булево - признак доступности.
//
Функция ДоступныАбоненты() Экспорт
	
	Если Пользователи.ЭтоПолноправныйПользователь() Или РольДоступна(Метаданные.Роли.ЧтениеАбонентов) 
	 Или РольДоступна(Метаданные.Роли.ДобавлениеИзменениеАбонентов) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции
 
// Признак доступности приложений
// 
// Возвращаемое значение:
//  Булево - признак доступности.
//
Функция ДоступныПриложения() Экспорт
	
	Если Пользователи.ЭтоПолноправныйПользователь() Или РольДоступна(Метаданные.Роли.ЧтениеПриложений) 
	 Или РольДоступна(Метаданные.Роли.ДобавлениеИзменениеПриложений) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти 
