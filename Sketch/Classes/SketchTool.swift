//
//  SketchTool.swift
//  Sketch
//
//  Created by daihase on 04/06/2018.
//  Copyright (c) 2018 daihase. All rights reserved.
//

import UIKit

protocol SketchTool {
    var lineWidth: CGFloat { get set }
    var lineColor: UIColor { get set }
    var lineAlpha: CGFloat { get set }
    
    func setInitialPoint(_ firstPoint: CGPoint)
    func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint)
    func draw()
}

public enum PenType {
    case normal
    case blur
    case neon
}

class PenTool: UIBezierPath, SketchTool {
    var path: CGMutablePath
    var lineColor: UIColor
    var lineAlpha: CGFloat
    var drawingPenType: PenType
    
    override init() {
        path = CGMutablePath.init()
        lineColor = .black
        lineAlpha = 0
        drawingPenType = .normal
        super.init()
        lineCapStyle = CGLineCap.round
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInitialPoint(_ firstPoint: CGPoint) {}
    
    func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint) {}
    
    func createBezierRenderingBox(_ previousPoint2: CGPoint, withPreviousPoint previousPoint1: CGPoint, withCurrentPoint cgPoint: CGPoint) -> CGRect {
        let mid1 = middlePoint(previousPoint1, previousPoint2: previousPoint2)
        let mid2 = middlePoint(cgPoint, previousPoint2: previousPoint1)
        let subpath = CGMutablePath.init()
        
        subpath.move(to: CGPoint(x: mid1.x, y: mid1.y))
        subpath.addQuadCurve(to: CGPoint(x: mid2.x, y: mid2.y), control: CGPoint(x: previousPoint1.x, y: previousPoint1.y))
        path.addPath(subpath)
        
        var boundingBox: CGRect = subpath.boundingBox
        boundingBox.origin.x -= lineWidth * 2.0
        boundingBox.origin.y -= lineWidth * 2.0
        boundingBox.size.width += lineWidth * 4.0
        boundingBox.size.height += lineWidth * 4.0
        
        return boundingBox
    }
    
    private func middlePoint(_ previousPoint1: CGPoint, previousPoint2: CGPoint) -> CGPoint {
        return CGPoint(x: (previousPoint1.x + previousPoint2.x) * 0.5, y: (previousPoint1.y + previousPoint2.y) * 0.5)
    }
    
    func draw() {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.setShouldAntialias(false)
        switch drawingPenType {
        case .normal:
            ctx.addPath(path)
            ctx.setLineCap(.round)
            ctx.setLineWidth(lineWidth)
            ctx.setStrokeColor(lineColor.cgColor)
            ctx.setBlendMode(.normal)
            ctx.setAlpha(lineAlpha)
            ctx.strokePath()
        case .blur:
            ctx.addPath(path)
            ctx.setLineCap(.round)
            ctx.setLineWidth(lineWidth)
            ctx.setStrokeColor(lineColor.cgColor)
            ctx.setShadow(offset: CGSize(width: 0, height: 0), blur: lineWidth / 1.25, color: lineColor.cgColor)
            ctx.setAlpha(lineAlpha)
            ctx.strokePath()
        case .neon:
            let shadowColor = lineColor
            let transparentShadowColor = shadowColor.withAlphaComponent(lineAlpha)
            
            ctx.addPath(path)
            ctx.setLineCap(.round)
            ctx.setLineWidth(lineWidth)
            ctx.setStrokeColor(UIColor.white.cgColor)
            ctx.setShadow(offset: CGSize(width: 0, height: 0), blur: lineWidth / 1.25, color: transparentShadowColor.cgColor)
            ctx.setBlendMode(.screen)
            ctx.strokePath()
        }
    }
}

class EraserTool: PenTool {
    override func draw() {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.setShouldAntialias(false)
        ctx.saveGState()
        ctx.addPath(path)
        ctx.setLineCap(.round)
        ctx.setLineWidth(lineWidth)
        ctx.setBlendMode(.clear)
        ctx.strokePath()
        ctx.restoreGState()
    }
}

class LineTool: SketchTool {
    var lineWidth: CGFloat
    var lineColor: UIColor
    var lineAlpha: CGFloat
    var firstPoint: CGPoint
    var lastPoint: CGPoint
    
    init() {
        lineWidth = 1.0
        lineAlpha = 1.0
        lineColor = .blue
        firstPoint = CGPoint(x: 0, y: 0)
        lastPoint = CGPoint(x: 0, y: 0)
    }
    
    internal func setInitialPoint(_ firstPoint: CGPoint) {
        self.firstPoint = firstPoint
    }
    
    internal func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint) {
        self.lastPoint = endPoint
    }
    
    internal func draw() {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        ctx.setStrokeColor(lineColor.cgColor)
        ctx.setLineCap(.square)
        ctx.setLineWidth(lineWidth)
        ctx.setAlpha(lineAlpha)
        ctx.move(to: CGPoint(x: firstPoint.x, y: firstPoint.y))
        ctx.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        ctx.strokePath()
    }
    
    func angleWithFirstPoint(first: CGPoint, second: CGPoint) -> Float {
        let dx: CGFloat = second.x - first.x
        let dy: CGFloat = second.y - first.y
        let angle = atan2f(Float(dy), Float(dx))
        
        return angle
    }
    
    func pointWithAngle(angle: CGFloat, distance: CGFloat) -> CGPoint {
        let x = Float(distance) * cosf(Float(angle))
        let y = Float(distance) * sinf(Float(angle))
        
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}

class ArrowTool: SketchTool {
    var lineWidth: CGFloat
    var lineColor: UIColor
    var lineAlpha: CGFloat
    var firstPoint: CGPoint
    var lastPoint: CGPoint
    
    init() {
        lineWidth = 1.0
        lineAlpha = 1.0
        lineColor = .black
        firstPoint = CGPoint(x: 0, y: 0)
        lastPoint = CGPoint(x: 0, y: 0)
    }
    
    func setInitialPoint(_ firstPoint: CGPoint) {
        self.firstPoint = firstPoint
    }
    
    func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint) {
        lastPoint = endPoint
    }
    
    func draw() {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        let capHeight = lineWidth * 4.0
        let angle = angleWithFirstPoint(first: firstPoint, second: lastPoint)
        var point1 = pointWithAngle(angle: CGFloat(angle + Float(6.0 * .pi / 8.0)), distance: capHeight)
        var point2 = pointWithAngle(angle: CGFloat(angle - Float(6.0 * .pi / 8.0)), distance: capHeight)
        let endPointOffset = pointWithAngle(angle: CGFloat(angle), distance: lineWidth)
        
        ctx.setStrokeColor(lineColor.cgColor)
        ctx.setLineCap(.square)
        ctx.setLineWidth(lineWidth)
        ctx.setAlpha(lineAlpha)
        ctx.move(to: CGPoint(x: firstPoint.x, y: firstPoint.y))
        ctx.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        
        point1 = CGPoint(x: lastPoint.x + point1.x, y: lastPoint.y + point1.y)
        point2 = CGPoint(x: lastPoint.x + point2.x, y: lastPoint.y + point2.y)
        
        ctx.move(to: CGPoint(x: point1.x, y: point1.y))
        ctx.addLine(to: CGPoint(x: lastPoint.x + endPointOffset.x, y: lastPoint.y + endPointOffset.y))
        ctx.addLine(to: CGPoint(x: point2.x, y: point2.y))
        ctx.strokePath()
    }
    
    func angleWithFirstPoint(first: CGPoint, second: CGPoint) -> Float {
        let dx: CGFloat = second.x - first.x
        let dy: CGFloat = second.y - first.y
        let angle = atan2f(Float(dy), Float(dx))
        
        return angle
    }
    
    func pointWithAngle(angle: CGFloat, distance: CGFloat) -> CGPoint {
        let x = Float(distance) * cosf(Float(angle))
        let y = Float(distance) * sinf(Float(angle))
        
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}

class RectTool: SketchTool {
    var lineWidth: CGFloat
    var lineAlpha: CGFloat
    var lineColor: UIColor
    var firstPoint: CGPoint
    var lastPoint: CGPoint
    var isFill: Bool
    
    init() {
        lineWidth = 1.0
        lineAlpha = 1.0
        lineColor = .blue
        firstPoint = CGPoint(x: 0, y: 0)
        lastPoint = CGPoint(x: 0, y: 0)
        isFill = false
    }
    
    internal func setInitialPoint(_ firstPoint: CGPoint) {
        self.firstPoint = firstPoint
    }
    
    internal func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint) {
        self.lastPoint = endPoint
    }
    
    internal func draw() {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        let rectToFill = CGRect(x: firstPoint.x, y: firstPoint.y, width: lastPoint.x - self.firstPoint.x, height: lastPoint.y - firstPoint.y)
        
        ctx.setAlpha(lineAlpha)
        if self.isFill {
            ctx.setFillColor(lineColor.cgColor)
            ctx.fill(rectToFill)
        } else {
            ctx.setStrokeColor(lineColor.cgColor)
            ctx.setLineWidth(lineWidth)
            ctx.stroke(rectToFill)
        }
    }
}

class EllipseTool: SketchTool {
    var eraserWidth: CGFloat
    var lineWidth: CGFloat
    var lineAlpha: CGFloat
    var lineColor: UIColor
    var firstPoint: CGPoint
    var lastPoint: CGPoint
    var isFill: Bool
    
    init() {
        eraserWidth = 0
        lineWidth = 1.0
        lineAlpha = 1.0
        lineColor = .blue
        firstPoint = CGPoint(x: 0, y: 0)
        lastPoint = CGPoint(x: 0, y: 0)
        isFill = false
    }
    
    internal func setInitialPoint(_ firstPoint: CGPoint) {
        self.firstPoint = firstPoint
    }
    
    internal func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint) {
        lastPoint = endPoint
    }
    
    internal func draw() {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        ctx.setAlpha(lineAlpha)
        ctx.setLineWidth(lineWidth)
        let rectToFill = CGRect(x: firstPoint.x, y: firstPoint.y, width: lastPoint.x - self.firstPoint.x, height: lastPoint.y - firstPoint.y)
        if self.isFill {
            ctx.setFillColor(lineColor.cgColor)
            ctx.fillEllipse(in: rectToFill)
        } else {
            ctx.setStrokeColor(lineColor.cgColor)
            ctx.strokeEllipse(in: rectToFill)
        }
    }
}

class StarTool: SketchTool {
    var lineWidth: CGFloat
    var lineColor: UIColor
    var lineAlpha: CGFloat
    var firstPoint: CGPoint
    var lastPoint: CGPoint
    
    init() {
        lineWidth = 0
        lineColor = .blue
        lineAlpha = 0
        firstPoint = CGPoint(x: 0, y: 0)
        lastPoint = CGPoint(x: 0, y: 0)
    }
    
    internal func setInitialPoint(_ firstPoint: CGPoint) {
        self.firstPoint = firstPoint
    }
    
    internal func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint) {
        lastPoint = endPoint
    }
    
    internal func draw() {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        let rect = CGRect(x: min(firstPoint.x, lastPoint.x),
                          y: min(firstPoint.y, lastPoint.y),
                          width: abs(firstPoint.x - lastPoint.x),
                          height: abs(firstPoint.y - lastPoint.y))
        
        let pathRef = CGMutablePath()
        pathRef.move(to: CGPoint(x: 98.582, y: 495))
        pathRef.addLine(to: CGPoint(x: 127.5, y: 317.716))
        pathRef.addLine(to: CGPoint(x: 5, y: 192.163))
        pathRef.addLine(to: CGPoint(x: 174.291, y: 166.298))
        pathRef.addLine(to: CGPoint(x: 250, y: 5))
        pathRef.addLine(to: CGPoint(x: 325.709, y: 166.298))
        pathRef.addLine(to: CGPoint(x: 495, y: 192.163))
        pathRef.addLine(to: CGPoint(x: 372.5, y: 317.716))
        pathRef.addLine(to: CGPoint(x: 401.418, y: 495))
        pathRef.addLine(to: CGPoint(x: 250, y: 411.298))
        pathRef.closeSubpath()
        
        var s = CGAffineTransform(scaleX: rect.width / 500.0, y: rect.height / 500.0)
        var a = CGAffineTransform(translationX: rect.minX, y: rect.minY)
        guard let pathRefTrans  = pathRef.copy(using: &s)?.copy(using: &a) else { return }
        
        ctx.setLineWidth(lineWidth)
        ctx.setAlpha(lineAlpha)
        ctx.setStrokeColor(lineColor.cgColor)
        ctx.addPath(pathRefTrans)
        ctx.strokePath()
    }
}

class StampTool: SketchTool {
    var lineWidth: CGFloat
    var lineColor: UIColor
    var lineAlpha: CGFloat
    var touchPoint: CGPoint
    var stampImage: UIImage?
    
    init() {
        lineWidth = 0
        lineColor = .blue
        lineAlpha = 0
        touchPoint = CGPoint(x: 0, y: 0)
    }
    
    func setInitialPoint(_ firstPoint: CGPoint) {
        touchPoint = firstPoint
    }
    
    func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint) {}
    
    func setStampImage(image: UIImage?) {
        if let image = image {
            stampImage = image
        }
    }
    
    func getStampImage() -> UIImage? {
        return stampImage
    }
    
    func draw() {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.setShadow(offset: CGSize(width :0, height: 0), blur: 0, color: nil)
        
        if let image = self.getStampImage() {
            let imageX = touchPoint.x  - (image.size.width / 2.0)
            let imageY = touchPoint.y - (image.size.height / 2.0)
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            
            image.draw(in: CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight))
        }
    }
}

class EditableStampTool: SketchTool {
    var lineWidth: CGFloat
    var lineColor: UIColor
    var lineAlpha: CGFloat
    var touchPoint: CGPoint
    var stampImage: UIImage?
    var isEditing: Bool
    var transform: CGAffineTransform
    var stampRect: CGRect
    var originalSize: CGSize
    
    
    var currentScale: CGFloat = 1.0
    var currentRotation: CGFloat = 0.0
    
    
    var isResizing: Bool = false
    var resizeStartPoint: CGPoint = .zero
    var resizeStartScale: CGFloat = 1.0
    
    var isRotating: Bool = false
    var rotateStartPoint: CGPoint = .zero
    var rotateStartAngle: CGFloat = 0.0
    
    init() {
        lineWidth = 0
        lineColor = .blue
        lineAlpha = 1.0
        touchPoint = CGPoint(x: 0, y: 0)
        isEditing = false
        transform = .identity
        stampRect = .zero
        originalSize = .zero
        currentScale = 1.0
    }
    
    func setInitialPoint(_ firstPoint: CGPoint) {
        touchPoint = firstPoint
        calculateStampRect()
    }
    
    func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint) {}
    
    func setStampImage(image: UIImage?) {
        if let image = image {
            stampImage = image
            originalSize = image.size
            calculateStampRect()
        }
    }
    
    func getStampImage() -> UIImage? {
        return stampImage
    }
    
    private func calculateStampRect() {
        guard let image = stampImage else { return }
        
        let scaledSize = CGSize(
            width: originalSize.width * currentScale,
            height: originalSize.height * currentScale
        )
        
        stampRect = CGRect(
            x: touchPoint.x - scaledSize.width / 2,
            y: touchPoint.y - scaledSize.height / 2,
            width: scaledSize.width,
            height: scaledSize.height
        )
    }
    
    func contains(point: CGPoint) -> Bool {
        let expandedRect = stampRect.insetBy(dx: -10, dy: -10)
        return expandedRect.contains(point)
    }
    
    func updateTransform(_ newTransform: CGAffineTransform) {
        transform = newTransform
        calculateStampRect()
    }
    
    func updatePosition(_ newPosition: CGPoint) {
        touchPoint = newPosition
        calculateStampRect()
    }
    
    
    func getResizeHandleRect() -> CGRect {
        let handleSize: CGFloat = 46
        return CGRect(
            x: stampRect.maxX - handleSize/2,
            y: stampRect.minY - handleSize/2,
            width: handleSize,
            height: handleSize
        )
    }
    
    
    func getRotateHandleRect() -> CGRect {
        let handleSize: CGFloat = 46
        return CGRect(
            x: stampRect.maxX - handleSize/2,
            y: stampRect.maxY - handleSize/2,
            width: handleSize,
            height: handleSize
        )
    }
    
    
    func isResizeHandleTapped(point: CGPoint) -> Bool {
        return getResizeHandleRect().contains(point)
    }
    
    
    func getDeleteHandleRect() -> CGRect {
        let handleSize: CGFloat = 46
        return CGRect(
            x: stampRect.minX - handleSize/2,
            y: stampRect.minY - handleSize/2,
            width: handleSize,
            height: handleSize
        )
    }
    
    
    func isDeleteHandleTapped(point: CGPoint) -> Bool {
        return getDeleteHandleRect().contains(point)
    }
    
    
    func isRotateHandleTapped(point: CGPoint) -> Bool {
        return getRotateHandleRect().contains(point)
    }
    
    func startResize(at point: CGPoint) {
        isResizing = true
        resizeStartPoint = point
        resizeStartScale = currentScale
    }
    
    
    func updateResize(to point: CGPoint) {
        guard isResizing else { return }
        
        let deltaX = point.x - resizeStartPoint.x
        let scaleChange = deltaX / 30.0
        let newScale = resizeStartScale + scaleChange
        
        if newScale > 0 {
            currentScale = newScale
            transform = CGAffineTransform(scaleX: currentScale, y: currentScale).rotated(by: currentRotation)
            calculateStampRect()
        }
    }
    
    func endResize() {
        isResizing = false
    }
    
    func startRotate(at point: CGPoint) {
        isRotating = true
        rotateStartPoint = point
        rotateStartAngle = currentRotation
    }
    
    func updateRotate(to point: CGPoint) {
        guard isRotating else { return }
        
        
        let center = CGPoint(x: touchPoint.x, y: touchPoint.y)
        let startAngle = atan2(rotateStartPoint.y - center.y, rotateStartPoint.x - center.x)
        let currentAngle = atan2(point.y - center.y, point.x - center.x)
        let angleDelta = currentAngle - startAngle
        currentRotation = rotateStartAngle + angleDelta
        
        
        transform = CGAffineTransform(scaleX: currentScale, y: currentScale).rotated(by: currentRotation)
        calculateStampRect()
    }
    
    
    func endRotate() {
        isRotating = false
    }
    
    func draw() {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        guard let image = stampImage else { return }
        
        ctx.saveGState()
        ctx.setShadow(offset: CGSize(width: 0, height: 0), blur: 0, color: nil)
        
        ctx.translateBy(x: touchPoint.x, y: touchPoint.y)
        ctx.concatenate(transform)
        ctx.translateBy(x: -touchPoint.x, y: -touchPoint.y)
        
        let drawRect = CGRect(
            x: touchPoint.x - originalSize.width / 2,
            y: touchPoint.y - originalSize.height / 2,
            width: originalSize.width,
            height: originalSize.height
        )
        
        image.draw(in: drawRect)
        
        ctx.restoreGState()
        
        if isEditing {
            drawDashedBorder()
        }
    }
    
    private func drawDashedBorder() {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        let borderRect = stampRect.insetBy(dx: -5, dy: -5)
        
        ctx.saveGState()
        ctx.setStrokeColor(UIColor.systemBlue.cgColor)
        ctx.setLineWidth(2.0)
        ctx.setLineDash(phase: 0, lengths: [8, 8])
        ctx.stroke(borderRect)
        
        drawHandles(in: ctx, rect: borderRect)
        
        ctx.restoreGState()
    }
    
    private func loadIcon(named name: String) -> UIImage? {
        
        if let image = UIImage(named: name) {
            
            return image
        }
        
        
        let frameworkBundle = Bundle(for: EditableStampTool.self)
        if let image = UIImage(named: name, in: frameworkBundle, compatibleWith: nil) {
            
            return image
        }
        
        
        if let resourceBundleURL = frameworkBundle.url(forResource: "Sketch", withExtension: "bundle"),
           let resourceBundle = Bundle(url: resourceBundleURL) {
            if let image = UIImage(named: name, in: resourceBundle, compatibleWith: nil) {
                
                return image
            }
        }
        
        
        let possibleNames = [name, "\(name)@1x", "\(name)@2x", "\(name)@3x"]
        for fileName in possibleNames {
            if let imageURL = frameworkBundle.url(forResource: fileName, withExtension: "png"),
               let image = UIImage(contentsOfFile: imageURL.path) {
                
            }
        }
        
        
        
        if let resourcePath = frameworkBundle.resourcePath {
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                let pngFiles = files.filter { $0.hasSuffix(".png") }
            } catch {
                print("\(error)")
            }
        }
        
        return nil
    }
    
    private func drawHandles(in ctx: CGContext, rect: CGRect) {
        let handleSize: CGFloat = 20
        let backgroundSize: CGFloat = 22
        
        let deleteHandleRect = CGRect(
            x: rect.minX - handleSize/2,
            y: rect.minY - handleSize/2,
            width: handleSize,
            height: handleSize
        )
        
        let deleteBackgroundRect = CGRect(
            x: rect.minX - backgroundSize/2,
            y: rect.minY - backgroundSize/2,
            width: backgroundSize,
            height: backgroundSize
        )
        
        let resizeHandleRect = CGRect(
            x: rect.maxX - handleSize/2,
            y: rect.minY - handleSize/2,
            width: handleSize,
            height: handleSize
        )
        
        let resizeBackgroundRect = CGRect(
            x: rect.maxX - backgroundSize/2,
            y: rect.minY - backgroundSize/2,
            width: backgroundSize,
            height: backgroundSize
        )
        
        let rotateHandleRect = CGRect(
            x: rect.maxX - handleSize/2,
            y: rect.maxY - handleSize/2,
            width: handleSize,
            height: handleSize
        )
        
        let rotateBackgroundRect = CGRect(
            x: rect.maxX - backgroundSize/2,
            y: rect.maxY - backgroundSize/2,
            width: backgroundSize,
            height: backgroundSize
        )
        
        
        ctx.saveGState()
        
        ctx.setShadow(offset: CGSize(width: 0, height: 2), blur: 4, color: UIColor.black.withAlphaComponent(0.25).cgColor)
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: deleteBackgroundRect)
        
        ctx.setShadow(offset: CGSize.zero, blur: 0, color: nil)
        ctx.setStrokeColor(UIColor.systemGray5.cgColor)
        ctx.setLineWidth(0.5)
        ctx.strokeEllipse(in: deleteBackgroundRect)
        ctx.restoreGState()
        
        
        if let closeIcon = loadIcon(named: "close_icon") {
            closeIcon.draw(in: deleteHandleRect)
        } else {
            
            ctx.saveGState()
            ctx.setStrokeColor(UIColor.systemRed.cgColor)
            ctx.setLineWidth(2.0)
            let centerX = deleteHandleRect.midX
            let centerY = deleteHandleRect.midY
            let iconSize: CGFloat = 6
            ctx.move(to: CGPoint(x: centerX - iconSize/2, y: centerY - iconSize/2))
            ctx.addLine(to: CGPoint(x: centerX + iconSize/2, y: centerY + iconSize/2))
            ctx.move(to: CGPoint(x: centerX + iconSize/2, y: centerY - iconSize/2))
            ctx.addLine(to: CGPoint(x: centerX - iconSize/2, y: centerY + iconSize/2))
            ctx.strokePath()
            ctx.restoreGState()
        }
        
        
        ctx.saveGState()
        
        ctx.setShadow(offset: CGSize(width: 0, height: 2), blur: 4, color: UIColor.black.withAlphaComponent(0.25).cgColor)
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: resizeBackgroundRect)
        
        
        ctx.setShadow(offset: CGSize.zero, blur: 0, color: nil)
        ctx.setStrokeColor(UIColor.systemGray5.cgColor)
        ctx.setLineWidth(0.5)
        ctx.strokeEllipse(in: resizeBackgroundRect)
        ctx.restoreGState()
        
        
        if let zoomIcon = loadIcon(named: "zoom_icon") {
            zoomIcon.draw(in: resizeHandleRect)
        } else {
            
        }
        
        
        ctx.saveGState()
        
        ctx.setShadow(offset: CGSize(width: 0, height: 2), blur: 4, color: UIColor.black.withAlphaComponent(0.25).cgColor)
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: rotateBackgroundRect)
        
        
        ctx.setShadow(offset: CGSize.zero, blur: 0, color: nil)
        ctx.setStrokeColor(UIColor.systemGray5.cgColor)
        ctx.setLineWidth(0.5)
        ctx.strokeEllipse(in: rotateBackgroundRect)
        ctx.restoreGState()
        
        
        if let rotateIcon = loadIcon(named: "rotate_icon") {
            rotateIcon.draw(in: rotateHandleRect)
        } else {
            
        }
    }
}

class FillTool: SketchTool {
    var lineWidth: CGFloat
    var lineColor: UIColor
    var lineAlpha: CGFloat
    var touchPoint: CGPoint
    
    init() {
        lineWidth = 0
        lineColor = .blue
        lineAlpha = 0
        touchPoint = CGPoint(x: 0, y: 0)
    }
    
    func setInitialPoint(_ firstPoint: CGPoint) {
        touchPoint = firstPoint
    }
    
    func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint) {}
    
    func draw() {
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { print("[ERROR] UIGraphicsGetCurrentContext"); return }
        
        guard let cgimg = context.makeImage() else { return  }
        let ptinImg = CGPoint(x: touchPoint.x * UIScreen.main.scale, y: touchPoint.y * UIScreen.main.scale)
        let img = UIImage(cgImage: cgimg)
        if let imgFilled = img.fill(pt: ptinImg, color: lineColor, colorCompare: nil) {
            imgFilled.draw(in: CGRect(x: 0,
                                      y: 0,
                                      width: CGFloat(context.width) / UIScreen.main.scale,
                                      height: CGFloat(context.height) / UIScreen.main.scale))
        }
    }
}
