import CoreGraphics
import Foundation

/// Represents a polygon defined by a sequence of vertices.
///
/// This code has been tested only with convex polygons whose vertices are specified in clockwise order.
public struct Polygon {
    /// Represents a polygon edge.
    public struct Segment {
        /// The first endpoint of the segment
        public let p0: CGPoint

        /// The second endpoint of the segment
        public let pf: CGPoint

        func crossesUpward(_ y: CGFloat) -> Bool {
            (
                // Upward, non-horizontal edge.
                (p0.y < pf.y)
                // Upward crossing includes segment start,
                // excludes segment end.
                && (p0.y <= y) && (y < pf.y))
        }

        func crossesDownward(_ y: CGFloat) -> Bool {
            (
                // Downward, non-horizontal edge.
                (p0.y > pf.y)
                // Downward crossing excludes segment start, includes
                // segment end.
                && (pf.y <= y) && (y < p0.y))
        }

        func xIntersect(_ rayOrigin: CGPoint) -> CGFloat {
            // Caller must ensure this is not a horizontal line.
            let dx = pf.x - p0.x
            let dy = pf.y - p0.y
            if abs(dx) < 1.0e-6 {
                let ry = rayOrigin.y
                let (ymin, ymax) = (p0.y < pf.y) ? (p0.y, pf.y) : (pf.y, p0.y)
                // If y is not between p0.y and pf.y?
                // Pretend the intersection is to the left of the ray origin.
                if (ry < ymin) || (ry > ymax) {
                    return rayOrigin.x - 1.0
                }
                // Otherwise the intersection is at the x coord of the
                // vertical line.
                return p0.x
            }
            let dyFract = (rayOrigin.y - p0.y) / dy
            let result = p0.x + dyFract * dx
            return result
        }

        /// Get a representation of the segment as a vector.
        /// - Returns: a vector representing the offset from the segment's starting point `p0` to its end point `pf`
        public func asVector() -> Vector {
            Vector(x: Double(pf.x - p0.x), y: Double(pf.y - p0.y))
        }
    }

    /// The polygon's vertices
    public let vertices: [CGPoint]

    /// The polygon's vertices, represented as vectors rather than as CGPoints.
    public let vertexVectors: [Vector]

    /// The polygon's edges.
    ///
    /// Each edge is a `Segment`.  `edges[0]` extends from `vertices[0]` to `vertices[1]`, and so on.
    public let edges: [Segment]

    /// The normal vectors for each of the polygon's edges.
    ///
    /// `edgeNormals[i]` is the normal vector
    /// for `edges[i]`.  It has a positive y component if `edges[i].pf.x`
    /// &ge; `edges[i].p0.x`, and a non-positive y component otherwise.
    public let edgeNormals: [Vector]

    /// The bounding box of the polygon
    public let bbox: CGRect

    /// The center point of the polygon, computed as the average of the polygon's vertices
    public let center: CGPoint  // Geometric center, sort of.

    /*
     Edge Crossing Rules

     1. an upward edge includes its starting endpoint, and excludes its final endpoint;

     2. a downward edge excludes its starting endpoint, and includes its final endpoint;

     3. horizontal edges are excluded

     4. the edge-ray intersection point must be strictly right of the point P.

     cn_PnPoly( Point P, Point V[], int n )
     {
         int    cn = 0;    // the  crossing number counter

         // loop through all edges of the polygon
         for (each edge E[i]:V[i]V[i+1] of the polygon) {
             if (E[i] crosses upward ala Rule #1
              || E[i] crosses downward ala  Rule #2) {
                 if (P.x <  x_intersect of E[i] with y=P.y)   // Rule #4
                      ++cn;   // a valid crossing to the right of P.x
             }
         }
         return (cn&1);    // 0 if even (out), and 1 if  odd (in)

     }
     */
    /// Find out whether a point lies on or within the boundaries of this polygon.
    ///
    /// This method is based on the "Point in Polygon" algorithm that was once described at
    /// [GeomAlgorithms](http://www.geomalgorithms.com/algorithms.html).  That website is now available as a book.
    /// - Parameter point: a point to be checked
    /// - Returns: `true` if `point` lies on or within the boundary of `self`, `false` otherwise
    public func contains(point: CGPoint) -> Bool {
        if bbox.contains(point) {
            let x0 = point.x
            let y0 = point.y
            var numCrossings = 0
            for edge in edges {
                if edge.crossesUpward(y0) || edge.crossesDownward(y0) {
                    let xIntersect = edge.xIntersect(point)
                    if x0 < xIntersect {
                        numCrossings += 1
                    }
                }
            }
            return 0 != (numCrossings % 2)
        }
        return false
    }

    /// Find out whether a point defined by `Double` coordinates lies on/within the boundaries of this
    /// polygon.
    ///
    /// See ``contains(point:)`` for more info.
    ///
    /// - Parameters:
    ///   - x: x coordinate of the point
    ///   - y: y coordinate of the point
    /// - Returns: whether or not the point `(x, y)` lies on or within the boundaries of this polygon
    public func contains(x: Double, y: Double) -> Bool {
        contains(point: CGPoint(x: x, y: y))
    }

    /// Find out whether a point defined by `Int` coordinates lies on/within the boundaries of this
    /// polygon.
    ///
    /// See ``contains(point:)`` for more info.
    ///
    /// - Parameters:
    ///   - x: x coordinate of the point
    ///   - y: y coordinate of the point
    /// - Returns: whether or not the point `(x, y)` lies on or within the boundaries of this polygon
    public func contains(x: Int, y: Int) -> Bool {
        contains(x: Double(x), y: Double(y))
    }

    private static func getEdges(_ vertices: [CGPoint]) -> [Segment] {
        let numVertices = vertices.count
        // Assume the polygon is not closed - that its first and last
        // vertices are not the same.
        return (0..<numVertices).map {
            Segment(p0: vertices[$0], pf: vertices[($0 + 1) % numVertices])
        }
    }

    private static func getEdgeNormals(_ edges: [Segment]) -> [Vector] {
        edges.map { edge in
            edge.asVector().normal().unit()
        }
    }
}

extension Polygon {
    /// Construct a polygon from an array of `CGPoint`s.
    ///
    /// _**Caveat:**_  the underlying code has been tested only with convex polygons, and only with
    /// vertices that have been ordered clockwise, starting from the vertex with the minimum x coordinate.
    ///
    /// - Parameter verticesIn: vertices of the polygon
    public init(_ verticesIn: [CGPoint]) {
        var bb = CGRect.zero
        var first = true
        for v in verticesIn {
            if first {
                bb = CGRect(x: v.x, y: v.y, width: 0.0, height: 0.0)
                first = false
            } else {
                bb = bb.union(CGRect(x: v.x, y: v.y, width: 0.0, height: 0.0))
            }
        }

        let xMean =
            verticesIn.map { $0.x }.reduce(0.0, +) / Double(verticesIn.count)
        let yMean =
            verticesIn.map { $0.y }.reduce(0.0, +) / Double(verticesIn.count)

        vertices = verticesIn
        vertexVectors = vertices.map { v in
            Vector(x: Double(v.x), y: Double(v.y))
        }
        edges = Self.getEdges(verticesIn)
        edgeNormals = Self.getEdgeNormals(edges)
        bbox = bb
        center = CGPoint(x: xMean, y: yMean)
    }

    /// Construct a polygon from an array of `(x, y)` points.
    ///
    /// See  the CGPoint overload of `init(_:)` for caveats.
    ///
    /// - Parameter verticesIn: vertices of the polygon
    public init(_ verticesIn: [(Double, Double)]) {
        self.init(verticesIn.map { CGPoint(x: $0, y: $1) })
    }
}

extension Polygon {
    /// Find the offset from a given point to the polygon vertex nearest to that point.
    /// - Parameter point: the point for which to find the nearest vertex
    /// - Returns: a ``Vector`` representing the displacement from `point` to the nearest vertex of this polygon
    public func nearestVertex(to point: Vector) -> Vector {
        var result = Vector()
        var minDist = 0.0
        for (i, v) in vertexVectors.enumerated() {
            let distSqr = (v - point).magSqr()
            if (i == 0) || (distSqr < minDist) {
                result = v
                minDist = distSqr
            }
        }
        return result
    }
}
