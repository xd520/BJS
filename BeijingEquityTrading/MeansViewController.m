//
//  MeansViewController.m
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/11/26.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "MeansViewController.h"
#import "AppDelegate.h"

@interface MeansViewController ()
{
    float addHight;
    
    NSArray *arrTitle;
    UITableView *table;
    
    UILabel *realName;
    UIImageView *headView;
    
    
    NSDictionary *myDic;
    
}

@end

@implementation MeansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        statusBarView.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }

    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, addHight + 44, ScreenWidth, 1)];
    lineView1.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    [self.view addSubview:lineView1];
    
    
    [self requestData];
    
    arrTitle = @[@"头像",@"用户名",@"手机号",@"邮箱地址",@"真实姓名",@"身份证号码"];
}


-(void) initData{
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, addHight + 45, ScreenWidth,ScreenHeight - 65)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [table setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
    table.tableFooterView = [[UIView alloc] init];
    
    table.bounces = NO;
    
    [self.view addSubview:table];

}



-(void) requestData {
    
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERpwdManageappappIndex] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            myDic = [responseObject objectForKey:@"object"];
            [self initData];
        } else {
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        NSLog(@"Error: %@", error);
    }];
    
    
}




#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
       return 4;
    } else {
    return 2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setScrollEnabled:NO]; tableView 不能滑动
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[UIColor clearColor]];
                //添加背景View
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
                [backView setBackgroundColor:[ConMethods colorWithHexString:@"fafafa"]];
                
                headView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 100,10, 70, 70)];
                headView.image = _headViewImg;
                headView.layer.cornerRadius = headView.frame.size.width / 2;
                headView.clipsToBounds = YES;
                [backView addSubview:headView];
                
                
                
                //品牌
                
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, ScreenWidth - 120, 39)];
                brandLabel.backgroundColor = [UIColor clearColor];
                brandLabel.font = [UIFont boldSystemFontOfSize:15];
                [brandLabel setTextColor:[ConMethods colorWithHexString:@"646464"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                brandLabel.text = [arrTitle objectAtIndex:indexPath.row];
                [backView addSubview:brandLabel];
                [cell.contentView addSubview:backView];
            }
            
        } else {
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[UIColor clearColor]];
                //添加背景View
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
                [backView setBackgroundColor:[ConMethods colorWithHexString:@"fafafa"]];
                //品牌
                
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 39)];
                brandLabel.backgroundColor = [UIColor clearColor];
                brandLabel.font = [UIFont boldSystemFontOfSize:15];
                [brandLabel setTextColor:[ConMethods colorWithHexString:@"646464"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                brandLabel.text = [arrTitle objectAtIndex:indexPath.row];
                [backView addSubview:brandLabel];
                
                
                UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, ScreenWidth - 130, 39)];
                endLabel.backgroundColor = [UIColor clearColor];
                endLabel.font = [UIFont boldSystemFontOfSize:15];
                [endLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                endLabel.textAlignment = NSTextAlignmentRight;
                [endLabel setBackgroundColor:[UIColor clearColor]];
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
               
                if (indexPath.row == 1) {
                    endLabel.text =  [[delegate.loginUser objectForKey:@"object"] objectForKey:@"username"];
                } else if (indexPath.row == 2) {
                    endLabel.text =  [myDic objectForKey:@"mobilePhone"];
                } else if (indexPath.row == 3) {
                   
                    if ([[myDic objectForKey:@"isSetEmail"] boolValue]) {
                        endLabel.text =  [myDic objectForKey:@"email"];
                    } else {
                    
                     endLabel.text = @"未设置";
                    }
                }
                
                [backView addSubview:endLabel];
                
                
                
                [cell.contentView addSubview:backView];
            }
            
        }
    } else {
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
        //添加背景View
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        [backView setBackgroundColor:[ConMethods colorWithHexString:@"fafafa"]];
        //品牌
        
        UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 39)];
        brandLabel.backgroundColor = [UIColor clearColor];
        brandLabel.font = [UIFont boldSystemFontOfSize:15];
        [brandLabel setTextColor:[ConMethods colorWithHexString:@"646464"]];
        [brandLabel setBackgroundColor:[UIColor clearColor]];
        brandLabel.text = [arrTitle objectAtIndex:indexPath.row + 4];
        [backView addSubview:brandLabel];
        
        UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 0, ScreenWidth - 125, 39)];
        endLabel.backgroundColor = [UIColor clearColor];
        endLabel.font = [UIFont boldSystemFontOfSize:15];
        [endLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
        endLabel.textAlignment = NSTextAlignmentRight;
        [endLabel setBackgroundColor:[UIColor clearColor]];
        if (myDic.count > 0) {
            
             if ([[myDic objectForKey:@"isSetCert"] boolValue]) {
                 if (indexPath.row == 0) {
                     endLabel.text = [myDic objectForKey:@"name"];
                 } else {
                     
                     endLabel.text = [myDic objectForKey:@"zjbh"];
                     }
             }else {
            
               endLabel.text = @"--";
           
            
             }
        }
       
        [backView addSubview:endLabel];
        
 
        
        
        [cell.contentView addSubview:backView];
    }
        
    
    }
  
    if (indexPath.row == 0&&indexPath.section == 0) {
       cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
           return 90;
        } else {
       return 40;
        }
    } else {
    
    return 40;
    }
}

- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIActionSheet *sheet;
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                
                
                sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
                
            } else {
                sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
            }
            sheet.tag = 255;
            [sheet showInView:self.view];
            
        } else {
 
    }
        
    } else {
    
    
    }
}

#pragma caramer Methods

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = 0;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:{
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                   // hasLoadedCamera = YES;
                }
                    break;
                case 2:{
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    // hasLoadedCamera = YES;
                }
                    break;
            }
        }else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        [self showcamera:sourceType];
        
    }
}

- (void)showcamera:(NSInteger)tag {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    //[imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imagePicker setAllowsEditing:YES];
    imagePicker.sourceType = tag;
    [self presentViewController:imagePicker animated:YES completion:^{}];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // NSLog(@"u a is sb");
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [self scaleImage:[info objectForKey:UIImagePickerControllerEditedImage]];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    
    // 保存图片至本地，方法见下文
    
    
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
      NSLog(@"%@",fullPath);
    

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{};
    
   // NSURL *filePath = [NSURL URLWithString:[NSString stringWithFormat:@"file:/%@",fullPath]];
    //NSLog(@"%@",filePath);
    
    NSURL *filePath = [NSURL fileURLWithPath:fullPath];
    // NSLog(@"%@",filePath);
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERappUploadPhotoSubmit] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // [formData appendPartWithFileData:data name:@"currentImage" fileName:@"upfile" mimeType:@"image/png"];
       // [formData appendPartWithFileURL:filePath name:@"upfile" fileName:@"currentImage" mimeType:@"image/jpeg" error:nil];
        
        
        [formData appendPartWithFileURL:filePath name:@"upfile" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"上传成功"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            headView.image = [[UIImage alloc] initWithContentsOfFile:fullPath];
        } else {
        
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
        }
        
        NSLog(@"Success: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        NSLog(@"Error: %@", error);
    }];

}




#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
   
    //[imageData writeToURL:[NSURL URLWithString:[NSString stringWithFormat:@"path%@",fullPath]] atomically:NO];
    
}


//图片压缩

- (UIImage *)scaleImage:(UIImage *)image {
    int kMaxResolution = 1000;
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    NSLog(@"boudns image =%@",NSStringFromCGRect(bounds));
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    
    switch(orient) {
        case UIImageOrientationUp:
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
            //        default:
            //            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else {
    
    return 35;
    }
}




- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    
    
    UIView *view;
    
    if (section == 0) {
     
        UIView  *lineview = [[UIView alloc] initWithFrame:CGRectMake(2, 1, ScreenWidth - 14, 1)];
        lineview.backgroundColor = [ConMethods colorWithHexString:@"a2a2a2"];
        view = lineview;
    } else {
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , 35)];
    view.backgroundColor = [UIColor clearColor];
        
        realName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5.5, ScreenWidth - 20, 24)];
        if ([[myDic objectForKey:@"isSetCert"] boolValue]) {
           realName.text = @"实名认证（已认证）";
        } else {
        
        realName.text = @"实名认证（未实名认证）";
        }
        realName.textColor = [ConMethods colorWithHexString:@"999999"];
        realName.font = [UIFont systemFontOfSize:14];
        [view addSubview:realName];
        

    }
    return view;
}







- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
