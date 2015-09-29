//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Lawrence Tan on 9/28/15.
//  Copyright © 2015 2359Media. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView.init()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell", forIndexPath: indexPath) as! MemeTableCell
        
        cell.imgView.image = memes[indexPath.row].originalImage
        cell.imgView.contentMode = UIViewContentMode.ScaleAspectFill
        cell.lblTxt.text = "\(memes[indexPath.row].topText) \(memes[indexPath.row].bottomText)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedMeme = memes[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dst = storyboard.instantiateViewControllerWithIdentifier("MemeEditorViewControllerNav") as! UINavigationController
        let vc: MemeEditorViewController = dst.topViewController as! MemeEditorViewController
        vc.selectedMeme = selectedMeme
        vc.isShowMeme = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Add Meme"){
            let viewController:UINavigationController = segue.destinationViewController as! UINavigationController
            let vc:MemeEditorViewController = viewController.topViewController as! MemeEditorViewController
            vc.isShowMeme = false
        }
    }

}
