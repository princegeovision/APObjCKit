import XCTest
@testable import APObjCKit

final class APObjCKitTests: XCTestCase {

    func testVersion() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        // match version
        XCTAssertEqual(APObjCKit.version(), "0.2.0")
    }
    func testOSVersion(){
        
        var osmv : Int = 0
        let gotV = APObjCKit.getOSMVersion(&osmv)
        //let gotV = APSysUtility().getOSMajorVersion(osmv);
        //NSInteger osMajorVer = 0;
        //BOOL versionGot = [APSysUtility getOsMajorVersion:&osMajorVer];
        XCTAssertEqual(gotV, true)
        XCTAssertEqual(osmv, 21)    //21
        
    }

    static var allTests = [
        ("testVersion", testVersion),
        ("testOSVersion", testOSVersion),
    ]
}
