//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Lars Halvorsen on 13/06/16.
//  Copyright © 2016 Amilar sprl. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    // Get a list of all MeMes
    var allMemes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collView: UICollectionView!
    
    // ===== Overridden functions =====
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collView.reloadData()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addMeme))
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Collection View Data Source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allMemes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = allMemes[indexPath.item]
        // Set the image
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
    
    // ===== Add Meme function =====

    func addMeme() {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    
}