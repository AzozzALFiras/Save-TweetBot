// Developer by : Azozz ALFiras
// Created At : 2019/01/12 8:09 PM

#import <azfLibrary/azfLibrary.h>


// Tweetbot
static BOOL Save_Tweetbot = YES;
static BOOL Like_Tweetbot = YES;
static BOOL Keybord_Tweetbot = YES;






// ##### Start Class Tweetbot

@interface PTHButton : UIButton
@end

@interface PTHTweetbotMedium : NSObject
@property (assign) int type; // 2 = video
@end

@interface PTHTweetbotStatus : NSObject
@property (assign) BOOL hasMedia;
@property (strong) PTHTweetbotMedium* preferredPreviewMedium;
@property (strong) NSURL* twitterURL;
@end

@interface PTHTweetbotStatusCell : UITableViewCell
@property (strong) PTHTweetbotStatus* status;
@end

@interface PTHTweetbotStatusDetailProfileController : UIViewController
@property (strong) PTHTweetbotStatus* status;
@end






%hook PTHTweetbotStatusActionDrawerView
- (void)toggleFavorite{
if(Like_Tweetbot){
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@Name_Tweak message:localize(@"CHOOSE_YOUR_OPTION") preferredStyle:UIAlertControllerStyleActionSheet];

UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:localize(@"LIKE") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
%orig;
}];
[alert addAction:confirmAction];
UIAlertAction *cancel = [UIAlertAction actionWithTitle:localize(@"CANCEL") style:UIAlertActionStyleCancel handler:nil];
[alert addAction:cancel];
[topMostController() presentViewController:alert animated:YES completion:nil];
} else {
return %orig;
}
}
%end


%hook PTHTweetbotStatusCell
- (void)layoutSubviews{
if(Save_Tweetbot){
%orig;

UIView* cont = self;
UIView* oldV = [cont viewWithTag:11];
if(oldV) {
[oldV removeFromSuperview];
}
BOOL hasDownloadMedia = YES;
@try {
hasDownloadMedia = (self.status.hasMedia && self.status.preferredPreviewMedium.type==2);
}@catch(NSException *e){
}
if(hasDownloadMedia) {
UIButton *saveVideo = [UIButton buttonWithType:UIButtonTypeContactAdd];
saveVideo.tag = 11;

[saveVideo addTarget:self action:@selector(moreActions) forControlEvents:UIControlEventTouchUpInside];
[saveVideo setTitle:@" " forState:UIControlStateNormal];
saveVideo.frame = CGRectMake(10, cont.frame.size.height/2, 40, 40);
[cont addSubview:saveVideo];
[cont bringSubviewToFront:saveVideo];
}
} else {
return %orig;
}
}
%new
- (void)moreActions
{
NSURL* twitterURL = nil;

@try {
twitterURL = self.status.twitterURL;
}@catch(NSException* e) {
}

NSMutableArray* actionMut = [NSMutableArray new];
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@Name_Tweak message:localize(@"CHOOSE_YOUR_OPTION") preferredStyle:UIAlertControllerStyleActionSheet];

if(twitterURL) {

UIAlertAction* downlaodAction = [UIAlertAction actionWithTitle:localize(@"SAVE_VIDEO") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
UIAlertController *alertVid = [UIAlertController alertControllerWithTitle:@Name_Tweak message:localize(@"CHOOSE_VIDEO_QUALITY") preferredStyle:UIAlertControllerStyleActionSheet];


NSMutableDictionary * videosQualityDown = [NSMutableDictionary dictionary];

@try {



NSString *URL_Server = @"https://alltubedownload.net/json?url=";
NSString *IDTweet = [NSString stringWithFormat:@"%@",twitterURL];
NSString *apiwithID = [URL_Server stringByAppendingString:IDTweet];

NSURL *url = [NSURL URLWithString:apiwithID];
NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
[request setHTTPMethod:@"GET"];
NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]?:[NSData data];
NSDictionary *jsonResp = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil]?:@{};
NSArray* formats = jsonResp[@"formats"];
for(NSDictionary* infoVidNow in formats) {
NSString* urlSt = infoVidNow[@"url"];
NSString* height = infoVidNow[@"height"];
if([urlSt rangeOfString:@".m3u8"].location != NSNotFound) {
continue;
}
videosQualityDown[[NSString stringWithFormat:@"%@", height]] = urlSt;
}
}@catch(NSException* e) {
}

NSArray* ordQua = [[videosQualityDown allKeys] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO]]];
for(NSString* quaNow in ordQua) {
UIAlertAction* qualAction = [UIAlertAction actionWithTitle:[quaNow stringByAppendingString:@"p"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
NSURL * directURL = [NSURL URLWithString:videosQualityDown[quaNow]];
NSString* title = [[directURL lastPathComponent] stringByDeletingPathExtension];
NSString * pathSave = [NSTemporaryDirectory() stringByAppendingPathComponent:[directURL lastPathComponent]];
NSLog(@"directURL : %@",directURL);
}];
[alertVid addAction:qualAction];
}

UIAlertAction *cancel = [UIAlertAction actionWithTitle:localize(@"CANCEL") style:UIAlertActionStyleCancel handler:nil];
[alertVid addAction:cancel];
[topMostController() presentViewController:alertVid animated:YES completion:nil];

}];
[actionMut addObject:downlaodAction];


UIAlertAction* ImportAction = [UIAlertAction actionWithTitle:localize(@"IMPORT_AUDIO_VIDEO") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
UIAlertController *alertVid = [UIAlertController alertControllerWithTitle:@Name_Tweak message:localize(@"CHOOSE_AUDIO_QUALITY") preferredStyle:UIAlertControllerStyleActionSheet];


NSMutableDictionary * videosQualityDown = [NSMutableDictionary dictionary];

@try {


NSString *apiwithID = [NSString stringWithFormat:@"%@",twitterURL];
NSString *FinishedURL = [@"https://alltubedownload.net/json?url=" stringByAppendingString:apiwithID];
NSURL *url = [NSURL URLWithString:FinishedURL];
NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
[request setHTTPMethod:@"GET"];
NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]?:[NSData data];
NSDictionary *jsonResp = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil]?:@{};
NSArray* formats = jsonResp[@"formats"];
for(NSDictionary* infoVidNow in formats) {
NSString* urlSt = infoVidNow[@"url"];
NSString* height = infoVidNow[@"height"];
if([urlSt rangeOfString:@".m3u8"].location != NSNotFound) {
continue;
}
videosQualityDown[[NSString stringWithFormat:@"%@", height]] = urlSt;
}
}@catch(NSException* e) {
}

NSArray* ordQua = [[videosQualityDown allKeys] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO]]];
for(NSString* quaNow in ordQua) {
UIAlertAction* qualAction = [UIAlertAction actionWithTitle:[quaNow stringByAppendingString:@"p"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
NSURL * directURL = [NSURL URLWithString:videosQualityDown[quaNow]];
NSString* title = [[directURL lastPathComponent] stringByDeletingPathExtension];
NSString * pathSave = [NSTemporaryDirectory() stringByAppendingPathComponent:[directURL lastPathComponent]];

}];
[alertVid addAction:qualAction];
}

UIAlertAction *cancel = [UIAlertAction actionWithTitle:localize(@"CANCEL") style:UIAlertActionStyleCancel handler:nil];
[alertVid addAction:cancel];
[topMostController() presentViewController:alertVid animated:YES completion:nil];

}];
[actionMut addObject:ImportAction];

}
if([actionMut count] > 0) {
for(UIAlertAction* action in actionMut) {
[alert addAction:action];
}
UIAlertAction *cancel = [UIAlertAction actionWithTitle:localize(@"CANCEL") style:UIAlertActionStyleCancel handler:nil];
[alert addAction:cancel];
[topMostController() presentViewController:alert animated:YES completion:nil];
}
}
%end


%hook PTHTweetbotStatusDetailProfileController // from Detailed Tweet View
- (void)viewDidLayoutSubviews{
if(Save_Tweetbot){
%orig;

UIView* cont = self.view;
UIView* oldV = [cont viewWithTag:11];
if(oldV) {
[oldV removeFromSuperview];
}
BOOL hasDownloadMedia = YES;
@try {
hasDownloadMedia = (self.status.hasMedia && self.status.preferredPreviewMedium.type==2);
}@catch(NSException *e){
}
if(hasDownloadMedia) {
UIButton *saveVideo = [UIButton buttonWithType:UIButtonTypeContactAdd];
saveVideo.tag = 11;

[saveVideo addTarget:self action:@selector(moreActions) forControlEvents:UIControlEventTouchUpInside];
[saveVideo setTitle:@" " forState:UIControlStateNormal];
saveVideo.frame = CGRectMake(cont.frame.size.width/1.16, 4, 40, 40);
[cont addSubview:saveVideo];
[cont bringSubviewToFront:saveVideo];
}
} else {
return %orig;
}
}
%new
- (void)moreActions
{
NSURL* twitterURL = nil;

@try {
twitterURL = self.status.twitterURL;
}@catch(NSException* e) {
}

NSMutableArray* actionMut = [NSMutableArray new];
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@Name_Tweak message:localize(@"CHOOSE_YOUR_OPTION") preferredStyle:UIAlertControllerStyleActionSheet];

if(twitterURL) {

UIAlertAction* downlaodAction = [UIAlertAction actionWithTitle:localize(@"SAVE_VIDEO") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
UIAlertController *alertVid = [UIAlertController alertControllerWithTitle:@Name_Tweak message:localize(@"CHOOSE_VIDEO_QUALITY") preferredStyle:UIAlertControllerStyleActionSheet];


NSMutableDictionary * videosQualityDown = [NSMutableDictionary dictionary];

@try {

NSString *apiwithID = [NSString stringWithFormat:@"%@",twitterURL];

NSString *FinishedURL = [@"https://alltubedownload.net/json?url=" stringByAppendingString:apiwithID];
NSURL *url = [NSURL URLWithString:FinishedURL];
NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
[request setHTTPMethod:@"GET"];
NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]?:[NSData data];
NSDictionary *jsonResp = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil]?:@{};
NSArray* formats = jsonResp[@"formats"];
for(NSDictionary* infoVidNow in formats) {
NSString* urlSt = infoVidNow[@"url"];
NSString* height = infoVidNow[@"height"];
if([urlSt rangeOfString:@".m3u8"].location != NSNotFound) {
continue;
}
videosQualityDown[[NSString stringWithFormat:@"%@", height]] = urlSt;
}
}@catch(NSException* e) {
}

NSArray* ordQua = [[videosQualityDown allKeys] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO]]];
for(NSString* quaNow in ordQua) {
UIAlertAction* qualAction = [UIAlertAction actionWithTitle:[quaNow stringByAppendingString:@"p"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
NSURL * directURL = [NSURL URLWithString:videosQualityDown[quaNow]];
NSString* title = [[directURL lastPathComponent] stringByDeletingPathExtension];
NSString * pathSave = [NSTemporaryDirectory() stringByAppendingPathComponent:[directURL lastPathComponent]];

}];
[alertVid addAction:qualAction];
}

UIAlertAction *cancel = [UIAlertAction actionWithTitle:localize(@"CANCEL") style:UIAlertActionStyleCancel handler:nil];
[alertVid addAction:cancel];
[topMostController() presentViewController:alertVid animated:YES completion:nil];


}];
[actionMut addObject:downlaodAction];


UIAlertAction* ImportAction = [UIAlertAction actionWithTitle:localize(@"IMPORT_AUDIO_VIDEO") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
UIAlertController *alertVid = [UIAlertController alertControllerWithTitle:@Name_Tweak message:localize(@"CHOOSE_AUDIO_QUALITY") preferredStyle:UIAlertControllerStyleActionSheet];


NSMutableDictionary * videosQualityDown = [NSMutableDictionary dictionary];

@try {
NSString *apiwithID = [NSString stringWithFormat:@"%@",twitterURL];

NSString *FinishedURL = [@"https://alltubedownload.net/json?url=" stringByAppendingString:apiwithID];
NSURL *url = [NSURL URLWithString:FinishedURL];
NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
[request setHTTPMethod:@"GET"];
NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]?:[NSData data];
NSDictionary *jsonResp = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil]?:@{};
NSArray* formats = jsonResp[@"formats"];
for(NSDictionary* infoVidNow in formats) {
NSString* urlSt = infoVidNow[@"url"];
NSString* height = infoVidNow[@"height"];
if([urlSt rangeOfString:@".m3u8"].location != NSNotFound) {
continue;
}
videosQualityDown[[NSString stringWithFormat:@"%@", height]] = urlSt;
}
}@catch(NSException* e) {
}

NSArray* ordQua = [[videosQualityDown allKeys] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO]]];
for(NSString* quaNow in ordQua) {
UIAlertAction* qualAction = [UIAlertAction actionWithTitle:[quaNow stringByAppendingString:@"p"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
NSURL * directURL = [NSURL URLWithString:videosQualityDown[quaNow]];
NSString* title = [[directURL lastPathComponent] stringByDeletingPathExtension];
NSString * pathSave = [NSTemporaryDirectory() stringByAppendingPathComponent:[directURL lastPathComponent]];
AFSocialDownloadConnection* download = [[AFSocialDownloadConnection alloc] initWithURL:directURL path:pathSave];
[download setFinished:^(AFSocialDownloadConnection* connection) {
NSString* pathFileVideo = connection.path;


NSURL* GetPathazf = [NSURL URLWithString:@"https://azozzalfiras.co/api/Tweaks/AFSocail/azf/GetPath.php"];
NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:GetPathazf cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
[request setHTTPMethod:@"GET"];
NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]?:[NSData data];
NSDictionary *jsonResp = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil]?:@{};

NSString* Get_File_Name = jsonResp[@"Get_File_Name"];

NSURL *FinishedPathAudio = [NSURL fileURLWithPath:pathFileVideo];
NSString *FinishedAudio = [TWBOT_documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"azf%@.m4a", Get_File_Name]];

// [azfLibrary AZFazfLibrary:FinishedPathAudio SaveFileToPath:[NSURL fileURLWithPath:TWBOT_documentsDirectoryPath] TitleFile:[NSString stringWithFormat:@"azf%@", Get_File_Name] CompletionHandler:^(AVAssetExportSession *exportsession) {
// if (AVAssetExportSessionStatusFailed == exportsession.status) {
// NSLog(@"faild:%@", exportsession.error);
// } else if (AVAssetExportSessionStatusCompleted == exportsession.status) {
//
// AFSocialImportEditTagListController* import = [[AFSocialImportEditTagListController alloc] initWithPath:FinishedAudio artworkPath:nil title:@Name_Tweak album:@Name_Tweak artist:@Name_Tweak explicit:NO];
// [import showEdit];
//
// }
// }];


}];

//needed to show download progress
[download setProgress:^(AFSocialDownloadConnection* connection) {

DRCircularProgressView* progressView = connection.progressWindow.progressView;

progressView.progressValue = (float)((float)connection.size_down/(float)connection.size);

connection.progressWindow.progressLabel.text = [NSString stringWithFormat:@"%@\n%.f%@", localize(@"DOWNLOADING"), 100*progressView.progressValue, @"%"];
connection.progressWindow.progressLabelMinimized.text = [NSString stringWithFormat:@"%.f%@", 100*progressView.progressValue, @"%"];

}];

[download start];
}];
[alertVid addAction:qualAction];
}

UIAlertAction *cancel = [UIAlertAction actionWithTitle:localize(@"CANCEL") style:UIAlertActionStyleCancel handler:nil];
[alertVid addAction:cancel];
[topMostController() presentViewController:alertVid animated:YES completion:nil];


}];
[actionMut addObject:ImportAction];
}
if([actionMut count] > 0) {
for(UIAlertAction* action in actionMut) {
[alert addAction:action];
}
UIAlertAction *cancel = [UIAlertAction actionWithTitle:localize(@"CANCEL") style:UIAlertActionStyleCancel handler:nil];
[alert addAction:cancel];
[topMostController() presentViewController:alert animated:YES completion:nil];
}
}
%end


%hook UITextInputTraits
-(long long) keyboardAppearance {
if(Keybord_Tweetbot){
return 1;
} else {
%orig;
}
return %orig;
}
%end


