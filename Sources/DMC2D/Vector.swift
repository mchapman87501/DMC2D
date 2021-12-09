import Foundation

public struct Vector: Equatable {
    public private(set) var x: Double
    public private(set) var y: Double

    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    public func magSqr() -> Double {
        return x * x + y * y
    }

    public func distSqr(_ other: Vector) -> Double {
        let dx = x - other.x
        let dy = y - other.y
        return dx * dx + dy * dy
    }

    public func magnitude() -> Double {
        return sqrt(magSqr())
    }

    public func unit() -> Vector {
        let ms = magSqr()
        if ms > 0.0 {
            let mag = sqrt(ms)
            return Vector(x: x / mag, y: y / mag)
        }
        return Vector(x: 0.0, y: 0.0)
    }

    public func dot(_ v: Vector) -> Double {
        return x * v.x + y * v.y
    }

    public func normal() -> Vector {
        return Vector(x: -y, y: x)
    }

    public func angle() -> Double {
        return atan2(self.y, self.x)
    }
}

extension Vector {
    public static func + (_ v1: Vector, _ v2: Vector) -> Vector {
        return Vector(x: v1.x + v2.x, y: v1.y + v2.y)
    }

    public static func - (_ v1: Vector, _ v2: Vector) -> Vector {
        return Vector(x: v1.x - v2.x, y: v1.y - v2.y)
    }

    public static func * (_ v: Vector, _ s: Double) -> Vector {
        return Vector(x: v.x * s, y: v.y * s)
    }

    public static func / (_ v: Vector, _ s: Double) -> Vector {
        return Vector(x: v.x / s, y: v.y / s)
    }

    public static func += (_ v1: inout Vector, _ v2: Vector) {
        v1.x += v2.x
        v1.y += v2.y
    }

    public static func -= (_ v1: inout Vector, _ v2: Vector) {
        v1.x -= v2.x
        v1.y -= v2.y
    }
}

extension Vector {
    public init() {
        x = 0.0
        y = 0.0
    }

    public init(_ p: CGPoint) {
        self.init(x: Double(p.x), y: Double(p.y))
    }
}

extension CGPoint {
    public init(_ v: Vector) {
        self.init(x: v.x, y: v.y)
    }
}
