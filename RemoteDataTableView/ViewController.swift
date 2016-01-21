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
    
    // spots is and Array of SurSpots and holds the data received from the server
    var spots: Array<SurfSpot> = Array<SurfSpot>()
    
    var selectedRow = 1
    
    // MARK: JSON
    
    /**
    retrieves the data from the server, parses the JSON and add the items into the global spots array
    - Parameter none
    */
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
            if let items = parsedResult["locations"] as? [[String: String]] {
                for item in items {
                    let mySpot = SurfSpot(  spot: item  )
                    print("spots.append")
                    self.spots.append(mySpot)
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

