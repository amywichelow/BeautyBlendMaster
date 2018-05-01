//  ImageViewController.swift
//  Beauty Blend
//  Created by Amy Wichelow on 08/11/2017.
//  Copyright © 2017 Amy Wichelow. All rights reserved.

import Foundation
import Vision
import UIKit

class StepFour: UIViewController, UINavigationControllerDelegate {
    
    
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    
    
    func addOverlays(imageViews: [UIImageView]) {
        let droplet = UIImage(named: "droplet")
        for overlayImageView in imageViews {
            overlayImageView.image = droplet
            imageView.addSubview(overlayImageView)
        }
    }
    
    
    func convert(point: CGPoint, offset: (x: CGFloat, y: CGFloat) ) -> CGPoint {
        return CGPoint(x: (imageView.frame.width - point.x + offset.x), y: (imageView.frame.height - point.y + offset.y))
    }
    
    
    
    
    func handleFaceFeatures(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNFaceObservation] else {
            fatalError("unexpected result type")
        }
        
        for face in observations {
            addFaceLandmarksToImage(face)
        }
        
    }
    
    func addFaceLandmarksToImage(_ face: VNFaceObservation) {
        var newOverlays = [UIImageView]()
        
        UIGraphicsBeginImageContextWithOptions(image.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        //Draw Image
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        //Draw Rectangle
        let w = face.boundingBox.size.width * image.size.width
        let h = face.boundingBox.size.height * image.size.height
        let x = face.boundingBox.origin.x * image.size.width
        let y = face.boundingBox.origin.y * image.size.height
        let faceRect = CGRect(x: x, y: y, width: w, height: h)
        context?.saveGState()
        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setLineWidth(0)
        context?.addRect(faceRect)
        context?.drawPath(using: .stroke)
        context?.restoreGState()
        
        //Draw Face Contour
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.faceContour {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.setLineWidth(3.5)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        //Draw Outer Lips
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.outerLips {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.closePath()
        context?.setLineWidth(3.5)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        //Draw Inner Lips
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.innerLips {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.closePath()
        context?.setLineWidth(3.5)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        //Draw Left Eye
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.leftEye {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.closePath()
        context?.setLineWidth(3.5)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        //Draw Right Eye
        //        context?.saveGState()
        //        context?.setStrokeColor(UIColor.yellow.cgColor)
        
        if let landmark = face.landmarks?.rightEye {
            
            var imagePoint: CGPoint!
            
            for i in 0...landmark.pointCount - 1 {
                let point = landmark.normalizedPoints[i]
                
                if i == 0 {
                    imagePoint = landmark.pointsInImage(imageSize: imageView.frame.size)[i]
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
            
            let theImageView = UIImageView(frame: CGRect(origin: convert(point: imagePoint, offset: (x: 25.0, y: 25.0)) , size: CGSize(width: 50, height: 50)))
            newOverlays.append(theImageView)
            
        }
        
        
        //Draw Left Eyebrow
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.leftEyebrow {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.setLineWidth(3.5)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        //Draw Right Eyebrow
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.rightEyebrow {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.setLineWidth(3.5)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        //Draw Nose
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.nose {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.closePath()
        context?.setLineWidth(3.5)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        //Draw Nose Crest
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.noseCrest {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.setLineWidth(3.5)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        //Final Image
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        addOverlays(imageViews: newOverlays)
        
        imageView.image = finalImage
        
    }
    
    
}




