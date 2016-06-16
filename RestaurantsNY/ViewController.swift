//
//  ViewController.swift
//  RestaurantsNY
//
//  Created by Harim Tejada on 6/15/16.
//  Copyright © 2016 Harim Tejada. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper
import MRProgress
import SDWebImage
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "CellIdentifier"
    var restaurantsItems: [Restaurant] = []
    var isNewYorkAvailable: Bool = false
    var iswebServiceAvailable: Bool = false
    var currentPage : Int = 1
    var refreshControl: UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Conecting...",
                                                 mode: MRProgressOverlayViewMode.IndeterminateSmall,
                                                 animated: true)
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(ViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        //
        if Reachability.isConnectedToNetwork() == true {
            checkWebService()
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    func refresh(sender:AnyObject) {
        currentPage = 1
        getNewYorkCityeRestaurants()
    }
    var valueToPass:Int!
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "showDetail") {
            
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! RestaurantProfileViewController
            let row = self.tableView.indexPathForSelectedRow?.row
            print(row)
            
            viewController.restaurantId = restaurantsItems[row!].id!
        }
        
    }
    //TableView Override
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = restaurantsItems.count
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RestaurantCell
        
        
        let rest = restaurantsItems[indexPath.row]
        
        //cell.imageRestaurant.sd_setImageWithURL(NSURL(string: rest.image_url!))
        cell.textName?.text = rest.name
        if indexPath.row == self.restaurantsItems.count - 1
        {
            currentPage = currentPage + 1
            getNewYorkCityeRestaurants()
            print("Loading more items")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let profileViewController = storyBoard.instantiateViewControllerWithIdentifier("RestaurantProfileViewController") as! RestaurantProfileViewController
        print("show detail")
        profileViewController.restaurantId = restaurantsItems[indexPath.row].id
        self.navigationController?.pushViewController(profileViewController, animated: true)
      //  self.valueToPass = restaurantsItems[indexPath.row].id
    }
    
    //Data Functions
    func checkWebService()->Void{
       
        Alamofire.request(.GET,Constansts.WebService.ApiEndPoint + Constansts.WebService.stats).responseJSON{(response)->Void in
    
            if response.result.value != nil {
                //
                let stats = Mapper<Stats>().map(response.result.value)
                //
                if stats?.cities > 1{
                    print("The web service is avaible...")
                    self.iswebServiceAvailable = true
                    self.checkIfNewYorkCityIsAvaible()
                }
                else{
                    print("Web service conection error...")
                    self.showOverlay("Unable to connect...", overlayMode:MRProgressOverlayViewMode.Cross)
                }
            }
            
           
        }
    }
    
    func checkIfNewYorkCityIsAvaible(){
        Alamofire.request(.GET,Constansts.WebService.ApiEndPoint + Constansts.WebService.cities).responseJSON{(response)->Void in
            
            if response.result.value != nil {
                //
                let cities = Mapper<Cities>().map(response.result.value)
                //
                if cities?.cities?.contains("New York") != nil{
                    self.getNewYorkCityeRestaurants()
                    print("New York City has restaurants...")
                    self.iswebServiceAvailable = true
                    self.showOverlay("Getting restaurants...", overlayMode:MRProgressOverlayViewMode.IndeterminateSmall)
                }
                else{
                    self.showOverlay("New York is under something weird...", overlayMode:MRProgressOverlayViewMode.Cross)
                }
            }
        }
    }
    
    func getNewYorkCityeRestaurants(){
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        let url = "\(Constansts.WebService.ApiEndPoint)\(Constansts.WebService.restaurants)"
        
        Alamofire.request(.GET,url,parameters: ["city": "New York", "per_page":"5", "page":currentPage]).responseJSON{(response)->Void in
            
            if let value = response.result.value {
               
                let restaurants = Mapper<Response>().map(value)
                
                if let data = restaurants?.data{
                    if self.currentPage == 1{
                     self.restaurantsItems = data
                    }
                    else{
                        self.restaurantsItems.appendContentsOf(data)
                    }
                   
                    self.tableView.reloadData()
                    //
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.refreshControl.endRefreshing()

                }
            }
        }
    }
    
    
    func showOverlay(text:String, overlayMode:MRProgressOverlayViewMode)->Void{
        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        MRProgressOverlayView.showOverlayAddedTo(self.view, title: text, mode: overlayMode, animated: true)
        let seconds = 2.0
        let delay = seconds * Double(NSEC_PER_SEC)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            
        })
    }

}

