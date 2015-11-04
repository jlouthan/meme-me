//
//  ViewController.swift
//  MemeMe
//
//  Created by Jennifer Louthan on 11/3/15.
//  Copyright © 2015 JennyLouthan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var memeImage: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topMemeText: UITextField!
    
    @IBOutlet weak var bottomMemeText: UITextField!
    
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topMemeText.backgroundColor = UIColor.clearColor()
        self.bottomMemeText.backgroundColor = UIColor.clearColor()
        self.topMemeText.borderStyle = UITextBorderStyle.None
        self.bottomMemeText.borderStyle = UITextBorderStyle.None
        self.topMemeText.text = "TOP"
        self.bottomMemeText.text = "BOTTOM"
        
//        TODO maybe move this into delegate class?
        self.topMemeText.delegate = self
        self.bottomMemeText.delegate = self
    }
    
    func presentImagePickerWithSourceType(type: UIImagePickerControllerSourceType) -> Void {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = type
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        presentImagePickerWithSourceType(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        presentImagePickerWithSourceType(UIImagePickerControllerSourceType.Camera)
    }
    
    //    image picker delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if let newImage = info["UIImagePickerControllerOriginalImage"] {
            self.memeImage.image = newImage as? UIImage
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    text field delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == self.topMemeText && textField.text == "TOP") || (textField == self.bottomMemeText && textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

