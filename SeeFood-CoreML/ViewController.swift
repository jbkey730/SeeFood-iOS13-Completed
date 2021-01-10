//
//  ViewController.swift
//  SeeFood-CoreML
//
//  Created by Angela Yu on 27/06/2017.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Social

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var classificationResults : [VNClassificationObservation] = []
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
    }
    
    func detect(image: CIImage) {
        
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: club(configuration: MLModelConfiguration()).model) else {
            fatalError("can't load ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in guard let results = request.results as? [VNClassificationObservation],
                                                
            let topResult = results.first?.confidence
       
            //VNImageCropAndScaleOption
                                                                                          
        else{
                    print("No results")
                    return
        }
        print(topResult)
        let predInt = Double(topResult)
        var thresh: Double
        thresh = 0.5
        if predInt < thresh {
            DispatchQueue.main.async {
                //self?.navigationItem.title = "Lax Wheat"
                self?.navigationItem.title = String(predInt)
                self?.navigationController?.navigationBar.barTintColor = UIColor.orange
                self?.navigationController?.navigationBar.isTranslucent = false
                                        }
        }
            else{
                DispatchQueue.main.async {
                    self?.navigationItem.title = String(predInt) //"Club Wheat"
                    self?.navigationController?.navigationBar.barTintColor = UIColor.orange
                    self?.navigationController?.navigationBar.isTranslucent = false
                    }
            }
       
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
        
    
    
    
        
        
            
        /*let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation],
            //self.navigationItem.title =
                let _ = results.first else{
                print("No Results")
                //self.message = .errNoRect
                return
            }
            var thresh: Double
            //var predString: String
            thresh = 0.5
            */
            /*if let predInt = Double(preds.text!){print()}
            if predInt! > thresh {
          
                
            }
            
            if predInt! < thresh {
                DispatchQueue.main.async {
                self.navigationItem.title = "Its Lax Wheat"
                self.navigationController?.navigationBar.barTintColor = UIColor.yellow
                self.navigationController?.navigationBar.isTranslucent = false
                print(predInt)
                
                }
            }
                
        }
 */
        //      let topResult = results.first
         //   else { fatalError("Model failed to process image.")
        
       // let handler = VNImageRequestHandler(ciImage: image){
        //do {
        //try handler.perform([request])
       // }
        //catch{
         //   print(error)
       // }
         /*   if topResult.identifier.contains("Identity") {
            //if let firstResult = results.first{
                 
            }
            else {
                DispatchQueue.main.async {
                    self.navigationItem.title = "Not Club!"
                    self.navigationController?.navigationBar.barTintColor = UIColor.red
                    self.navigationController?.navigationBar.isTranslucent = false
                }
            }
            //if let firstResult = results.first {
             //   self.textView.text = firstResult.identifier.capitalized
             //   print (firstResult.identifier.capitalized)
            //}
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }*/
    //}
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            guard let ciImage = CIImage(image: image) else {
                fatalError("couldn't convert uiimage to CIImage")
            }
            detect(image: ciImage)
        }
    }
    
    
    @IBAction func cameraTapped(_ sender: Any) {
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
