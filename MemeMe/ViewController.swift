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
    
    var normalOriginY: CGFloat!
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        shareButton.enabled = (memeImage.image != nil)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        store this to ensure view returns to original position (first responder not guranteed when hiding keyboard)
        normalOriginY = view.frame.origin.y
        styleTextField(topMemeText)
        styleTextField(bottomMemeText)
        setToLaunchState()
        topMemeText.delegate = self
        bottomMemeText.delegate = self
    }
    
    func styleTextField(textField: UITextField) {
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.borderStyle = UITextBorderStyle.None
        textField.textAlignment = NSTextAlignment.Center
    }
    
//    choose image
    
    func presentImagePickerWithSourceType(type: UIImagePickerControllerSourceType) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = type
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        presentImagePickerWithSourceType(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        presentImagePickerWithSourceType(UIImagePickerControllerSourceType.Camera)
    }
    
//    create and share memed image
    
    func generateMemedImage() -> UIImage {
        navBar.hidden = true
        toolbar.hidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navBar.hidden = false
        toolbar.hidden = false
        
        return memedImage
    }
    
    func saveMeme(memedImage: UIImage) {
        let meme = Meme(topText: topMemeText.text!, bottomText: bottomMemeText.text!, image: memeImage.image!, memedImage: memedImage)
        
        //Add to memes array in App Delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    @IBAction func share(sender: AnyObject) {
        
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        controller.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.saveMeme(memedImage)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
//    cancel
    
    func setToLaunchState() {
        topMemeText.text = "TOP"
        bottomMemeText.text = "BOTTOM"
        memeImage.image = nil
        shareButton.enabled = false
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        setToLaunchState()
    }
    
    //    image picker delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let newImage = info["UIImagePickerControllerOriginalImage"] {
            memeImage.image = newImage as? UIImage
            shareButton.enabled = true
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//    text field delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == topMemeText && textField.text == "TOP") || (textField == bottomMemeText && textField.text == "BOTTOM") {
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
        if bottomMemeText.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = normalOriginY
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

