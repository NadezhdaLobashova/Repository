////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными XDTO".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет, входит ли план обмена в сисок планов обмена, которые используют обмен данными по формату XDTO
//
// Параметры:
//  ИнформацияОПланеОбмена - Ссылка на узел плана обмена или имя плана обмена
//
// Возвращаемое значение: Булево
//
Функция ЭтоПланОбменаXDTO(ИнформацияОПланеОбмена) Экспорт
	
	Возврат ОбменДаннымиXDTOВызовСервера.ЭтоПланОбменаXDTO(ИнформацияОПланеОбмена);
	
КонецФункции

#КонецОбласти