//
//  ViewController.swift
//  RemoteDataTableView
//
//  Created by Fabio De Lorenzo on 1/20/16.
//  Copyright © 2016 Crokky Software Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    var tableView: UITableView!
    
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
            self.tableView!.reloadData()
            //self.view
            
            
        } // end NS session
        task.resume()
        
    }
    
    
    // https://www.youtube.com/watch?v=BCSGh-YJgvs
    
    var selectedRow = 1
    
    let movies = [
        ("iOS App Dev with Swift Essential Training","Simon Allardice"),
        ("iOS 8 SDK New Features","Lee Brimelow"),
        ("Data Visualization with D3.js","Ray Villalobos"),
        ("Swift Essential Training","Simon Allardice"),
        ("Up and Running with AngularJS","Ray Villalobos"),
        ("MySQL Essential Training","Bill Weinman"),
        ("Building Adaptive Android Apps with Fragments","David Gassner"),
        ("Advanced Unity 3D Game Programming","Michael House"),
        ("Up and Running with Ubuntu Desktop Linux","Scott Simpson"),
        ("Up and Running with C","Dan Gookin") ]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("spots.count=" + String(spots.count) )
        return spots.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        print("tableView Row: \(row)")
        let cell = tableView.dequeueReusableCellWithIdentifier("fabiocell", forIndexPath:  indexPath) as! LocationCell
        cell.titleLabel.text = spots[row].location
        cell.contentLabel.text = spots[row].report
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
        destinationVC.labelText = movies[self.selectedRow].0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getServerData()
        tableView = UITableView(frame:self.view!.frame)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

