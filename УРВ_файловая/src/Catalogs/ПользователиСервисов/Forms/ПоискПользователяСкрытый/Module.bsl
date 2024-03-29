
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Сервис") Тогда
		Сервис = Параметры.Отбор.Сервис;
	ИначеЕсли Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") Тогда
		Сервис = Параметры.Отбор.Владелец;
	ИначеЕсли Параметры.Свойство("Сервис") Тогда
		Сервис = Параметры.Сервис;
    КонецЕсли;
    
    ИспользоватьДополнительныеРеквизиты = ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения");
    //+ Котова А.Ю. 25.09.2018 ТЗ№ 72350 {
	УстановитьДополнительныеРеквизитыПоиска();
	//- Котова А.Ю. 25.09.2018 ТЗ№ 72350 }  
    УстановитьНачальныеЗначенияИспользованияОтборов();
    УстановитьВидимостьОтборов();
	
	//astyul, 74135, 22.10.2018
	Если Параметры.Отбор.Свойство("Абонент") Тогда
		Если ЗначениеЗаполнено(Параметры.Отбор.Абонент) Тогда
			ЗаполнитьСписокПоАбоненту(Параметры.Отбор.Абонент);
			Абонент = Параметры.Отбор.Абонент;
		КонецЕсли;
	КонецЕсли;
	//astyul, 74135, 22.10.2018
	
	//+astyul,72353, 30.10.2018
	КомандаСоздать			= ЭтаФорма.Команды.Добавить("СоздатьПользователяСервиса");
	КомандаСоздать.Действие	= "СоздатьПользователяСервисаКоманда";
	
	КнопкаСоздать			    = ЭтаФорма.Элементы.Добавить("КнопкаСоздатьПользователяСервиса", Тип("КнопкаФормы"), ЭтаФорма.Элементы.ГруппаПоиск);
	КнопкаСоздать.Заголовок	    = "Создать";
	КнопкаСоздать.ИмяКоманды	= "СоздатьПользователяСервиса";
	КнопкаСоздать.Картинка      = БиблиотекаКартинок.СоздатьЭлементСписка;
	КнопкаСоздать.Отображение   = ОтображениеКнопки.КартинкаИТекст;
	Элементы.Переместить(КнопкаСоздать, ЭтаФорма.Элементы.ГруппаПоиск, Элементы.Отступ);
	//-astyul,72353, 30.10.2018
	
   
КонецПроцедуры

//+ Котова А.Ю. 25.09.2018 ТЗ№ 72350 {
&НаСервере
Процедура УстановитьДополнительныеРеквизитыПоиска()
	
	ЭтаФорма.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;

	ДополнительныеРеквизитыПоиска = Новый Массив;
	
	РеквизитПоискаФИО = Новый РеквизитФормы("ПоискФИО",Новый ОписаниеТипов("Строка"),, "ФИО", Истина);
	ДополнительныеРеквизитыПоиска.Добавить(РеквизитПоискаФИО);
	
	ИспользоватьРеквизитПоискаФИО = Новый РеквизитФормы("ИспользоватьПоискФИО",Новый ОписаниеТипов("Булево"),, "", Истина);
	ДополнительныеРеквизитыПоиска.Добавить(ИспользоватьРеквизитПоискаФИО);
	
	РеквизитПоискаТелефон = Новый РеквизитФормы("ПоискТелефон",Новый ОписаниеТипов("Строка"),, "Телефон", Истина);
	ДополнительныеРеквизитыПоиска.Добавить(РеквизитПоискаТелефон);
	
	ИспользоватьРеквизитПоискаТелефон = Новый РеквизитФормы("ИспользоватьПоискТелефон",Новый ОписаниеТипов("Булево"),, "", Истина);
	ДополнительныеРеквизитыПоиска.Добавить(ИспользоватьРеквизитПоискаТелефон);
	
	ИзменитьРеквизиты(ДополнительныеРеквизитыПоиска);
	
	ГруппаФормыДопПоиск = Элементы.Добавить("Группа_ДополнительныйПоиск", Тип("ГруппаФормы"),Элементы.ГруппаКритерииПоиска);
	ГруппаФормыДопПоиск.Вид                        = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаФормыДопПоиск.Отображение                = ОтображениеОбычнойГруппы.Нет;
	ГруппаФормыДопПоиск.ОтображатьЗаголовок        = Ложь;
	ГруппаФормыДопПоиск.Группировка                = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		
	ГруппаФормыДопПоискФИО = Элементы.Добавить("Группа_ДопПоискФИО", Тип("ГруппаФормы"),Элементы.Группа_ДополнительныйПоиск);
	ГруппаФормыДопПоискФИО.Вид                        = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаФормыДопПоискФИО.Отображение                = ОтображениеОбычнойГруппы.Нет;
	ГруппаФормыДопПоискФИО.ОтображатьЗаголовок        = Ложь;
	ГруппаФормыДопПоискФИО.Группировка                = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	
	ГруппаФормыДопПоискТелефон = Элементы.Добавить("Группа_ДопПоискТелефон", Тип("ГруппаФормы"),Элементы.Группа_ДополнительныйПоиск);
	ГруппаФормыДопПоискТелефон.Вид                        = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаФормыДопПоискТелефон.Отображение                = ОтображениеОбычнойГруппы.Нет;
	ГруппаФормыДопПоискТелефон.ОтображатьЗаголовок        = Ложь;
	ГруппаФормыДопПоискТелефон.Группировка                = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	
	НовыйЭлемент = Элементы.Добавить("ИспользоватьПоискФИО", Тип("ПолеФормы"), ГруппаФормыДопПоискФИО);
	НовыйЭлемент.ПутьКДанным                  = "ИспользоватьПоискФИО";
	НовыйЭлемент.Вид                          = ВидПоляФормы.ПолеФлажка;
	НовыйЭлемент.ТолькоПросмотр               = Ложь;
	НовыйЭлемент.ПоложениеЗаголовка 		  = ПоложениеЗаголовкаЭлементаФормы.Нет;
	
	НовыйЭлемент = Элементы.Добавить("ПоискФИО", Тип("ПолеФормы"), ГруппаФормыДопПоискФИО);
	НовыйЭлемент.ПутьКДанным                  = "ПоискФИО";
	НовыйЭлемент.Вид                          = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ТолькоПросмотр               = Ложь;
	НовыйЭлемент.КнопкаОчистки = Истина;
	
	НовыйЭлемент = Элементы.Добавить("ИспользоватьПоискТелефон", Тип("ПолеФормы"), ГруппаФормыДопПоискТелефон);
	НовыйЭлемент.ПутьКДанным                  = "ИспользоватьПоискТелефон";
	НовыйЭлемент.Вид                          = ВидПоляФормы.ПолеФлажка;
	НовыйЭлемент.ТолькоПросмотр               = Ложь;
	НовыйЭлемент.ПоложениеЗаголовка 		  = ПоложениеЗаголовкаЭлементаФормы.Нет;
	
	НовыйЭлемент = Элементы.Добавить("ПоискТелефон", Тип("ПолеФормы"), ГруппаФормыДопПоискТелефон);
	НовыйЭлемент.ПутьКДанным                  = "ПоискТелефон";
	НовыйЭлемент.Вид                          = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ТолькоПросмотр               = Ложь;
	НовыйЭлемент.КнопкаОчистки = Истина;

КонецПроцедуры
//- Котова А.Ю. 25.09.2018 ТЗ№ 72350 }

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
    
    Для каждого ИмяПоля Из ИменаПолейОтбора() Цикл
        ИмяРеквизита = СтрШаблон("Использовать%1", ИмяПоля);
		ЗначениеНастройки = Настройки.Получить(ИмяРеквизита);
        Если ЗначениеНастройки <> Неопределено Тогда
            ЭтаФорма[ИмяРеквизита] = ЗначениеНастройки;
			Настройки.Удалить(ИмяРеквизита);
        КонецЕсли;
    КонецЦикла;
    
    Если ИспользоватьДополнительныеРеквизиты Тогда
        Для каждого ОписаниеСвойства Из ЭтаФорма.Свойства_ОписаниеДополнительныхРеквизитов Цикл
            ИмяРеквизита = СтрШаблон("Использовать%1", ОписаниеСвойства.ИмяРеквизитаЗначение);
    		ЗначениеНастройки = Настройки.Получить(ИмяРеквизита);
            Если ЗначениеНастройки <> Неопределено Тогда
                ЭтаФорма[ИмяРеквизита] = ЗначениеНастройки;
    			Настройки.Удалить(ИмяРеквизита);
            КонецЕсли;
        КонецЦикла;
    КонецЕсли;
            
    УстановитьВидимостьОтборов();
    
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
    
    Если ИспользоватьДополнительныеРеквизиты Тогда
        Для каждого ОписаниеСвойства Из ЭтаФорма.Свойства_ОписаниеДополнительныхРеквизитов Цикл
            ИмяРеквизита = СтрШаблон("Использовать%1", ОписаниеСвойства.ИмяРеквизитаЗначение);
  			Настройки.Вставить(ИмяРеквизита, ЭтаФорма[ИмяРеквизита]);
        КонецЦикла;
    КонецЕсли;
    
КонецПроцедуры

//+astyul,72353, 30.10.2018
&НаКлиенте
Процедура СоздатьПользователяСервисаКоманда()
	ОткрытьФорму("Справочник.ПользователиСервисов.Форма.ФормаСозданияПользователяВОБД", Новый Структура("Владелец, Абонент", Сервис, Абонент),,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры
//-astyul,72353, 30.10.2018

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы 

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок 

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ОбслуживающаяОрганизация", ТекущиеДанные.ОбслуживающаяОрганизация);
	СтруктураВозврата.Вставить("ПользовательСервиса", ТекущиеДанные.ПользовательСервиса);
	СтруктураВозврата.Вставить("Абонент", ТекущиеДанные.Абонент);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ОбслуживающаяОрганизация", ТекущиеДанные.ОбслуживающаяОрганизация);
	СтруктураВозврата.Вставить("ПользовательСервиса", ТекущиеДанные.ПользовательСервиса);
	СтруктураВозврата.Вставить("Абонент", ТекущиеДанные.Абонент);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ОбслуживающаяОрганизация", ТекущиеДанные.ОбслуживающаяОрганизация);
	СтруктураВозврата.Вставить("ПользовательСервиса", ТекущиеДанные.ПользовательСервиса);
	СтруктураВозврата.Вставить("Абонент", ТекущиеДанные.Абонент);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиПользователя(Команда)
	
	ВыполнитьПоискНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПоиск(Команда)
    
    Элементы.НастроитьПоиск.Пометка = Не Элементы.НастроитьПоиск.Пометка;
	УстановитьВидимостьОтборов();
    
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции 

&НаСервере
Процедура ВыполнитьПоискНаСервере()
    
    УстановленоИспользованиеДопСвойства = Ложь;
    Если ИспользоватьДополнительныеРеквизиты Тогда
        Для Каждого ОписаниеСвойства Из ЭтаФорма.Свойства_ОписаниеДополнительныхРеквизитов Цикл
            Если ЭтаФорма["Использовать" + ОписаниеСвойства.ИмяРеквизитаЗначение] Тогда
                УстановленоИспользованиеДопСвойства = Истина;
                Прервать;
            КонецЕсли;
        КонецЦикла;
    КонецЕсли;
	
	//+ Котова А.Ю. 25.09.2018 ТЗ№ 72350 {
	//Если НомерАбонента = 0  И СтрДлина(Логин) < 3 И СтрДлина(Email) < 3 И НомерОбласти = 0 И НЕ УстановленоИспользованиеДопСвойства Тогда
	Если НомерАбонента = 0  И СтрДлина(Логин) < 3 И СтрДлина(Email) < 3 И НомерОбласти = 0 И СтрДлина(ЭтотОбъект["ПоискФИО"])=0 И СтрДлина(ЭтотОбъект["ПоискТелефон"])=0 И НЕ УстановленоИспользованиеДопСвойства Тогда
	//- Котова А.Ю. 25.09.2018 ТЗ№ 72350 }
		Возврат;
    КонецЕсли;
    
    ПараметрыОтбора = Новый Структура;
    Для каждого ИмяПоля Из ИменаПолейОтбора() Цикл
        ПараметрыОтбора.Вставить("Использовать" + ИмяПоля, ЭтаФорма["Использовать" + ИмяПоля]);
        ПараметрыОтбора.Вставить(ИмяПоля, ЭтаФорма[ИмяПоля]);
    КонецЦикла;
    
    ДополнительныеПараметрыОтбора = Новый ТаблицаЗначений;
    ДополнительныеПараметрыОтбора.Колонки.Добавить("Свойство");
    ДополнительныеПараметрыОтбора.Колонки.Добавить("Значение");
    
    Если ИспользоватьДополнительныеРеквизиты Тогда
        Для каждого ОписаниеСвойства Из ЭтаФорма.Свойства_ОписаниеДополнительныхРеквизитов Цикл
            Если ЭтаФорма["Использовать" + ОписаниеСвойства.ИмяРеквизитаЗначение] Тогда
                НоваяСтрока = ДополнительныеПараметрыОтбора.Добавить();
                НоваяСтрока.Свойство = ОписаниеСвойства.Свойство;
                НоваяСтрока.Значение = ЭтаФорма[ОписаниеСвойства.ИмяРеквизитаЗначение];
            КонецЕсли;    
        КонецЦикла;
    КонецЕсли;
    
    СвойстваПользователей = Справочники.ПользователиСервисов.СвойстваПользователей(Сервис, ПараметрыОтбора, ДополнительныеПараметрыОтбора);
	
	Список.Загрузить(СвойстваПользователей);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьОтборов();
    
    Для каждого ИмяПоля Из ИменаПолейОтбора() Цикл
        Элементы["Использовать" + ИмяПоля].Видимость = Элементы.НастроитьПоиск.Пометка;
        Элементы[ИмяПоля].Видимость = Элементы.НастроитьПоиск.Пометка Или ЭтаФорма["Использовать" + ИмяПоля]; 
    КонецЦикла;
    
    Если ИспользоватьДополнительныеРеквизиты Тогда
        Для каждого ОписаниеСвойства Из ЭтаФорма.Свойства_ОписаниеДополнительныхРеквизитов Цикл
            Элементы["Использовать" + ОписаниеСвойства.ИмяРеквизитаЗначение].Видимость = Элементы.НастроитьПоиск.Пометка;
            Элементы[ОписаниеСвойства.ИмяРеквизитаЗначение].Видимость = Элементы.НастроитьПоиск.Пометка Или ЭтаФорма["Использовать" + ОписаниеСвойства.ИмяРеквизитаЗначение]; 
        КонецЦикла; 
    КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНачальныеЗначенияИспользованияОтборов()
    
    Для каждого ИмяПоля Из ИменаПолейОтбора() Цикл
        ЭтаФорма["Использовать" + ИмяПоля] = Истина;
    КонецЦикла;
    
    // Добавим отборы по дополнительным реквизитам и сведениям, если они используются.
	Если ИспользоватьДополнительныеРеквизиты Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Объект", Справочники.Абоненты.ПустаяСсылка());
		ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаКритерииПоискаДополнительно");
		ДополнительныеПараметры.Вставить("ПроизвольныйОбъект", Ложь);
		
    	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
        ДобавляемыеРеквизиты = Новый Массив();
        
        Для каждого ОписаниеСвойства Из ЭтаФорма.Свойства_ОписаниеДополнительныхРеквизитов Цикл
            Реквизит = Новый РеквизитФормы("Использовать"+ОписаниеСвойства.ИмяРеквизитаЗначение, Новый ОписаниеТипов("Булево"), , ОписаниеСвойства.Наименование, Ложь);
            ДобавляемыеРеквизиты.Добавить(Реквизит);
        КонецЦикла; 
        ИзменитьРеквизиты(ДобавляемыеРеквизиты);
        
        Для каждого ОписаниеСвойства Из ЭтаФорма.Свойства_ОписаниеДополнительныхРеквизитов Цикл
            ИмяПризнака = "Использовать" + ОписаниеСвойства.ИмяРеквизитаЗначение;
            ЭлементГруппа = Элементы.Добавить("Группа" + ОписаниеСвойства.ИмяРеквизитаЗначение, Тип("ГруппаФормы"), Элементы.ГруппаКритерииПоискаДополнительно);
            ЭлементГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
            ЭлементГруппа.Отображение = ОтображениеОбычнойГруппы.Нет;
            ЭлементГруппа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
            ЭлементГруппа.ОтображатьЗаголовок = Ложь;
            ЭлементПризнак = Элементы.Добавить(ИмяПризнака, Тип("ПолеФормы"), ЭлементГруппа);
            ЭлементПризнак.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
            ЭлементПризнак = Элементы[ИмяПризнака];
            ЭлементПризнак.ПутьКДанным = ИмяПризнака;
            ЭлементПризнак.Вид = ВидПоляФормы.ПолеФлажка;
            ЭлементПризнак.УстановитьДействие("ПриИзменении", "Подключаемый_ИспользоватьДополнительныйРеквизитПриИзменении");
            Элементы[ОписаниеСвойства.ИмяРеквизитаЗначение].УстановитьДействие("ПриИзменении", "Подключаемый_ДополнительныйРеквизитПриИзменении");
            Элементы.Переместить(Элементы[ОписаниеСвойства.ИмяРеквизитаЗначение], ЭлементГруппа);
        КонецЦикла;
    КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция ИменаПолейОтбора()
	//+ Котова А.Ю. 25.09.2018 ТЗ№ 72350 {
	//Возврат СтрРазделить("НомерАбонента,НомерОбласти,Логин,EMail", ",", Ложь);
    Возврат СтрРазделить("НомерАбонента,НомерОбласти,Логин,EMail,ПоискФИО,ПоискТелефон", ",", Ложь);
	//- Котова А.Ю. 25.09.2018 ТЗ№ 72350 }
КонецФункции

&НаКлиенте
Процедура Подключаемый_ИспользоватьДополнительныйРеквизитПриИзменении(Элемент)
    
    СохраняемыеВНастройкахДанныеМодифицированы = Истина;
    
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ДополнительныйРеквизитПриИзменении(Элемент)
    
    Модифицированность = Ложь;
    
КонецПроцедуры

//astyul, 74135, 22.10.2018
&НаСервере
Процедура ЗаполнитьСписокПоАбоненту(АбонентВладелец)
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	ПользователиАбонентов.Абонент КАК Абонент,
	                      |	ПользователиАбонентов.Абонент.Код КАК АбонентКод,
	                      |	КИАдресАбонента.Представление КАК АдресАбонента,
	                      |	ВзаимоотношенияАбонентов.ВедущийАбонент КАК ОбслуживающаяОрганизация,
	                      |	ВзаимоотношенияАбонентов.ВедущийАбонент.Код КАК ОбслуживающаяОрганизацияКод,
	                      |	Пользователи.Ссылка КАК ПользовательСервиса,
	                      |	Пользователи.Код КАК Код,
	                      |	Пользователи.Наименование КАК Наименование,
	                      |	Пользователи.СтрокаEmail КАК Email,
	                      |	КИТелефон.Представление КАК Телефон,
	                      |	Пользователи.Владелец КАК Сервис
	                      |ИЗ
	                      |	Справочник.ПользователиСервисов КАК Пользователи
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПользователиАбонентов КАК ПользователиАбонентов
	                      |			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Абоненты.КонтактнаяИнформация КАК КИАдресАбонента
	                      |			ПО ПользователиАбонентов.Абонент = КИАдресАбонента.Ссылка
	                      |				И (КИАдресАбонента.Вид = &АдресАбонента)
	                      |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВзаимоотношенияАбонентов КАК ВзаимоотношенияАбонентов
	                      |			ПО ПользователиАбонентов.Абонент = ВзаимоотношенияАбонентов.Абонент
	                      |				И (ВзаимоотношенияАбонентов.ВидВзаимоотношений = &ОбслуживающаяОрганизацияАбонент)
	                      |		ПО Пользователи.Ссылка = ПользователиАбонентов.ПользовательСервиса
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПользователиСервисов.КонтактнаяИнформация КАК КИТелефон
	                      |		ПО Пользователи.Ссылка = КИТелефон.Ссылка
	                      |			И (КИТелефон.Вид = &ТелефонПользователя)
	                      |ГДЕ
	                      |	ПользователиАбонентов.Абонент = &Абонент");
	Запрос.УстановитьПараметр("Абонент",АбонентВладелец);
	Запрос.УстановитьПараметр("ТелефонПользователя", Справочники.ВидыКонтактнойИнформации.ТелефонПользователяСервиса);
	Запрос.УстановитьПараметр("АдресАбонента", Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресАбонента);
	Запрос.УстановитьПараметр("ОбслуживающаяОрганизацияАбонент", Перечисления.ВидыВзаимоотношений.ОбслуживающаяОрганизацияАбонент);
	Список.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры	
//astyul, 74135, 22.10.2018

#КонецОбласти 
