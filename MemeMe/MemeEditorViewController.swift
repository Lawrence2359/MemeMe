//
//  ViewController.swift
//  MemeMe
//
//  Created by Lawrence Tan on 9/25/15.
//  Copyright © 2015 2359Media. All rights reserved.
//

import UIKit
import Foundation

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var btnShare: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnAlbum: UIBarButtonItem!
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    @IBOutlet weak var txtTop: UITextField!
    @IBOutlet weak var txtBottom: UITextField!
    
    var selectedMeme: Meme!
    
    var isShowMeme: Bool!
    
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
        setupView()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        btnCamera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
        subscribeToKeyboardWillHideNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeToKeyboardNotifications()
        unsubscribeToKeyboardWillHideNotifications()
    }
    
    func setupView() {
        txtTop.defaultTextAttributes = memeTextAttributes
        txtBottom.defaultTextAttributes = memeTextAttributes
        txtTop.textAlignment = .Center
        txtBottom.textAlignment = .Center
        txtTop.tag = 1
        txtBottom.tag = 2
        
        if(isShowMeme==false){
            btnShare.enabled = false
            txtTop.placeholder = "Input top text here"
            txtBottom.placeholder = "Input bottom text here"
        }else{
            btnShare.enabled = true
            txtTop.enabled = false
            txtBottom.enabled = false
            txtTop.text = selectedMeme.topText
            txtBottom.text = selectedMeme.bottomText
            btnCamera.enabled = false
            btnCamera.enabled = false
            imageView.image = selectedMeme.originalImage
            self.tabBarController?.tabBar.hidden = true
            toolBar.hidden = true
        }
        
    }
    
// MARK: - Actions
    
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
    
    @IBAction func onShare(sender: AnyObject) {
        share(generateMemedImage())
    }
    
// MARK: - ImagePickerController Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.ScaleAspectFill;
        btnShare.enabled = true
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
// MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTxtField = textField
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
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigationController?.navigationBarHidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    
    func save(){
        if(validateFields()){
            let meme = Meme(topText:txtTop.text!, bottomText:txtBottom.text!, originalImage:imageView.image!, memedImage:generateMemedImage())
            // Add it to the memes array in the Application Delegate
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(meme)
        }else{
            showAlertWithMessage("Missing Fields", message: "Please input message and text")
        }
    }
    
    func validateFields() -> Bool {
        if ((txtTop.text != "") || (txtBottom.text != "")){
            if imageView.image != nil {
                return true
            }
        }
        return false
    }
    
    func showAlertWithMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func share(memedImage: UIImage) {
        let shareItems:Array = [memedImage]
        let activityViewController:UIActivityViewController! = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func onClose(sender: AnyObject) {
        if(isShowMeme == false){
            save()
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
        

}

