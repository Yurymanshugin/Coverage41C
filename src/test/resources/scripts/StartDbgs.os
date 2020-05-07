#Использовать v8find
#Использовать 1commands
#Использовать cli

Процедура ВыполнитьПриложение()

    Приложение = Новый КонсольноеПриложение("StartDbgs", "Запуск http отладчика dbgs.exe");
    Приложение.Версия("v version", "1.0.1.1");

	Приложение.УстановитьОсновноеДействие(ЭтотОбъект);
	
	Приложение.Опция("opid", 0 ,"PID родительского процесса")
	.ТЧисло()
	.ВОкружении("OPID");

	Приложение.Опция("port", 9999 ,"Порт для запуска dbgs")
	.ТЧисло()
	.ВОкружении("PORT");

	Приложение.Опция("host", "127.0.0.1" ,"Порт для запуска dbgs")
	.ТЧисло()
	.ВОкружении("HOST");

    Приложение.Опция("password", "" ,"Пароль для доступа к серверу отладки")
    .ТЧисло()
    .ВОкружении("PASSWORD");

	Приложение.Опция("v8version", "8.3" ,"Версия платформы 1С")
	.ТСтрока()
	.ВОкружении("V8VERSION");
	
	Приложение.Опция("notify-file", "" ,"Имя файла, в который будет записан адрес отладчика")
	.ТСтрока()
	.ВОкружении("NOTIFY_FILE");

	Приложение.Опция("port-range", "" ,"Диапазон портов для запуска отладчика")
	.ТСтрока()
	.ВОкружении("PORT_RANGE");

    Приложение.Запустить(АргументыКоманднойСтроки);

КонецПроцедуры // ВыполнениеКоманды()

Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ПутьКDBGS = Платформа1С.ПутьКDBGS(Команда.ЗначениеОпции("v8version"));
	Сообщить(ПутьКDBGS);
	OPID = Команда.ЗначениеОпции("opid");
	Пароль = Команда.ЗначениеОпции("password");
	ДиапазонПортов = Команда.ЗначениеОпции("port-range");
	ФайлУведомления = Команда.ЗначениеОпции("notify-file");

	КомандаЗапускаDbgs = Новый Команда;
	КомандаЗапускаDbgs.УстановитьКоманду(ПутьКDBGS);
	Если НЕ ПустаяСтрока(ДиапазонПортов) Тогда
		КомандаЗапускаDbgs.ДобавитьПараметр("-n");
		КомандаЗапускаDbgs.ДобавитьПараметр(ФайлУведомления);
	КонецЕсли;
	Если НЕ ПустаяСтрока(ДиапазонПортов) Тогда
		КомандаЗапускаDbgs.ДобавитьПараметр("-r");
		КомандаЗапускаDbgs.ДобавитьПараметр(ДиапазонПортов);
	Иначе
		КомандаЗапускаDbgs.ДобавитьПараметр("-p");
		КомандаЗапускаDbgs.ДобавитьПараметр(Команда.ЗначениеОпции("port"));
	КонецЕсли;
	КомандаЗапускаDbgs.ДобавитьПараметр("-a");
	КомандаЗапускаDbgs.ДобавитьПараметр(Команда.ЗначениеОпции("host"));
	Если OPID > 0 Тогда
		КомандаЗапускаDbgs.ДобавитьПараметр("-opid");
		КомандаЗапускаDbgs.ДобавитьПараметр(OPID);
	КонецЕсли;
	Если НЕ ПустаяСтрока(Пароль) Тогда
        КомандаЗапускаDbgs.ДобавитьПараметр("--password");
		КомандаЗапускаDbgs.ДобавитьПараметр(Пароль);
    КонецЕсли;
	КомандаЗапускаDbgs.ЗапуститьПроцесс();

КонецПроцедуры

Попытка

    ВыполнитьПриложение();

Исключение

    Сообщить(ОписаниеОшибки());

КонецПопытки;