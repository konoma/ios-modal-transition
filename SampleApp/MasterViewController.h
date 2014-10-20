//
//  MasterViewController.h
//  SampleApp
//
//  Created by Markus Gasser on 16.10.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MasterViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *presentDetailButton;
@property (nonatomic, weak) IBOutlet UISegmentedControl *detailOrientationSwitch;

- (IBAction)presentDetail:(UIButton *)sender;

@end
