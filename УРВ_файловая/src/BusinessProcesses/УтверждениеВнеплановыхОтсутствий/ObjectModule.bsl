
Процедура УтвердитьДокументПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	ЗадачаУтверждения = Задачи.ЗадачиПоУтверждениюВнеплановыхОтсутствий.СоздатьЗадачу();	
	ЗадачаУтверждения.Дата = ТекущаяДата();
	ЗадачаУтверждения.Документ = ЭтотОбъект.Документ;
	ЗадачаУтверждения.ТочкаМаршрута = БизнесПроцессы.УтверждениеВнеплановыхОтсутствий.ТочкиМаршрута.УтвердитьДокумент;
	ЗадачаУтверждения.Сотрудник = ПараметрыСеанса.ТекущийПользователь;
	ЗадачаУтверждения.Наименование = "Утверждение внеплановых отсутствий";
	ЗадачаУтверждения.БизнесПроцесс = ЭтотОбъект.Ссылка;
	ФормируемыеЗадачи.Добавить(ЗадачаУтверждения);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

