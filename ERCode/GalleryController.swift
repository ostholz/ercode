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

  override func viewWillAppear(animated: Bool) {
//    self.navigationController?.navigationBarHidden = true
    self.navigationController?.navigationBar.topItem?.title = "WALLPAPER"
    allWallpapers.reloadData()
  }

  override func viewDidLoad() {
    // Defined as Global Variable in StatusChecker.swift
    savedWallpaper =  NSUserDefaults.standardUserDefaults().objectForKey("wallpapers") as? NSMutableArray
    if savedWallpaper == nil {
      savedWallpaper = NSMutableArray()
    }

    if (savedWallpaper?.count == 0) {
      savedWallpaper?.addObject(NSDictionary(objects: ["addNewWallpaper", "add_wp_cell.png"], forKeys: [kKeyWallpapername, kKeyThumbname]))
    }

    // right bar button
    let rightBarButton = UIBarButtonItem(image: UIImage(named: "add_wp_icon.png"), style: UIBarButtonItemStyle.Plain,
      target: self, action: "createNewWallpaper:")
    self.navigationItem.rightBarButtonItem = rightBarButton

  }

  deinit{
    // TODO: Save Wallpaper list
    NSUserDefaults.standardUserDefaults().setObject(savedWallpaper, forKey: "wallpapers")
    NSUserDefaults.standardUserDefaults().synchronize()
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

    if wpname == "add_wp_cell.png" {
      imageview.image = UIImage(named: "add_wp_cell.png")
    } else {
      imageview.image = StatusChecker.getWallpaper(wpname)
    }

//    cell.layer.borderColor = UIColor.grayColor().CGColor
//    cell.layer.borderWidth = 1.0
    return cell
  }


  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    if indexPath.row == (savedWallpaper!.count - 1) {
      createNewWallpaper(self)
    } else {
      
    }
  }

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return savedWallpaper!.count
  }




}
