//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Lawrence Tan on 9/28/15.
//  Copyright © 2015 2359Media. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        collectionView?.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
        collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionCell
        let meme = memes[indexPath.row]
        //cell.lblTop.text = meme.topText
        //cell.lblBottom.text = meme.bottomText
        let imageView = UIImageView(image: meme.memedImage)
        cell.backgroundView = imageView
        cell.backgroundView?.contentMode = UIViewContentMode.ScaleAspectFit
        cell.lblBottom.hidden = true
        cell.lblTop.hidden = true
        
        return cell
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
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
