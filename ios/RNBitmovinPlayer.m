#import "RNBitmovinPlayer.h"
#import <React/RCTLog.h>
#import <React/RCTView.h>

@implementation RNBitmovinPlayer {
    BOOL _fullscreen;
}

@synthesize player = _player;
@synthesize playerView = _playerView;


- (void)dealloc {
    [_player destroy];

    _player = nil;
    _playerView = nil;
}

- (instancetype)init {
    if ((self = [super init])) {
        _fullscreen = NO;
    }
    return self;
}

- (void)setConfiguration:(NSDictionary *)config {
    BMPPlayerConfiguration *configuration = [BMPPlayerConfiguration new];


    NSURL *adSourceTag = [NSURL URLWithString:@"https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator=83223"];

    BMPAdSource *adSource = [[BMPAdSource alloc]initWithTag:adSourceTag ofType:BMPAdSourceTypeIMA];
    BMPAdItem *adItem = [[BMPAdItem alloc] initWithAdSources:@[adSource] atPosition:@"pre"];
    BMPAdvertisingConfiguration *adConfig = [[BMPAdvertisingConfiguration alloc] initWithSchedule: @[adItem]];
    [configuration setAdvertisingConfiguration:adConfig];

//    configuration.playbackConfiguration.muted = YES;


//    configuration.sourceItem.itemTitle = config[@"title"];

//    if (config[@"poster"] && config[@"poster"][@"url"]) {
//        configuration.sourceItem.posterSource = [NSURL URLWithString:config[@"poster"][@"url"]];
//        configuration.sourceItem.persistentPoster = [config[@"poster"][@"persistent"] boolValue];
//    }

//    if (![config[@"style"][@"uiEnabled"] boolValue]) {
//        configuration.styleConfiguration.uiEnabled = NO;
//    }
//
//    if ([config[@"style"][@"systemUI"] boolValue]) {
//        configuration.styleConfiguration.userInterfaceType = BMPUserInterfaceTypeSystem;
//    }
//
//    if (config[@"style"][@"uiCss"]) {
//        configuration.styleConfiguration.playerUiCss = [NSURL URLWithString:config[@"style"][@"uiCss"]];
//    }
//
//    if (config[@"style"][@"supplementalUiCss"]) {
//        configuration.styleConfiguration.supplementalPlayerUiCss = [NSURL URLWithString:config[@"style"][@"supplementalUiCss"]];
//    }
//
//    if (config[@"style"][@"uiJs"]) {
//        configuration.styleConfiguration.playerUiJs = [NSURL URLWithString:config[@"style"][@"uiJs"]];
//    }
    BMPSourceItem *sourceItem = [[BMPSourceItem alloc] initWithUrl:[NSURL URLWithString:@"https://bitmovin-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8"]];
    //    BMPSourceItem *sourceItem = [[BMPSourceItem alloc] initWithUrl:[NSURL URLWithString:config[@"source"][@"hls"]]];

    [configuration setSourceItem:sourceItem];
    _player = [[BMPBitmovinPlayer alloc] initWithConfiguration:configuration];

    [_player addPlayerListener:self];

    _playerView = [[BMPBitmovinPlayerView alloc] initWithPlayer:_player frame:self.frame];
    _playerView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    _playerView.frame = self.bounds;

//    [_playerView addUserInterfaceListener:self];

//    if ([config[@"style"][@"fullscreenIcon"] boolValue]) {
//        _playerView.fullscreenHandler = self;
//    }
    [self addSubview:_playerView];
    [self bringSubviewToFront:_playerView];

    self.player = _player;
}

- (void)onAdError:(BMPAdErrorEvent *)event {
    NSLog(event);
}

- (void)onAdScheduled:(BMPAdScheduledEvent *)event {
    NSLog(event);
}

- (void)onAdStarted:(BMPAdStartedEvent *)event {
    NSLog(event);
}

#pragma mark BMPFullscreenHandler protocol
- (BOOL)isFullscreen {
    return _fullscreen;
}

- (void)onFullscreenRequested {
    _fullscreen = YES;
}

- (void)onFullscreenExitRequested {
    _fullscreen = NO;
}

#pragma mark BMPPlayerListener
- (void)onReady:(BMPReadyEvent *)event {
    _onReady(@{});
    [_playerView enterFullscreen];
}

- (void)onPlay:(BMPPlayEvent *)event {
    _onPlay(@{
              @"time": @(event.time),
              });
}

- (void)onPaused:(BMPPausedEvent *)event {
    _onPaused(@{
              @"time": @(event.time),
              });
}

- (void)onTimeChanged:(BMPTimeChangedEvent *)event {
    _onTimeChanged(@{
                @"time": @(event.currentTime),
                });
}

- (void)onStallStarted:(BMPStallStartedEvent *)event {
    _onStallStarted(@{});
}

- (void)onStallEnded:(BMPStallEndedEvent *)event {
    _onStallEnded(@{});
}

- (void)onPlaybackFinished:(BMPPlaybackFinishedEvent *)event {
    _onPlaybackFinished(@{});
}

- (void)onRenderFirstFrame:(BMPRenderFirstFrameEvent *)event {
    _onRenderFirstFrame(@{});
}

- (void)onError:(BMPErrorEvent *)event {
    _onPlayerError(@{
               @"error": @{
                       @"code": @(event.code),
                       @"message": event.message,
                       }
               });
}

- (void)onMuted:(BMPMutedEvent *)event {
    _onMuted(@{});
}

- (void)onUnmuted:(BMPUnmutedEvent *)event {
    _onUnmuted(@{});
}

- (void)onSeek:(BMPSeekEvent *)event {
    _onSeek(@{
              @"seekTarget": @(event.seekTarget),
              @"position": @(event.position),
              });
}

- (void)onSeeked:(BMPSeekedEvent *)event {
    _onSeeked(@{});
}

#pragma mark BMPUserInterfaceListener
- (void)onFullscreenEnter:(BMPFullscreenEnterEvent *)event {
    _onFullscreenEnter(@{});
}

- (void)onFullscreenExit:(BMPFullscreenExitEvent *)event {
    _onFullscreenExit(@{});
}
- (void)onControlsShow:(BMPControlsShowEvent *)event {
    _onControlsShow(@{});
}

- (void)onControlsHide:(BMPControlsHideEvent *)event {
    _onControlsHide(@{});
}



@end
