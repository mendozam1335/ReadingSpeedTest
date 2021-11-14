//
//  FirstViewController.swift
//  Assignment4_Mario_Mendoza
//
//  Created by mario mendoza on 7/24/20.
//  Copyright © 2020 mario mendoza. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {

    let defaults = UserDefaults.standard
    var users: UserDB!
    var timer = Timer()
    var interval = 0.16
    var words: [String] = []
    var counter: Int = 0
    var delay: Int = 0
    
    /* function to retrieve all user defaults and place them into variables used throughout the program
     variables: interval : timer interval to dispaly words
                delay: delay between hitting start button and displaying words
                fullname: gets name of current user to display at top
     */
    func reload(){
        interval = 60 / (defaults.value(forKey: "defaultSpeed") as! Double)
        delay = (defaults.value(forKey: "delay") as! Int)
        let fullname = (defaults.value(forKey: "currentUser") as! String)
        userLabel.text = fullname
    }
    
    /* Set user defaults to be used throughout program for variables like interval, delay, and current user
      created notification observers to archive users and unarchive users
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        users = UserDB()
        
        self.WordsPerMinute.delegate = self
        WordsPerMinute.becomeFirstResponder()

        defaults.setValue(60.0, forKey: "defaultSpeed")
        defaults.setValue(2, forKey: "delay")
        defaults.setValue("", forKey: "currentUser")
        
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.unarchive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.archive(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let speed = Double(WordsPerMinute.text!){
            setWPM(speed)
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        WordsPerMinute.resignFirstResponder()
        if let speed = Double(WordsPerMinute.text!) {
            setWPM(speed)
        }
        
        self.view.endEditing(true)
    }
    
    /** Convert words per minute into an interval to be used by timer*/
    func setWPM(_ speed: Double){
        interval = 60 / speed
    }
    
    /** pass user information inot the second view controller whihc is a table view controller to display users and their speeds
     calls reload to relaod all user defaults */
    override func viewDidAppear(_ animated: Bool) {
        (self.tabBarController?.viewControllers?[1] as! SecondViewController).user = users
        reload()
        self.WordsPerMinute.becomeFirstResponder()
    }
    
    @IBOutlet weak var displayWords: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var WordsPerMinute: UITextField!
    
    /** Function called every tick to display words onto screen
     changes middle letter of every word into a red color
     Text already split into an array of words by start action
     When reaches end of array, stop timer and add attempt onto current user*/
    @objc func updateWords(){
        if counter < words.count{
            let word = words[counter]
            let myMutableText = NSMutableAttributedString(string: word)
            let loc = word.count / 2
            myMutableText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: loc, length: 1))
            
            displayWords.attributedText = myMutableText
           // print("\(counter) \(word)")
            counter += 1
        }else{
            timer.invalidate()
            counter = 0
            users.getCurrentUser().addAttempt(speed: 60 / interval)
        }
    }
    /**Start button action checks to see if any registered users before it actually displays words
     if no active users, then show msg and force user to register new user
     retrieve file using bundle file and manager file and split text into words
     further filters those words by removing characters that are not a period
     Also acts as a pause button */
    @IBAction func start(_ sender: Any) {
        if users.count() == 0{
            showAlert(title: "No Registered User", msg: "Must First Register a User to start")
        }else{
            let seperator = CharacterSet(charactersIn: " ,-\n")
            if let path = Bundle.main.path(forResource: "SpeedTest", ofType: "txt"){
                if let text = try? String(contentsOfFile: path, encoding: String.Encoding.utf8){
                    let tmpWords = text.components(separatedBy: seperator)
                    words = tmpWords.filter{ (x) -> Bool in !x.isEmpty}
                    
                    if !timer.isValid{
                        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(FirstViewController.updateWords), userInfo: nil, repeats: true)
                        sleep(UInt32(delay))
                    }else if timer.isValid{
                        timer.invalidate()
                    }
                }
            }
        }
    }
    
    /** Unwind segue action comming from Login view controller upong clicking register button
        retrieve user from registered user and add it onto UserDB
     set new user as current user
     set default values used for entire program
     pops all view controllers in previos Navigation Stack so that when swithing between apps, goes back to root instead of previous view controller
     */
    @IBAction func newUser(segue: UIStoryboardSegue){
        if segue.identifier == "register"{
            let dest = segue.source as! LoginViewController
            users.addUser(dest.user)
            let idx = users.getIndexOfUser(dest.user)
            users.setCurrentUser(idx)
            defaults.setValue(users.getCurrentUser().fullName(), forKey: "currentUser")
            userLabel.text = users.getCurrentUser().fullName()
            
           let userListController = self.tabBarController?.viewControllers![2] as! UINavigationController
            userListController.popToRootViewController(animated: false)
            archive()
        }
    }
    /**Unwind segue action comming from user list controller upon clicking a cell
     sets that user clicked as current user and set defauts
     pops all previous view controllers on Navigation stack*/
    @IBAction func changeUser(segue: UIStoryboardSegue){
        if segue.identifier == "changeUser"{
            let dest = segue.source as! UserListTableViewController
            let selectedRow = dest.tableView.indexPathForSelectedRow?.row ?? 0
            users.setCurrentUser(selectedRow)
            let cu = users.getCurrentUser().fullName()
            defaults.setValue(cu, forKey: "currentUser")
            reload()
            if let userListController = segue.source as? UINavigationController{
                if userListController.topViewController is LoginViewController{
                    userListController.popViewController(animated: true)
                }
            }
        }
    }
    /**Function used to segue onto register new user if no user is detected*/
    func registerNewUSer(){
        performSegue(withIdentifier: "goto", sender: self)
    }
    /** Manually Archive users using NSKeyed archiver*/
    func archive(){
        let path = NSHomeDirectory() + "/Documents/userNotification.archive"
        
        NSKeyedArchiver.archiveRootObject(users.user, toFile: path)
    }
    /** Manually UnArchive users using NSKeyed Unarchiver*/
    func unarchive(){
        let path = NSHomeDirectory() + "/Documents/userNotification.archive"
        let manager = FileManager.default
        if manager.fileExists(atPath: path){
            users.user = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! [User]
        }else{
            registerNewUSer()
        }
    }
    /** Use notification to archive users in case user quits app*/
    @objc func archive(_ notification: Notification){
        let path = NSHomeDirectory() + "/Documents/userNotification.archive"
        NSKeyedArchiver.archiveRootObject(users.user, toFile: path)
    }
    /** Use notification center to try and unarchive users stored in home directory upon opening app
     if no file detected then go to register a new user*/
    @objc func unarchive(_ notification: Notification){
        let path = NSHomeDirectory() + "/Documents/userNotification.archive"
        let manager = FileManager.default
        if manager.fileExists(atPath: path){
            users.user = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! [User]
            reload()
            for i in users.user{
                i.setTopScore()
            }
        }else{
            registerNewUSer()
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    /** function used to show alerts.
     Primarily used if trying to start the program without registering a new user
     Only Option is to send user to login view controller to create a new user */
    func showAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Register", style: .cancel, handler: {action in self.performSegue(withIdentifier: "goto", sender: self)})
        
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
    }
}

