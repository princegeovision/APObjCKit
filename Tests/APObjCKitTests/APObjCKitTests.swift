import XCTest
@testable import APObjCKit

final class APObjCKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(APObjCKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
