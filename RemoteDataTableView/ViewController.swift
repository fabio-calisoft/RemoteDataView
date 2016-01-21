//
//  ViewController.swift
//  RemoteDataTableView
//
//  Created by Fabio De Lorenzo on 1/20/16.
//  Copyright © 2016 Crokky Software Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var mTableView: UITableView!
    
    class SurfSpot {
        
        var location: String?
        var waves_min: String?
        var waves_max: String?
        var low_tide: String?
        var high_tide: String?
        var imageurl: String?
        var report: String?
        init(location: String, waves_min: String, waves_max: String, low_tide: String, high_tide: String, imageurl: String, report: String) {
            self.location = location
            self.waves_min = waves_min
            self.waves_max = waves_max
            self.low_tide = low_tide
            self.high_tide = high_tide
            self.imageurl = imageurl
            self.report = report
        }
    }
    
    var spots: Array<SurfSpot> = Array<SurfSpot>()
    // https://www.youtube.com/watch?v=BCSGh-YJgvs
    
    var selectedRow = 1
    
    // MARK: JSON
    
    func getServerData() {
        print("getServerData")
        let urlString = "http://www.crokky.com/androidapps/lazanzara/demo.php"
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* 5 - Check for a successful response */
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 6 - Parse the data (i.e. convert the data to JSON and look for values!) */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            if let blogs = parsedResult["locations"] as? [[String: AnyObject]] {
                for blog in blogs {
                    let name = blog["location"] as! String
                    let waves_min = blog["waves_min"]  as! String
                    let waves_max = blog["waves_max"]as! String
                    let low_tide = blog["low_tide"]as! String
                    let high_tide = blog["high_tide"]as! String
                    let imageurl = blog["imageurl"]as! String
                    let report = blog["report"]as! String
                    /*print(high_tide)
                    print(report)
                    print(low_tide)
                    print(waves_max)
                    print(waves_min)
                    print(name)
                    print(imageurl)*/
                    let spot = SurfSpot(location: name, waves_min: waves_min, waves_max: waves_max, low_tide: low_tide, high_tide: high_tide, imageurl: imageurl, report: report)
                    print("spots.append")
                    self.spots.append(spot)
                }
            }// if
            print("reloadData")
            dispatch_async(dispatch_get_main_queue()) {
                self.mTableView!.reloadData()
            }
            
            
        } // end NS session
        task.resume()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("spots.count=" + String(spots.count) )
        self.mTableView = tableView
        return spots.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        print("tableView Row: \(row)")
        let cell = tableView.dequeueReusableCellWithIdentifier("fabiocell", forIndexPath:  indexPath) as! LocationCell
        cell.locationLabel.text = spots[row].location
        cell.waveminlabel.text = spots[row].waves_min
        cell.wavemaxlabel.text = spots[row].waves_max
        cell.tideminlabel.text = spots[row].low_tide
        cell.tidemaxlabel.text = spots[row].high_tide
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
        self.selectedRow = row
        print("Row: \(row)")
        self.performSegueWithIdentifier("showDetail", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        print("custom prepareForSegue:" + segue.identifier! )
        let destinationVC :DetailViewController = segue.destinationViewController as! DetailViewController
        destinationVC.location = spots[self.selectedRow].location!
        destinationVC.forecast = spots[self.selectedRow].report!
        destinationVC.wavemin = spots[self.selectedRow].waves_min!
        destinationVC.wavemax  = spots[self.selectedRow].waves_max!
        destinationVC.tidemin = spots[self.selectedRow].low_tide!
        destinationVC.tidemax  = spots[self.selectedRow].high_tide!
        destinationVC.imageurl = spots[self.selectedRow].imageurl!
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mTableView = UITableView(frame:self.view!.frame)
        mTableView.delegate = self
        getServerData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

