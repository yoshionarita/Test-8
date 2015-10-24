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

        self.messagesArray.append("Arizona")
        self.messagesArray.append("Brazil")
        self.messagesArray.append("Carter's")
        self.messagesArray.append("Denver")

/*
        let testObject:PFObject = PFObject(className: "TestObject")
        testObject["name"] = "kako"
        testObject.saveInBackgroundWithBlock(nil)
*/
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendButtonTapped(sender: UIButton) {

    }

    func textFieldDidBeginEditing(textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            self.dockViewHeightConstraint.constant = 310
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    func textFieldDidEndEditing(textField: UITextField) {
        self.view.layoutIfNeeded()
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
