//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Lars Halvorsen on 18/06/16.
//  Copyright © 2016 Amilar sprl. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var allMemes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    // ===== Overridden functions =====

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addMeme))
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allMemes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")! as! MemeTableViewCell
        let meme = self.allMemes[indexPath.row]
        
        // Set the name and image
        cell.memeText?.text = meme.topText + " " + meme.bottomText
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.allMemes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    // ===== Add Meme function =====

    func addMeme() {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    
}
