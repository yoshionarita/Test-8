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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var dockViewHeightConstraint: NSLayoutConstraint!

    var messagesArray:[String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        self.messageTextField.delegate = self

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tableViewTapped")
        self.messageTableView.addGestureRecognizer(tapGesture)

        self.sendButton.enabled = false

        self.messagesArray.append("Arizona")
        self.messagesArray.append("Brazil")
        self.messagesArray.append("Carter's")
        self.messagesArray.append("Denver")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendButtonTapped(sender: UIButton) {
        self.messageTextField.endEditing(true)

        self.sendButton.enabled = false
        self.messageTextField.enabled = false

        var newMessageObject:PFObject = PFObject(className: "Message")
        newMessageObject["Text"] = self.messageTextField.text

        newMessageObject.saveInBackgroundWithBlock {
        (success: Bool, error: NSError?) -> Void in
            if (success == true) {
                NSLog("Message saved successfully.")
            } else {
                NSLog(error!.description)
            }
            self.sendButton.enabled = true
            self.messageTextField.enabled = true
            self.messageTextField.text = ""
        }
    }

    func tableViewTapped() {
        self.messageTextField.endEditing(true)
    }

    func textFieldDidBeginEditing(textField: UITextField) {
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
