//
//  User.m
//  twitter
//
//  Created by josemurillo on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

// Method initializaes the object and returns a user
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        // Initializes properties
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileURL = dictionary[@"profile_image_url_https"];
        
    }
    return self;
}

@end
