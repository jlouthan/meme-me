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
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topMemeText: UITextField!
    @IBOutlet weak var bottomMemeText: UITextField!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        shareButton.enabled = (memeImage.image != nil)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleTextViews()
        self.setToLaunchState()
        self.topMemeText.delegate = self
        self.bottomMemeText.delegate = self
    }
    
    func styleTextViews() {
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0
        ]
        
        self.topMemeText.defaultTextAttributes = memeTextAttributes
        self.bottomMemeText.defaultTextAttributes = memeTextAttributes
        self.topMemeText.borderStyle = UITextBorderStyle.None
        self.bottomMemeText.borderStyle = UITextBorderStyle.None
        self.topMemeText.textAlignment = NSTextAlignment.Center
        self.bottomMemeText.textAlignment = NSTextAlignment.Center
    }
    
//    choose image
    
    func presentImagePickerWithSourceType(type: UIImagePickerControllerSourceType) {
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
    
//    create and share memed image
    
    func generateMemedImage() -> UIImage {
        self.navBar.hidden = true
        self.toolbar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navBar.hidden = false
        self.toolbar.hidden = false
        
        return memedImage
    }
    
    func saveMeme(memedImage: UIImage) {
        let meme = Meme(topText: topMemeText.text!, bottomText: bottomMemeText.text!, image: memeImage.image!, memedImage: memedImage)
    }
    
    @IBAction func share(sender: AnyObject) {
        
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        controller.completionWithItemsHandler = { activity, success, items, error in
            self.saveMeme(memedImage)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
//    cancel
    
    func setToLaunchState() {
        self.topMemeText.text = "TOP"
        self.bottomMemeText.text = "BOTTOM"
        self.memeImage.image = nil
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        setToLaunchState()
    }
    
    //    image picker delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if let newImage = info["UIImagePickerControllerOriginalImage"] {
            self.memeImage.image = newImage as? UIImage
            self.shareButton.enabled = true
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
    
//    keyboard notifications
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

}

