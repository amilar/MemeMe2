//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Lars Halvorsen on 06/05/16.
//  Copyright © 2016 Amilar sprl. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var pictureToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!

    
    // The meme text attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),  // Outline
        NSForegroundColorAttributeName : UIColor.whiteColor(),  // Fill
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]

    
    // ===== Overridden functions =====
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextFields()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        subscribeToKeyboardNotifications()
        
        // Enable the camera button if a camera is available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Check whether the Share button should be enabled
        enableDisableShareButton()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from keyboard notifications
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // ===== Keyboard notifications =====
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if (bottomTextField.isFirstResponder()) {
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
        else if topTextField.isFirstResponder(){
            view.frame.origin.y = 0
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if (bottomTextField.isFirstResponder()) {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    
    // ===== Image picker support =====
    
    func pickAnImage(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    // ===== Text field support =====
    
    // Initialize the top & bottom text fields to default text and attributes
    func initializeTextFields() {
        initializeOneTextField(topTextField, theText: "TOP")
        initializeOneTextField(bottomTextField, theText: "BOTTOM")
    }

    func initializeOneTextField(textField: UITextField, theText: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
        textField.text = theText
        textField.delegate = self
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    
    // ===== Utility functions =====
    
    func enableDisableShareButton() {
        shareButton.enabled = imagePickerView.image != nil
    }
    
 
    // ===== Support functions to create/save meme'd image =====
    
    func save() {
        
        //Create the meme
        let meme = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!, origImage:imagePickerView.image!, memedImage: generateMemedImage())
        
        (UIApplication.sharedApplication().delegate as!
            AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        topToolbar.hidden = true
        pictureToolbar.hidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        topToolbar.hidden = false
        pictureToolbar.hidden = false

        return memedImage
    }
    
    // ===== Action handlers =====
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        pickAnImage(UIImagePickerControllerSourceType.PhotoLibrary)
    }

    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        pickAnImage(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        let memedImage = generateMemedImage()
        
        let avCtl = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        avCtl.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(avCtl, animated: true, completion: nil)
    }
    
    @IBAction func resetImage(sender: AnyObject) {
        imagePickerView.image = nil
        initializeTextFields()
        enableDisableShareButton()
    }
}

