import CoreGraphics
import SwiftMath
import simd
import CGExt
//import Kromagear
//
// read https://github.com/adamnemecek/ngrid14/blob/main/docs/camera.md
//

struct Camera2D {
    // view size in pixels
    private var outerSize: CGSize

    private var transform: Matrix4x4f
    private var scale: Float32
}

extension Camera2D {
    init(outerSize: CGSize) {
        self.outerSize = outerSize
        self.transform = .identity

        self.scale = 1.0
    }

    func proj(_ worldPoint: CGExt.Point<World>) -> CGExt.Point<Screen> {
        fatalError()
    }

//    func unproj(_ screenPoint: CGExt.Point<Screen>) -> CGExt.Point<World> {
//        fatalError()
//    }

    func unproject(screenPoint: CGPoint) -> CGPoint {
        let ndc = Vector4f(
            Float(2 * screenPoint.x / self.outerSize.width - 1),
            Float(2 * screenPoint.y / self.outerSize.height - 1),
            0.0,
            1.0
        )

        let inv = self.fullTransform.inversed

        let res = inv * ndc
        return CGPoint(x: CGFloat(res.x), y: CGFloat(res.y))
    }

    func unproject(sp: CGExt.Point<Screen>) -> CGExt.Point<World> {
        let x: Float = sp.x
        let y: Float = sp.y
        let ndc = Vector4f(
            2 * x / Float(self.outerSize.width) - 1,
            2 * y / Float(self.outerSize.height) - 1,
            0.0,
            1.0
        )

        let inv = self.fullTransform.inversed

        let res = inv * ndc
        return Point(x: res.x, y: res.y)
    }

//    internal func gridPoint(sp: CGExt.Point<Screen>) -> GridPoint2? {
//        GridPoint2(sp: sp, camera: self)
//    }

    mutating func resize() {
        fatalError()
    }

    mutating func zoom(to point: CGPoint, scale: CGFloat) {
        //        let zp = flip(outerSize: outerSize, point: point)
        let zp = point
        let zoomPoint = texturePoint(
            transform: self.transform,
            from: zp,
            in: outerSize
        )

        print("point \(point) zoomPoint \(zoomPoint)")
        let scale = 1 + Float(scale)
        self.scale *= scale

        self.transform = self.transform.scale(about: zoomPoint,
                                              scale: .init(repeating: scale))
        self.fix()
    }

    mutating func scroll(by delta: CGVector) {
        // this is in
        let t = textureTranslation(from: delta, in: self.outerSize)

        let tt = Matrix4x4f.translate(
            tx: Float(t.x) / self.scale,
            ty: Float(t.y) / self.scale,
            tz: 0.0
        )
//        print("textureT ranslation \(t) tt \(tt)")
//        let transform =

        self.transform = self.transform * tt
        self.fix()
    }

    func unproj(_ v: Vector<World>) {

    }

    ///
    /// we check if we are outside of the bounds of the grid and if so, we adjust it accordingly
    /// there are two types of adjustment
    /// - translation
    /// - zooming: under certain circumstances,
    ///
    mutating func fix() {

        // returns
        func unproj1() {

        }

//        guard let src = self.gridPoint(sp: .zero) else { return nil }
//        guard let dst = self.gridPoint(sp: Point(x: Float(self.outerSize.width),
//                                                 y: Float(self.outerSize.height))) else { return nil }
        // we work in world points since if we are outside of bounds,
        // there are no grid points
        let src = self.unproject(sp: .zero)

        let dst = self.unproject(
            sp: Point(x: Float(self.outerSize.width),
                      y: Float(self.outerSize.height))
        )

        // we have to check if we have to rescale in y dimension

//        print("src \(src)")
//        var needsTranslation = false
//        var translation: (Float, Float) = (x: 0.0, y: 0.0)

        let scale = CGFloat(self.scale)
        // we have to figure out
        // max height in world units
//        let maxHeight = GPU_LINE_HEIGHT * Float(MIDIPitch.max.rawValue + 1)
        let height = Float(4000.0)

        // if we have to
//        if src.y < 0.0 && dst.y > height {
//            let currentHeight = dst.y - src.y
//            let diff = maxHeight / currentHeight
//            let tt = Matrix4x4f.scale(
//                sx: 1.0,// / self.scale
//                sy: 1 + 1.0/diff,
//                sz: 1.0
//            )
//            self.transform = self.transform * tt
//            print("both outside \(diff)")
//        }

        //
        // fix source
        //
        if src.x < 0.0 {
            let tx = Float(src.x) / Float(self.outerSize.width * scale)
            print("tx \(tx)")
            let tt = Matrix4x4f.translate(
                tx: tx,// / self.scale
                ty: 0.0,
                tz: 0.0
            )
            //
            self.transform = self.transform * tt
        }

        if src.y < 0.0 {
            let ty = Float(src.y) / Float(self.outerSize.height)
            print("ty \(ty)")
            let tt = Matrix4x4f.translate(
                tx: 0.0,
                ty: ty,
                tz: 0.0
            )

            self.transform = self.transform * tt
        }



        //
        //
        //



//        let height = Float(50.0 * 129.0)
//        GPU_LINE_HEIGHT

        if src.y > height {
            let ty = Float(src.y - height) / Float(self.outerSize.height * scale)
//            print("ty \(ty)")
            let tt = Matrix4x4f.translate(
                tx: 0.0,
                ty: ty,
                tz: 0.0
            )

            self.transform = self.transform * tt
        }
//        print("src \(src)")
//        print("dst \(dst)")

//        if needsTranslation {
//            print("translation \(translation)")
////            let t = textureTranslation(from: delta, in: self.outerSize)
//
//            let tt = Matrix4x4f.translate(
//                tx: Float(translation.0) / Float(self.outerSize.width),// / self.scale,
//                ty: Float(translation.1) / Float(self.outerSize.height),// / self.scale,
//                tz: 0.0
//            )
////            print("textureTranslation \(t) tt \(tt)")
//            let transform = self.transform * tt
//
//            self.transform = transform
//        }
//        let src = self.gridPoint(sp: .zero)

//        let lt = rect.timeRange.lowerBound
//        if lt <= .zero {
////            self.scroll(by: GridDelta(dt: lt.abs(), dp: MIDIPitch(inner: 0)))
//            fatalError()
//        }

//        if
    }

    ///
    ///
    ///
    mutating func scroll(by: Vector<World>) {
        // let ndc = na::Vector3::new(
        //  world_point.x / self.outer_size.0,
        //  world_point.y / self.outer_size.1,
        //  0.0,
        // );
        //
        // let inv = self.transform.try_inverse().unwrap();
        //
        //// note that you need to use `transform_vector` vector instead of `transform_point`
        //// https://computergraphics.stackexchange.com/q/4290
        // let ndc = inv.transform_vector(&ndc);
        // let shift = Vec3::new(-ndc.x, 0.0, 0.0);
        //
        // self.transform = self.transform.append_translation(&shift);

    }

    // this is a grid point that can be negative
    // these have to be floating point numbers
    struct UnrestrictedGridPoint {
        // fundamentally this is midibeats but can be negative
        let timestamp: Double
        // this is fundamentally pitches but floating and negative
        // 13.3 is still
        let pitch: Float
    }



    ///
    ///
    ///
//    var visibleRect1: GridRect2? {
//        guard let src = self.gridPoint(sp: .zero) else { return nil }
//        guard let dst = self.gridPoint(sp: Point(x: Float(self.outerSize.width),
//                                                 y: Float(self.outerSize.height))) else { return nil }
//        return GridRect2(a: src, b: dst)
//    }

    var fullTransform: Matrix4x4f {
        self.transform * .ortho(size: self.outerSize)
        //        self.transform * Matrix4x4f.ortho(left: 0.0, right: Float(self.outerSize.width), bottom: 0.0, top: Float(self.outerSize.height), near: 0.1, far: 100.0)
    }

    var scaling: SIMD3<Float> {
        self.transform.scale
    }
//    mutating func zoomTo(_ screenPoint: Point<Screen>, mag: Float32) {
////        let zoom_point = flip(self.outer_size, zoom_point);
////
////        // this is in ndc
////        let zp = texture_point(&self.transform, zoom_point, self.outer_size);
////        println!("zoom_point: {:?}", zp);
////        let scale = 1.0 + mag;
////        self.scale *= scale;
////        print!("mag: {:?} scale {:?}", mag, self.scale);
////
////        let shift = Vec3::new(zp.0, zp.1, 0.0);
////        println!("shift: {:?}", shift);
////        // we are using scale instead of self.scale since self.transform already is scaled by self.scale
////        let scaling = {
////            let s = scale as f32;
////            Vec3::new(s, s, 1.0)
////        };
////        let to_point = Mat4::identity().append_translation(&shift);
////        let from_point = Mat4::identity().append_translation(&-shift);
////        let s = Mat4::identity().append_nonuniform_scaling(&scaling);
////
////        println!("shift {:?}", shift);
////
////        // self.transform = self
////        //     .transform
////        //     .append_translation(&shift)
////        //     .append_nonuniform_scaling(&scaling)
////        //     .append_translation(&-shift);
////        self.transform = self.transform * to_point * s * from_point;
//        let zoomPoint = texturePoint(transform: self.transform,
//                                     windowPoint: screenPoint,
//                                     outerSize: (0.0, 0.0))
//        let scale = 1.0 + mag
//        self.scale *= scale
//
//        let shift = SIMD3<Float>(x: zoomPoint.0, y: zoomPoint.1, z: 0.0)
//        let scaling = SIMD3<Float>(x: scale, y: scale, z: 1.0)
//
//        let toPoint = Float4x4(transation: shift)
//        let fromPoint = Float4x4(transation: -shift)
//        let s = Float4x4(transation: scaling)
//        // how is this parenthesized
//        self.transform = self.transform * toPoint * s * fromPoint
//
////        let
////        let toPoint = Float4x4(translation: )
//
//        fatalError()
//    }
//
//    func scroll(_ delta: Vector2<Uncertain>) {
//        fatalError()
//    }
}

// func textureTranslation(viewTranslation: (Float, Float),
//                        outerSize: (Float, Float)) -> (Float, Float) {
//    return (
//        viewTranslation.0 / outerSize.0,
//        viewTranslation.1 / outerSize.1
//    )
// }
//
//// converts point the ndc
// func texturePoint(
//    transform: Float4x4,
//    windowPoint: Point<Screen>,
//    outerSize: (Float, Float) // called texture size
// ) -> (Float, Float) {
//    var point = (windowPoint.x, windowPoint.y)
//
//    point = (point.0 / outerSize.0, point.1 / outerSize.1); // normalize
//    point = (point.0 * 2.0, point.1 * 2.0); // convert
//    point = (point.0 - 1.0, point.1 - 1.0); // to metal
//
//    let p = SIMD4<Float>(x: point.0, y: point.1, z: 0.0, w: 1.0)
//
//    // ;
//    //    transform.inv
//    //    let res = if let Some(inv) = transform.try_inverse() {
//    //        inv * point
//    //    } else {
//    //        panic!("no inverse for {:?}", transform);
//    //        // todo!();
//    //    }
//
//    let res = transform.inverse * p
//    // let res = transform.try_inverse().unwrap() * point;
//    return (res.x, res.y)
// }

// extension CGVector {
//    prefix static func -(v: Self) -> Self {
//        Self(dx: -v.dx, dy: -v.dy)
//    }
// }

public func texturePoint(
    transform: Matrix4x4f,
    from point: CGPoint,
    in size: CGSize
) -> SIMD2<Float> {
    let textureViewSize: SIMD2<Float> = .init(.init(size.width),
                                              .init(size.height))
    var point: SIMD2<Float> = .init(.init(point.x),
                                    .init(point.y))
    point /= textureViewSize // normalize
    point *= 2               // convert
    point -= 1               // to metal

    let result: SIMD4<Float> = float4x4(transform.inversed)
        * .init(point.x, point.y, 0, 1)
    return .init(result.x,
                 result.y)
}

///
/// what are the units
///
public func textureTranslation(
    from viewTranslation: CGVector,
    in size: CGSize
) -> SIMD2<Float> {
    let textureViewSize: SIMD2<Float> = .init(.init(size.width),
                                              .init(size.height))
    var translation: SIMD2<Float> = .init(.init(viewTranslation.dx),
                                          .init(viewTranslation.dy))
    translation /= textureViewSize // normalize

    return translation
}

extension Matrix4x4f {
    public func scale(about point: SIMD2<Float>, scale: SIMD2<Float>) -> Self {
        let toPoint = Matrix4x4f.translate(tx: point.x,
                                           ty: point.y,
                                           tz: 0)

        let fromPoint = Matrix4x4f.translate(tx: -point.x,
                                             ty: -point.y,
                                             tz: 0)

        let scale = Matrix4x4f.scale(sx: scale.x, sy: scale.y, sz: 1)
        return self * toPoint * scale * fromPoint
    }

    //    public func scale1(about point: SIMD2<Float>, scale: SIMD2<Float>) -> Self {
    //        .translate(tx: point.x,
    //                   ty: point.y,
    //                   tz: 0)
    //        * .scale(sx: scale.x, sy: scale.y, sz: 1)
    //        * .translate(tx: -point.x,
    //                     ty: -point.y,
    //                     tz: 0)
    //
    //    }

    static func ortho(size: CGSize) -> Self {
        Self(float4x4.ortho(size: size))
    }

    func transform(point p: CGPoint) -> CGPoint {
        let v = Vector4f(Float(p.x), Float(p.y), 0, 1)
        let r = self * v
        return CGPoint(x: CGFloat(r.x), y: CGFloat(r.y))
    }

}

extension float4x4 {
    static func ortho(size: CGSize) -> Self {
        let width = Float(size.width)
        let height = Float(size.height)
        let m11 = 2.0 / width
        let m22 = 2.0 / height
        return Self([ m11, 0.0, 0.0, 0.0],
                    [ 0.0, m22, 0.0, 0.0],
                    [ 0.0, 0.0, 1.0, 0.0],
                    [-1.0, -1.0, 0.0, 1.0])

    }
}
