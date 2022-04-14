struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

extension Int {
    var gbp : Int { return Int(Double(self) * 0.5) }
    var usd : Int { return self }
    var can : Int { return Int(Double(self) * 1.25) }
    var eur : Int { return Int(Double(self) * 1.5) }
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount : Int
    var currency : String
    
    init(amount: Int, currency: String) {
        self.amount = amount
        if(currency == "GBP" || currency == "USD" || currency == "EUR" || currency == "CAN") {
            self.currency = currency
        } else {
            self.currency = "USD"
        }
    }
    
    private func convertUSD(_ amt : Int) -> Int {
        switch self.currency {
            case "GBP" : return Int(Double(amt) / 0.5)
            case "EUR" : return Int(Double(amt) / 1.5)
            case "CAN" : return Int(Double(amt) / 1.25)
            default : return amt
        }
    }
    
    func convert(_ conversionCurrency : String) -> Money {
        var convertedAmt : Int
        
        // Convert USD to other currencies
        if(self.currency == "USD") {
            switch conversionCurrency {
                case "GBP" : convertedAmt = (self.amount).gbp
                case "EUR" : convertedAmt = (self.amount).eur
                case "CAN" : convertedAmt = (self.amount).can
                default : convertedAmt = self.amount
            }
            return Money(amount: convertedAmt, currency: conversionCurrency)
        // Convert other currencies to USD
        } else if(conversionCurrency == "USD"){
            switch self.currency {
                case "GBP" : convertedAmt = convertUSD(self.amount)
                case "EUR" : convertedAmt = convertUSD(self.amount)
                case "CAN" : convertedAmt = convertUSD(self.amount)
                default : convertedAmt = self.amount
            }
            return Money(amount: convertedAmt, currency: "USD")
        // Converting other currencies to each other
        } else {
            switch conversionCurrency {
            case "GBP" : return Money(amount: convertUSD(self.amount).gbp, currency: "GBP")
            case "EUR" : return Money(amount: convertUSD(self.amount).eur, currency: "EUR")
            case "CAN" : return Money(amount: convertUSD(self.amount).can, currency: "EUR")
            default : return Money(amount: self.amount, currency: self.currency)
            }
        }
    }
    
    func add(_ addVal : Money) -> Money {
        let lhs = convert(addVal.currency)
        let rhs = convert(addVal.currency)
        print("lhs: ", lhs)
        print("rhs: ", rhs)
        
        let sum = lhs.amount + rhs.amount
        
        return Money(amount: sum, currency: addVal.currency)
    }
    
    func subtract(_ difVal : Money) -> Money {
        let lhs = convert(difVal.currency)
        let rhs = convert(difVal.currency)
        print("lhs: ", lhs)
        print("rhs: ", rhs)
        
        let difference = lhs.amount - rhs.amount
        
        return Money(amount: difference, currency: difVal.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    var title : String
    var type : JobType
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ time: Int) -> Int {
        switch self.type {
            case.Hourly(let dollars):
                return Int(dollars * Double(time))
                
            case.Salary(let dollars):
                return Int(dollars)
        }
    }
    
    func raise(byAmount: Double) {
        switch self.type {
            case.Hourly(let dollars):
                let newPay = dollars + byAmount
                self.type = JobType.Hourly(newPay)
            case.Salary(let dollars):
                let newPay = dollars + UInt(byAmount)
                self.type = JobType.Salary(newPay)
        }
    }
    
    func raise(byPercent: Double) {
        switch self.type {
            case.Hourly(let dollars):
                let newPay = (dollars) + (dollars * byPercent)
                self.type = JobType.Hourly(newPay)
            case.Salary(let dollars):
                let newPay = Double(dollars) + (Double(dollars) * byPercent)
                self.type = JobType.Salary(UInt(newPay))
        }
    }
    
    public func toString() -> String {
        return "Money (title: \(self.title), type: \(self.type))"
    }
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
}

////////////////////////////////////
// Person
//
public class Person {
    let firstName : String
    let lastName : String
    var age : Int
    var job : Job? {
        didSet {
            if(age < 18) {
                job = nil
            }
        }
    }
    var spouse : Person? {
        didSet {
            if(abs(spouse!.age - age) > 20) {
                spouse = oldValue
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = nil
        self.spouse = nil
    }
    
    init(firstName: String, lastName: String, age: Int, job: Job, spouse: Person) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = job
        self.spouse = spouse
    }
    
    public func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(String(describing: self.job)) spouse:\(String(describing: self.spouse))]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members : [Person]
    
    init(spouse1: Person, spouse2: Person) {
        if(spouse1.spouse == nil && spouse2.spouse == nil && abs(spouse1.age - spouse2.age) < 20) {
            self.members = []
            
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            
            self.members.append(spouse1)
            self.members.append(spouse2)
        } else {
            self.members = []
        }
    }
    
    func householdIncome() -> Int {
        var sum = 0
        for index in 0..<self.members.count {
            print("index \(index) has person \(self.members[index].firstName)")
            sum += self.members[index].job?.calculateIncome(2000) ?? 0
        }
        return sum
    }
    
    func haveChild(_ child: Person) {
        self.members.append(child)
    }
}
