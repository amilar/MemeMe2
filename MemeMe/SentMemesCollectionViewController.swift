//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Lars Halvorsen on 13/06/16.
//  Copyright © 2016 Amilar sprl. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    // Get a list of all MeMes
    var allMemes = (UIApplication.sharedApplication().delegate as!
        AppDelegate).memes
   
    //TODO: Add outlet to flowLayout here.
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadMemes()
       self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addMeme))
        self.tabBarController?.tabBar.hidden = false
    }
    
    func addMeme() {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        presentViewController(vc, animated: true, completion: loadMemes)
    }
    
    func loadMemes() {
        allMemes = (UIApplication.sharedApplication().delegate as!
            AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Implement flowLayout here.
        let space: CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (5 * space)) / 6.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(width, height)
    }
    
    // MARK: Collection View Data Source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allMemes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = allMemes[indexPath.item]
        cell.setText(meme.topText, bottomString: meme.bottomText)
        // Set the image
        let imageView = UIImageView(image: meme.origImage)
        cell.backgroundView = imageView
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")
        let detailVC = object as! MemeDetailViewController
        detailVC.meme = self.allMemes[indexPath.row]
        navigationController!.pushViewController(detailVC, animated: true)
        
    }
    
}