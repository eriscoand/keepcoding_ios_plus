//
//  AddEditAnnotationViewController+Utils.swift
//  HackerBooks2
//
//  Created by Eric Risco de la Torre on 02/03/2017.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

extension AddEditAnnotationViewController: CLLocationManagerDelegate {

    func handleLocation(){
        
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locManager.requestWhenInUseAuthorization()
        }
        
        if authStatus == .denied || authStatus == .restricted {
            locationDisabledAlert()
            return
        }
        
        startLocation()
        
    }
    
    func startLocation() {
        if CLLocationManager.locationServicesEnabled() {
            
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
            locationEnabled = true
            
            timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(AddEditAnnotationViewController.locationTimedOut), userInfo: nil, repeats: false)
        }
    }
    
    func stopLocation() {
        if locationEnabled {
            if let timer = timer {
                timer.invalidate()
            }
            locManager.stopUpdatingLocation()
            locManager.delegate = nil
            locationEnabled = false
        }
    }
    
    func locationDisabledAlert() {
        let alert = UIAlertController(title: "Location Alert", message: "Locations are disabled!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "👍", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func locationTimedOut() {
        if loc == nil {
            stopLocation()
            let alert = UIAlertController(title: "Location Alert", message: "Location timed out!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "👍", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {        
        if (error as NSError).code == CLError.Code.locationUnknown.rawValue {
            return
        }
        locationError = error as NSError?
        stopLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        loc = locations.last!
        
        if let l = loc {
            coordinates.text = String(format: "%.8f", l.coordinate.latitude) + "," + String(format: "%.8f", l.coordinate.longitude)
        }
                
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
            if (error != nil) {
                self.directionText.text = "..."
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                
                let country = pm.country != nil ? pm.country : ""
                let postalCode = pm.postalCode != nil ? pm.postalCode : ""
                let locality = pm.locality != nil ? pm.locality : ""
                
                self.directionText.text = country! + " (" + postalCode! + ") " + locality!
                
            } else {
                self.directionText.text = "..."
            }
        })
        
        locationError = nil
    }
    
    
}

extension AddEditAnnotationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(userText: UITextField!) -> Bool {
        self.titleText = userText
        self.titleText.resignFirstResponder()
        self.view.endEditing(true);
        return true;
    }
}

extension AddEditAnnotationViewController: UITextViewDelegate {
    func textViewShouldReturn(userText: UITextView!) -> Bool {
        self.descriptionText = userText
        self.descriptionText.resignFirstResponder()
        self.view.endEditing(true);
        return true;
    }
}