import XCTest
@testable import APObjCKit

final class APObjCKitTests: XCTestCase {

    func testVersion() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        // match version
        XCTAssertEqual(APObjCKit.version(), "0.4.0")
    }
    func testOSVersion(){
        
        var osmv : Int = 0
        let gotV = APSys.getOSMVersion(&osmv)
        XCTAssertEqual(gotV, true)
        if #available(macOS 12.0, * ) {
            XCTAssertEqual(osmv, 21)    //macOS Monterey
        } else if #available(macOS 11.0, * ) {
            XCTAssertEqual(osmv, 20)    //macOS Big Sur
        } else if #available(macOS 10.15, * ) {
            XCTAssertEqual(osmv, 19)    //macOS Catalina
        } else {
            XCTAssertEqual(osmv, 0)    //Unknown
        }
        
    }
    
    func testGetNumberWithDateYear(){
        let timeStamp = 1513330403393 //2017-12-15 09:33:23 +0000 UTC, Local +8
        let unixTimeStamp: Double = Double(timeStamp) / 1000.0
        let exactDate = NSDate.init(timeIntervalSince1970: unixTimeStamp)
        let inputType = APSysDateType.year
        let num = APSys.getNumberWith(exactDate as Date, type: inputType.rawValue, useUtc: false)
        XCTAssertEqual(num, 2017)
    }
    
    func testGetNumberWithDateMonth(){
        let timeStamp = 1513330403393
        let unixTimeStamp: Double = Double(timeStamp) / 1000.0
        let exactDate = NSDate.init(timeIntervalSince1970: unixTimeStamp)
        let inputType = APSysDateType.month
        let num = APSys.getNumberWith(exactDate as Date, type: inputType.rawValue, useUtc: false)
        XCTAssertEqual(num, 12)
    }
    func testGetNumberWithDateDay(){
        let timeStamp = 1513330403393
        let unixTimeStamp: Double = Double(timeStamp) / 1000.0
        let exactDate = NSDate.init(timeIntervalSince1970: unixTimeStamp)
        let inputType = APSysDateType.day
        let num = APSys.getNumberWith(exactDate as Date, type: inputType.rawValue, useUtc: false)
        XCTAssertEqual(num, 15)
    }
    func testGetNumberWithDateHour(){
        let timeStamp = 1513330403393
        let unixTimeStamp: Double = Double(timeStamp) / 1000.0
        let exactDate = NSDate.init(timeIntervalSince1970: unixTimeStamp)
        let inputType = APSysDateType.hours
        let num = APSys.getNumberWith(exactDate as Date, type: inputType.rawValue, useUtc: false)
        XCTAssertEqual(num, 17)
    }

    static var allTests = [
        ("testVersion", testVersion),
        ("testOSVersion", testOSVersion),
        ("testGetNumberWithDateYear", testGetNumberWithDateYear),
        ("testGetNumberWithDateMonth", testGetNumberWithDateMonth),
        ("testGetNumberWithDateDay", testGetNumberWithDateDay),
        ("testGetNumberWithDateHour", testGetNumberWithDateHour),
    ]
}
