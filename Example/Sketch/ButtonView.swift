//
//  ButtonView.swift
//  Sketch
//
//  Created by daihase on 2018/04/06.
//  Copyright (c) 2018 daihase. All rights reserved.
//

import UIKit

protocol ButtonViewInterface: class {
    func tapPenButton()
    func tapEraserButton()
    func tapUndoButton()
    func tapRedoButton()
    func tapClearButton()
    func tapPaletteButton()
    func tapFillButton()
    func tapStampButton()
    func tapFigureButton()
    func tapFilterButton()
    func tapCameraButton()
}

class ButtonView: UIView {
    var delegate: ButtonViewInterface?
    
    class func instanceFromNib(_ delegate: ButtonViewInterface?) -> ButtonView {
        let buttonView : ButtonView = UINib(
            nibName: "ButtonView",
            bundle: Bundle.main
            ).instantiate(
                withOwner: self,
                options: nil
            ).first as! ButtonView
        
        buttonView.delegate = delegate
        
        return buttonView
    }
    
    // Tap pen Button
    @IBAction func tapPenButton(_ sender: Any) {
        delegate?.tapPenButton()
    }
    
    // Tap Eraser Button
    @IBAction func tapEraserButton(_ sender: Any) {
        delegate?.tapEraserButton()
    }
    
    // Tap Undo Buddon
    @IBAction func tapUndoButton(_ sender: Any) {
        delegate?.tapUndoButton()
    }
    
    // Tap Redo Button
    @IBAction func tapRedoButton(_ sender: Any) {
        delegate?.tapRedoButton()
    }
    
    // Tap Clear Button
    @IBAction func tapClearButton(_ sender: Any) {
        delegate?.tapClearButton()
    }
    
    // Tap Palette Button
    @IBAction func tapPaletteButton(_ sender: Any) {
        delegate?.tapPaletteButton()
    }
    
    // Tap Fill Button
    @IBAction func tapFillButton(_ sender: Any) {
        delegate?.tapFillButton()
    }
    
    // Tap Stamp Button
    @IBAction func tapStampButton(_ sender: Any) {
        delegate?.tapStampButton()
    }
    
    // Tap Figure Button
    @IBAction func tapFigureButton(_ sender: Any) {
        delegate?.tapFigureButton()
    }
    
    // Tap Filter Button
    @IBAction func tapFilterButton(_ sender: Any) {
        delegate?.tapFilterButton()
    }
    
    // Tap Camera Button
    @IBAction func tapCameraButton(_ sender: Any) {
       delegate?.tapCameraButton()
    }
}
