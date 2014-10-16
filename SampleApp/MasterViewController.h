//
//  MasterViewController.h
//  SampleApp
//
//  Created by Markus Gasser on 16.10.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MasterViewController : UIViewController

@property (nonatomic, weak) IBOutlet UISegmentedControl *detailOrientationSwitch;
@property (nonatomic, weak) IBOutlet UISegmentedControl *presentationStyleSwitch;

- (IBAction)presentDetail:(id)sender;

@end

