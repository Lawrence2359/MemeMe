//
//  ViewController.swift
//  MemeMe
//
//  Created by Lawrence Tan on 9/25/15.
//  Copyright © 2015 2359Media. All rights reserved.
//

import UIKit
import Foundation

struct Meme {
    var text: String
    var image: UIImage
    var memedImage: UIImage
    
    init(text: String, image: UIImage, memedImage: UIImage){
        self.text = text
        self.image = image
        self.memedImage = memedImage
    }
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var btnShare: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnAlbum: UIBarButtonItem!
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    @IBOutlet weak var txtTop: UITextField!
    @IBOutlet weak var txtBottom: UITextField!
    
    var activeTxtField: UITextField!
    
    let memeTextAttributes = [        
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 60)!,
        NSStrokeWidthAttributeName : CGFloat(-5.0)
    ]
    
// MARK: Main Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.btnCamera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
        self.subscribeToKeyboardWillHideNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeToKeyboardNotifications()
        self.unsubscribeToKeyboardWillHideNotifications()
    }
    
    func setupView() {
        self.txtTop.defaultTextAttributes = memeTextAttributes
        self.txtBottom.defaultTextAttributes = memeTextAttributes
        self.txtTop.textAlignment = .Center
        self.txtBottom.textAlignment = .Center
        self.txtTop.tag = 1
        self.txtBottom.tag = 2
        self.btnShare.enabled = false
    }
    
// MARK: - Actions
    
    func tappedView() {
        //self.activeTxtField.resignFirstResponder()
    }
    
    @IBAction func onAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        [self .presentViewController(imagePicker, animated: true, completion: nil)]
    }
    
    @IBAction func onCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        [self .presentViewController(imagePicker, animated: true, completion: nil)]
    }
    
    @IBAction func onSave(sender: AnyObject) {
        //Create the meme
        let combinedText = self.txtTop.text! + self.txtBottom.text!
        let meme = Meme( text: combinedText, image:
            self.imageView.image!, memedImage: self.generateMemedImage())
        //var messageStr:String  = "Check out my awesome iPicSafe photo!"
        //var shareItems:Array = [img, messageStr]
        let shareItems:Array = [meme.memedImage]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
// MARK: - ImagePickerController Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.imageView.image = image
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill;
        self.btnShare.enabled = true
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
// MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTxtField = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
// MARK: - Keyboard Notifications
        
    func keyboardWillShow(notification: NSNotification) {
        if(activeTxtField.tag == 2){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if(activeTxtField.tag == 2){
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardWillHideNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardWillHideNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
// MARK: - Image Methods
    
    func generateMemedImage() -> UIImage
    {
        self.navigationController?.navigationBarHidden = true
        self.toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigationController?.navigationBarHidden = false
        self.toolBar.hidden = false
        
        return memedImage
    }

}

