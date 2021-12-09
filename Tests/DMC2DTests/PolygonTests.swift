import XCTest

@testable import DMC2D

typealias Polygon = DMC2D.Polygon

class PolygonTests: XCTestCase {
    func getPoly() -> Polygon {
        return Polygon([
            (0.0, -5.0), (10.0, -10.0), (20.0, 0.0), (10.0, 10.0), (0.0, 5.0),
        ])
    }

    func testBBox() throws {
        let poly = getPoly()
        XCTAssertEqual(poly.bbox.origin.x, 0.0)
        XCTAssertEqual(poly.bbox.origin.y, -10.0)
        XCTAssertEqual(poly.bbox.size.width, 20.0)
        XCTAssertEqual(poly.bbox.size.height, 20.0)
    }

    func testContains1() throws {
        let poly = getPoly()

        func contains(_ x: Double, _ y: Double) -> Bool {
            return poly.contains(x: x, y: y)
        }

        // Crossing counts are fragile when the point lies near one of the
        // vertices.
        XCTAssert(contains(0.0, 0.01))
        XCTAssert(contains(0.0, 4.99))
        XCTAssert(!contains(-4.0, 10.0))
        XCTAssert(contains(0.0, 0.0))
        XCTAssert(contains(0.0, -0.01))
        XCTAssert(contains(9.999, 9.8))
        XCTAssert(contains(5.0, 7.0))
    }

    func testContainsXYInt() throws {
        let poly = getPoly()
        XCTAssert(poly.contains(x: 10, y: 9))
    }

    func testContainsXYDouble() throws {
        let poly = getPoly()
        XCTAssert(poly.contains(x: 10.0, y: 9.0))
    }

    func testNearestVertex(toX x: Double, y: Double, expX: Double, expY: Double)
    {
        let poly = getPoly()
        let actual = poly.nearestVertex(to: Vector(x: x, y: y))
        XCTAssertEqual(actual.x, expX, "Expected x offset")
        XCTAssertEqual(actual.y, expY, "Expected y offset")
    }

    func testNearestVertex() throws {
        testNearestVertex(toX: 0.0, y: -5.0, expX: 0.0, expY: -5.0)
        testNearestVertex(toX: 9.0, y: -9.8, expX: 10.0, expY: -10.0)
        testNearestVertex(toX: 11.0, y: -10.8, expX: 10.0, expY: -10.0)
    }
}
