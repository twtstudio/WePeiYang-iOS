//
//  ViewController.swift
//  MapKitImplementAgain
//
//  Created by Allen X on 7/12/16.
//  Copyright © 2016 twtstudio. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class BicycleServiceMapController: UIViewController, MKMapViewDelegate {
    
    
    //@IBOutlet var whereAmI: UIButton!
    
    /*@IBAction func whereAmI(sender: AnyObject) {
     if let userLoc:MKUserLocation? = newMapView.userLocation {
     let cl = CLLocation(latitude: (userLoc?.coordinate.latitude)!, longitude: (userLoc?.coordinate.longitude)!)
     centerMapOnLocation(cl)
     } else {
     checkLocationAuthorizationStatus()
     }
     }*/
    var whereAmI: UIButton! = UIButton()
    
    func whereAmI(sender: UIButton!) {
        if let userLoc:MKUserLocation? = newMapView.userLocation {
            let cl = CLLocation(latitude: (userLoc?.coordinate.latitude)!, longitude: (userLoc?.coordinate.longitude)!)
            centerMapOnLocation(cl)
            print("How are you")
        } else {
            checkLocationAuthorizationStatus()
            print("FUCKYOU")
        }
    }
    var newMapView = MKMapView()
    
    //@IBOutlet var newMapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    let BeijingSpot = CLLocation(latitude: 39.903257, longitude: 116.301336)
    var locationManager = CLLocationManager()
    let spot = ParkingSpots(title: "金家沟", coordinate: CLLocationCoordinate2D(latitude: 38.99677, longitude: 117.30438), numberOfBikes: 32)
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            newMapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius*2, regionRadius*2)
        newMapView.setRegion(coordinateRegion, animated: true)
    }
    
    //img processing
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRect(x: 0.0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whereAmI.addTarget(self, action: Selector("whereAmI:"), forControlEvents: .TouchUpInside)
        self.view.addSubview(newMapView)
        newMapView.addSubview(whereAmI)
        
        whereAmI.snp_makeConstraints(closure: {(make) in
            make.left.equalTo(self.view).offset(20)
            make.bottom.equalTo(self.view).offset(-46)
        })
        
        newMapView.snp_makeConstraints(closure: {(make) in
            make.left.equalTo(self.view)
            make.top.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        })
        
        whereAmI.sizeThatFits(CGSize(width: 48.0, height: 48.0))
        //let imgForWhereAmI = imageWithImage(#imageLiteral(resourceName: "回到定位"), scaledToSize: CGSize(width: 48.0, height: 48.0))
        let imgForWhereAmI = imageWithImage(UIImage(named: "回到定位")!, scaledToSize: CGSize(width: 48.0, height: 48.0))
        print(imgForWhereAmI)
        whereAmI.setBackgroundImage(imgForWhereAmI, forState: .Normal)
        
        
        
        centerMapOnLocation(BeijingSpot)
        newMapView.delegate = self
        if #available(iOS 9.0, *) {
            newMapView.showsCompass = true
        } else {
            // Fallback on earlier versions
        }
        
        newMapView.addAnnotation(spot)
        
        
        // Do any additional setup after loading the view, typically from a nib.'\
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let view = SpotDetailsView(positionsAvailable: "123/153", spotName: "诚园宿舍停车位群", distanceFromUser: 314)
        //let view = SpotDetailsView(positionsAvailable: "\(view.annotation!.currentNumberOfBikes)/\(view.annotation!.numberOfBikes)", spotName: view.annotation!.title, distanceFromUser: "Hello")
        
        self.view.addSubview(view)
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        for view in self.view.subviews {
            if view.isKindOfClass(SpotDetailsView) {
                view.removeFromSuperview()
            }
            
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationIdentifier = "AnnotationIdentifier"
        if let fooAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) {
            fooAnnotationView.annotation = annotation
            return fooAnnotationView
        } else {
            let fooAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            fooAnnotationView.canShowCallout = false
            
            if let fooUserLocation = mapView.userLocation.location {
                if annotation.coordinate.latitude == fooUserLocation.coordinate.latitude && annotation.coordinate.longitude == fooUserLocation.coordinate.longitude {
                    fooAnnotationView.image = imageWithImage(UIImage(named: "小箭头")!, scaledToSize: CGSize(width: 25.0, height: 25.0))
                    print("FUCKIT")
                } else {
                    fooAnnotationView.image = imageWithImage(UIImage(named: "大点位")!, scaledToSize: CGSize(width: 25.0, height: 25.0))
                    print("FUCKITAGAIN")
                }
            } else {
                //警告用户无法定位
                checkLocationAuthorizationStatus()
                //仍然显示自行车点位
                fooAnnotationView.image = imageWithImage(UIImage(named: "大点位")!, scaledToSize: CGSize(width: 25.0, height: 25.0))
                print("ahoh")
            }
            
            return fooAnnotationView
        }
    }
    
}

