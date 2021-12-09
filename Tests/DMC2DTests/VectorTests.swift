import XCTest

@testable import DMC2D

class VectorTests: XCTestCase {

    func testZeroUnit() throws {
        let zeroUnit = Vector().unit()
        XCTAssertEqual(zeroUnit.magnitude(), 0.0)
    }

    func testInitCGPoint() throws {
        let v = Vector(CGPoint(x: 10.0, y: 10.0))
        XCTAssertEqual(v.x, 10.0)
        XCTAssertEqual(v.y, 10.0)
    }

    func testAngle() throws {
        for degrees in [
            0.0, 10.0, 30.0, 45.0, 90.0, 132.3, 245.0, 281.3, 301.4,
        ] {
            let rads = degrees * .pi / 180.0
            let r = 3.1
            let vx = r * cos(rads)
            let vy = r * sin(rads)

            let vec = Vector(x: vx, y: vy)
            XCTAssertEqual(vec.magnitude(), r)

            let vAngle = vec.angle()
            let actual = (vAngle < 0.0) ? vAngle + (2.0 * .pi) : vAngle
            XCTAssertEqual(actual, rads, accuracy: 1.0e-12)
        }
    }

    func testCGPoint() throws {
        let vx = -7.0
        let vy = 1.2
        let vec = Vector(x: vx, y: vy)
        let point = CGPoint(vec)
        XCTAssertEqual(point.x, vx)
        XCTAssertEqual(point.y, vy)
    }

    func testPlus() throws {
        let v1 = Vector(x: -1.0, y: 1.0)
        let v2 = Vector(x: 1.0, y: -1.0)

        let v3 = v1 + v2
        XCTAssertEqual(v3.x, 0.0)
        XCTAssertEqual(v3.y, 0.0)

        XCTAssertEqual(v3.magnitude(), 0.0)
    }

    func testPlusEquals() throws {
        let v1 = Vector(x: -1.0, y: 1.0)
        var v2 = Vector(x: 1.0, y: -1.0)
        v2 += v1
        v2 += v1

        XCTAssertEqual(v2.x, -1.0)
        XCTAssertEqual(v2.y, 1.0)
        XCTAssertEqual(v2.magSqr(), 2.0)
        XCTAssertEqual(v2.magnitude(), sqrt(2.0))
    }

    func testScalarMultiply() throws {
        let v = Vector(x: 1.0, y: 4.0)
        let vs = v * 3.0
        XCTAssertEqual(vs.x, 3.0)
        XCTAssertEqual(vs.y, 12.0)
    }

    func testScalarDivide() throws {
        let v = Vector(x: 1.0, y: 4.0)
        let vs = v / 4.0
        XCTAssertEqual(vs.x, 0.25)
        XCTAssertEqual(vs.y, 1.0)
    }

    func testScalarDivideByZero() throws {
        let v = Vector(x: 1.0, y: 4.0)
        let vs = v / 0.0
        XCTAssertTrue(vs.x.isInfinite)
        XCTAssertTrue(vs.y.isInfinite)
    }

    func testMagnitudeBC() throws {
        let v = Vector(x: sqrt(-1.0), y: 0.0)
        XCTAssertTrue(v.magSqr().isNaN)
        XCTAssertTrue(v.magnitude().isNaN)
    }
}
