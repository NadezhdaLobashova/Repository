#Область ФункцииСобытийФормы
&НаКлиенте
Процедура ФайлНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ВыборПапкиДляВыгрузки(Файл);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
	Если Не ЗначениеЗаполнено(Файл) Тогда		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не выбран файл для загрузки!";
		Сообщение.Поле = "Файл";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	ОчиститьТаблицу();
	ВыполнитьЗагрузку();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВБазу(Команда)
	Если Объект.ТаблицаКонтрагентов.Количество() = 0 Тогда
		Сообщить("Нет данных для загрузки");
		Возврат
	КонецЕсли;
	ЗагрузитьВБазуНаСервере();
КонецПроцедуры

#КонецОбласти



#Область СлужебныеФункции
&НаСервере
Процедура ОчиститьТаблицу()
	Объект.ТаблицаКонтрагентов.Очистить();
КонецПроцедуры	

&НаКлиенте
Процедура ВыборПапкиДляВыгрузки(парамЗначение)
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбора.Заголовок = "Выберите файл";
	
	Если ДиалогВыбора.Выбрать() Тогда
		парамЗначение = ДиалогВыбора.ПолноеИмяФайла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузку()
	
	//подключаемся к эксель
	Попытка
		Excel = Новый COMОбъект("Excel.Application");
		Excel.WorkBooks.Open(Файл);
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Ошибка при открытии файла с помощью Excel! Загрузка не будет произведена!" + ОписаниеОшибки();
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Возврат;
	КонецПопытки;
	
	Попытка
		//Открываем необходимый лист
		Excel.Sheets(1).Select(); // лист 1, по умолчанию
	Исключение
		//Закрываем Excel
		Excel.ActiveWorkbook.Close();
		Excel = 0;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Файл "+Строка(Файл)+" не соответствует необходимому формату! Первый лист не найден!";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Возврат;
	КонецПопытки;
	
	ФайлСтрок = Excel.Cells(1,1).SpecialCells(11).Row;
	ФайлКолонок = Excel.Cells(1,1).SpecialCells(11).Column;
	
	Для НС = 4 по ФайлСтрок Цикл
		 СтрокаДанных            = Объект.ТаблицаКонтрагентов.Добавить();
		 СтрокаДанных.Контрагент = СокрЛП(Excel.Cells(НС, 1).Text);
		 СтрокаДанных.ИНН        = СокрЛП(Excel.Cells(НС, 2).Text);	 
	 КонецЦикла;
	 
	 Excel.DisplayAlerts = 0;
	 Excel.Quit();
     Excel.DisplayAlerts = 1;
	 
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = "Загрузка файла завершена";
	Сообщение.УстановитьДанные(ЭтотОбъект);
	Сообщение.Сообщить();	
КонецПроцедуры	

&НаСервере
Процедура ЗагрузитьВБазуНаСервере()
	РеквизитФормыВЗначение("Объект").СоздатьКонтрагентов();
КонецПроцедуры	
#КонецОбласти







