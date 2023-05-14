import XCTest
@testable import CodableRouting

enum Route: Codable, Hashable {
    case home
    case profile(id: Int)
    case user(UUID)
    case nested(NestedRoute?)
    case page(Page?)
}

struct Page: Codable, Hashable {
    var ndx: Double = 0
}

enum NestedRoute: Codable, Hashable {
    case foo
}

final class CodableRoutingTests: XCTestCase {
    func testExample() throws {
        XCTAssertEqual(try encode(Route.home), "/home")
        XCTAssertEqual(try encode(Route.page(.init(ndx: 1))), "/page/1.00")
        XCTAssertEqual(try encode(Route.profile(id: 5)), "/profile/5")
        XCTAssertEqual(try encode(Route.nested(.foo)), "/nested/foo")
        XCTAssertEqual(try encode(Route.nested(nil)), "/nested")

        XCTAssertEqual(try decode("/home"), Route.home)
        XCTAssertEqual(try decode("/page/1"), Route.page(.init(ndx: 1)))
        XCTAssertEqual(try decode("/profile/5"), Route.profile(id: 5))
        XCTAssertEqual(try decode("/nested/foo"), Route.nested(.foo))
        XCTAssertEqual(try decode("/nested"), Route.nested(nil))
    }
}
