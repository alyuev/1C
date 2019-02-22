Перем ПараметрыОбработчика Экспорт;
Перем глобальныйОбработчик Экспорт;
Перем Периодический Экспорт;
Перем ТекстМодуляРасчитанный; //Запоминаем здесь, чтобы для периодического таймера каждый раз не расчитывать

Функция Этот(Конт) Возврат Конт; КонецФункции    
Функция Сам() Возврат Этот(Контекст); КонецФункции

//_____________________________________________________________________________/
Процедура Конструктор()
	ПараметрыОбработчика=СоздатьОбъект("СписокЗначений");
	ТекстМодуляРасчитанный="";
КонецПроцедуры

Процедура Деструктор()
	Попытка
		вирт().Остановить();
		вирт().УдалитьОбработчик();
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

Функция ПодготовитьТекстВМ()
	Перем ТекстМодуля,СтрПарам;
	Если (Периодический=1)и(ТекстМодуляРасчитанный<>"") Тогда
		Возврат ТекстМодуляРасчитанный;
	КонецЕсли;
	СтрПарам="";
	Для нн=1 По ПараметрыОбработчика.РазмерСписка() Цикл
		СтрПарам=СтрПарам+"ПараметрыОбработчика.ПолучитьЗначение("+нн+")"+?(нн=ПараметрыОбработчика.РазмерСписка(),"",",");
	КонецЦикла;
	ТекстМодуля="
	|Процедура ВыполнитьПроцедуруГлМодуля()
	|	"+глобальныйОбработчик+"("+СтрПарам+");
	|КонецПроцедуры";
	ТекстМодуляРасчитанный=ТекстМодуля;
	Возврат ТекстМодуля;	
КонецФункции

Процедура локОбработчикТаймера() Экспорт
	Перем ВМ,ТекстМодуля;
	Если Периодический=0 Тогда
		вирт().Остановить();
	КонецЕсли;
	ТекстМодуля=ПодготовитьТекстВМ();
	ВМ=ВыполнитьМодуль(Контекст,ТекстМодуля);
	ВМ.ВыполнитьПроцедуруГлМодуля();
КонецПроцедуры

Процедура ЗапуститьТаймер(ИнтервалМс,Периодически,ОбработчикТаймера) Экспорт
	ПараметрыОбработчика=вирт().ПолучитьСписокПараметров("ЗапуститьТаймер");
	глобальныйОбработчик=ОбработчикТаймера;
	Периодический		=Периодически;
	вирт().ЗадатьОбработчикВОбъекте(сам(),"локОбработчикТаймера");//ТекТаймер
	вирт().Запустить(ИнтервалМс);
КонецПроцедуры
