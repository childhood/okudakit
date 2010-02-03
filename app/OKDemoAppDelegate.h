//
//  OKDemoAppDelegate.h
//  OkudaKit
//
//  Created by Todd Ditchendorf on 7/27/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class OKSyntaxHighlighter;

@interface OKDemoAppDelegate : NSObject {
    IBOutlet NSWindow *window;
    IBOutlet NSTextView *textView;
    
    NSAttributedString *displayString;
}

- (IBAction)highlight:(id)sender;

@property (nonatomic, copy) NSAttributedString *displayString;
@end
