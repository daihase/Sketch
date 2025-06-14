//
//  SketchView.swift
//  Sketch
//
//  Created by daihase on 04/06/2018.
//  Copyright (c) 2018 daihase. All rights reserved.
//

import UIKit

public enum SketchToolType {
    case pen
    case eraser
    case stamp
    case line
    case arrow
    case rectangleStroke
    case rectangleFill
    case ellipseStroke
    case ellipseFill
    case star
    case fill
}

public enum ImageRenderingMode {
    case scale
    case original
}

@objc public protocol SketchViewDelegate: NSObjectProtocol  {
    @objc optional func drawView(_ view: SketchView, willBeginDrawUsingTool tool: AnyObject)
    @objc optional func drawView(_ view: SketchView, didEndDrawUsingTool tool: AnyObject)
}

public class SketchView: UIView {
    public var lineColor = UIColor.black
    public var lineWidth = CGFloat(10)
    public var lineAlpha = CGFloat(1)
    public var stampImage: UIImage?
    public var drawTool: SketchToolType = .pen
    public var drawingPenType: PenType = .normal
    public var sketchViewDelegate: SketchViewDelegate?
    
    
    public var isStampEditable: Bool = false
    
    private var currentTool: SketchTool?
    private let pathArray: NSMutableArray = NSMutableArray()
    private let bufferArray: NSMutableArray = NSMutableArray()
    private var currentPoint: CGPoint?
    private var previousPoint1: CGPoint?
    private var previousPoint2: CGPoint?
    private var image: UIImage?
    private var backgroundImage: UIImage?
    private var drawMode: ImageRenderingMode = .original
    private var isDraggingStamp: Bool = false
    private var dragStartPoint: CGPoint = .zero
    
    private var editingStampTool: EditableStampTool? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.editingStampTool) as? EditableStampTool
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.editingStampTool, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var stampTools: [EditableStampTool] {
        return pathArray.compactMap { $0 as? EditableStampTool }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepareForInitial()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        prepareForInitial()
    }
    
    private func prepareForInitial() {
        backgroundColor = UIColor.clear
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        switch drawMode {
        case .original:
            image?.draw(at: CGPoint.zero)
            break
        case .scale:
            image?.draw(in: self.bounds)
            break
        }
        
        currentTool?.draw()
    }
    
    private func updateCacheImage(_ isUpdate: Bool) {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        if isUpdate {
            image = nil
            switch drawMode {
            case .original:
                if let backgroundImage = backgroundImage  {
                    (backgroundImage.copy() as! UIImage).draw(at: CGPoint.zero)
                }
                break
            case .scale:
                (backgroundImage?.copy() as! UIImage).draw(in: self.bounds)
                break
            }
            
            for obj in pathArray {
                if let tool = obj as? SketchTool {
                    tool.draw()
                }
            }
        } else {
            switch drawMode {
            case .original:
                image?.draw(at: .zero)
            case .scale:
                image?.draw(in: self.bounds)
            }
            currentTool?.draw()
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func toolWithCurrentSettings() -> SketchTool? {
        switch drawTool {
        case .pen:
            return PenTool()
        case .eraser:
            return EraserTool()
        case .stamp:
            
            if isStampEditable {
                return EditableStampTool()
            } else {
                return StampTool()
            }
        case .line:
            return LineTool()
        case .arrow:
            return ArrowTool()
        case .rectangleStroke:
            let rectTool = RectTool()
            rectTool.isFill = false
            return rectTool
        case .rectangleFill:
            let rectTool = RectTool()
            rectTool.isFill = true
            return rectTool
        case .ellipseStroke:
            let ellipseTool = EllipseTool()
            ellipseTool.isFill = false
            return ellipseTool
        case .ellipseFill:
            let ellipseTool = EllipseTool()
            ellipseTool.isFill = true
            return ellipseTool
        case .star:
            return StarTool()
        case .fill:
            return FillTool()
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        
        
        if isStampEditable {
            if let editingStamp = editingStampTool {
                if editingStamp.isDeleteHandleTapped(point: touchPoint) {
                    deleteSelectedStamp()
                    return
                } else if editingStamp.isResizeHandleTapped(point: touchPoint) ||
                            editingStamp.isRotateHandleTapped(point: touchPoint) {
                } else if editingStamp.contains(point: touchPoint) {
                    isDraggingStamp = true
                    dragStartPoint = touchPoint
                    return
                } else {
                    confirmStampEditing(stampTool: editingStamp)
                }
            }
            
            if drawTool == .stamp {
                handleEditableStampToolTouch(at: touchPoint)
                return
            }
        }
        
        if currentTool != nil {
            finishDrawing()
        }
        
        previousPoint1 = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
        currentTool = toolWithCurrentSettings()
        currentTool?.lineWidth = lineWidth
        currentTool?.lineColor = lineColor
        currentTool?.lineAlpha = lineAlpha
        
        sketchViewDelegate?.drawView?(self, willBeginDrawUsingTool: currentTool! as AnyObject)
        
        switch currentTool! {
        case is PenTool:
            guard let penTool = currentTool as? PenTool else { return }
            pathArray.add(penTool)
            penTool.drawingPenType = drawingPenType
            penTool.setInitialPoint(currentPoint!)
        case is StampTool:
            guard let stampTool = currentTool as? StampTool else { return }
            pathArray.add(stampTool)
            stampTool.setStampImage(image: stampImage)
            stampTool.setInitialPoint(currentPoint!)
        case is EditableStampTool:
            guard let editableStampTool = currentTool as? EditableStampTool else { return }
            pathArray.add(editableStampTool)
            editableStampTool.setStampImage(image: stampImage)
            editableStampTool.setInitialPoint(currentPoint!)
        default:
            guard let currentTool = currentTool else { return }
            pathArray.add(currentTool)
            currentTool.setInitialPoint(currentPoint!)
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        
        
        if isStampEditable {
            if isDraggingStamp, let editingStamp = editingStampTool {
                let deltaX = currentPoint.x - dragStartPoint.x
                let deltaY = currentPoint.y - dragStartPoint.y
                let newPosition = CGPoint(
                    x: editingStamp.touchPoint.x + deltaX,
                    y: editingStamp.touchPoint.y + deltaY
                )
                editingStamp.updatePosition(newPosition)
                dragStartPoint = currentPoint
                updateCacheImage(true)
                setNeedsDisplay()
                return
            }
            
            if let editingStamp = editingStampTool, editingStamp.isResizing {
                editingStamp.updateResize(to: currentPoint)
                updateCacheImage(true)
                setNeedsDisplay()
                return
            }
            
            if let editingStamp = editingStampTool, editingStamp.isRotating {
                editingStamp.updateRotate(to: currentPoint)
                updateCacheImage(true)
                setNeedsDisplay()
                return
            }
        }
        
        previousPoint2 = previousPoint1
        previousPoint1 = touch.previousLocation(in: self)
        self.currentPoint = currentPoint
        
        if let penTool = currentTool as? PenTool {
            let renderingBox = penTool.createBezierRenderingBox(previousPoint2!, withPreviousPoint: previousPoint1!, withCurrentPoint: self.currentPoint!)
            setNeedsDisplay(renderingBox)
        } else {
            currentTool?.moveFromPoint(previousPoint1!, toPoint: self.currentPoint!)
            setNeedsDisplay()
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isStampEditable {
            if isDraggingStamp {
                isDraggingStamp = false
                updateCacheImage(true)
                setNeedsDisplay()
                return
            }
            
            if let editingStamp = editingStampTool, editingStamp.isResizing {
                editingStamp.endResize()
                updateCacheImage(true)
                setNeedsDisplay()
                return
            }
            
            if let editingStamp = editingStampTool, editingStamp.isRotating {
                editingStamp.endRotate()
                updateCacheImage(true)
                setNeedsDisplay()
                return
            }
        }
        
        touchesMoved(touches, with: event)
        finishDrawing()
    }
    
    fileprivate func finishDrawing() {
        updateCacheImage(false)
        bufferArray.removeAllObjects()
        sketchViewDelegate?.drawView?(self, didEndDrawUsingTool: currentTool! as AnyObject)
        currentTool = nil
    }
    
    private func resetTool() {
        currentTool = nil
    }
    
    public func clear() {
        resetTool()
        bufferArray.removeAllObjects()
        pathArray.removeAllObjects()
        editingStampTool = nil
        updateCacheImage(true)
        
        setNeedsDisplay()
    }
    
    func pinch() {
        resetTool()
        guard let tool = pathArray.lastObject as? SketchTool else { return }
        bufferArray.add(tool)
        pathArray.removeLastObject()
        updateCacheImage(true)
        
        setNeedsDisplay()
    }
    
    public func loadImage(image: UIImage, drawMode: ImageRenderingMode = .original) {
        self.image = image
        self.drawMode = drawMode
        backgroundImage =  image.copy() as? UIImage
        bufferArray.removeAllObjects()
        pathArray.removeAllObjects()
        editingStampTool = nil
        updateCacheImage(true)
        
        setNeedsDisplay()
    }
    
    public func undo() {
        if canUndo() {
            guard let tool = pathArray.lastObject as? SketchTool else { return }
            resetTool()
            
            
            if let editableStamp = tool as? EditableStampTool,
               let currentEditingStamp = editingStampTool,
               editableStamp === currentEditingStamp {
                editingStampTool = nil
            }
            
            bufferArray.add(tool)
            pathArray.removeLastObject()
            updateCacheImage(true)
            
            setNeedsDisplay()
        }
    }
    
    public func redo() {
        if canRedo() {
            guard let tool = bufferArray.lastObject as? SketchTool else { return }
            resetTool()
            pathArray.add(tool)
            bufferArray.removeLastObject()
            updateCacheImage(true)
            
            setNeedsDisplay()
        }
    }
    
    public func canUndo() -> Bool {
        return pathArray.count > 0
    }
    
    public func canRedo() -> Bool {
        return bufferArray.count > 0
    }
    
    
    private func handleEditableStampToolTouch(at point: CGPoint) {
        if let editingStamp = editingStampTool {
            if editingStamp.isDeleteHandleTapped(point: point) {
                deleteSelectedStamp()
                return
            }
            
            if editingStamp.isResizeHandleTapped(point: point) {
                editingStamp.startResize(at: point)
                return
            }
            
            if editingStamp.isRotateHandleTapped(point: point) {
                editingStamp.startRotate(at: point)
                return
            }
            
            if editingStamp.contains(point: point) {
                return
            } else {
                confirmStampEditing(stampTool: editingStamp)
                return
            }
        }
        
        if let existingTool = stampTools.first(where: { $0.contains(point: point) && !$0.isEditing }) {
            editExistingStamp(stampTool: existingTool)
        } else {
            createNewStamp(at: point)
        }
    }
    
    private func createNewStamp(at point: CGPoint) {
        let stampTool = EditableStampTool()
        stampTool.setStampImage(image: stampImage)
        stampTool.setInitialPoint(point)
        stampTool.isEditing = true
        
        pathArray.add(stampTool)
        bufferArray.removeAllObjects()
        editingStampTool = stampTool
        
        updateCacheImage(true)
        setNeedsDisplay()
    }
    
    private func editExistingStamp(stampTool: EditableStampTool) {
        stampTools.forEach { $0.isEditing = false }
        
        stampTool.isEditing = true
        editingStampTool = stampTool
        
        updateCacheImage(true)
        setNeedsDisplay()
    }
    
    private func confirmStampEditing(stampTool: EditableStampTool) {
        stampTool.isEditing = false
        editingStampTool = nil
        updateCacheImage(true)
        setNeedsDisplay()
    }
    
    public func deleteSelectedStamp() {
        guard let selectedStamp = editingStampTool else { return }
        
        let index = pathArray.index(of: selectedStamp)
        if index != NSNotFound {
            pathArray.removeObject(at: index)
        }
        
        editingStampTool = nil
        updateCacheImage(true)
        setNeedsDisplay()
    }
    
    public func setStampEditable(_ editable: Bool) {
        isStampEditable = editable
        
        
        if let editingStamp = editingStampTool {
            confirmStampEditing(stampTool: editingStamp)
        }
    }
}

private struct AssociatedKeys {
    static var editingStampTool = "editingStampTool"
}
