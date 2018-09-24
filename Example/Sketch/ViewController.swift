//
//  ViewController.swift
//  Sketch
//
//  Created by daihase on 04/07/2018.
//  Copyright (c) 2018 daihase. All rights reserved.
//

import UIKit
import Sketch

class ViewController: UIViewController, ButtonViewInterface {
    @IBOutlet weak var sketchView: SketchView!
    var buttonView: ButtonView!
    var scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))

    override func viewDidLoad() {
        super.viewDidLoad()
        // If you set it by code, let's do as follows
        /*
        let sketchView = SketchView(frame:
            CGRect(x: 0,
                   y: 0,
                   width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.height
            )
        )
        view.addSubview(sketchView)
        */

        // create ButtonView instance
        buttonView = ButtonView.instanceFromNib(self)

        view.addSubview(scrollView)
        scrollView.addSubview(buttonView)

        scrollView.contentSize = buttonView.frame.size
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame.origin.x = 0
        scrollView.frame.origin.y = UIScreen.main.bounds.height - buttonView.frame.size.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - ButtonViewInterface
//////////////////////////////////////////////////////////////////////////////////////////
extension ViewController {
    func tapPenButton() {
        sketchView.drawTool = .pen
    }

    func tapEraserButton() {
        sketchView.drawTool = .eraser
    }

    func tapUndoButton() {
        sketchView.undo()
    }

    func tapRedoButton() {
        sketchView.redo()
    }

    func tapClearButton() {
        sketchView.clear()
    }

    func tapPaletteButton() {
        // Black
        let blackAction = UIAlertAction(title: "Black", style: .default) { _ in
            self.sketchView.lineColor = .black
        }
        // Blue
        let blueAction = UIAlertAction(title: "Blue", style: .default) { _ in
            self.sketchView.lineColor = .blue
        }
        // Red
        let redAction = UIAlertAction(title: "Red", style: .default) { _ in
            self.sketchView.lineColor = .red
        }
        // Cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }

        let alertController = UIAlertController(title: "Please select a color", message: nil, preferredStyle: .alert)
        alertController.addAction(blackAction)
        alertController.addAction(blueAction)
        alertController.addAction(redAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func tapFillButton() {
        sketchView.drawTool = .fill
    }

    func tapStampButton() {
        // Heart
        let heartAction = UIAlertAction(title: "Heart", style: .default) { _ in
            self.changeStampMode(stampName: "Heart")
        }
        // Star
        let starAction = UIAlertAction(title: "Star", style: .default) { _ in
            self.changeStampMode(stampName: "Star")
        }
        // Smile
        let smileAction = UIAlertAction(title: "Smile", style: .default) { _ in
            self.changeStampMode(stampName: "Smile")
        }
        // Cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }

        let alertController = UIAlertController(title: "Please select a stamp", message: nil, preferredStyle: .alert)
        alertController.addAction(heartAction)
        alertController.addAction(starAction)
        alertController.addAction(smileAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    private func changeStampMode(stampName: String) {
        sketchView.stampImage = UIImage(named: stampName)
        sketchView.drawTool = .stamp
    }

    func tapFigureButton() {
        // Line
        let lineAction = UIAlertAction(title: "Line", style: .default) { _ in
            self.sketchView.drawTool = .line
        }
        // Arrow
        let arrowAction = UIAlertAction(title: "Arrow", style: .default) { _ in
            self.sketchView.drawTool = .arrow
        }
        // Rect
        let rectAction = UIAlertAction(title: "Rect", style: .default) { _ in
            self.sketchView.drawTool = .rectangleStroke
        }
        // Rectfill
        let rectFillAction = UIAlertAction(title: "Rect(Fill)", style: .default) { _ in
            self.sketchView.drawTool = .rectangleFill
        }
        // Ellipse
        let ellipseAction = UIAlertAction(title: "Ellipse", style: .default) { _ in
            self.sketchView.drawTool = .ellipseStroke
        }
        // EllipseFill
        let ellipseFillAction = UIAlertAction(title: "Ellipse(Fill)", style: .default) { _ in
            self.sketchView.drawTool = .ellipseFill
        }
        // Star
        let starAction = UIAlertAction(title: "Star platinum", style: .default) { _ in
            self.sketchView.drawTool = .star
        }
        // Cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }

        let alertController = UIAlertController(title: "Please select a figure", message: nil, preferredStyle: .alert)
        alertController.addAction(lineAction)
        alertController.addAction(arrowAction)
        alertController.addAction(rectAction)
        alertController.addAction(rectFillAction)
        alertController.addAction(ellipseAction)
        alertController.addAction(ellipseFillAction)
        alertController.addAction(starAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func tapFilterButton() {
        // Normal
        let normalAction = UIAlertAction(title: "Normal", style: .default) { _ in
            self.sketchView.drawingPenType = .normal
        }
        // Blur
        let blurAction = UIAlertAction(title: "Blur", style: .default) { _ in
            self.sketchView.drawingPenType = .blur
        }
        // Neon
        let neonAction = UIAlertAction(title: "Neon", style: .default) { _ in
            self.sketchView.drawingPenType = .neon
        }
        // Cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }

        let alertController = UIAlertController(title: "Please select a filter type", message: nil, preferredStyle: .alert)
        alertController.addAction(normalAction)
        alertController.addAction(blurAction)
        alertController.addAction(neonAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func tapCameraButton() {
        // Camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.setImageFromCamera()
        }
        // Gallery
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.setImageFromGallery()
        }
        // Cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }

        let alertController = UIAlertController(title: "Please select a Picture", message: nil, preferredStyle: .alert)
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    private func setImageFromCamera() {
        PhotoRequestManager.requestPhotoFromCamera(self){ [weak self] result in
            switch result {
            case .success(let image):
                self?.sketchView.loadImage(image: image)
            case .faild:
                print("failed")
            case .cancel:
                break
            }
        }
    }

    private func setImageFromGallery() {
        PhotoRequestManager.requestPhotoLibrary(self){ [weak self] result in
            switch result {
            case .success(let image):
                self?.sketchView.loadImage(image: image)
            case .faild:
                print("failed")
            case .cancel:
                break
            }
        }
    }
}
