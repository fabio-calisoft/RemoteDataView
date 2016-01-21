//
//  DetailViewController.swift
//  RemoteDataTableView
//
//  Created by Fabio De Lorenzo on 1/20/16.
//  Copyright © 2016 Crokky Software Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet var locationlabel: UILabel!
    @IBOutlet var forecastlabel: UILabel!
    
    @IBOutlet var waveminlabel: UILabel!
    
    @IBOutlet var wavemaxlabel: UILabel!
    
    @IBOutlet var tideminlabel: UILabel!
    
    @IBOutlet var tidemaxlabel: UILabel!
    
    @IBOutlet var locationImage: UIImageView!
    
    var location: String = ""
    var forecast: String = ""
    var wavemin: String = ""
    var wavemax: String = ""
    var tidemin: String = ""
    var tidemax: String = ""
    var imageurl: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationlabel.text =  location
        forecastlabel.text = forecast
        waveminlabel.text = wavemin
        wavemaxlabel.text = wavemax
        tideminlabel.text = tidemin
        tidemaxlabel.text = tidemax
        
        // dinamically load the image from hte URL
        let url = NSURL(string: imageurl)
        let data = NSData(contentsOfURL:url!)
        if data != nil {
            locationImage.image = UIImage(data:data!)
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
