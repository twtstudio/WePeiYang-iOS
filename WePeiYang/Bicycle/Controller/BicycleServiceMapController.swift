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
    
    let regionRadius: CLLocationDistance = 100
    //let BeijingSpot = CLLocation(latitude: 39.903257, longitude: 116.301336)
    let defaultCenterSpot = CLLocation(latitude: 38.994857, longitude: 117.314955)
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

        centerMapOnLocation(defaultCenterSpot)
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
        
        if annotation.isKindOfClass(ParkingSpot) {
            
            let annotationIdentifier = "AnnotationIdentifier"
            if let dequeuedView = newMapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) {
                
                //log.word("Reused AnnotationView!")/
                return dequeuedView
            } else {
                
                //let fooAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                //fooAnnotationView.image = UIImage.resizedImage(UIImage(named: "大点位")!, scaledToSize: CGSize(width: 25.0, height: 25.0))
                let fooAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                fooAnnotationView.canShowCallout = false
                //log.word("Created New AnnotationView")/
                return fooAnnotationView
            }
        } else {
            
            let userPinIdentifier = "UserPinIdentifier"
            if let dequeuedView = newMapView.dequeueReusableAnnotationViewWithIdentifier(userPinIdentifier) {

                //log.word("Reused UserPinView!")/
                return dequeuedView
            } else {
                
                let fooAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: userPinIdentifier)
                fooAnnotationView.image = UIImage.resizedImage(UIImage(named: "小箭头")!, scaledToSize: CGSize(width: 25.0, height: 25.0))
                fooAnnotationView.canShowCallout = false
                //log.word("Created New UserPinView!")/
                return fooAnnotationView
            }
            
        }
    }
    
    
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        for view in views {
            let endFrame = view.frame
            view.frame = CGRectOffset(endFrame, 0, -1000)
            UIView.animateWithDuration(1) {
                view.frame = endFrame
            }
        }
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {

        guard let spot = view.annotation as? ParkingSpot else {
            return
        }
        guard let userLoc = newMapView.userLocation as? MKUserLocation else {
            (view.annotation as! ParkingSpot).getCurrentStatus {
                let detailView = SpotDetailsView(positionsAvailable: "\((spot.currentNumberOfBikes)!)/\(spot.numberOfBikes)", spotName: spot.title!, distanceFromUser: nil)
                mapView.addSubview(detailView)
                self.checkLocationAuthorizationStatus()
            }
        }
        
        (view.annotation as! ParkingSpot).getCurrentStatus {
            let detailView = SpotDetailsView(positionsAvailable: "\((spot.currentNumberOfBikes)!)/\(spot.numberOfBikes)", spotName: spot.title!, distanceFromUser: spot.calculateDistance(userLoc))
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
    
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    
}


//MARK: Geograph info Calculation and Fetching
extension BicycleServiceMapController {
    
}
