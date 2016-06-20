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
    var allMemes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collView: UICollectionView!
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collView.reloadData()
        
       self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addMeme))
        self.tabBarController?.tabBar.hidden = false
    }
    
    func addMeme() {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let space: CGFloat = 3.0
//        let width = (view.frame.size.width - (2 * space)) / 3.0
//        let height = (view.frame.size.height - (4 * space)) / 5.0
//        
//        flowLayout.minimumInteritemSpacing = space
//        flowLayout.itemSize = CGSizeMake(width, height)
    }
    
    // MARK: Collection View Data Source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allMemes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = allMemes[indexPath.item]
        // Set the image
//        let imageView = UIImageView(image: meme.memedImage)
//        cell.backgroundView = imageView
        cell.memeImageView.image = meme.memedImage
        
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