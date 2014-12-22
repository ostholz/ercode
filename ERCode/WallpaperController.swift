//
//  WallpaperController.swift
//  ERCode
//
//  Created by Dong Wang on 24.10.14.
//  Copyright (c) 2014 i2dm. All rights reserved.
//

import UIKit


class WallpaperController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
  var qrCodeAdded = false
  var backgroundImageview: UIImageView?
  var qrCode: UIImageView?
  let panRecognizer = UIPanGestureRecognizer()
  let pinchRecognizer = UIPinchGestureRecognizer()
  var currentScale: CGFloat = 1.0
  var lastScale: CGFloat = 0.0
    
  var imagesView = UIView()
    
  @IBOutlet weak var hintLabel: UILabel!
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var redSlider: UISlider!
  @IBOutlet weak var greenSlider: UISlider!
  @IBOutlet weak var blueSlider: UISlider!
  @IBOutlet weak var alphaSlider: UISlider!
  @IBOutlet weak var continueButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!

  override func viewWillAppear(animated: Bool) {
    self.navigationController?.navigationBarHidden = false
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
        
    imagesView.frame = self.view.frame
    self.view.addSubview(imagesView)
    self.view.sendSubviewToBack(imagesView)
        
    panRecognizer.addTarget(self, action: "paning:")
    pinchRecognizer.addTarget(self, action: "pinching:")
        
    backgroundImageview = UIImageView()
    backgroundImageview!.tag = 100
        
    imagesView.addSubview(backgroundImageview!)

    redSlider.value = 1.0
    greenSlider.value = 1.0
    blueSlider.value = 1.0
    alphaSlider.value = 1.0

    cancelButton.enabled = false
    cancelButton.alpha = 0.0

    /*
    button.setTranslatesAutoresizingMaskIntoConstraints(false)
    var viewDictionary: Dictionary<String, UIView> = ["albumbutton": button]
    
    let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=30)-[albumbutton(==150)]-(>=30)-|",
        options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: viewDictionary)
    
    let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[albumbutton(==44)]-|",
        options: NSLayoutFormatOptions(0), metrics: nil, views: viewDictionary)
    
    self.view.addConstraints(hConstraints)
    self.view.addConstraints(vConstraints)
    */

  }

  @IBAction func setBackgroundColor(sender: AnyObject) {
    var rv : Float = redSlider.value
    var gv : Float = greenSlider.value
    var bv : Float = blueSlider.value
    var av : Float = alphaSlider.value

    self.view.backgroundColor = UIColor(red: CGFloat(rv), green: CGFloat(gv), blue: CGFloat(bv), alpha: CGFloat(av))
  }
    

  @IBAction func openPhotoAlbum(sender: AnyObject) {
    // hidden Slider 
    let sliderContainer = self.view.viewWithTag(95)
    sliderContainer?.alpha = 0.0

    var imagePicker = UIImagePickerController()
    imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    imagePicker.mediaTypes = [kUTTypeImage]
    imagePicker.delegate = self
    self.presentViewController(imagePicker, animated: true, completion: nil)
  }

  @IBAction func doNextStep(sender: AnyObject){
    // placeholder
  }

  /*
   Load QR-Code, set the Image in center.
  */
  @IBAction func addQRImage(sender: AnyObject){

    if (qrCodeAdded) {
      // when this button (continue button) tapped again, generated wallpaper.
      // 1. save into Photoalbum, 2. save in Documents directory, 3. save thumbnai image.
      continueButton.enabled = false
      generateWallpaper()

    } else {
      qrCodeAdded = true
      hintLabel.text = "QR-Code platzieren"
      // background Image can't changed
      button.enabled = false
      button.alpha = 0.0

      var qrImage = StatusChecker.getQRImage()
      // TODO: make sure, that the qr image is already saved.

      var screenSize: CGSize = UIScreen.mainScreen().bounds.size
      var qrImageView = UIImageView(image: qrImage)
      qrImageView.userInteractionEnabled = true
      qrImageView.frame = CGRect(x: (screenSize.width - 100) / 2, y: (screenSize.height - 100) / 2, width: 100, height: 100)
      
      var panRecg = UIPanGestureRecognizer()
      panRecg.addTarget(self, action: "paning:")
      qrImageView.addGestureRecognizer(panRecg)
      
      var pinchRecg = UIPinchGestureRecognizer()
      pinchRecg.addTarget(self, action: "pinching:")
      qrImageView.addGestureRecognizer(pinchRecg)
      
      backgroundImageview?.removeGestureRecognizer(panRecognizer)
      backgroundImageview?.removeGestureRecognizer(pinchRecognizer)
      
      imagesView.addSubview(qrImageView)

      // change button text
      continueButton.setTitle("fertig", forState: UIControlState.Normal)
//      cancelButton.alpha = 1.0
//      cancelButton.enabled = true

    }
    
//    qrButton.setTitle("fertig", forState: UIControlState.Normal)
//    qrButton.removeTarget(self, action: "addQRImage", forControlEvents: UIControlEvents.TouchUpInside)
//    qrButton.addTarget(self, action: "generateWallpaper", forControlEvents: UIControlEvents.TouchUpInside)
  }


  // speichert aktuelle Hintergrund und QR-Code
  func generateWallpaper() {
      
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0.0)
    imagesView.layer.renderInContext(UIGraphicsGetCurrentContext())
    
    var resultImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    // speichert in Photoalbum
    UIImageWriteToSavedPhotosAlbum(resultImage, nil, nil, nil)

    // speichert in Documents Dir
    StatusChecker.saveWallpaper(resultImage)

    var iv = UIImageView(image: resultImage)
    
    imagesView.removeFromSuperview()
    button.removeFromSuperview()

    self.navigationController?.popToRootViewControllerAnimated(true)

  }


  //   MARK: - ImagePickerController Delegate
  func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary! ) {
    var pickedImage: UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
    backgroundImageview!.image = pickedImage
    backgroundImageview!.userInteractionEnabled = true
    let imageSize: CGSize = pickedImage.size
    var screenSize: CGSize = UIScreen.mainScreen().bounds.size

    var imageHeight = screenSize.width * imageSize.height / imageSize.width
    backgroundImageview!.frame = CGRectMake(0, (screenSize.height - imageHeight)/2, screenSize.width, imageHeight)

    backgroundImageview!.addGestureRecognizer(panRecognizer)
    backgroundImageview!.addGestureRecognizer(pinchRecognizer)

    // change Hinttext 
    hintLabel.text = "Hintergrundbild platzieren"
    
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  func paning(recognizer: UIPanGestureRecognizer) {
    let viewCenter: CGPoint = recognizer.view!.center
    var traslation: CGPoint = recognizer.translationInView(self.view)
    recognizer.view?.center = CGPointMake(viewCenter.x + traslation.x, viewCenter.y + traslation.y)
    recognizer.setTranslation(CGPointZero, inView: self.view)
  }
  
  func pinching(recognizer: UIPinchGestureRecognizer) {
    var imageview = recognizer.view? as UIImageView
    var image = imageview.image

    lastScale = recognizer.scale - 1.0
    if (recognizer.state == UIGestureRecognizerState.Ended) {
    }
    
    var totalScale = currentScale + lastScale
    
    currentScale = totalScale
    recognizer.view?.transform = CGAffineTransformScale(recognizer.view!.transform, recognizer.scale, recognizer.scale)
    recognizer.scale = 1
    
    if imageview.frame.width <= image?.size.width && imageview.frame.width >= UIScreen.mainScreen().bounds.size.width {
    } else {
        
    }
      
//        if imageview.frame.width < image?.size.width {
//            recognizer.view?.transform = CGAffineTransformScale(recognizer.view!.transform, currentScale, currentScale)
//        } else {
      
//        }

  }
    
    
}