//
//  GalleryController.swift
//  ERCode
//
//  Created by Dong Wang on 03.11.14.
//  Copyright (c) 2014 i2dm. All rights reserved.
//

import Foundation

class GalleryController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  /*
  TODO: die Hintergrundbilder wurden (sollen) in ~/Documents/wallpapers/ gespeichert.
        die Thumbnaibilder wurde in ~/Documents/thumbs/ gespeichert.


  */

  @IBOutlet weak var allWallpapers: UICollectionView!

  @IBOutlet weak var addNewWPButton: UIButton!

  var savedWallpaper: NSMutableArray?

  override func viewWillAppear(animated: Bool) {
    self.navigationController?.navigationBarHidden = true
  }

  override func viewDidLoad() {
    savedWallpaper =  NSUserDefaults.standardUserDefaults().objectForKey("wallpapers") as? NSMutableArray

  }

  deinit{
    // TODO: Save Wallpaper list
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

  //   MARK: - custom Methods
  @IBAction func createNewWallpaper(sender: AnyObject) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let wallpaperVC = storyboard.instantiateViewControllerWithIdentifier("Wallpaper") as UIViewController
    self.navigationController?.pushViewController(wallpaperVC, animated: true)
  }

  // MARK: - UICollectionView DataSource and Delegate Methods

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WallpaperCell", forIndexPath: indexPath) as UICollectionViewCell

    var imageview: UIImageView = cell.contentView.viewWithTag(101) as UIImageView // tag: 101
    let namedict: NSDictionary = savedWallpaper?[indexPath.row] as NSDictionary
    let wpname: NSString = namedict[kKeyThumbname] as NSString
    imageview.image = StatusChecker.getWallpaper(wpname)

    return cell
  }

  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

  }

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    if (savedWallpaper == nil){
      return 0
    }
    else {
      return savedWallpaper!.count
    }
  }




}
