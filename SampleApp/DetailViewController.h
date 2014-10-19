//
//  DetailViewController.h
//  KNMModalTransitions
//
//  Created by Markus Gasser on 16.10.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *closeButton;

@property (nonatomic, assign) UIInterfaceOrientation preferredInterfaceOrientationForPresentation;

- (IBAction)close:(id)sender;

@end
