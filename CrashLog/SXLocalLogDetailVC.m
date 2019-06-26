//
//  SXLocalLogDetailVC.m
//  SXExceptionLog
//
//  Created by Sunny on 2018/11/23.
//  Copyright © 2018 Sunny. All rights reserved.
//

#import "SXLocalLogDetailVC.h"
#import "SXMacro.h"

@interface SXLocalLogDetailVC ()

@property (nonatomic, strong) UITextView *logTextView;
@property (nonatomic, strong) id logData;

@end

@implementation SXLocalLogDetailVC

- (id)initWithLogDict:(id)logData
{
    self = [super init];
    if (self)
    {
        _logData = logData;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"内功精要";
    
    [self.view sendSubviewToBack:self.logTextView];
    
    if ([_logData isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *logDict = _logData;
        NSArray *keys = logDict.allKeys;
        NSMutableString *str = [[NSMutableString alloc] init];
        for (int i = 0; i<keys.count; i++)
        {
            NSString *key = [keys objectAtIndex:i];
            NSString *value = [logDict objectForKey:key];
            [str appendFormat:@"%@:\n%@\n\n",key,value];
        }
        self.logTextView.text = str;
    }
    else
    {
        self.logTextView.text = _logData;
    }
}

#pragma  mark - getter
- (UITextView *)logTextView
{
    if (!_logTextView)
    {
        _logTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, SX_NavBar_H, screenW, screenH - SX_NavBar_H)];
        _logTextView.editable = NO;
        [self.view addSubview:_logTextView];
    }
    return _logTextView;
}


#pragma  mark - UIResponse
- (void)actionPop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
