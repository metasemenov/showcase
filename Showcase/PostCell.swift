//
//  PostCell.swift
//  Showcase
//
//  Created by Admin on 03.10.16.
//  Copyright © 2016 EvilMint. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likesImg: UIImageView!
    
    var post: Post!
    var likesRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likesImg.addGestureRecognizer(tap)
        likesImg.isUserInteractionEnabled = true
    }

    override func draw(_ rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        showcaseImg.clipsToBounds = true
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        self.descriptionText.text = post.postDescription
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil {
            self.showcaseImg.image = img
        } else {
            if let imgUrl = post.imgUrl {
                let ref = FIRStorage.storage().reference(forURL: imgUrl)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("OCTO: download img fail")
                    } else {
                        print("OCTO: img check")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.showcaseImg.image = img
                                FeedViewController.imgCache.setObject(img, forKey: imgUrl as NSString)
                            }
                        }
                    }
                })
            }
            
            likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull{
                    self.likesImg.image = UIImage(named: "heart-empty")
                } else {
                    self.likesImg.image = UIImage(named: "heart-full")
                }
            })
        }

    }

    func likeTapped(sender: UIGestureRecognizer) {
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.likesImg.image = UIImage(named: "heart-full")
                self.post.addJustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.likesImg.image = UIImage(named: "heart-empty")
                self.post.addJustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }
    
}
