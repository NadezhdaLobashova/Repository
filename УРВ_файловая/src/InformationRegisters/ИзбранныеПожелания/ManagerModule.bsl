
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ДобавитьПожелание(Пожелание, Пользователь) Экспорт
    
    УстановитьПривилегированныйРежим(Истина);
    
    НоваяЗапись = РегистрыСведений.ИзбранныеПожелания.СоздатьМенеджерЗаписи();
    НоваяЗапись.Пожелание = Пожелание;
    НоваяЗапись.Пользователь = Пользователь;
    НоваяЗапись.ДатаИзменения = ТекущаяУниверсальнаяДата();
    НоваяЗапись.Записать();
    
КонецПроцедуры

#КонецОбласти

#КонецЕсли
