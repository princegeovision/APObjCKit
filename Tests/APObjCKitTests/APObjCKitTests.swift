import XCTest
@testable import APObjCKit

final class APObjCKitTests: XCTestCase {

    func testVersion() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        // match version
        XCTAssertEqual(APObjCKit.version(), "0.6.0")
    }
    func prepareInputDate()->NSDate {
        let timeStamp = 1513330403393 //2017-12-15 09:33:23 +0000 UTC, Local +8
        let unixTimeStamp: Double = Double(timeStamp) / 1000.0
        let exactDate = NSDate.init(timeIntervalSince1970: unixTimeStamp)
        return exactDate
    }
    func testOSVersion(){
        
        var osmv : Int = 0
        let gotV = APSys.getOSMVersion(&osmv)
        XCTAssertEqual(gotV, true)
//        if #available(macOS 12.0, * ) {
//
//        } else {
//            XCTAssertEqual(osmv, 0)    //Unknown
//        }
        //XCTAssertEqual(osmv, 21)    //macOS Monterey
        //XCTAssertEqual(osmv, 20)    //macOS Big Sur
        XCTAssertEqual(osmv, 19)    //macOS Catalina
    }
    
    func testGetNumberWithDateYear(){
        let exactDate = prepareInputDate()
        let inputType = APSysDateType.year
        let num = APSys.getNumberWith(exactDate as Date, type: inputType.rawValue, useUtc: false)
        XCTAssertEqual(num, 2017)
    }
    
    func testGetNumberWithDateMonth(){
        let exactDate = prepareInputDate()
        let inputType = APSysDateType.month
        let num = APSys.getNumberWith(exactDate as Date, type: inputType.rawValue, useUtc: false)
        XCTAssertEqual(num, 12)
    }
    func testGetNumberWithDateDay(){
        let exactDate = prepareInputDate()
        let inputType = APSysDateType.day
        let num = APSys.getNumberWith(exactDate as Date, type: inputType.rawValue, useUtc: false)
        XCTAssertEqual(num, 15)
    }
    func testGetNumberWithDateHour(){
        let exactDate = prepareInputDate()
        let inputType = APSysDateType.hours
        let num = APSys.getNumberWith(exactDate as Date, type: inputType.rawValue, useUtc: false)
        XCTAssertEqual(num, 17)
    }
    func testGetNumberWithDateMinutes(){
        let exactDate = prepareInputDate()
        let inputType = APSysDateType.minutes
        let num = APSys.getNumberWith(exactDate as Date, type: inputType.rawValue, useUtc: false)
        XCTAssertEqual(num, 33)
    }
    
    func testGetNumberWithDateSeconds(){
        let exactDate = prepareInputDate()
        let inputType = APSysDateType.seconds
        let num = APSys.getNumberWith(exactDate as Date, type: inputType.rawValue, useUtc: false)
        XCTAssertEqual(num, 23)
    }
    
    func testGetNumberWithDateMilliseconds(){
        let exactDate = prepareInputDate()
        let inputType = APSysDateType.milliseconds
        let num = APSys.getNumberWith(exactDate as Date, type: inputType.rawValue, useUtc: false)
        XCTAssertEqual(num, 393)
    }
    
    func testGetStringWithDate(){
        let exactDate = prepareInputDate()
        let str = APSys.getStringWith(exactDate as Date, useUtc: false)
        XCTAssertEqual(str, "2017-12-15 17-33-23.393 +0800")
    }
    func testIPv4AddressValidateSomeIP(){
        let bValidate = APSys.isIPv4AddressValidation("192.168.3.72");
        XCTAssertEqual(bValidate, true)
    }
    func testIPv4AddressValidateMask(){
        //Mask
        let bValidate = APSys.isIPv4AddressValidation("255.255.248.0");
        XCTAssertEqual(bValidate, true)
    }
    func testIPv4AddressValidateWrongString(){
        //Wrong String
        let bValidate = APSys.isIPv4AddressValidation("192.168.110.256");
        XCTAssertEqual(bValidate, false)
    }
    func testIPv4AddressValidateZero(){
        
        let bValidate = APSys.isIPv4AddressValidation("0.0.0.0");
        XCTAssertEqual(bValidate, true)
    }
    func testNIKey1_name(){
        
        let name = APSys.getNIKey(APSysNIKey.name.rawValue)
        XCTAssertEqual(name, "name")
    }
    func testNIKey2_localized_name(){
        
        let value = APSys.getNIKey(APSysNIKey.localizedName.rawValue)
        XCTAssertEqual(value, "localized_name")
    }
    func testNIKey3_mask(){
        
        let value = APSys.getNIKey(APSysNIKey.mask.rawValue)
        XCTAssertEqual(value, "mask")
    }
    
    func testNIKey4_destination(){
        
        let value = APSys.getNIKey(APSysNIKey.destination.rawValue)
        XCTAssertEqual(value, "destination")
    }
    
    func testNIKey5_address(){
        
        let value = APSys.getNIKey(APSysNIKey.address.rawValue)
        XCTAssertEqual(value, "address")
    }
    
    func testNIKey6_mac_address(){
        
        let value = APSys.getNIKey(APSysNIKey.macAddress.rawValue)
        XCTAssertEqual(value, "mac_address")
    }
    
    func testNIKey7_gateway(){
        
        let value = APSys.getNIKey(APSysNIKey.gateway.rawValue)
        XCTAssertEqual(value, "gateway")
    }
    //
    func testNIKey8_dns_servers(){
        
        let value = APSys.getNIKey(APSysNIKey.dnsServers.rawValue)
        XCTAssertEqual(value, "dns_servers")
    }
    
    static var allTests = [
        ("testVersion", testVersion),
        ("testOSVersion", testOSVersion),
        ("testGetNumberWithDateYear", testGetNumberWithDateYear),
        ("testGetNumberWithDateMonth", testGetNumberWithDateMonth),
        ("testGetNumberWithDateDay", testGetNumberWithDateDay),
        ("testGetNumberWithDateHour", testGetNumberWithDateHour),
        ("testGetNumberWithDateMinutes", testGetNumberWithDateMinutes),
        ("testGetNumberWithDateSeconds", testGetNumberWithDateSeconds),
        ("testGetNumberWithDateMilliseconds", testGetNumberWithDateMilliseconds),
        ("testIPv4AddressValidateSomeIP", testIPv4AddressValidateSomeIP),
        ("testIPv4AddressValidateMask", testIPv4AddressValidateMask),
        ("testIPv4AddressValidateWrongString", testIPv4AddressValidateWrongString),
        ("testIPv4AddressValidateZero", testIPv4AddressValidateZero),
    ]
}
