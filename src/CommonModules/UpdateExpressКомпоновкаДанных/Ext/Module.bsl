﻿// This file is part of Update.Express.
// Copyright © 2016 Petro Bazeliuk.
// 
// Update.Express is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as 
// published by the Free Software Foundation, either version 3 
// of the License, or any later version.
// 
// Update.Express is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public 
// License along with Update.Express. If not, see <http://www.gnu.org/licenses/>.
  
#Область ПрограммныйИнтерфейс

#Область ОперацииСхемыКомпоновкиДанных

Процедура УстановитьСхемуКомпоновкиДанных(АдресПриемник, АдресСхемаИсточник,
	ПроверятьНаИзменение = Ложь, БылиИзменения = Ложь) Экспорт
	
	Если ЭтоАдресВременногоХранилища(АдресСхемаИсточник) Тогда
		СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемаИсточник);
	Иначе
		СхемаКомпоновкиДанных = АдресСхемаИсточник;
	КонецЕсли;
	
	Если ПроверятьНаИзменение Тогда
		
		БылиИзменения = Ложь;
		Если ЭтоАдресВременногоХранилища(АдресПриемник) Тогда
			
			ТекущаяСКД = ПолучитьИзВременногоХранилища(АдресПриемник);
			Если ТипЗнч(ТекущаяСКД) = Тип("СхемаКомпоновкиДанных") Тогда
				Если UpdateExpressСлужебный.ПолучитьXML(СхемаКомпоновкиДанных) <> 
					 UpdateExpressСлужебный.ПолучитьXML(ТекущаяСКД) Тогда	
					БылиИзменения = Истина;
				КонецЕсли
			Иначе
				БылиИзменения = Истина;
			КонецЕсли;
			
		Иначе
			БылиИзменения = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(АдресПриемник) Тогда
		ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, АдресПриемник);
	Иначе
		АдресПриемник = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры // УстановитьСхемуКомпоновкиДанных()

Процедура СкопироватьСхемуКомпоновкиДанных(АдресПриемник, АдресИсточник) Экспорт
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресИсточник);	
	Если ТипЗнч(СхемаКомпоновкиДанных) = Тип("СхемаКомпоновкиДанных") Тогда
		СхемаКомпоновкиДанных = СериализаторXDTO.ПрочитатьXDTO(СериализаторXDTO.ЗаписатьXDTO(СхемаКомпоновкиДанных));
	Иначе
		СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(АдресПриемник) Тогда
		ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, АдресПриемник);
	Иначе
		АдресПриемник = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры // СкопироватьСхемуКомпоновкиДанных()

Процедура ИнициализироватьКомпоновщикНастроек(КомпоновщикНастроек, 
	АдресСхемыКомпоновкиДанных, 
	АдресНастроекКомпоновкиДанных = Неопределено) Экспорт
	
	Если ЭтоАдресВременногоХранилища(АдресСхемыКомпоновкиДанных) Тогда
		СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	Иначе
		СхемаКомпоновкиДанных = АдресСхемыКомпоновкиДанных;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресНастроекКомпоновкиДанных) Тогда
		Если ЭтоАдресВременногоХранилища(АдресНастроекКомпоновкиДанных) Тогда
			НастройкиКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресНастроекКомпоновкиДанных);
		Иначе
			НастройкиКомпоновкиДанных = АдресНастроекКомпоновкиДанных;	
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		КомпоновщикНастроек.Инициализировать(
			Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
	Исключение
		UpdateExpressСлужебный.ЗаписатьВЖурналРегистрации(ОписаниеОшибки(), 
			УровеньЖурналаРегистрации.Ошибка);
	КонецПопытки;
	
	Если ЗначениеЗаполнено(АдресНастроекКомпоновкиДанных) Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпоновкиДанных);
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;
	
	КомпоновщикНастроек.Восстановить(
		СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
КонецПроцедуры // ИнициализироватьКомпоновщикНастроек

Процедура ОбработатьНастройкиКомпоновщикаНастроек(КомпоновщикНастроек,
	ПараметрыЗапроса) Экспорт
		
	Перем Настройки, ПользовательскиеНастройки, ФиксированныеНастройки;
	
	Если ПараметрыЗапроса.Data.Свойство("Settings", Настройки) Тогда
		
		ПараметрыДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных;
		ДоступныеПараметры = ПараметрыДанных.ДоступныеПараметры;
		
		ПараметрыИнициализированы = Ложь;
		Если ДоступныеПараметры <> Неопределено Тогда
			ПараметрыИнициализированы = 
				ТипЗнч(ДоступныеПараметры) = Тип("ДоступныеПараметрыКомпоновкиДанных");
		КонецЕсли;
				
		НастройкиИнициализированы = Ложь;
		Если ТипЗнч(Настройки) = Тип("Структура") Тогда
			НастройкиИнициализированы = Настройки.Количество() > 0; 
		КонецЕсли;
		
		Если ПараметрыИнициализированы И НастройкиИнициализированы Тогда
			ЗаполнитьКоллекциюЗначенийПараметровКомпоновкиДанных(
				ПараметрыДанных, Настройки);	
		КонецЕсли;
			
	КонецЕсли;
		
КонецПроцедуры // ОбработатьНастройкиКомпоновщикаНастроек()



Функция СоздатьМакетКомпоновкиДанных(СхемаКомпоновкиДанных, 
	НастройкиКомпоновкиДанных, 
	ДополнительныеПараметры = Неопределено) Экспорт
	
	ТипМакета = Неопределено;
	Если UpdateExpressСлужебный.ЭтоДополнительныеПараметры(
			ДополнительныеПараметры) Тогда
		ДополнительныеПараметры.Свойство("ТипМакета", ТипМакета);	
	КонецЕсли;
	
	// Подготовить макет компоновки данных 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Возврат КомпоновщикМакета.Выполнить(
		СхемаКомпоновкиДанных, 
		НастройкиКомпоновкиДанных, 
		, 
		, 
		ТипМакета);
	
КонецФункции // СоздатьМакетКомпоновкиДанных() 
	
Функция СформироватьРезультатДеревоЗначений(СхемаКомпоновкиДанных,
	НастройкиКомпоновкиДанных, 
	ДополнительныеПараметры = Неопределено) Экспорт
	
	Если UpdateExpressСлужебный.ЭтоДополнительныеПараметры(
		ДополнительныеПараметры) Тогда
		
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("ТипМакета", 
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));	
		
	МакетКомпоновкиДанных = СоздатьМакетКомпоновкиДанных(СхемаКомпоновкиДанных, 
		НастройкиКомпоновкиДанных, Параметры); 
	
	// Инициализировать процессор 
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, , , Истина);

	// Вывести результат
	ДеревоЗначений = Новый ДеревоЗначений;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;	
	ПроцессорВывода.УстановитьОбъект(ДеревоЗначений);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
		
	Возврат ДеревоЗначений;
	
КонецФункции // СформироватьРезультатДеревоЗначений()

Функция СформироватьРезультатТабличныйДокумент(СхемаКомпоновкиДанных,
	НастройкиКомпоновкиДанных, 
	ДополнительныеПараметры = Неопределено) Экспорт
	
	Если UpdateExpressСлужебный.ЭтоДополнительныеПараметры(
		ДополнительныеПараметры) Тогда
		
	КонецЕсли;
	
	МакетКомпоновкиДанных = СоздатьМакетКомпоновкиДанных(СхемаКомпоновкиДанных, 
		НастройкиКомпоновкиДанных);	
	
	// Инициализировать процессор 
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, , , Истина);

	// Вывести результат
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабличныйДокумент);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	Возврат ТабличныйДокумент;
	
КонецФункции // СформироватьРезультатТабличныйДокумент()

//Функция СформироватьРезультатСтрокаJSON(СтруктураОбмена, КоллекцияЗначений, 
//	НастройкиКомпоновкиДанных, ПараметрыЗаписиJSON = Неопределено) Экспорт
//	
//	ПоГруппировкам = НеобходимоОбработатьПоГруппировкам(
//		НастройкиКомпоновкиДанных.Структура);
//		
//	Если ПоГруппировкам Тогда
//		ЗаполнитьСтруктуруОбменаПоГруппировкам(СтруктураОбмена, КоллекцияЗначений);		
//	Иначе
//		ЗаполнитьСтруктуруОбменаДетальныеЗаписи(СтруктураОбмена, КоллекцияЗначений);		
//	КонецЕсли;
//			
//	ЗаписьJSON = Новый ЗаписьJSON;
//	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
//	ЗаписатьJSON(ЗаписьJSON, 
//		СтруктураОбмена, 
//		, 
//		"ФункцияПреобразования", 
//		UpdateExpressПроцессорВыводаПовтИсп);
//	Возврат ЗаписьJSON.Закрыть();
//	
//КонецФункции // СформироватьРезультатСтрокаJSON() 

#КонецОбласти // ОперацииСхемыКомпоновкиДанных

#Область ОбработчикиСобытийСправочника

Процедура ПриСозданииНаСервере(Форма) Экспорт
	
	Объект = Форма.Объект;
	Ссылка = Объект.Ссылка;	
	Если ТипЗнч(Ссылка) <> Тип("СправочникСсылка.UpdateExpressНастройкиОбменов") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ОбработатьПриСозданииНаСервере(Объект.Команды, Ссылка.Команды);
		//ResolveOnCreateAtServer(Form.Object.Events, ObjectRef.Events);		
	КонецЕсли;
	
	//Если ЗначениеЗаполнено(ОбъектСсылка) Тогда
	//	
	//	СКД = Объект.Ссылка.СхемаКомпоновкиДанных.Получить();
	//	Настройки = Объект.Ссылка.ХранилищеНастроекКомпоновкиДанных.Получить();
	//	
	//	Если СКД <> Неопределено Тогда
	//		Форма.АдресСКД = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор);
	//	КонецЕсли;
	//	Если Настройки <> Неопределено Тогда
	//		Форма.АдресНастроекСКД = ПоместитьВоВременноеХранилище(Настройки, Новый УникальныйИдентификатор);
	//	КонецЕсли;
	//	
	//Иначе
	//	
	//	Объект.ИмяШаблонаСКД = "ОсновнаяСхема";
	//	
	//КонецЕсли;
	//
	////ПолучитьРасписаниеРегламентногоЗадания(Форма);
	//
	//Если НЕ ПустаяСтрока(Объект.ИмяШаблонаСКД) Тогда
	//	
	//	МетаданныеШаблона = Метаданные.НайтиПоТипу(ТипЗнч(ОбъектСсылка)).Макеты.Найти(Объект.ИмяШаблонаСКД);
	//	Если МетаданныеШаблона = Неопределено Тогда
	//		
	//		Форма.ПредставлениеШаблонаСКД = НСтр("ru = 'Произвольная'");
	//		
	//	Иначе
	//		
	//		Форма.ПредставлениеШаблонаСКД = МетаданныеШаблона.Синоним;
	//		
	//	КонецЕсли;
	//	
	//Иначе
	//	
	//	Форма.ПредставлениеШаблонаСКД = НСтр("ru = 'Произвольная'");
	//	
	//КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

Процедура ПередЗаписьюНаСервере(Форма, ТекущийОбъект) Экспорт
	
	Объект = Форма.Объект;	
	ОбработатьПередЗаписьюНаСервере(Объект.Команды, ТекущийОбъект.Команды);
	//ResolveBeforeWriteAtServer(Form.Object.Events, CurrentObject.Events);
		
	//If Форма.Объект.СпособФормирования = Перечисления.СпособыФормированияСегментов.ПериодическиОбновлять Then
	//	ТекущийОбъект.ДополнительныеСвойства.Вставить("Расписание", Форма.Расписание);
	//	ТекущийОбъект.ДополнительныеСвойства.Вставить("Использование", Форма.РегламентноеЗаданиеИспользуется);
	//EndIf;

КонецПроцедуры // ПередЗаписьюНаСервере()

#КонецОбласти // ОбработчикиСобытийСправочника

#КонецОбласти // ПрограммныйИнтерфейс

#Область СервисныеПроцедурыИФункции

#Область ОперацииСхемыКомпоновкиДанных

// Только для внутреннего использования
Процедура ЗаполнитьКоллекциюЗначенийПараметровКомпоновкиДанных(
	ПараметрыДанных, 
	Настройки)
	
	ДоступныеПараметры = ПараметрыДанных.ДоступныеПараметры;
	Для Каждого Настройка Из Настройки Цикл
		
		Параметр = Новый ПараметрКомпоновкиДанных(Настройка.Ключ);
		РезультатПоиска = ДоступныеПараметры.НайтиПараметр(Параметр);
		Если РезультатПоиска = Неопределено Тогда
			Продолжить;	
		КонецЕсли;
		
		МассивТипов = РезультатПоиска.Тип.Типы();
		Если МассивТипов.Количество() = 1 Тогда
			Если РезультатПоиска.Тип.СодержитТип(Тип("СтандартныйПериод")) Тогда
				СтандартныйПериод = ПолучитьЗначениеСтандартногоПериода(
					Настройка.Значение);	
				УстановитьЗначениеДоступногоПараметраКомпоновкиДанных(
					ПараметрыДанных, Настройка.Ключ, СтандартныйПериод);
			Иначе
				ВызватьИсключение НСтр(
					"en = 'Processing not period types not implemented.'; 
					|ru = 'Обработка непериодических типов не реализована.'; 
					|uk = 'Обробка неперіодичних типів не реалізована.'");		
			КонецЕсли;
		Иначе
			ВызватьИсключение НСтр(
				"en = 'Processing agregate types not implemented.'; 
				|ru = 'Обработка агрегатных типов не реализована.'; 
				|uk = 'Обробка агрегатних типів не реалізована.'");				
		КонецЕсли;
		
	КонецЦикла;		
	
КонецПроцедуры // ЗаполнитьКоллекциюЗначенийПараметровКомпоновкиДанных()

// Только для внутреннего использования
Процедура УстановитьЗначениеДоступногоПараметраКомпоновкиДанных(
	ПараметрыДанных, Ключ, Значение)
	
	Элементы = ПараметрыДанных.Элементы;	
	РезультатПоиска = Элементы.Найти(Ключ);
	Если РезультатПоиска <> Неопределено Тогда
		РезультатПоиска.Значение = Значение;	
	Иначе
		НовыйЭлемент = Элементы.Добавить();
		ВызватьИсключение НСтр(
			"en = 'Adding new elements into DataCompositionParameterValueCollection not implemented.'; 
			|ru = 'Добавление новых элементов в КоллекцияЗначенийПараметровКомпоновкиДанных не реализовано.'; 
			|uk = 'Додавання нових елементів в КоллекцияЗначенийПараметровКомпоновкиДанных не реалізовано.'");
	КонецЕсли;
	
КонецПроцедуры // УстановитьЗначениеДоступногоПараметраКомпоновкиДанных()


// Только для внутреннего использования
Функция ПолучитьЗначениеСтандартногоПериода(Значение)
	
	Перем ДатаНачала, ДатаОкончания, Вариант;
	
	Если ТипЗнч(Значение) <> Тип("Структура") Тогда
		ВызватьИсключение НСтр(
			"en = 'Unable to parse [StandardPeriod].'; 
			|ru = 'Не удалось распознать [СтандартныйПериод].'; 
			|uk = 'Не вдалось розпізнати [СтандартныйПериод].'");	
	КонецЕсли;
		
	ЕстьВариант = Значение.Свойство("Variant", Вариант)
		ИЛИ Значение.Свойство("Вариант", Вариант);
		
	ЕстьДатаНачала = Значение.Свойство("StartDate", ДатаНачала)
		ИЛИ Значение.Свойство("ДатаНачала", ДатаНачала);
				   
	ЕстьДатаОкончания = Значение.Свойство("EndDate", ДатаОкончания)
		ИЛИ Значение.Свойство("ДатаОкончания", ДатаОкончания);
		
	Если ЕстьДатаНачала И ЕстьДатаОкончания Тогда
		
		СтандартныйПериод = Новый СтандартныйПериод;		
		СтандартныйПериод.ДатаНачала = ПрочитатьДату(ДатаНачала);
		СтандартныйПериод.ДатаОкончания = ПрочитатьДату(ДатаОкончания);		
		Если СтандартныйПериод.ДатаНачала <= СтандартныйПериод.ДатаОкончания Тогда
			Возврат СтандартныйПериод;	
		Иначе	
			ВызватьИсключение НСтр(
				"en = '[StartDate] is greater than [EndDate].'; 
				|ru = '[ДатаНачала] не может быть больше [ДатаОкончания].'; 
				|uk = '[ДатаНачала] не може бути більшою [ДатаОкончания].'");		
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЕстьВариант Тогда
		Возврат Новый СтандартныйПериод(
			ВариантСтандартногоПериода[Вариант]);	
	КонецЕсли;
	
	ВызватьИсключение НСтр(
		"en = 'Unable to parse [StandardPeriod] ([StartDate] & [EndDate] or [Variant] not found).'; 
		|ru = 'Не удалось распознать [СтандартныйПериод] ([ДатаНачала] и [ДатаОкончания] или [Вариант] не найдены).'; 
		|uk = 'Не вдалось розпізнати [СтандартныйПериод] ([ДатаНачала] и [ДатаОкончания] или [Вариант] не найдены).'");
	   	
КонецФункции // ПолучитьЗначениеСтандартногоПериода()

// Только для внутреннего использования 
Функция ПрочитатьДату(Строка)
	
	Перем ПреобразованнаяДата;
	
	Если ПрочитатьДатуПоФормату(Строка, ФорматДатыJSON.ISO, ПреобразованнаяДата) Тогда
		Возврат ПреобразованнаяДата;	
	КонецЕсли;
	
	Если ПрочитатьДатуПоФормату(Строка, ФорматДатыJSON.JavaScript, ПреобразованнаяДата) Тогда
		Возврат ПреобразованнаяДата;	
	КонецЕсли;
	
	Если ПрочитатьДатуПоФормату(Строка, ФорматДатыJSON.Microsoft, ПреобразованнаяДата) Тогда
		Возврат ПреобразованнаяДата;	
	КонецЕсли;
	
	Возврат Дата(Строка);
	
КонецФункции // ПрочитатьДату()

// Только для внутреннего использования
Функция ПрочитатьДатуПоФормату(Знач Строка, Формат, ПреобразованнаяДата)
	
	Попытка
		 ПреобразованнаяДата = ПрочитатьДатуJSON(Строка, Формат);
	Исключение
		Возврат Ложь;	 
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции // ПрочитатьДатуПоФормату()

Функция НеобходимоОбработатьПоГруппировкам(СтруктураВывода)
	
	Результат = Ложь;
	Для Каждого Структура Из СтруктураВывода Цикл
		
		Если Структура.Использование Тогда
			
			ПоляГруппировки = Структура.ПоляГруппировки.Элементы;
			Если ПоляГруппировки.Количество() > 0 Тогда
				Возврат Истина;	
			КонецЕсли;
			
			Если Структура.Структура.Количество() > 0 Тогда
				Результат = НеобходимоОбработатьПоГруппировкам(Структура.Структура);	
			КонецЕсли;
			
			Если Результат Тогда
				Возврат Результат;	
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
		
КонецФункции // НеобходимоОбработатьПоГруппировкам()

#КонецОбласти // ОперацииСхемыКомпоновкиДанных

#Область ОперацииОбработкиКоллекцийЗначений

// Только для внутреннего использования
//Процедура ЗаполнитьСтруктуруОбменаПоГруппировкам(СтруктураОбмена, 
//	КоллекцияЗначений, Ключ = "Data", КлючиСтруктуры = Неопределено)
//	
//	Если КлючиСтруктуры = Неопределено Тогда
//		КлючиСтруктуры = КоллекцияЗначений.Колонки;
//		Если КлючиСтруктуры.Количество() = 0 Тогда
//			Возврат;
//		КонецЕсли;		
//	КонецЕсли;
//	
//	ТипНеопределено = Тип("Неопределено");
//	Для каждого Строка Из КоллекцияЗначений.Строки Цикл
//		
//		Структура = Новый Структура;
//		Для каждого Колонка Из КлючиСтруктуры Цикл
//			Значение = Строка[Колонка.Имя];
//			Если ТипЗнч(Значение) <> ТипНеопределено Тогда
//				Структура.Вставить(Колонка.Имя, Значение); 			
//			КонецЕсли;
//		КонецЦикла;
//		
//		Если Строка.Строки.Количество() > 0 Тогда
//			Структура.Вставить("Rows", Новый Массив);	
//			ЗаполнитьСтруктуруОбменаПоГруппировкам(
//				Структура, Строка, "Rows", КлючиСтруктуры);
//		КонецЕсли;
//		
//		СтруктураОбмена[Ключ].Добавить(Структура);
//		
//	КонецЦикла;
//	
//КонецПроцедуры // ЗаполнитьСтруктуруОбменаПоГруппировкам()

// Только для внутреннего использования
//Процедура ЗаполнитьСтруктуруОбменаДетальныеЗаписи(СтруктураОбмена, 
//	КоллекцияЗначений, Ключ = "Data", КлючиСтруктуры = Неопределено)
//	
//	Если КлючиСтруктуры = Неопределено Тогда
//		
//		Колонки = КоллекцияЗначений.Колонки;
//		Если Колонки.Количество() = 0 Тогда
//			Возврат;
//		КонецЕсли;
//		
//		КлючиСтруктуры = "";
//		Для Каждого Колонка Из Колонки Цикл
//			Если ПустаяСтрока(КлючиСтруктуры) Тогда
//				КлючиСтруктуры = Колонка.Имя;	
//			Иначе
//				КлючиСтруктуры = КлючиСтруктуры + "," + Колонка.Имя;	
//			КонецЕсли;		
//		КонецЦикла;
//		
//	КонецЕсли;
//		
//	Для Каждого Строка Из КоллекцияЗначений.Строки Цикл
//		
//		Структура = Новый Структура(КлючиСтруктуры);	
//		ЗаполнитьЗначенияСвойств(Структура, Строка);
//		
//		Если Строка.Строки.Количество() > 0 Тогда
//			Структура.Вставить("Rows", Новый Массив);	
//			ЗаполнитьСтруктуруОбменаДетальныеЗаписи(
//				Структура, Строка, "Rows", КлючиСтруктуры);
//		КонецЕсли;
//			
//		СтруктураОбмена[Ключ].Добавить(Структура); 
//		
//	КонецЦикла;
//	
//КонецПроцедуры // ЗаполнитьСтруктуруОбменаДетальныеЗаписи()

#КонецОбласти // ОперацииОбработкиКоллекцийЗначений

#Область ОбработчикиСобытийСправочника

// Только для внутреннего использования
Процедура ОбработатьПриСозданииНаСервере(ОбъектФормы, Ссылка)
	
	Для каждого Элемент Из ОбъектФормы Цикл
		
		РезультатПоиска = Ссылка.Найти(Элемент.Наименование, "Наименование");
		Если РезультатПоиска = Неопределено Тогда
			
		КонецЕсли;
		
		СхемаКомпоновкиДанных = РезультатПоиска.СхемаКомпоновкиДанных.Получить();
		НастройкиКомпоновкиДанных = РезультатПоиска.НастройкиКомпоновкиДанных.Получить();
		
		Если СхемаКомпоновкиДанных <> Неопределено Тогда
			Элемент.АдресСхемыКомпоновкиДанных = 
				ПоместитьВоВременноеХранилище(
					СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
		КонецЕсли;
		
		Если НастройкиКомпоновкиДанных <> Неопределено Тогда
			Элемент.АдресНастроекКомпоновкиДанных = 
				ПоместитьВоВременноеХранилище(
					НастройкиКомпоновкиДанных, Новый УникальныйИдентификатор);	
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры // ОбработатьПриСозданииНаСервере()
	
// Только для внутреннего использования
Процедура ОбработатьПередЗаписьюНаСервере(ОбъектФормы, Объект)
	
	Для каждого Элемент Из ОбъектФормы Цикл
	
		РезультатПоиска = Объект.Найти(Элемент.Наименование, "Наименование");
		Если РезультатПоиска = Неопределено Тогда
			
		КонецЕсли;
		
		Если ЭтоАдресВременногоХранилища(Элемент.АдресСхемыКомпоновкиДанных) Тогда
			РезультатПоиска.СхемаКомпоновкиДанных = Новый ХранилищеЗначения(
				ПолучитьИзВременногоХранилища(
					Элемент.АдресСхемыКомпоновкиДанных));					
		Иначе
			РезультатПоиска.СхемаКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);	
		КонецЕсли;
		
		Если ЭтоАдресВременногоХранилища(Элемент.АдресНастроекКомпоновкиДанных) Тогда
			РезультатПоиска.НастройкиКомпоновкиДанных = Новый ХранилищеЗначения(
				ПолучитьИзВременногоХранилища(
					Элемент.АдресНастроекКомпоновкиДанных));
		Иначе
			РезультатПоиска.НастройкиКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);	
		КонецЕсли;	
	
	КонецЦикла;  
	
КонецПроцедуры // ОбработатьПередЗаписьюНаСервере()

#КонецОбласти // ОбработчикиСобытийСправочника

#КонецОбласти // СервисныеПроцедурыИФункции