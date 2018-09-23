//
//  uiimage+fill.swift
//  FoodFill(scan line fill)
//
//  Created by bj1024 on 2018/09/08.
//  Copyright © 2018年 digitalnauts inc. All rights reserved.
//

import Foundation
import UIKit

struct ARGB8 {
    var a: UInt8
    var r: UInt8
    var g: UInt8
    var b: UInt8

    static func fromUIColor(color: UIColor) -> ARGB8 {
        var R: CGFloat = 0
        var G: CGFloat = 0
        var B: CGFloat = 0
        var A: CGFloat = 1.0
        color.getRed(&R, green: &G, blue: &B, alpha: &A)
        return ARGB8(a: max(min(255, UInt8(A * 255)), 0), r: max(min(255, UInt8(R * 255)), 0), g: max(min(255, UInt8(G * 255)), 0), b: max(min(255, UInt8(B * 255)), 0))
    }
}

extension UIImage {
    func fill(pt: CGPoint, color: UIColor, colorCompare: ((ARGB8, ARGB8) -> Bool)?) -> UIImage? {

        guard let cgImage = self.cgImage else { return nil }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorCompare = colorCompare ?? diffColorBasic
        let fillARGB = ARGB8.fromUIColor(color: color)
        let width: Int = Int(size.width)
        let height: Int = Int(size.height)

        if !(pt.x > 0 && pt.x < size.width && pt.y > 0 && pt.y < size.height ) { return nil }
        let bitsPerComponent: Int = 8
        let bytesPerRow: Int = Int(size.width) * 4
        guard let ctx = CGContext(data: nil,
                                  width: width,
                                  height: height,
                                  bitsPerComponent: bitsPerComponent,
                                  bytesPerRow: bytesPerRow,
                                  space: colorSpace,
                                  bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        else {
            return nil
        }
        ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let ptrUint8 = ctx.data?.assumingMemoryBound(to: UInt8.self) else { return nil   }

        let ptX: Int = Int(pt.x)
        let ptY: Int = Int(pt.y)

        let pos: Int = ptX * 4 + ptY * bytesPerRow
        let ptARGB = ARGB8(a: ptrUint8[pos], r: ptrUint8[pos + 1], g: ptrUint8[pos + 2], b: ptrUint8[pos + 3])
        let diff = colorCompare(ptARGB, fillARGB)
        if (!diff ) {
            return self
        }

        var cnt: Int = 0
        var procPts: [CGPoint] = []
        procPts.append(CGPoint(x: ptX, y: ptY))

        while (procPts.count > 0) {
            let ptProc = procPts[0]
            procPts.remove(at: 0)
            var ptProcX: Int = Int(ptProc.x)
            let ptProcY: Int = Int(ptProc.y)

            // find left edge
            while ( ptProcX >= 0 ) {
                let pos: Int = ptProcX * 4 + ptProcY * bytesPerRow
                let ptProcARGB = ARGB8(a: ptrUint8[pos], r: ptrUint8[pos + 1], g: ptrUint8[pos + 2], b: ptrUint8[pos + 3])

                let diff = colorCompare(ptARGB, ptProcARGB)
                if ( diff ) {
                    break
                }
                ptProcX -= 1
            }
            ptProcX += 1

            // fill right and check upper,lower line start pos.
            var isUpperStarted: Bool = false
            var isLowwerStarted: Bool = false
            while ( ptProcX < width ) {
                let pos: Int = ptProcX * 4 + ptProcY * bytesPerRow
                let ptProcARGB = ARGB8(a: ptrUint8[pos], r: ptrUint8[pos + 1], g: ptrUint8[pos + 2], b: ptrUint8[pos + 3])

                let diff = colorCompare(ptARGB, ptProcARGB)
                if ( diff ) {
                    break
                }

                // check upper line.
                if ( ptProcY > 0 ) {
                    let pos: Int = ptProcX * 4 + (ptProcY - 1) * bytesPerRow
                    let ptProcARGB = ARGB8(a: ptrUint8[pos], r: ptrUint8[pos + 1], g: ptrUint8[pos + 2], b: ptrUint8[pos + 3])

                    let diff = colorCompare(ptARGB, ptProcARGB)
                    if ( diff ) {
                        if (isUpperStarted) {
                            isUpperStarted = false
                        }
                    }
                    else {  // same
                        if (!isUpperStarted) {
                            procPts.append(CGPoint(x: ptProcX, y: ptProcY - 1)) // upper
                            isUpperStarted = true
                        }
                    }
                }

                // check lowwer line
                if ( ptProcY < height - 1 ) {
                    let pos: Int = ptProcX * 4 + (ptProcY + 1) * bytesPerRow
                    let ptProcARGB = ARGB8(a: ptrUint8[pos], r: ptrUint8[pos + 1], g: ptrUint8[pos + 2], b: ptrUint8[pos + 3])

                    let diff = colorCompare(ptARGB, ptProcARGB)
                    if ( diff ) {
                        if (isLowwerStarted) {
                            isLowwerStarted = false
                        }
                    }
                    else { // same
                        if (!isLowwerStarted) {
                            procPts.append(CGPoint(x: ptProcX, y: ptProcY + 1)) // lowwer
                            isLowwerStarted = true
                        }
                    }
                }

                ptProcX += 1

                // change color
                ptrUint8[pos] = fillARGB.a
                ptrUint8[pos + 1] = fillARGB.r
                ptrUint8[pos + 2] = fillARGB.g
                ptrUint8[pos + 3] = fillARGB.b

                cnt += 1
            }
        }

        guard let newcgImg = ctx.makeImage() else { return nil }
        return UIImage(cgImage: newcgImg)
    }

    private func diffColorBasic(base: ARGB8, target: ARGB8) -> Bool {
        let diffR = abs(Int(base.r) - Int(target.r))
        let diffG = abs(Int(base.g) - Int(target.g))
        let diffB = abs(Int(base.b) - Int(target.b))
        let diffA = abs(Int(base.a) - Int(target.a))

        return diffR + diffG + diffB + diffA > 30
    }
}
