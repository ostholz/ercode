//
//  StationViewController.swift
//  ERCode
//
//  Created by Dong Wang on 11.12.14.
//  Copyright (c) 2014 i2dm. All rights reserved.


import UIKit
import CoreLocation
import AudioToolbox
import MessageUI

class StationViewController: UIViewController, UITableViewDataSource,
          UITableViewDelegate, CLLocationManagerDelegate,
          MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var stationsTable: UITableView!
  @IBOutlet weak var callStationButton: UIButton!
  @IBOutlet weak var smsButton: UIButton!
  @IBOutlet weak var ercodeLabel: UILabel!

  var controlStations : [ControlStation] = []
  let locationManager = CLLocationManager()
  var currentLocation : CLLocation?
  var scannedERcode: String?


  var activCondition = 0
  var selectedStation : ControlStation?

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let tabItem = UITabBarItem(title: "Scan", image: nil, selectedImage: nil)
    self.tabBarItem = tabItem

    setButtonStatus()

    //self.stationsTable.registerClass(StationCell.self, forCellReuseIdentifier: "StationCell")
    self.stationsTable.registerNib( UINib(nibName: "StationCell", bundle: nil), forCellReuseIdentifier: "StationCell")
    self.loadControlStations()

    locationManager.requestWhenInUseAuthorization()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters  // braucht nicht unbedingt so korrekt
    locationManager.startUpdatingLocation()
  }

  func loadControlStations() {
    // FIXME: Load Control Stations from JSON
    let filePath = NSBundle.mainBundle().pathForResource("ControlStations", ofType:"json")
    var error: NSError?
    let data = NSData(contentsOfFile: filePath!, options: nil, error: &error)

    var jsonStations = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as [Dictionary<String, AnyObject>]

    for stn in jsonStations{
      var station = ControlStation(name: stn["name"] as String, telefon: stn["telefonNumber"] as String, lat: stn["lat"] as Double, lng: stn["lng"] as Double)
      controlStations.append(station)
    }
  }


  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  //  MARK: - UITableView Delegate Methods
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return controlStations.count
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 65
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("StationCell", forIndexPath: indexPath) as StationCell

    var station = controlStations[indexPath.row]
    cell.stationName.text = station.name
    cell.stationNumber.text = station.telefonNumber
    if let dis = station.distance {
      cell.distance.text = NSString(format: "%.1f km", station.distance! / 1000)

    }
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if selectedStation == nil {
      activCondition++
    }
    println("<<< activCondition: \(activCondition)")
    selectedStation = controlStations[indexPath.row]
    setButtonStatus()
  }

  //  MARK: - CLLocationManagerDelegate Methods
  func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
    locationManager.stopUpdatingLocation()
  }

  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    locationManager.stopUpdatingLocation()

    currentLocation = (locations as NSArray).lastObject as? CLLocation


    // sort Stations with distance
    for station in controlStations {
      var loc = CLLocation(latitude: station.lat, longitude: station.lng)

      var distance = currentLocation?.distanceFromLocation(loc)
      station.distance = distance

    }

    controlStations.sort { (s1: ControlStation, s2: ControlStation) -> Bool in
      s1.distance < s2.distance
    }

    stationsTable.reloadData()

  }

  // MARK: - MFMessageComposeViewDelegate methods

  func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {

    if (result.value == MessageComposeResultCancelled.value) {
      println("abgebrochen")

    } else if (result.value == MessageComposeResultFailed.value) {
      println("Send SMS mislungen")

    } else if (result.value == MessageComposeResultSent.value) {
      println("Suessce sendt")
    }

    controller.dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func startScanQRImage() {
    if activCondition > 0 {
      activCondition--
    }
    println("activCondition: \(activCondition)")
    let scanController = ScanViewController()
    scanController.parentController = self

    self.presentViewController(scanController, animated: true, completion: nil)
  }

  @IBAction func callStation() {
    var telUrl = "tel://" + selectedStation!.telefonNumber
    UIApplication.sharedApplication().openURL(NSURL(string: telUrl)!)
  }

  @IBAction func sendSMS() {
    if !MFMessageComposeViewController.canSendText() {
      let alertview = UIAlertView(title: "", message: "SMS kann nicht gesendet werden", delegate: nil, cancelButtonTitle: "OK")
      alertview.show()
      return
    }

    let messageComposeVC = MFMessageComposeViewController()
    messageComposeVC.delegate = self
    messageComposeVC.recipients = [selectedStation!.telefonNumber]
    messageComposeVC.body = scannedERcode
    self.presentViewController(messageComposeVC, animated: true, completion: nil)
  }

  func successGetERCode(ercode: String) {
    SVProgressHUD.showSuccessWithStatus(ercode)

    // play sound
    let soundUrl = NSBundle.mainBundle().URLForResource("success", withExtension: "wav")
    var successSound : SystemSoundID = 100
    AudioServicesCreateSystemSoundID(soundUrl, &successSound)
    AudioServicesPlayAlertSound(successSound)

    scannedERcode = ercode
    ercodeLabel.text = ercode
    activCondition++
    println("success Get ERCode - activCondition: \(activCondition)")

    setButtonStatus()

    var localNotification = UILocalNotification()
    localNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
    localNotification.alertBody = "Recognized ER-Code"
    localNotification.timeZone = NSTimeZone.defaultTimeZone()

    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
  }
  

  func setButtonStatus() {
    var enable = activCondition == 2 ? true : false

    println(">>> activCondition: \(activCondition)")

    callStationButton.enabled = enable
    smsButton.enabled = enable
    if enable {
      callStationButton.backgroundColor = UIColor.greenColor()
      smsButton.backgroundColor = UIColor.greenColor()
    } else {
      callStationButton.backgroundColor = UIColor.grayColor()
      smsButton.backgroundColor = UIColor.grayColor()
    }
  }
  
}


