/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

// クラスの宣言、UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate を追加
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    // StoryboardからのOutlet接続
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var dockViewHeightConstraint: NSLayoutConstraint!

    var messagesArray:[String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self

        // Set self as the delegate for the text field
        self.messageTextField.delegate = self

        // Add a tap gesture recognizer to the table view
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tableViewTapped")
        self.messageTableView.addGestureRecognizer(tapGesture)

        /* Add some sample data so that we can see something
        self.messagesArray.append("Text 1")
        self.messagesArray.append("Text 2")
        self.messagesArray.append("Text 3")
        */

        // Retrieve messages from Parse.com
        self.retrieveMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Send button is tapped
    @IBAction func sendButtonTapped(sender: UIButton) {

        // Call the end editing method for the text field
        self.messageTextField.endEditing(true)

        // Disabable the send button and text field
        self.sendButton.enabled = false
        self.messageTextField.enabled = false

// Create a PFObject
        var newMessageObject:PFObject = PFObject(className:"Message")

// Set the Text key to the text of the messageTextField
// コラムの追加
        newMessageObject["Text"] = self.messageTextField.text

// Save the PFObject
        newMessageObject.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if (success == true) {

                // Retrieve the latest messages andn reload the table
                self.retrieveMessages()
                NSLog("Message saved successfully.")
            }
            else {

                // somethng bad happend
                NSLog(error!.description)
            }

            dispatch_async(dispatch_get_main_queue()) {

            // Enable the text field and send button
            self.sendButton.enabled = true
            self.messageTextField.enabled = true
            self.messageTextField.text = ""
            }
        }
    }

    func retrieveMessages() {

// Create a new PFQuery
        var query:PFQuery = PFQuery(className:"Message")

// Call findObjectsInBackground
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in

            // Clear the messagesArray
            self.messagesArray = [String]()

            // Loop through the objects array
            for messageObject in objects! {

                // Retrieve the Text column value of each PFObject
                var messageText:String? = (messageObject as PFObject)["Text"] as! String

                // Assign it into our messagesArray
                if messageText != nil {
                    self.messagesArray.append(messageText!)
                }
            }

            dispatch_async(dispatch_get_main_queue()) {

                // Reload the table view
                self.messageTableView.reloadData()
            }
        }
    }

    func tableViewTapped() {

        // Force the text field on end editing
        self.messageTextField.endEditing(true)
    }

    // MARK: Text field delegate methods
    func textFieldDidBeginEditing(textField: UITextField) {

        // Perform an animation to grow the dock view
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            self.dockViewHeightConstraint.constant = 285
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    func textFieldDidEndEditing(textField: UITextField) {
        self.view.layoutIfNeeded()

        self.messageTextField.enabled = false
        self.sendButton.enabled = true

        UIView.animateWithDuration(0.5, animations: {
            self.dockViewHeightConstraint.constant = 60
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.messageTableView.dequeueReusableCellWithIdentifier("MessageCell") as UITableViewCell!
        cell!.textLabel?.text = self.messagesArray[indexPath.row]
        return cell!
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }

}