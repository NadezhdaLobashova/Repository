////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными XDTO"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет список планов обмена, которые используют функционал подсистемы обмена данными по формату XDTO.
//
// Параметры:
// ПланыОбменаXDTO. Тип: Массив.
// Массив планов обмена конфигурации, которые используют функционал подсистемы обмена данными по формату XDTO.
// Элементами массива являются объекты метаданных планов обмена.
//
// Пример тела процедуры:
//
// ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ОбменУправлениеТорговлейБухгалтерияПредприятия30);
//
Процедура СписокПлановОбменаXDTO(ПланыОбменаXDTO) Экспорт
	
	ПланыОбменаXDTO.Добавить(Метаданные.ПланыОбмена.СинхронизацияДанныхПоддержки);
	
КонецПроцедуры

#КонецОбласти
