//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Jennifer Louthan on 1/24/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController: UICollectionViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    var spacePortrait: CGFloat = 3.0
    var numInRowPortrait: CGFloat = 3
    
    var spaceLandscape: CGFloat = 3.0
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let portraitWidth = min(self.view.frame.width, self.view.frame.height)
        let width = (portraitWidth - ((numInRowPortrait - 1) * spacePortrait)) / numInRowPortrait
        
        let landscapeWidth = max(self.view.frame.width, self.view.frame.height)
        let extraSpaceLandscape = landscapeWidth % width
        let n = floor(landscapeWidth / width)
        spaceLandscape = extraSpaceLandscape / (n - 1)
        
        adjustFlowLayoutSpacing(self.view.frame.size)
        flowLayout.itemSize = CGSizeMake(width, width)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if flowLayout != nil {
            adjustFlowLayoutSpacing(size)
        }
    }
    
    //MARK: Flow Layout
    
    func adjustFlowLayoutSpacing(size: CGSize) {
        let space = size.width > size.height ? spaceLandscape : spacePortrait
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
    }
    
    // MARK: Collection View Data Source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        // Set the cell image
        cell.imageView.image = meme.image
        cell.topLabel.text = meme.topText
        cell.bottomLabel.text = meme.bottomText
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
}
