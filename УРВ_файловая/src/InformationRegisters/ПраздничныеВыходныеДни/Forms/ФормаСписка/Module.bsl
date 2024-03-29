
&НаКлиенте
Процедура ЗаполнитьГод(Команда)
	
	НомерГода = Год(ТекущаяДата()) + 1; // По умолчанию: Следующий год
	Если ВвестиЧисло(НомерГода, "Введите год", 4, 0) Тогда
		
		Если ЕстьЗаполненныеДниВГоду(НомерГода) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "Заполнение не выполнено: В " + НомерГода + " году уже есть заполненные значения!";
			Сообщение.Сообщить();
			
		Иначе
			Если Вопрос("Заполнить " + НомерГода + " год ?", РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Нет) <> КодВозвратаДиалога.Да Тогда
			    Возврат;
			КонецЕсли;
			
			ВыполнитьЗаполнениеПоГоду(НомерГода);
			Элементы.Список.Обновить();
			
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "Выполнено заполнение по умолчанию выходных и праздничных дней в " + НомерГода + " году. Проверьте и откорректируйте при необходимости!";
			Сообщение.Сообщить();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьЗаполненныеДниВГоду(НомерГода)

	Возврат РегистрыСведений.ПраздничныеВыходныеДни.ЕстьЗаполненныеДниВГоду(НомерГода);	

КонецФункции // ()

&НаСервереБезКонтекста
Процедура ВыполнитьЗаполнениеПоГоду(НомерГода)

	РегистрыСведений.ПраздничныеВыходныеДни.ВыполнитьЗаполнениеПоГоду(НомерГода);

КонецПроцедуры

