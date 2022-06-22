import XCTest
@testable import APObjCKit

final class APObjCKitTests: XCTestCase {

    func testVersion() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        // match version
        XCTAssertEqual(APObjCKit.version(), "0.3.0")
    }
    func testOSVersion(){
        
        var osmv : Int = 0
        let gotV = APSys.getOSMVersion(&osmv)
        XCTAssertEqual(gotV, true)
        XCTAssertEqual(osmv, 21)    //21
    }

    static var allTests = [
        ("testVersion", testVersion),
        ("testOSVersion", testOSVersion),
    ]
}
