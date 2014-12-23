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
  @IBOutlet weak var geoLocationLabel: UILabel!

  var controlStations : [ControlStation] = []
  let locationManager = CLLocationManager()
  var currentLocation : CLLocation?
  var scannedERcode: String?


//  var activCondition = 0
  var valaidERCodeScanned = false
  var selectedStation : ControlStation?

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    let tabItem = UITabBarItem(title: "Scan", image: UIImage(named: "scan.png"), selectedImage: nil)
    self.tabBarItem = tabItem
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func viewWillDisappear(animated: Bool) {
    valaidERCodeScanned = false
    ercodeLabel.text = ""
  }

  override func viewWillAppear(animated: Bool) {
    // for Test Telephone
    stationsTable.reloadData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

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
    // only the first 5 Controlstations
    return 5
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 65
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("StationCell", forIndexPath: indexPath) as StationCell

    var station = controlStations[indexPath.row]
    cell.stationName.text = station.name
    if testTelephoneNum != nil {
      station.telefonNumber = testTelephoneNum!
      cell.stationNumber.text = testTelephoneNum!
    } else {
       cell.stationNumber.text = station.telefonNumber
    }
    if let dis = station.distance {
      cell.distance.text = NSString(format: "%.1f km", station.distance! / 1000)

    }
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
    geoLocationLabel.text = locationToString(currentLocation!)

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

  func locationToString(location: CLLocation) -> String {
    let lat : Double = location.coordinate.latitude
    let lng : Double = location.coordinate.longitude

    var latSeconds: Int = Int( round(lat * 3600) )
    let latDegrees: Int = Int( latSeconds / 3600 )
    latSeconds = abs(latSeconds % 3600 )
    var latMinutes = latSeconds / 60
    latSeconds %= 60

    var lngSeconds: Int = Int( round(lng * 3600))
    let lngDegrees = Int(lngSeconds / 3600)
    lngSeconds = abs(lngSeconds % 3600)
    let lngMinutes = lngSeconds / 60
    lngSeconds %= 60

    var latDirection = (lat >= 0) ? "N" : "S"
    var lngDirection = (lng >= 0) ? "E" : "W"

    return "\(latDirection) \(latDegrees)° \(latMinutes)' \(latSeconds)\", \(lngDirection) \(lngDegrees)° \(lngMinutes)' \(lngSeconds)\" "

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

  @IBAction func startScanQRImage(sender: AnyObject) {
    let scanController = ScanViewController()
    scanController.parentController = self

    self.presentViewController(scanController, animated: true, completion: nil)
  }

  @IBAction func callStation(sender: AnyObject) {
    var telUrl = "tel://" + selectedStation!.telefonNumber
    UIApplication.sharedApplication().openURL(NSURL(string: telUrl)!)
  }

  @IBAction func sendSMS(sender: AnyObject) {
    if !MFMessageComposeViewController.canSendText() {
      let alertview = UIAlertView(title: "", message: "SMS kann nicht gesendet werden", delegate: nil, cancelButtonTitle: "OK")
      alertview.show()
      return
    }

    let messageComposeVC = MFMessageComposeViewController()
    messageComposeVC.messageComposeDelegate = self
    messageComposeVC.recipients = [selectedStation!.telefonNumber]
    messageComposeVC.body = scannedERcode
    self.presentViewController(messageComposeVC, animated: true, completion: nil)
  }

  func successGetERCode(ercode: String) {
//    SVProgressHUD.showSuccessWithStatus(ercode)

    // play sound
    let soundUrl = NSBundle.mainBundle().URLForResource("success", withExtension: "wav")
    var successSound : SystemSoundID = 100
    AudioServicesCreateSystemSoundID(soundUrl, &successSound)
    AudioServicesPlayAlertSound(successSound)

    validateERCode(ercode)

}

  func validateERCode(code: String) {
    SVProgressHUD.show()

    let manager = AFHTTPRequestOperationManager()
    // default responseSerializer ist JSON Serializer
    manager.responseSerializer = AFJSONResponseSerializer() as AFHTTPResponseSerializer
    manager.requestSerializer.setValue(wsSessionid, forHTTPHeaderField: kPHPSession)
    manager.GET(
      "\(kServerUrl)ercode/check/\(code)",
      parameters: nil,
      success: {[unowned self] (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
        var response: NSDictionary = responseObject as NSDictionary
        if response["ercode"] as Bool {
          self.scannedERcode = code
          self.ercodeLabel.text = code
          self.valaidERCodeScanned = true

          self.setButtonStatus()

          var localNotification = UILocalNotification()
          localNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
          localNotification.alertBody = "Recognized ER-Code"
          localNotification.timeZone = NSTimeZone.defaultTimeZone()

          UIApplication.sharedApplication().scheduleLocalNotification(localNotification)

        } else {
          self.ercodeLabel.text = "Kein gültiger ER-Code"
        }
        SVProgressHUD.dismiss()

      },

      failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
        SVProgressHUD.dismiss()
      }
    )

  }


  func setButtonStatus() {
    var enable = (valaidERCodeScanned && selectedStation != nil)

    callStationButton.enabled = enable
    smsButton.enabled = enable
    if enable {
      callStationButton.backgroundColor = UIColor(red: 11 / 255, green: 185 / 255, blue: 11 / 255, alpha: 1)
      smsButton.backgroundColor = UIColor(red: 11 / 255, green: 185 / 255, blue: 11 / 255, alpha: 1)
    } else {
      callStationButton.backgroundColor = UIColor.grayColor()
      smsButton.backgroundColor = UIColor.grayColor()
    }
  }
  
}





