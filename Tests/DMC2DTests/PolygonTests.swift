import XCTest

@testable import DMC2D

struct PolyTestHelper {
    let poly: DMC2D.Polygon

    func contains(_ x: Double, _ y: Double) -> Bool {
        poly.contains(point: CGPoint(x: x, y: y))
    }
}

class PolygonTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBBox() throws {
        let poly = DMC2D.Polygon([
            (0.0, 0.0), (10.0, 10.0), (0.0, 20.0), (-10.0, 10.0),
        ])
        XCTAssertEqual(poly.bbox.origin.x, -10.0)
        XCTAssertEqual(poly.bbox.origin.y, 0.0)
        XCTAssertEqual(poly.bbox.size.width, 20.0)
        XCTAssertEqual(poly.bbox.size.height, 20.0)
    }

    func testContains1() throws {
        let poly = DMC2D.Polygon([
            (0.0, 0.0), (10.0, 10.0), (0.0, 20.0), (-10.0, 10.0),
        ])
        let pth = PolyTestHelper(poly: poly)

        // Crossing counts are fragile when the point lies near one of the
        // edge vertices
        XCTAssert(pth.contains(0.0, 0.01))
        XCTAssert(pth.contains(0.0, 10.0))
        XCTAssert(!pth.contains(-14.0, 10.0))
        XCTAssert(!pth.contains(0.0, 0.0))
        XCTAssert(!pth.contains(0.0, -0.01))
        XCTAssert(pth.contains(4.999, 5.0))
        XCTAssert(pth.contains(-5.0, 5.0))
    }
}
