//
//  ViewController.swift
//  On-The-Map
//
//  Created by Vasanth Kodeboyina on 6/25/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate
{
    
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    
    var selectedTextField: UITextField!
    
    let loginButton: FBSDKLoginButton =
        {
            let button = FBSDKLoginButton()
            button.readPermissions = ["email"]
            
            return button
    }()

    
    // MARK: - View Cycle Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        view.addSubview(loginButton)
        loginButton.delegate = self
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraintsToFacebookButton(loginButton)
        signUpButtonOutlet.enabled = true

    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(true)
        unsubsribeToKeyboardNotification()
        emailIDTextField.text = nil
        passwordTextField.text = nil
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        view.endEditing(true) // KeyBoard will disappear when user Tap on view
    }
    

    // MARK: - Alert Methods

    // Alert Message with Ok Action for error in email ID and Password
    func createAlertWithMessage(title: String, message: String)
    {
        let UIAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        UIAlert.addAction(UIAlertAction(title: "ok",style: .Default, handler: {(ACTION:UIAlertAction!) in }))
        presentViewController(UIAlert, animated: true, completion: nil)
    }

    
    // MARK: - KeyBoard Resigning and Notification
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        selectedTextField = textField
    }
    
    // Calculation of keyBoard Height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    // Move frame upward
    func keyboardWillShow(notification: NSNotification)
    {
        if ((selectedTextField != nil && (selectedTextField == emailIDTextField || selectedTextField == passwordTextField)) && self.view.frame.origin.y == 0.0)
        {
            let keyBoardTop = view.frame.height - getKeyboardHeight(notification)
            let diffADD = (keyBoardTop - selectedTextField.frame.maxY)
            if (keyBoardTop - selectedTextField.frame.maxY) < 40
            {
                self.view.frame.origin.y -= (40-diffADD)
            }
        }
    }
    
    // Move frame back to its original position
    func keyboardWillHide(notification: NSNotification)
    {
        if -self.view.frame.origin.y > 0
        {
            self.view.frame.origin.y = 0
        }
    }
    
    //Suscribe the view controller to the UIKeyboardWillShowNotification:
    func subscribeToKeyboardNotification()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Unsubscribe the view controller to the UIKeyboardWillShowNotification:
    func unsubsribeToKeyboardNotification()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    // MARK: - Login Button Actions

    @IBAction func LoginButtonPressed(sender: AnyObject)
    {
        // create Alert if emailID is nil
        if emailIDTextField.text == ""
        {
            createAlertWithMessage("Login Failed", message: "Invalid Email ID")
            return
        }
       
        // create Alert if password is nil
        if passwordTextField.text == ""
        {
            createAlertWithMessage("Login Failed", message: "Invalid Password ID")
            return
        }
        
        // Disable login Button
        loginButtonOutlet.enabled = false
        
        //print("username: \(self.emailIDTextField.text! as String)")
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(emailIDTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil
            {
                // create Error Alert
                self.createAlertWithMessage("Login Failed", message: "We are not able to process the request, please try again later.")
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
         //   print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            do {
                self.loginButtonOutlet.enabled = true
                let json = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
                //print("JSON Data >> \(json)")
            
                // Checking whether json value exists or not
                if(json.valueForKey("status") != nil)
                {
                    let jsonStatus = json .valueForKey("status") as! NSNumber
                    let errorMessage = json["error"] as! String
              
                    if (jsonStatus == 403)
                    {
                        dispatch_async(dispatch_get_main_queue(), {
                        self.createAlertWithMessage("Login Failed", message: errorMessage)
                        })
                        return
                    }
                }

                let user = User.sharedInstance
                user.updateUserCredentials(json)
                let userLM = UserLocationManager.locationManagerSharedInstance
                userLM.getLoginUserDetails()
                
                // segue call
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("loginScreenToTabViewSegue", sender: self)
                })
            }
            catch {
                
            }
        }
        task.resume()
    }

    
    // MARK: - SignUp Button Actions

    @IBAction func signUpButtonPressed(sender: AnyObject)
    {
        //disable signup Button
        signUpButtonOutlet.enabled = false
        
        let url = NSURL(string : "https://www.udacity.com/account/auth#!/signin")
        UIApplication.sharedApplication().openURL(url!)
    }

 
    // MARK: - Facebook Button Actions
    
    @IBAction func facebookButtonPressed(sender: AnyObject)
    {
        print("facebook button pressed")
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("Login Completed")
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Logout Complete")
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func addConstraintsToFacebookButton(loginButton: FBSDKLoginButton)
    {
        /* Add constraints for FB Login Button */
        loginButton.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 40).active = true
        loginButton.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -40).active = true
        loginButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -20).active = true
        loginButton.heightAnchor.constraintEqualToConstant(30).active = true
    }
    
    
}

