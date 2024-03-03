import UIKit

protocol UserData {
  var userName: String { get }    //Имя пользователя
  var userCardId: String { get }   //Номер карты
  var userCardPin: Int { get }       //Пин-код
  var userPhone: String { get }       //Номер телефона
  var userCash: Float { get set }   //Наличные пользователя
  var userBankDeposit: Float { get set }   //Банковский депозит
  var userPhoneBalance: Float { get set }    //Баланс телефона
  var userCardBalance: Float { get set }    //Баланс карты
}

enum UserActions {
    case balansCardUser
    case balansDepositeUser
    case withdrawCashUser(withdraw: Float)
    case topUpBalance(topUp: Float)
    case topUpPhonBalance(phone: String)
    
}

enum DescriptionTypesAvailableOperations: String {
    case topUpYourBalance = "Вы нажали кнопку пополнить баланс"
    case topUpYourDeposit = "Вы нажали кноку пополнить депозит"
    case topUpYourPhone = "Вы нажали кнопку пополнить телефон"
    case withdrawFromDeposit = "Вы нажали кнопку снять с депозита"
    case balansCard = "Вы нажали кнопку показать баланс карты"
    case balansDeposite = "Вынажали кнопку показать баланс депозита"
    case withdrawCard = "Вы нажали кнопку снять наличнеы с карты"
}

// Способ оплаты/пополнения наличными, картой или через депозит
enum PaymentMethod {
    case cash(cash: Float)
    case depozit(deposit: Float)
    case card(card: Float)
}

// Тексты ошибок
enum TextErrors: String {
    case theCardDetailsAreIncorrect = "Данные карты веденны не коректно"
    case invalidPincode = "Неправильный PIN"
    case notEnoughMoney = "Недостаточно средств на вашем счете"
    case cardIsBlocked = "Ваша карта заблокирована"
    case errorPhone = "Введет не правильно номер телефона"
    case errorCash = "Недостаточно наличных"
 
}

// Протокол по работе с банком предоставляет доступ к данным пользователя зарегистрированного в банке
protocol BankApi {
    func showUserCardBalance() //баланс карты
    func showUserDepositBalance() //баланс депозита
    func showUserToppedUpMobilePhoneCash(cash: Float) //пополнить телефоно через наличнеы
    func showUserToppedUpMobilePhoneCard(card: Float) //пополнить телефоно через депозит
    func showWithdrawalCard(cash: Float) //показать карту для снятие
    func showWithdrawalDeposit(cash: Float) //показать депозит для снятие
    func showTopUpCard(cash: Float) // показать карту для пополнения
    func showTopUpDeposit(cash: Float) //показать баланс пополняемого депозит
    func showError(error: TextErrors)
 
    func checkUserPhone(phone: String) -> Bool //проверить телефон пользователя
    func checkMaxUserCash(cash: Float) -> Bool //проверьте максимальную денежную сумму пользователя
    func checkMaxUserCard(withdraw: Float) -> Bool //проверьте карту максимального пользователя
    func checkCurrentUser(userCardId: String, userCardPin: Int) -> Bool //проверить текущего пользователя
 
    mutating func topUpPhoneBalanceCash(pay: Float) // положить на телефон через нал
    mutating func topUpPhoneBalanceCard(pay: Float) // положить на телефон через карту
    mutating func getCashFromDeposit(cash: Float) //снять с депозита
    mutating func getCashFromCard(cash: Float) //снять с карты
    mutating func putCashDeposit(topUp: Float) //положить на депозит
    mutating func putCashCard(topUp: Float) //положить на карту
}

// Банкомат, с которым мы работаем, имеет общедоступный интерфейс sendUserDataToBank
class ATM {
    private let userCardId: String
    private let userCardPin: Int
    private var someBank: BankApi
    private let action: UserActions
    private let paymentMethod: PaymentMethod?
 
    init(userCardId: String, userCardPin: Int, someBank: BankApi, action: UserActions, paymentMethod: PaymentMethod? = nil) {
        self.userCardId = userCardId
        self.userCardPin = userCardPin
        self.someBank = someBank
        self.action = action
        self.paymentMethod = paymentMethod
 
 
    sendUserDataToBank(userCardId: userCardId, userCardPin: userCardPin, actions: action, payment: paymentMethod)
  }
 
 
  public final func sendUserDataToBank(userCardId: String, userCardPin: Int, actions: UserActions, payment: PaymentMethod?) {
      if someBank.checkCurrentUser(userCardId: userCardId, userCardPin: userCardPin) {
          switch actions {
          case .balansCardUser:
              someBank.showUserCardBalance
          case .balansDepositeUser:
              someBank.showUserDepositBalance()
              
              
          case let .withdrawCashUser(withdraw):
              switch payment {
              case .some(.depozit(deposit: let deposit)):
                  someBank.getCashFromDeposit(cash: withdraw)
                  someBank.showWithdrawalDeposit(cash: withdraw)
              case .some(.card(card: let card)):
                  someBank.getCashFromCard(cash: withdraw)
                  someBank.showWithdrawalCard(cash: withdraw)
              case .some(.cash(cash: let cash)):
                  break
              case .none: break
              }
          case let .topUpBalance(amount):
              switch payment {
              case .some(.depozit(deposit: let deposit)):
                  someBank.putCashDeposit(topUp: amount)
                  someBank.showTopUpDeposit(cash: amount)
              case .some(.card(card: let card)):
                  someBank.putCashCard(topUp: amount)
                  someBank.showTopUpCard(cash: amount)
              case .some(.cash(cash: let cash)):
                  break
              case .none: break
              }
              
          case let .topUpPhonBalance(phone):
              if someBank.checkUserPhone(phone: phone) {
                  if let payment = payment {
                      switch payment {
                      case  let .cash(cash: payment):
                          if someBank.checkMaxUserCash(cash: payment) {
                              someBank.topUpPhoneBalanceCash(pay: payment)
                              someBank.showUserToppedUpMobilePhoneCash(cash: payment)
                          } else {
                              someBank.showError(error: .errorCash)
                          }
                      case let .depozit(deposit: payment):
                          if someBank.checkMaxUserCard(withdraw: payment) {
                              someBank.topUpPhoneBalanceCard(pay: payment)
                              someBank.showUserToppedUpMobilePhoneCard(card: payment)
                          } else {
                              someBank.showError(error: .notEnoughMoney)
                          }
                      case .card(card: let card):
                          break
                      }
                  }
                  
              }else {
                  someBank.showError(error: .errorPhone)
              }
          }
      } else {
          someBank.showError(error: .theCardDetailsAreIncorrect)
      }
  
  }
}


struct BankServer: BankApi {
    var user: UserData
    init(user: UserData) {
        self.user = user
    }
    
    func showUserCardBalance() {
        let report = """
Здравствуйте, \(user.userName)
\(DescriptionTypesAvailableOperations.balansCard.rawValue)
Ваша баланс карты составляет:\(user.userCardBalance)
До скорой встречи!
"""
        print(report)
    }
    
    func showUserDepositBalance() {
        let report = """
Здравствуйте, \(user.userName)
\(DescriptionTypesAvailableOperations.balansDeposite.rawValue)
Ваш баланс депозита составляет: \(user.userBankDeposit)
До скорой встречи!
"""
        print(report)
    }
    
    func showUserToppedUpMobilePhoneCash(cash: Float) {
        let report = """
\(DescriptionTypesAvailableOperations.topUpYourBalance.rawValue)
Вы пополнили счет телефона на сумму:\(cash)
Ваш баланс телефона: \(user.userPhoneBalance) рублей
"""
        print(report)
    }
    
    func showUserToppedUpMobilePhoneCard(card: Float) {
        let report = """
\(DescriptionTypesAvailableOperations.topUpYourPhone.rawValue)
Ваш баланс карты: \(user.userCardBalance)
Вы пополнили счет телефона на сумму \(card)
Ваш баланс телефона: \(user.userPhoneBalance) рублей
"""
        print(report)
    }
    
    func showWithdrawalCard(cash: Float) {
        let report = """
\(DescriptionTypesAvailableOperations.withdrawCard.rawValue)
Вы сняли с карты: \(cash) руб
Ваш баланс карты: \(user.userCardBalance)
"""
        print(report)
    }
    
    func showWithdrawalDeposit(cash: Float) {
        let report = """
\(DescriptionTypesAvailableOperations.withdrawFromDeposit.rawValue)
Вы сняли с депозита: \(cash) руб
Ваш баланс депозита: \(user.userBankDeposit)
"""
        print(report)
    }
    
    func showTopUpCard(cash: Float) {
        let report = """
\(DescriptionTypesAvailableOperations.topUpYourBalance.rawValue)
Вы пополнили карту на сумму \(cash)
Баланс карты: \(user.userCardBalance)
"""
        print(report)
    }
    
    func showTopUpDeposit(cash: Float) {
        let report = """
\(DescriptionTypesAvailableOperations.topUpYourBalance.rawValue)
Вы пополнили депозит на сумму: \(cash)
Ваш баланс депозита: \(user.userBankDeposit)
"""
        print(report)
    }
    
    func showError(error: TextErrors) {
        let report = """
Здравствуйте \(user.userName)!
Ошибка: \(error.rawValue)
Хорошего дня!
"""
         print(report)
    }
    
    func checkUserPhone(phone: String) -> Bool {
        if phone == user.userPhone {
            return true
        }
        return false
    }
    
    func checkMaxUserCash(cash: Float) -> Bool {
        if cash <= user.userCash {
            return true
        }
        return false
    }
    
    func checkMaxUserCard(withdraw: Float) -> Bool {
        if withdraw <= user.userCardBalance {
            return true
        }
        return false
    }
    
    func checkCurrentUser(userCardId: String, userCardPin: Int) -> Bool {
        if checkCurrentUser(userCardId: userCardId, userCardPin: userCardPin) {
           return true
        }
        return false
    }
    
    mutating func topUpPhoneBalanceCash(pay: Float) {
        user.userPhoneBalance += pay
        user.userCash -= pay
    }
    
    mutating func topUpPhoneBalanceCard(pay: Float) {
        user.userPhoneBalance += pay
        user.userCardBalance -= pay
    }
    
    mutating func getCashFromDeposit(cash: Float) {
        user.userBankDeposit -= cash
        user.userCash += cash
    }
    
    mutating func getCashFromCard(cash: Float) {
        user.userCardBalance -= cash
        user.userCash += cash
    }
    
    mutating func putCashDeposit(topUp: Float) {
        user.userBankDeposit += topUp
        user.userCash -= topUp
    }
    
    mutating func putCashCard(topUp: Float) {
        user.userCardBalance += topUp
        user.userCash -= topUp
    }
}

struct User: UserData {
    var userName: String
    var userCardId: String
    var userCardPin: Int
    var userPhone: String
    var userCash: Float
    var userBankDeposit: Float
    var userPhoneBalance: Float
    var userCardBalance: Float
}

let karipovMarat: UserData = User(
    userName: "Karipov Marat",
    userCardId: "123 321 123 321",
    userCardPin: 1122,
    userPhone: "89567775777",
    userCash: 2300.50,
    userBankDeposit: 5000,
    userPhoneBalance: 200,
    userCardBalance: 43000
)

let bankClient = BankServer(user: karipovMarat)

let atm22 = ATM (userCardId: "123 321 123 321", userCardPin: 1122, someBank: bankClient, action: .topUpPhonBalance(phone: "89567775777"), paymentMethod: .cash(cash: 100))
