
#Область ПрограммныйИнтерфейс

// Позволяет задать общие настройки подсистемы.
//
// Параметры:
//   Настройки - Структура - настройки подсистемы:
//     * КартинкаИндикатораПроблем    - Картинка, которая будет выводиться в качестве
//                                      индикатора ошибки в колонке динамического списка
//                                      форм списков и на специальной панели форм объектов.
//     * ПояснениеИндикатораПроблем   - Строка - Поясняющая строка к ошибке.
//     * ГиперссылкаИндикатораПроблем - Строка - Текст гиперссылки, при нажатии на которую,
//                                      будет сформирован и открыт отчет с ошибками.
//
// Пример:
//   Настройки = Новый Структура;
//   Настройки.Вставить("КартинкаИндикатораПроблем",    БиблиотекаКартинок.Предупреждение);
//   Настройки.Вставить("ПояснениеИндикатораПроблем",   Неопределено);
//   Настройки.Вставить("ГиперссылкаИндикатораПроблем", Неопределено);
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
КонецПроцедуры

// Предназначена для подключения собственных правил проверки ведения учета.
//
// Параметры:
//   ГруппыПроверок - ТаблицаЗначений - Таблица, в которую добавляются группы проверок:
//      * Наименование                 - Строка - Наименование группы проверок.
//      * ИдентификаторГруппы          - Строка - Строковый идентификатор группы проверок, например: 
//                                       "СистемныеПроверки", "ЗакрытиеМесяца", "ПроверкиНДС" и т.п.
//                                       Обязателен для заполнения.
//      * Идентификатор                - Строка - Строковый идентификатор группы проверок. Обязателен для заполнения.
//                                       Для уникальности формат идентификатора следует выбирать следующим:
//                                       "<Название программного продукта>.<Идентификатор проверки>". 
//                                       Например: "СтандартныеПодсистемы.СистемныеПроверки".
//      * КонтекстПроверокВеденияУчета - ОпределяемыйТип.КонтекстПроверокВеденияУчета - значение, дополнительно
//                                       уточняющее принадлежность группы проверок ведения учета к определенной категории.
//      * Комментарий                  - Строка - комментарий к группе проверок.
//
//   Проверки - ТаблицаЗначений - Таблица, в которую добавляются проверки:
//      * ИдентификаторГруппы                    - Строка - Строковый идентификатор группы проверок, например: 
//                                                 "СистемныеПроверки", "ЗакрытиеМесяца", "ПроверкиНДС" и т.п.
//                                                 Обязателен для заполнения.
//      * Наименование                           - Строка - Наименование проверки, выводимое пользователю.
//      * Причины                                - Строка - Описание возможных причин, которые приводят к возникновению
//                                                 проблемы.
//      * Рекомендация                           - Строка - Рекомендация по решению возникшей проблемы.
//      * Идентификатор                          - Строка - Строковый идентификатор элемента. Обязателен для заполнения.
//                                                 Формат идентификатора должен быть следующим:
//                                                 <Название программного продукта>.<Идентификатор проверки>. Например:
//                                                 СтандартныеПодсистемы.СистемныеПроверки.
//      * ДатаНачалаПроверки                     - Дата - Пороговая дата, обозначающая границу проверяемых
//                                                 объектов (только для объектов с датой). Объекты, дата которых меньше
//                                                 указанной, не следует проверять. По умолчанию не заполнено (т.е.
//                                                 проверять все).
//      * ЛимитПроблем                           - Число - Количество проверяемых объектов. По умолчанию 1000. 
//                                                 Если указан 0, то следует проверять все объекты.
//      * ОбработчикПроверки                     - Строка - Имя экспортной процедуры-обработчика серверного общего 
//                                                 модуля в виде ИмяМодуля.ИмяПроцедуры. 
//      * ОбработчикПереходаКИсправлению         - Строка - Имя экспортной процедуры-обработчика клиентского общего 
//                                                 модуля для перехода к исправлению проблемы в виде ИмяМодуля.ИмяПроцедуры.
//      * БезОбработчикаПроверки                 - Булево - признак служебной проверки, которая не имеет процедуры-обработчика.
//      * ЗапрещеноИзменениеВажности             - Булево - Если Истина, то администратор не сможет перенастраивать 
//                                                 важность данной проверки.
//      * КонтекстПроверокВеденияУчета           - ОпределяемыйТип.КонтекстПроверокВеденияУчета - значение, дополнительно 
//                                                 уточняющее принадлежность проверки ведения учета к определенной группе 
//                                                 или категории.
//      * УточнениеКонтекстаПроверокВеденияУчета - ОпределяемыйТип.УточнениеКонтекстаПроверокВеденияУчета - второе значение, 
//                                                 дополнительно уточняющее принадлежность проверки ведения учета 
//                                                 к определенной группе или категории.
//      * ДополнительныеПараметры                - ХранилищеЗначений - Дополнительная информация о проверке для программного
//                                                 использования.
//      * Комментарий                            - Строка - комментарий к проверке.
//
// Пример:
//   1) Добавление проверки
//      Проверка = Проверки.Добавить();
//      Проверка.ИдентификаторГруппы = "СистемныеПроверки";
//      Проверка.Наименование        = НСтр("ru='Демо: Проверка заполнения комментария в документах ""Демо: Поступление товаров""'");
//      Проверка.Причины             = НСтр("ru='Не введен комментарий в документе.'");
//      Проверка.Рекомендация        = НСтр("ru='Ввести комментарий в документе.'");
//      Проверка.Идентификатор       = "ПроверитьКомментарийВПоступленииТоваров";
//      Проверка.ОбработчикПроверки  = "_ДемоСтандартныеПодсистемы.ПроверитьКомментарийВПоступленииТоваров";
//      Проверка.ДатаНачалаПроверки  = Дата('20140101000000');
//      Проверка.ЛимитПроблем        = 3;
//   2) Добавление группы проверок
//      ГруппаПроверок = ГруппыПроверок.Добавить();
//      ГруппаПроверок.Наименование                 = НСтр("ru='Системные проверки'");
//      ГруппаПроверок.Идентификатор                = "СтандартныеПодсистемы.СистемныеПроверки";
//      ГруппаПроверок.КонтекстПроверокВеденияУчета = "СистемныеПроверки";
//
Процедура ПриОпределенииПроверок(ГруппыПроверок, Проверки) Экспорт
	
	
	
КонецПроцедуры

// Позволяет настроить положение индикатора о проблемах в формах объектов.
//
// Параметры:
//   ПараметрыГруппыИндикации - Структура - выходные параметры индикатора:
//     * ВыводитьСнизу     - Булево - Если указать Истина, то группа индикатора будет выводиться самой последней 
//                           в форме или в конце указанной группе элементов ИмяРодителяГруппы.
//                           По умолчанию Ложь - группа выводится в начале указанной группе ИмяРодителяГруппы или 
//                           сразу под командной панелью формы объекта.
//     * ИмяРодителяГруппы - Строка - Определяет имя группы элементов формы объекта, внутри которой должна 
//                           располагаться группа индикации.
//
//   ТипСсылки - Тип - Тип ссылки, для которой переопределяются параметры группы индикации.
//                     Например, Тип("ДокументСсылка.НачислениеЗарплаты").
//
Процедура ПриОпределенииПараметровГруппыИндикации(ПараметрыГруппыИндикации, Знач ТипСсылки) Экспорт
	
	
	
КонецПроцедуры

// Позволяет настроить внешний вид и положение колонки-индикатора о проблемах в формах списков
// (с динамическим списком).
//
// Параметры:
//   ПараметрыКолонкиИндикации - Структура - выходные параметры индикатора:
//     * ВыводитьПоследней  - Булево - Если указать Истина, то колонка-индикатор будет выводиться в конце.
//                            По умолчанию Ложь - колонка выводится в начале.
//     * ПоложениеЗаголовка - ПоложениеЗаголовкаЭлементаФормы - Задает положение заголовка колонки-индикатора.
//     * Ширина             - Число - Ширина колонки-индикатора.
//
//   ПолноеИмя - Строка - Полное имя объекта основной таблицы динамического списка.
//                        Например, Метаданные.Документы.НачислениеЗарплаты.ПолноеИмя().
//
Процедура ПриОпределенииПараметровКолонкиИндикации(ПараметрыКолонкиИндикации, ПолноеИмя) Экспорт
	
	
	
КонецПроцедуры

// Позволяет дозаполнить информацию о проблеме перед ее регистрацией.
// В частности, можно заполнить дополнительные значения для ограничения доступа на уровне записей 
// к списку проблем ведения учета.
//
// Параметры:
//   Проблема - Структура - Сформированная алгоритмом проверки информация о проблеме:
//     * ПроблемныйОбъект         - ЛюбаяСсылка - объект, по поводу которого записывается проблема.
//                                                Либо ссылка на элемент справочника ИдентификаторыОбъектовМетаданных
//     * ПравилоПроверки          - СправочникСсылка.ПравилаПроверкиУчета - Ссылка на выполненную проверку.
//     * ВидПроверки              - СправочникСсылка.ВидыПроверок - Ссылка на вид проверки, к которому 
//                                  относится выполненная проверка.
//     * КлючУникальности         - УникальныйИдентификатор - Ключ уникальности проблемы.
//     * УточнениеПроблемы        - Строка - Строка-уточнение найденной проблемы.
//     * ВажностьПроблемы         - ПеречислениеСсылка.ВажностьПроблемыУчета - Важность проблемы учета
//                                  Информация, Предупреждение, Ошибка, ПолезныйСовет и ВажнаяИнформация.
//     * Ответственный            - СправочникСсылка.Пользователи - Заполнен если есть возможность
//                                  идентифицировать ответственного в проблемном объекте.
//     * ИгнорироватьПроблему     - Булево - Флаг игнорирования проблемы. Если имеет значение "Истина",
//                                  запись о проблеме игнорируется подсистемой.
//     * ДополнительнаяИнформация - ХранилищеЗначений - Служебное свойство с дополнительными
//                                  сведениями, связанными с выявленной проблемой.
//     * Выявлено                 - Дата - Серверное время идентификации проблемы.
//
//   СсылкаНаОбъект  - ЛюбаяСсылка - Ссылка на объект-источник значения для добавляемых
//                     дополнительных измерений.
//   Реквизиты       - КоллекцияОбъектовМетаданных - Коллекция, содержащая реквизиты объекта-
//                     источника проблем.
//
Процедура ПередЗаписьюПроблемы(Проблема, СсылкаНаОбъект, Реквизиты) Экспорт
	
	
	
КонецПроцедуры

#Область УстаревшиеПроцедурыИФункции

// Устарела: Следует использовать функцию ПриОпределенииПроверок.
// Предназначена для подключения собственных правил проверки ведения учета.
//
// Параметры:
//   ГруппыПроверок - ТаблицаЗначений - Таблица, в которую добавляются группы проверок:
//      * Наименование  - Строка - Наименование группы проверок, например: "Системные проверки".
//      * Идентификатор - Строка - Строковый идентификатор группы, например: "СистемныеПроверки".
//
//   Проверки - ТаблицаЗначений - Таблица, в которую добавляются проверки:
//      * Наименование                   - Строка - Наименование элемента проверки. Обязательно для заполнения.
//      * Причины                        - Строка - Возможные причины, которые привели к возникновению проблемы.
//                                                  Выводятся в отчете о проблемах. Необязательно для заполнения.
//      * Рекомендация                   - Строка - Рекомендация по решению возникшей проблемы.
//                                                  Выводятся в отчете о проблемах. Необязательно для заполнения.
//      * Идентификатор                  - Строка - Строковый идентификатор проверки. Обязателен для заполнения.
//      * ИдентификаторРодителя          - Строка - Строковый идентификатор группы проверок, например: "СистемныеПроверки".
//                                                  Обязательно для заполнения.
//      * ДатаНачалаПроверки             - Дата - Пороговая дата, обозначающая границу проверяемых
//                                         объектов (только для объектов с датой). Объекты, дата которых меньше
//                                         указанной, не следует проверять. По умолчанию не заполнено (т.е. проверять все).
//      * ЛимитПроблем                   - Число - Максимальное количество проверяемых объектов.
//                                         По умолчанию 0 - следует проверить все объекты.
//      * ОбработчикПроверки             - Строка - Имя экспортной процедуры-обработчика проверки в серверном общем модуле.
//                                         Предназначен для поиска и регистрации проблем ведения учета.
//                                         Параметры обработчика проверки:
//                                           * Проверка - СправочникСсылка.ПравилаПроверкиУчета - исполняемая проверка.
//                                           * ПараметрыПроверки - Структура - Параметры проверки, которую необходимо выполнить.
//                                                                             Подробнее см. в документации.
//      * ОбработчикПереходаКИсправлению - Строка - Имя экспортной процедуры-обработчика исправления проблемы 
//                                         в клиентском общем модуле или полное имя формы, которая будет открыта для
//                                         исправления проблемы. Параметры обработчика исправления проблемы или формы:
//                                          * ИдентификаторПроверки - Строка - идентификатор проверки, 
//                                                                    которая выявила проблему.
//                                          * ВидПроверки - СправочникСсылка.ВидыПроверок - вид проверки 
//                                                          с дополнительной информацией о проблеме.
//      * ДополнительныеПараметры        - ХранилищеЗначений - Дополнительная информация по проверке.
//
// Пример:
//   Проверка = Проверки.Добавить();
//   Проверка.ИдентификаторГруппы = "СистемныеПроверки";
//   Проверка.Наименование        = НСтр("ru='Демо: Проверка заполнения комментария в документах ""Демо: Поступление товаров""'");
//   Проверка.Причины             = НСтр("ru='Не введен комментарий в документе.'");
//   Проверка.Рекомендация        = НСтр("ru='Ввести комментарий в документе.'");
//   Проверка.Идентификатор       = "ПроверитьКомментарийВПоступленииТоваров";
//   Проверка.ОбработчикПроверки  = "_ДемоСтандартныеПодсистемы.ПроверитьКомментарийВПоступленииТоваров";
//   Проверка.ДатаНачалаПроверки  = Дата('20140101000000');
//   Проверка.ЛимитПроблем        = 3;
//
Процедура ПриОпределенииПрикладныхПроверок(ГруппыПроверок, Проверки) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
	


