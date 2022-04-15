import XCTest
@testable import DomainModel

class ExtraCreditTests: XCTestCase {
    let christian = Person(firstName: "Christian", lastName: "Calloway", age: 21)
    let cWife = Person(firstName: "C", lastName: "L", age: 21)
    
    ////////////////////////////////////
    // Money Tests
    func testCreateBadMoney() {
        let money = Money(amount: -5, currency: "USD")
        XCTAssert(money.amount == 0)
        XCTAssert(money.currency == "USD")
    }
    
    func testCreateBadMoney2() {
        let money = Money(amount: 7)
        XCTAssert(money.amount == 7)
        XCTAssert(money.currency == "USD")
    }
    
    func testCreateBadMoney3() {
        let money = Money(currency: "GBP")
        XCTAssert(money.amount == 0)
        XCTAssert(money.currency == "GBP")
    }
    
    func testCreateBadMoney4() {
        let money = Money()
        XCTAssert(money.amount == 0)
        XCTAssert(money.currency == "USD")
    }
    
    func testMoneyComplex() {
        let usd = Money(amount: 210, currency: "USD")
        let newUsd = usd.add(Money(amount: 10, currency: "USD"))
        
        XCTAssert(newUsd.amount == 220)
        XCTAssert(newUsd.currency == "USD")
        
        let gbp = Money(amount: 5, currency: "GBP")
        let gbpSum = newUsd.add(gbp)
        
        XCTAssert(gbpSum.amount == 115)
        XCTAssert(gbpSum.currency == "GBP")
        
        let convertedGbp = gbpSum.convert("EUR")
        XCTAssert(convertedGbp.amount == 345)
        XCTAssert(convertedGbp.currency == "EUR")
        
        let convertedCan = convertedGbp.convert("CAN")
        XCTAssert(convertedCan.amount == 287)
        XCTAssert(convertedCan.currency == "CAN")
        
    }
    
    ////////////////////////////////////
    // Job Tests
    func testCreateBadJob() {
        let myNewJob = Job(title: "Scammer", type: Job.JobType.Hourly(-7))
        XCTAssert(myNewJob.title == "Scammer")
        XCTAssert(myNewJob.calculateIncome(2000) == 14000)
    }
    
    func testCreateBadJob2() {
        let myNewNewJob = Job(title: "A job with no pay")
        XCTAssert(myNewNewJob.title == "A job with no pay")
        XCTAssert(myNewNewJob.calculateIncome(2000) == 0)
    }
    
    func testCreateBadJob3() {
        let myNewNewNewJob = Job(type: Job.JobType.Hourly(50))
        XCTAssert(myNewNewNewJob.title == "None")
        XCTAssert(myNewNewNewJob.calculateIncome(2000) == 0)
    }
    
    func testNegativeRaise() {
        let myJob = Job(title: "Software Engineer", type: Job.JobType.Hourly(77))
        XCTAssert(myJob.title == "Software Engineer")
        XCTAssert(myJob.calculateIncome(2000) == 154000)
        
        myJob.raise(byAmount: -5)
        XCTAssert(myJob.calculateIncome(2000) == 144000)
        
        myJob.raise(byPercent: -0.3)
        XCTAssert(myJob.calculateIncome(2000) == 144000)
    }
    
    func testConvertToSalary() {
        let myJob = Job(title: "Software Engineer", type: Job.JobType.Hourly(77))
        myJob.convertToSalary()
        
        switch myJob.type {
        case.Salary(_) : XCTAssert(myJob.calculateIncome(2000) == 154000)
        default: XCTAssert(false)
        }
    }
    
    ////////////////////////////////////
    // Person Tests
    func testBadPerson() {
        let newPerson = Person(firstName: "Beyonce", age: 40)
        XCTAssert(newPerson.firstName == "Beyonce")
        XCTAssert(newPerson.lastName == "")
        XCTAssert(newPerson.age == 40)
        XCTAssert(newPerson.job == nil)
        XCTAssert(newPerson.spouse == nil)
    }
    
    func testBadPerson2() {
        let newPerson = Person(firstName: "Beyonce", age: 40)
        XCTAssert(newPerson.firstName == "Beyonce")
        XCTAssert(newPerson.lastName == "")
        XCTAssert(newPerson.age == 40)
        newPerson.job = Job(title: "Singer", type: Job.JobType.Salary(1000000))
        XCTAssert(newPerson.job?.calculateIncome(2000) == 1000000)
    }
    
    func testBadPerson3() {
        let newPerson2 = Person(firstName: "Jay-Z")
        XCTAssert(newPerson2.firstName == "")
        XCTAssert(newPerson2.lastName == "")
        XCTAssert(newPerson2.age == 0)
    }
    
    ////////////////////////////////////
    // Family Tests
    func testFam() {
        let newPerson = Person(firstName: "Beyonce", age: 40)
        XCTAssert(newPerson.firstName == "Beyonce")
        XCTAssert(newPerson.lastName == "")
        XCTAssert(newPerson.age == 40)
        newPerson.job = Job(title: "Singer", type: Job.JobType.Salary(1000000))
        XCTAssert(newPerson.job?.calculateIncome(2000) == 1000000)
        
        let newPerson2 = Person(firstName: "Jay-Z", age: 52)
        XCTAssert(newPerson2.firstName == "Jay-Z")
        XCTAssert(newPerson2.lastName == "")
        XCTAssert(newPerson2.age == 52)
        newPerson2.job = Job(title: "Musical Artist", type: Job.JobType.Salary(1000000))
        
        let newFam = Family(spouse1: newPerson, spouse2: newPerson2)
        XCTAssert(newFam.members[0].firstName == "Beyonce")
        XCTAssert(newFam.members[1].firstName == "Jay-Z")
    }
    
    func testFam2() {
        let newPerson = Person(firstName: "Beyonce", age: 40)
        newPerson.job = Job(title: "Singer", type: Job.JobType.Salary(1000000))
        
        let newPerson2 = Person(firstName: "Jay-Z", age: 52)
        newPerson2.job = Job(title: "Musical Artist", type: Job.JobType.Salary(1000000))
        
        let newFam = Family(spouse1: newPerson, spouse2: newPerson2)
        XCTAssert(newFam.householdIncome() == 2000000)
        
        newPerson.job = nil
        newPerson2.job = nil
        XCTAssert(newFam.householdIncome() == 0)
    }
    
    func testFam3() {
        let newPerson = Person(firstName: "Beyonce", age: 40)
        newPerson.job = Job(title: "Singer", type: Job.JobType.Salary(1000000))
        
        let newPerson2 = Person(firstName: "Jay-Z", age: 52)
        newPerson2.job = Job(title: "Musical Artist", type: Job.JobType.Salary(1000000))
        
        let newFam = Family(spouse1: newPerson, spouse2: newPerson2)
        
        newPerson.job = nil
        newPerson2.job = nil
        
        newPerson.job = Job(title: "Scamming", type: Job.JobType.Hourly(-20))
        print(newFam.householdIncome())
        XCTAssert(newFam.householdIncome() == 40000)
    }
    
    func testFam4() {
        let newNewFam = Family(spouse1: christian, spouse2: cWife)
        newNewFam.members[0].job = Job(title:"Software Engineer", type: Job.JobType.Salary(210000))
        newNewFam.members[1].job = Job(title:"Financial Advisor", type: Job.JobType.Salary(210000))
        // Hooray for equal pay!
        
        XCTAssert(newNewFam.members[0].spouse?.firstName == cWife.firstName)
        XCTAssert(newNewFam.householdIncome() == 420000)
        
        // Hooray for kids!
        newNewFam.haveChild(Person(firstName: "Baby", lastName: "C", age: 0))
        newNewFam.members[2].job = Job(title:"Impossible", type: Job.JobType.Hourly(15))
        XCTAssert(newNewFam.householdIncome() == 420000)
        
        newNewFam.members[2].age = 18
        newNewFam.members[2].job = Job(title:"Starting Job", type: Job.JobType.Hourly(15))
        XCTAssert(newNewFam.householdIncome() == 450000)
    }
    

    static var allTests = [
        // Money Tests
        ("testCreateBadMoney", testCreateBadMoney),
        ("testCreateBadMoney2", testCreateBadMoney2),
        ("testCreateBadMoney3", testCreateBadMoney3),
        ("testCreateBadMoney4", testCreateBadMoney4),
        ("testMoneyComplex", testMoneyComplex),
        // Job Tests
        ("testCreateBadJob", testCreateBadJob),
        ("testCreateBadJob2", testCreateBadJob2),
        ("testCreateBadJob2", testCreateBadJob3),
        ("testNegativeRaise", testNegativeRaise),
        ("testConvertToSalary", testConvertToSalary),
        // Person Tests
        ("testBadPerson", testBadPerson),
        ("testBadPerson2", testBadPerson2),
        ("testBadPerson3", testBadPerson3),
        // Family Tests
        ("testFam", testFam),
    ]
}
