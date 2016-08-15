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

class BicycleServiceMapController: UIViewController {
    
    
    //@IBOutlet var whereAmI: UIButton!
    
    /*@IBAction func whereAmI(sender: AnyObject) {
     if let userLoc:MKUserLocation? = newMapView.userLocation {
     let cl = CLLocation(latitude: (userLoc?.coordinate.latitude)!, longitude: (userLoc?.coordinate.longitude)!)
     centerMapOnLocation(cl)
     } else {
     checkLocationAuthorizationStatus()
     }
     }*/
    var whereAmI = UIButton(backgroundImageName: "回到定位", desiredSize: CGSize(width: 46.0, height: 46.0))!
    
    func whereAmI(sender: UIButton!) {
        if let userLoc:MKUserLocation? = newMapView.userLocation {
            let cl = CLLocation(latitude: (userLoc?.coordinate.latitude)!, longitude: (userLoc?.coordinate.longitude)!)
            centerMapOnLocation(cl)
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

    let spots = ParkingSpot.parkingSpots!
    
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
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        whereAmI.addTarget(self, action: #selector(BicycleServiceMapController.whereAmI(_:)), forControlEvents: .TouchUpInside)

        computeLayout()

        centerMapOnLocation(BeijingSpot)
        newMapView.delegate = self
        if #available(iOS 9.0, *) {
            newMapView.showsCompass = true
        } else {
            // Fallback on earlier versions
        }
        
        newMapView.addAnnotations(spots)
        //newMapView.addAnnotation(spot)

        // Do any additional setup after loading the view, typically from a nib.'\
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Constraint Layout using Snapkit
extension BicycleServiceMapController {
    func computeLayout() {
        
        view.addSubview(newMapView)
        newMapView.snp_makeConstraints {
            make in
            make.left.equalTo(view)
            make.top.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        
        newMapView.addSubview(whereAmI)
        whereAmI.snp_makeConstraints {
            make in
            make.left.equalTo(view).offset(20)
            make.bottom.equalTo(view).offset(-46)
            make.width.height.equalTo(46.0)
        }
    }
}

//MARK: MapView Delegate
extension BicycleServiceMapController: MKMapViewDelegate {
    
    
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
                    fooAnnotationView.image = UIImage.resizedImage(UIImage(named: "小箭头")!, scaledToSize: CGSize(width: 25.0, height: 25.0))
                    print("FUCKIT")
                } else {
                    fooAnnotationView.image = UIImage.resizedImage(UIImage(named: "大点位")!, scaledToSize: CGSize(width: 25.0, height: 25.0))
                    print("FUCKITAGAIN")
                }
            } else {
                //警告用户无法定位
                checkLocationAuthorizationStatus()
                //仍然显示自行车点位
                fooAnnotationView.image = UIImage.resizedImage(UIImage(named: "大点位")!, scaledToSize: CGSize(width: 25.0, height: 25.0))
                print("ahoh")
            }
            
            return fooAnnotationView
        }
    }
    /*
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? ParkingSpot {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = false
            }
            return view
        }
        return nil
    }*/
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        //let detailView = SpotDetailsView(positionsAvailable: "123/153", spotName: "诚园宿舍停车位群", distanceFromUser: 314)
        //let detailView = SpotDetailsView(positionsAvailable: "123/153", , distanceFromUser: <#T##Float#>)
        //let view = SpotDetailsView(positionsAvailable: "\(view.annotation!.currentNumberOfBikes)/\(view.annotation!.numberOfBikes)", spotName: view.annotation!.title, distanceFromUser: "Hello")
        (view.annotation as! ParkingSpot).getCurrentStatus { 
            let detailView = SpotDetailsView(positionsAvailable: "\(((view.annotation as! ParkingSpot).currentNumberOfBikes)!)/\((view.annotation as! ParkingSpot).numberOfBikes)", spotName: (view.annotation as! ParkingSpot).title!, distanceFromUser: 32)
            mapView.addSubview(detailView)
        }
    }
    
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        for view in mapView.subviews {
            if view.isKindOfClass(SpotDetailsView) {
                view.removeFromSuperview()
            }
            
        }
    }
    
}


//MARK: Geograph info Calculation and Fetching
extension BicycleServiceMapController {
    
}
