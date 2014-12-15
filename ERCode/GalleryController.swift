//
//  GalleryController.swift
//  ERCode
//
//  Created by Dong Wang on 03.11.14.
//  Copyright (c) 2014 i2dm. All rights reserved.
//

import Foundation

class GalleryController: UIViewController {

  @IBOutlet weak var allWallpaper: UICollectionView!
  @IBOutlet weak var desciption: UITextView!

  var savedWallpaper = [UIImage]()

  override func viewDidLoad() {

  }

  func setCollectionView() {
    let filemanager = NSFileManager.defaultManager()

    let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
//    let contents = filemanager.contentsAtPath(documentPath) as [String]

//    for filename in contents {
//      if (filename.hasPrefix("wallpaper")) {
//
//      }
//    }

  }

  /*
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

  }

  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

  }

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

  }
*/

}
