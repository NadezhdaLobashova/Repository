#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
    
#Область СлужебныеПроцедурыИФункции

Процедура НастроитьМакетСхемыКомпоновки()

    // Если соглашения не используются, поля ПревышениеДниЧасы, ПревышениеВРабочееВремяЧасы нужно скрыть.
    Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСоглашения") Тогда
        ПолеПревышениеДниЧасы = Новый ПолеКомпоновкиДанных("ПревышениеДниЧасы");
        ПолеПревышениеВРабочееВремяЧасы = Новый ПолеКомпоновкиДанных("ПревышениеВРабочееВремяЧасы");
        ПоляОграничений = СтрРазделить("Поле, Группировка, Порядок, Условие", ", ", Ложь);
        Для каждого ПолеНабора Из СхемаКомпоновкиДанных.НаборыДанных.Основной.Поля Цикл
            Если ПолеНабора.Поле = "Превышение" Или ПолеНабора.Поле = "ПревышениеВРабочееВремя" Тогда
                Для Каждого Ограничение Из ПоляОграничений Цикл
                     ПолеНабора.ОграничениеИспользования[Ограничение] = Истина;
                     ПолеНабора.ОграничениеИспользованияРеквизитов[Ограничение] = Истина;
                КонецЦикла; 	
            КонецЕсли;
        КонецЦикла;
        Для каждого ПолеНабора Из СхемаКомпоновкиДанных.ВычисляемыеПоля Цикл
            Если ПолеНабора.ПутьКДанным = "ПревышениеВРабочееВремяЧасы" Или ПолеНабора.ПутьКДанным = "ПревышениеДниЧасы" Тогда
                Для Каждого Ограничение Из ПоляОграничений Цикл
                     ПолеНабора.ОграничениеИспользования[Ограничение] = Истина;
                КонецЦикла; 	
            КонецЕсли;
        КонецЦикла;
    	ВариантНастроек = СхемаКомпоновкиДанных.ВариантыНастроек.ДлительностьОбработкиОбращений;
        Для НомерПоля = -(ВариантНастроек.Настройки.Выбор.Элементы.Количество() - 1) По 0 Цикл
            ПолеВыбора = ВариантНастроек.Настройки.Выбор.Элементы[-НомерПоля];
            Если ПолеВыбора.Поле = ПолеПревышениеДниЧасы 
                Или ПолеВыбора.Поле = ПолеПревышениеВРабочееВремяЧасы Тогда
                ВариантНастроек.Настройки.Выбор.Элементы.Удалить(ПолеВыбора);
            КонецЕсли;
        КонецЦикла;
        
    КонецЕсли; 
    
КонецПроцедуры
    
НастроитьМакетСхемыКомпоновки();

#КонецОбласти

#КонецЕсли
