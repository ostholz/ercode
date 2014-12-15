//
//  ScanViewController.swift
//  ERCode
//
//  Created by Dong Wang on 11.12.14.
//  Copyright (c) 2014 i2dm. All rights reserved.
//

import Foundation
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

  var session : AVCaptureSession = AVCaptureSession()
  var previewLayer: AVCaptureVideoPreviewLayer?
  var decocedMessage : String?
//  var boundingBox: ScanShapView?

  weak var parentController : StationViewController?

  override func viewDidLoad() {
    var captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)

    var error : NSError?

    // set uitabbar item
    let tabItem = UITabBarItem(title: "Scan", image: nil, selectedImage: nil)
    self.tabBarItem = tabItem

    var input: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
    if input != nil {
      session.addInput(input as AVCaptureInput)
    } else {
      return
    }

    var output = AVCaptureMetadataOutput()
    session.addOutput(output)
    output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]

    output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())


    previewLayer = (AVCaptureVideoPreviewLayer.layerWithSession(session) as AVCaptureVideoPreviewLayer)
    previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
    previewLayer!.bounds = self.view.bounds
    previewLayer!.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
    /*
    boundingBox = ScanShapView(frame: self.view.bounds)
    boundingBox!.backgroundColor = UIColor.clearColor()
    boundingBox!.hidden = true
    self.view.addSubview(boundingBox!)
    */

    self.view.layer.addSublayer(previewLayer)

    var screensize = self.view.bounds.size
    var buttonFrame = CGRectMake((screensize.width - 100) / 2, screensize.height - 50, 100, 44)

    let cancelButton = UIButton(frame: buttonFrame)
    cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    cancelButton.setTitle("abbrechen", forState: UIControlState.Normal)
    cancelButton.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0.6, alpha: 0.9)
    cancelButton.addTarget(self, action: "cancelScan", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(cancelButton)

    // start session (begin capture)
    session.startRunning()

  }

  // MARK: - AVCaptureMetadataOutputObjectsDelegate

  func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
    session.stopRunning()

    for metadata in metadataObjects {
      if metadata.type == AVMetadataObjectTypeQRCode {
        var transformed = previewLayer?.transformedMetadataObjectForMetadataObject(metadata as AVMetadataObject) as AVMetadataMachineReadableCodeObject

        decocedMessage = transformed.stringValue
        parentController!.successGetERCode(decocedMessage!)
        self.dismissViewControllerAnimated(true, completion: nil)

        /*
        boundingBox?.frame = transformed.bounds
        boundingBox?.hidden = false
        var translateCorners = self.translatePoints(transformed.corners, fromView: self.view, toView: boundingBox)

        */
      }
    }
  }

  func translatePoints(points: [AnyObject], fromView: UIView, toView: UIView) -> [CGPoint] {
    var translatePoints = [CGPoint]()
    /*
    for point in points {
    let pointDict = point as NSDictionary
    let pointValue = CGPointMake(pointDict["x"], pointDict["y"])

    let translatedPoint = fromView.convertPoint(pointValue, toView: toView)
    translatePoints.append(translatedPoint)

    }
    */
    return translatePoints
  }
  
  func cancelScan() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
}