//
//  SignupVC.swift
//  StudyBuddy
//
//  Created by Moez Hudda on 10/18/14.
//  Copyright (c) 2014 Moez Hudda. All rights reserved.
//

import UIKit
import AudioToolbox
import QuartzCore

class SignupVC: UIViewController {

    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textConfirmPassword: UITextField!
    @IBOutlet weak var textEmailAddress: UITextField!
    @IBOutlet weak var textDisplayName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBAction func noLogin(sender: AnyObject) {
        var username:NSString = textUsername.text as NSString
        var password:NSString = textPassword.text as NSString
        var confirmPassword:NSString = textConfirmPassword.text as NSString
        var emailAddress:NSString = textEmailAddress.text as NSString
        var displayName:NSString = textDisplayName.text as NSString
        var isOkay = true
        
        
        
        
        if(username.isEqualToString("") || password.isEqualToString(""))
        {
            var alert:UIAlertView = UIAlertView()
            alert.title = "Sign up failed"
            alert.message = "Pleaes enter Username and Password"
            alert.delegate = self
            alert.addButtonWithTitle("Ok")
            alert.show()
            isOkay = false
        }
        if (!password.isEqual(confirmPassword))
        {
            var alert:UIAlertView = UIAlertView()
            alert.title = "Sign up failed"
            alert.message = "Passwords don't match"
            alert.delegate = self;
            alert.addButtonWithTitle("Ok")
            alert.show()
            isOkay = false
        }
        else {
            
            var post:NSString = "username=\(username)&password=\(password)&c_password=\(confirmPassword)"
            
            NSLog("PostData: %@",post);
            
            var url:NSURL = NSURL.URLWithString("http://funpatent.com/jsonsignup.php")
            
            //var url:NSURL = NSURL.URLWithString("http://dipinkrishna.com/jsonsignup.php")
            
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            var postLength:NSString = String( postData.length )
            
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
            
            if ( urlData != nil ) {
                let res = response as NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)
                    
                    NSLog("Response ==> %@", responseData);
                    
                    var error: NSError?
                    
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as NSDictionary
                    
                    
                    let success:NSInteger = jsonData.valueForKey("success") as NSInteger
                    
                    //[jsonData[@"success"] integerValue];
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
                        NSLog("Sign Up SUCCESS");
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign Up Failed!"
                        alertView.message = error_msg
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
                    
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign Up Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            }  else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}
