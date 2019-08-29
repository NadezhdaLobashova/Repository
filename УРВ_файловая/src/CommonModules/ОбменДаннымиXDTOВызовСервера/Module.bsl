////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными XDTO"
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Определяет, входит ли план обмена в сисок планов обмена, которые используют обмен данными по формату XDTO
//
// Параметры:
//  ПланОбмена - Ссылка на узел плана обмена или имя плана обмена
//
// Возвращаемое значение: Булево
//
Функция ЭтоПланОбменаXDTO(ПланОбмена) Экспорт
	
	МассивПлановОбменаXDTO = Новый Массив;
	ОбменДаннымиXDTOПереопределяемый.СписокПлановОбменаXDTO(МассивПлановОбменаXDTO);
	Если МассивПлановОбменаXDTO.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	Если ТипЗнч(ПланОбмена) = Тип("Строка") Тогда
		ПланОбменаXDTO = МассивПлановОбменаXDTO.Найти(Метаданные.ПланыОбмена[ПланОбмена]);
	Иначе
		ПланОбменаXDTO = МассивПлановОбменаXDTO.Найти(ПланОбмена.Метаданные());
	КонецЕсли;
	Если ПланОбменаXDTO = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
