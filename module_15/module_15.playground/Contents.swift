import UIKit


//MARK: 1. Создайте перечисление для ошибок. Добавьте в него 3 кейса:

enum ListOfErrors: Error {
    case error400
    case error404
    case error500
}

var error400 = false
var error404: Bool = false
var error500: Bool = false

do {
    if error400 {
        throw ListOfErrors.error400
    }
    if error404 {
        throw ListOfErrors.error404
    }
    if error500 {
        throw ListOfErrors.error500
    }
} catch  ListOfErrors.error400 {
    print("Ошибка 400")
} catch  ListOfErrors.error404 {
    print("Ошибка 404")
} catch ListOfErrors.error500 {
    print("Ошибка 500")
}

//MARK: 2. Теперь добавьте проверку переменных в генерирующую функцию и обрабатывайте её!

func errorChecking() throws {
    if error400 {
        throw ListOfErrors.error400
    }
    if error404 {
        throw ListOfErrors.error404
    }
    if error500 {
        throw ListOfErrors.error500
    }
}

//MARK: 3. Напишите функцию, которая будет принимать на вход два разных типа и проверять: если типы входных значений одинаковые, то вывести сообщение “Yes”, в противном случае — “No”.

func dataTypeChecking <T, E>(a: T, b: E) {
    if type(of: T.self) == type(of: E.self) {
        print("Yes")
    }else {
        print("No")
    }
}
dataTypeChecking(a: 22, b: 33)
dataTypeChecking(a: 22, b: "33" )

//MARK: 4. Реализуйте то же самое, но если тип входных значений различается, выбросите исключение. Если тип одинаковый — тоже выбросите исключение, но оно уже будет говорить о том, что типы одинаковые. Не бойтесь этого. Ошибки — это не всегда про плохой результат.

enum TypeComparisonError: Error {
    case sameTypes
    case differentTypes
}

func dataTypeCheckWithError <T, E>(valueOne: T, valueTwo: E) throws {
    if type(of: T.self) == type(of: E.self) {
        print("sameTypes")
        throw TypeComparisonError.sameTypes
    }else {
        throw TypeComparisonError.differentTypes
    }
}

//MARK: 5. Напишите функцию, которая принимает на вход два любых значения и сравнивает их при помощи оператора равенства ==

func comparisonOfResults<T: Equatable> (valueOne: T, valueTwo: T)-> Bool {
    return valueOne == valueTwo
}
let resualt = comparisonOfResults(valueOne: "asd", valueTwo: "asd")
print(resualt)
