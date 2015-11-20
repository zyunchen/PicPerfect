//
//  RecorderAudio.swift
//  PichPerfect
//
//  Created by zhangyunchen on 15/11/16.
//  Copyright © 2015年 zhangyunchen. All rights reserved.
//

import Foundation
public class RecordedAudio:NSObject {
    
    var filePathUrl: NSURL!
    var title:String!
    
    public init(filepath:NSURL,title:String) {
        self.filePathUrl = filepath
        self.title = title
    }
    
}
