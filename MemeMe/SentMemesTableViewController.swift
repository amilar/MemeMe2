//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Lars Halvorsen on 18/06/16.
//  Copyright © 2016 Amilar sprl. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource {
    
    var allMemes = (UIApplication.sharedApplication().delegate as!
        AppDelegate).memes
    
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allMemes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")!
        let meme = self.allMemes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.allMemes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}
