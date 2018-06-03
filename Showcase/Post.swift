//
//  Post.swift
//  Showcase
//
//  Created by Admin on 05.10.16.
//  Copyright © 2016 EvilMint. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _postDescription: String!
    private var _imgUrl: String?
    private var _userName: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    
    var postDescription: String {
        return _postDescription
    }
    
    var imgUrl: String? {
        return _imgUrl
    }
    
    var userName: String {
        return _userName
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(description: String, imgUrl: String?, userName: String) {
        self._postDescription = description
        self._imgUrl = imgUrl
        self._userName = userName
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let imgUrl = dictionary["imgUrl"] as? String? {
            self._imgUrl = imgUrl
        }
        
        if let desc = dictionary["description"] as? String {
            self._postDescription = desc
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
    }
    
    func addJustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
}
