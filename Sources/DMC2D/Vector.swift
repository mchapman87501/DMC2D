import Foundation

/// Represents a 2-dimensional vector.
public struct Vector: Equatable {
    /// x component of the vector
    public private(set) var x: Double
    /// y component of the vector
    public private(set) var y: Double

    /// Create a vector with the given components.
    /// - Parameters:
    ///   - x: x component of the vector
    ///   - y: y component of the vector
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    /// Get the square of the vector's magnitude.
    ///
    /// ```swift
    /// let msqr = Vector(x: -4.0, y: 25.0).magSqr()
    /// // msqr == 641.0
    /// ```
    ///
    /// - Returns: The square of the vector's magnitude
    public func magSqr() -> Double {
        x * x + y * y
    }

    /// Get the squared "distance" (differerence) relative to another `Vector`.
    ///
    /// ```swift
    /// let v1 = Vector(x: 7.5, y: -3.5)
    /// let v2 = Vector(x: 3.3, y: 10.5)
    /// let ds = v1.distSqr(v2)
    /// // ds == 213.64
    /// ```
    ///
    /// - Parameter other: the vector relative to which the difference is desired
    /// - Returns: the squared difference with `other`
    public func distSqr(_ other: Vector) -> Double {
        let dx = x - other.x
        let dy = y - other.y
        return dx * dx + dy * dy
    }

    /// Get the vector's magnitude.
    ///
    /// ```swift
    /// let m = Vector(x: 3.0, y: 4.0).magnitude()
    /// // m == 5.0
    /// ```
    ///
    /// - Returns: The vector's magnitude
    public func magnitude() -> Double {
        sqrt(magSqr())
    }

    /// Get a vector that has unit magnitude and the same direction as `self`.
    ///
    /// ```swift
    /// let u = Vector(x: 10.0, y: 0.0).unit()
    /// // u == Vector(x: 1.0, y: 0.0)
    /// ```
    ///
    /// - Returns: the unit vector for `self`
    public func unit() -> Vector {
        let ms = magSqr()
        if ms > 0.0 {
            let mag = sqrt(ms)
            return Vector(x: x / mag, y: y / mag)
        }
        return Vector(x: 0.0, y: 0.0)
    }

    /// Get the dot product with another vector.
    ///
    /// ```swift
    /// let v1 = Vector(x: 5.0, y: 1.0)
    /// let v2 = Vector(x: 1.0, y: 0.0)
    /// let dotProd = v1.dot(v2)
    /// // dotProd == 5.0 * 1.0 + 1.0 * 0.0 == 5.0
    /// ```
    ///
    /// - Parameter v: another vector
    /// - Returns: the dot product of `self` and `v`
    public func dot(_ v: Vector) -> Double {
        x * v.x + y * v.y
    }

    /// Get the normal vector to `self`.
    ///
    /// ```swift
    /// let normal = Vector(x: 2.0, y: 3.0).normal()
    /// // normal == Vector(x: -3.0, y: 2.0)
    /// ```
    ///
    /// - Returns: a vector orthogonal to `self` with the same magnitude as `self`
    public func normal() -> Vector {
        Vector(x: -y, y: x)
    }

    /// Get the direction of `self`.
    ///
    /// ```swift
    /// let v = Vector(x: 1.0, y: 1.0)
    /// let theta = v.angle()
    /// // theta == π / 4.0, or about 0.7854
    /// ```
    ///
    /// - Returns: The direction of `self` in radians, counterclockwise from the positive x axis.
    public func angle() -> Double {
        atan2(self.y, self.x)
    }
}

extension Vector {
    /// Add two vectors.
    ///
    /// ```swift
    /// let v = Vector(x: 2.0, y: 1.0) + Vector(x: 3.0, y: 2.0)
    /// // v == Vector(x: 5.0, y: 3.0)
    /// ```
    ///
    /// - Parameters:
    ///   - v1: first vector to add
    ///   - v2: second vector to add
    /// - Returns: a vector representing the sum of `v1` and `v2`.
    public static func + (_ v1: Vector, _ v2: Vector) -> Vector {
        Vector(x: v1.x + v2.x, y: v1.y + v2.y)
    }

    /// Subtract two vectors.
    ///
    /// ```swift
    /// let v = Vector(x: 0.0, y: 1.0) - Vector(x: 1.0, y: 1.0)
    /// // v == Vector(x: -1.0, y: 0.0)
    /// ```
    ///
    /// - Parameters:
    ///   - v1: vector from which to subtract
    ///   - v2: vector to subtract from `v1`
    /// - Returns: a vector representing `v1` - `v2`
    public static func - (_ v1: Vector, _ v2: Vector) -> Vector {
        Vector(x: v1.x - v2.x, y: v1.y - v2.y)
    }

    /// Multiply a vector by a scalar.
    ///
    /// ```swift
    /// let scaled = Vector(x: 12.0, y: 13.0) * 3.5
    /// // scaled == Vector(x: 42.0, y: 45.5)
    /// ```
    ///
    /// - Parameters:
    ///   - v: vector to multiply by `s`
    ///   - s: scalar by which to multiply the components of `v`
    /// - Returns: a vector representing `v` scaled by `s`
    public static func * (_ v: Vector, _ s: Double) -> Vector {
        Vector(x: v.x * s, y: v.y * s)
    }

    /// Divide a vector by a scalar.
    ///
    /// ```swift
    /// let scaled = Vector(x: 12.0, y: 6.0) / 2.0
    /// // scaled == Vector(x: 6.0, y: 3.0)
    /// ```
    ///
    /// - Parameters:
    ///   - v: vector to divide by `s`
    ///   - s: scalar by which to divide the components of `v`
    /// - Returns: a vector representing `v` with components divided by `s`
    public static func / (_ v: Vector, _ s: Double) -> Vector {
        Vector(x: v.x / s, y: v.y / s)
    }

    /// Modify a vector by adding another vector to it.
    ///
    /// This method mutates `v1` by adding the components of `v2` to it.
    ///
    /// ```swift
    /// var v = Vector(x: 5.0, y: 6.0)
    /// let v2 = Vector(x: 1.0, y: 0.0)
    /// v += v2 // v is now Vector(x: 6.0, y: 6.0)
    /// ```
    ///
    /// - Parameters:
    ///   - v1: vector to which to add `v2`
    ///   - v2: vector to add to `v1`
    public static func += (_ v1: inout Vector, _ v2: Vector) {
        v1.x += v2.x
        v1.y += v2.y
    }

    /// Modify a vector by subtracting another vector from it.
    ///
    /// This method mutates `v1` by subtracting the components of `v2` from it.
    ///
    ///   ```swift
    ///   var v = Vector(x: 1.0, y: -4.0)
    ///   let v2 = Vector(x: 0.0, y: -4.0)
    ///   v -= v2  // v is now Vector(x: 1.0, y: 0.0)
    ///   ```
    ///
    /// - Parameters:
    ///   - v1: vector from which to subtract `v2`
    ///   - v2: vector to subtract from `v1`
    public static func -= (_ v1: inout Vector, _ v2: Vector) {
        v1.x -= v2.x
        v1.y -= v2.y
    }
}

extension Vector {
    /// Create a zero-magnitude vector.
    public init() {
        x = 0.0
        y = 0.0
    }

    /// Create a vector whose components are given by a `CGPoint`.
    /// - Parameter p: a point whose coordinates are the components of the new `Vector`
    public init(_ p: CGPoint) {
        self.init(x: Double(p.x), y: Double(p.y))
    }
}

extension CGPoint {
    /// Create a `CGPoint` from a `Vector`.
    /// - Parameter v: a vector whose components are the coordinates of the new `CGPoint`
    public init(_ v: Vector) {
        self.init(x: v.x, y: v.y)
    }
}
