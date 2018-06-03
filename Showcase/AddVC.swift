//
//  AddVC.swift
//  Showcase
//
//  Created by Admin on 07.10.16.
//  Copyright © 2016 EvilMint. All rights reserved.
//

import UIKit
import Firebase

class AddVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker: UIImagePickerController!
    var imgSelected = false
    
    @IBOutlet weak var postField: MaterialTF!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    @IBOutlet weak var iconImg: CircleView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func BackButtPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            iconImg.image = image
            iconImg.clipsToBounds = true
            iconImg.layer.cornerRadius = iconImg.frame.width / 2
            imgSelected = true
        } else {
            print("OCTO: img wasn't selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImg(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func makePost(_ sender: AnyObject) {
        guard let caption = postField.text, caption != "" else {
            print("OCTO: text miss")
            return
        }
        guard let img = iconImg.image, imgSelected == true else {
            print("OCTO: img miss")
            return
        }
        
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg" // ?????
            
            DataService.ds.REF_POST_IMG.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("OCTO: uploading error")
                } else {
                    print("OCTO: success upload")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    self.postToFirebase(imgUrl: downloadURL!)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, AnyObject> = [
            "description":  NSString(string: postField.text!),
            "imgUrl":  NSString(string: imgUrl),
            "likes": NSNumber(value: 0)
        ]
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        imgSelected = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    

}
