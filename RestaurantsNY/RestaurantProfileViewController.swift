//
//  RestauranteProfileViewController.swift
//  RestaurantsNY
//
//  Created by Harim Tejada on 6/15/16.
//  Copyright © 2016 Harim Tejada. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper
import SDWebImage
import MapKit
class RestaurantProfileViewController: UITableViewController{

    var restaurant:Restaurant!
    var restaurantId:Int!
    //Views
    @IBOutlet weak var PhotoImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var StateLabel: UILabel!
    @IBOutlet weak var CountryLabel: UILabel!
    @IBOutlet weak var PhoneLabel: UILabel!
    
    
    @IBAction func openInMapsClicked(sender: AnyObject) {
        
        let latitute:CLLocationDegrees =  self.restaurant.latitude!
        let longitute:CLLocationDegrees = self.restaurant.longitude!
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitute, longitute)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.restaurant.name!
        mapItem.openInMapsWithLaunchOptions(options)
    }
    @IBAction func reserveClicked(sender: AnyObject){
        UIApplication.sharedApplication().openURL(NSURL(string: self.restaurant.mobile_reserve_url!)!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRestaurantDetail()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func getRestaurantDetail(){
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let id = "\(Constansts.WebService.restaurants)\("/")\(restaurantId)"
        let url = "\(Constansts.WebService.ApiEndPoint)\(id)"
        
        Alamofire.request(.GET,url).responseJSON{(response)->Void in
            
            if let value = response.result.value {
                
                self.restaurant = Mapper<Restaurant>().map(value)

                
                self.NameLabel.text = self.restaurant?.name
                self.AddressLabel.text = self.restaurant?.address
                self.StateLabel.text = self.restaurant?.state
                self.CountryLabel.text = self.restaurant?.country
                self.PhoneLabel.text = self.restaurant?.phone
            self.PhotoImageView.sd_setImageWithURL(NSURL(string: self.restaurant!.image_url!))
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            }
        }
    }
}