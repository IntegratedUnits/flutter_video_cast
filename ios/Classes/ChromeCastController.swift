//
//  ChromeCastController.swift
//  flutter_video_cast
//
//  Created by Alessio Valentini on 07/08/2020.
//

import Flutter
import GoogleCast
import Foundation

class ChromeCastController: NSObject, FlutterPlatformView {

    // MARK: - Internal properties

    private let channel: FlutterMethodChannel
    private let chromeCastButton: GCKUICastButton
    private let sessionManager = GCKCastContext.sharedInstance().sessionManager
    private let discovryManager = GCKCastContext.sharedInstance().discoveryManager

    // MARK: - Init

    init(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        registrar: FlutterPluginRegistrar
    ) {
        self.channel = FlutterMethodChannel(name: "flutter_video_cast/chromeCast_\(viewId)", binaryMessenger: registrar.messenger())
        self.chromeCastButton = GCKUICastButton(frame: frame)
        self.chromeCastButton.tintColor = UIColor(red: 255.0/255.0, green:
                                                    255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        discovryManager.startDiscovery()
//        self.chromeCastButton.backgroundColor = UIColor.init(cgColor: CGColor.init(red: 225, green: 255, blue: 200, alpha: 100))
        super.init()
        self.configure(arguments: args)
    }

    func view() -> UIView {
        
        return chromeCastButton
    }

    private func configure(arguments args: Any?) {
        setTint(arguments: args)
        setMethodCallHandler()
    }

    // MARK: - Styling

    private func setTint(arguments args: Any?) {
        guard
            let args = args as? [String: Any],
            let red = args["red"] as? CGFloat,
            let green = args["green"] as? CGFloat,
            let blue = args["blue"] as? CGFloat,
            let alpha = args["alpha"] as? Int else {
                print("Invalid color")
                return
        }
        chromeCastButton.tintColor = UIColor(
            red: red / 255,
            green: green / 255,
            blue: blue / 255,
            alpha: CGFloat(alpha) / 255
        )
    }

    // MARK: - Flutter methods handling

    private func setMethodCallHandler() {
        channel.setMethodCallHandler { call, result in
            self.onMethodCall(call: call, result: result)
        }
    }

    private func onMethodCall(call: FlutterMethodCall, result: FlutterResult) {
        
        switch call.method {
        case "chromeCast#wait":
            result(nil)
            break
        case "chromeCast#loadMedia":
            loadMedia(args: call.arguments)
            result(nil)
            break
        case "chromeCast#play":
            play()
            result(nil)
            break
        case "chromeCast#pause":
            pause()
            result(nil)
            break
        case "chromeCast#seek":
            seek(args: call.arguments)
            result(nil)
            break
        case "chromeCast#stop":
            stop()
            result(nil)
            break
        case "chromeCast#isConnected":
            result(isConnected())
            break
        case "chromeCast#isPlaying":
            result(isPlaying())
            break
        case "chromeCast#addSessionListener":
            addSessionListener()
            result(nil)
        case "chromeCast#removeSessionListener":
            removeSessionListener()
            result(nil)
        case "chromeCast#position":
            result(position())
        case "chromeCast#loadMediaTvShow":
            loadMediaTvShow(args: call.arguments)
            result(nil)
        case "chromeCast#loadMediaWithRequestObject":
            load(args: call.arguments)
            result(nil)
        case "chromeCast#getStatus":
            result(getStatus())
        case "chromeCast#queueNext":
            queueNext();
            result(nil)
        case "chromeCast#queuePrevious":
            queuePrevious();
            result(nil)
        case "chromeCast#getStatusIOS":
            result(getMediaStausIOS())
        default:
            result(nil)
            break
        }
    }
    

    private func loadMedia(args: Any?) {
        guard
            let args = args as? [String: Any],
            let url = args["url"] as? String,
            let mediaUrl = URL(string: url) else {
                print("Invalid URL")
                return
        }
        let mediaInformation = GCKMediaInformationBuilder(contentURL: mediaUrl).build()
        if let request = sessionManager.currentCastSession?.remoteMediaClient?.loadMedia(mediaInformation) {
            request.delegate = self
        }
    }
    private func load(args: Any?) {
        let args = args as? [String:Any]
//        let reuqestData = GCKMediaLoadRequestDataBuilder()
//        if(args?["media"] != nil){
//            let data = args?["media"] as? [String: Any]
//            let mediaInfo = GCKMediaInformationBuilder()
//            mediaInfo.contentID = data?["contentId"] as? String
//            reuqestData.mediaInformation = mediaInfo.build()
//
//        }
        
        if let request = sessionManager.currentCastSession?.remoteMediaClient?.loadMedia(with: getMediaLoadRequestDataFromDic(d:args)){
            request.delegate = self
        }
        
    }
    func getMediaLoadRequestDataFromDic(d: Dictionary<String,Any>?) -> GCKMediaLoadRequestData{
        let r = GCKMediaLoadRequestDataBuilder.init()
        if(d?["media"] != nil){
            let data = d?["media"] as? [String: Any]
//            do{
//                let a =  try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
//                 print(a)
//            }
//            catch{}
    
            
//            let mediaInfo = GCKMediaInformationBuilder()
//            mediaInfo.contentID = data?["contentId"] as? String
////            mediaInfo.streamType = data?[""]
////            mediaInfo.setValuesForKeys(data!)
//            let metaData = data?["metadata"] as? [String:Any]
//            let metaData1 = GCKMediaMetadata.init(metadataType: GCKMediaMetadataType.init(rawValue: metaData?["metadataType"] as? Int ?? 0)!)
//            if(metaData1.metadataType == GCKMediaMetadataType.movie){
//
//                metaData1.setString((metaData?["title"]) as? String ?? "", forKey: kGCKMetadataKeyTitle)
//                metaData1.setString(metaData?["subtitle"] as? String ?? "", forKey: kGCKMetadataKeySubtitle)
//                let images = (metaData?["images"] as? [Dictionary<String,Any>])
////                metaData1.setString(images?.first?["url"] as? String ?? "", forKey: kGCKMetadataKeySubtitle)
//                for val in images!{
//                    metaData1.addImage(GCKImage(url:URL(string:val["url"] as? String ?? "")!,width: 480,height: 360))
//                }
//
////                metaData1.setString(<#T##value: String##String#>, forK)
//            }
//            mediaInfo.metadata = metaData1
        
//            mediaInfo.streamType = getStreamTypeFromString(s: data?["streamType"])
            r.mediaInformation = getMediaInfoFromDix(d:data)
        }
        if(d?["queueData"] != nil){
            let queueData = d?["queueData"] as? [String:Any];
            let queueDataBuilder = GCKMediaQueueDataBuilder.init(queueType: GCKMediaQueueType.tvSeries)
            
            queueDataBuilder.queueID = "13"
            if(queueData?["startIndex"] != nil){
                queueDataBuilder.startIndex = (queueData!["startIndex"] as? NSNumber)?.uintValue ?? UInt.zero
//                queueDataBuilder.startIndex =
            }
//            print("loading..........aa")
//            print(queueData?.description)
            if(queueData?["items"] is NSArray){
                
                let items = queueData!["items"] as? NSArray
//                print("got hear")
//                print(items?.object(at: 0))
//                let firstItem = items?.object(at: 0) as? [String:Any]
//                print(firstItem?["media"])
                var loadingItems = [GCKMediaQueueItem]()
                for val in items!{
                    let v = val as? [String:Any]
                    let itemBuilder = GCKMediaQueueItemBuilder.init();
                    itemBuilder.preloadTime = v?["preloadTime"] as? TimeInterval ?? 10
            
                    itemBuilder.autoplay = true
//                    print(items?.index(of: val))
                    itemBuilder.mediaInformation = getMediaInfoFromDix(d: v?["media"]! as? [String:Any])
                    loadingItems.append(itemBuilder.build())
                }
                queueDataBuilder.items = loadingItems
            
//                print(queueDataBuilder.items?.description)
               
            }
            r.queueData = queueDataBuilder.build()
            
        }
        return r.build()
        
    }
    func getMediaInfoFromDix(d:[String:Any]?) -> GCKMediaInformation{
        let mediaInfo = GCKMediaInformationBuilder()
        mediaInfo.contentID = d?["contentId"] as? String
        
//            mediaInfo.streamType = data?[""]
//            mediaInfo.setValuesForKeys(data!)
        let metaData = d?["metadata"] as? [String:Any]
        let metaData1 = GCKMediaMetadata.init(metadataType: GCKMediaMetadataType.init(rawValue: metaData?["metadataType"] as? Int ?? 0)!)
        if(metaData1.metadataType == GCKMediaMetadataType.movie){

            metaData1.setString((metaData?["title"]) as? String ?? "", forKey: kGCKMetadataKeyTitle)
            metaData1.setString(metaData?["subtitle"] as? String ?? "", forKey: kGCKMetadataKeySubtitle)
            let images = (metaData?["images"] as? [Dictionary<String,Any>])
//                metaData1.setString(images?.first?["url"] as? String ?? "", forKey: kGCKMetadataKeySubtitle)
            for val in images!{
                metaData1.addImage(GCKImage(url:URL(string:val["url"] as? String ?? "")!,width: 480,height: 360))
            }

//                metaData1.setString(<#T##value: String##String#>, forK)
        }
        else if(metaData1.metadataType == GCKMediaMetadataType.tvShow){
            metaData1.setString((metaData?["seriesTitle"]) as? String ?? "", forKey: kGCKMetadataKeySeriesTitle)
            metaData1.setString(metaData?["subtitle"] as? String ?? "", forKey: kGCKMetadataKeySubtitle)
//            metaData1.setInteger(metaData?["season"] as? Int, forKey: kGCKMetadataKeySeasonNumber)
            let episode = metaData!["episode"] as? NSNumber
            metaData1.setInteger(episode?.intValue ?? 0, forKey: kGCKMetadataKeyEpisodeNumber)
        }
        let images = (metaData?["images"] as? [Dictionary<String,Any>])
//                metaData1.setString(images?.first?["url"] as? String ?? "", forKey: kGCKMetadataKeySubtitle)
        for val in images!{
            metaData1.addImage(GCKImage(url:URL(string:val["url"] as? String ?? "")!,width: 480,height: 360))
        }
        mediaInfo.metadata = metaData1
        return mediaInfo.build()
        }
    func getMediaMetaDataFromDic(d:[String:Any]?) -> GCKMediaMetadata?{
        return nil;
    }
    func getStreamTypeFromString(s:String?) -> GCKMediaStreamType{
        switch(s){
        case "NONE":
            return GCKMediaStreamType.none
        case "BUFFERED" :
            return GCKMediaStreamType.buffered
        case "LIVE" :
            return GCKMediaStreamType.live
        default:
            return GCKMediaStreamType.unknown
            
        }
    }
    //    private func getStatus() -> Dictionary<String,Any>?{
////        return "testData"
//
////        sessionManager.currentCastSession?.remoteMediaClient?.mediaStatus
////        data["possition"]
//
//
//
//
//        return getDictionaryFromMediaInfo(arg: sessionManager.currentCastSession?.remoteMediaClient?.mediaStatus)
//    }
    private func getStatus() ->String? {
        print("devices............")
        print(discovryManager.deviceCount)
        print(discovryManager.device(at: 0).deviceID)
//        return "testData"
       
//        sessionManager.currentCastSession?.remoteMediaClient?.mediaStatus
//        data["possition"]
        
          
        
        
        return getDictionaryFromMediaInfo(arg: sessionManager.currentCastSession?.remoteMediaClient?.mediaStatus)?.description.replacingOccurrences(of: "[", with: "{").replacingOccurrences(of: "]", with:  "}")
    }
    private func getMediaStausIOS() -> Dictionary<String,Any>?{
//        var d = [String:Any]()
//        let images = self.sessionManager.currentSession?.remoteMediaClient?.mediaStatus?.mediaInformation?.metadata?.images()
//        if(images != nil){
//            var imageArray = NSArray()
//
//                for val in images!{
//                    let v = val as? GCKImage
//                    imageArray = imageArray.adding(["url" : v?.url.absoluteString]) as NSArray
//
//            }
//            d["images"] = imageArray
//        }
        return getDictionaryFromMediaInfo(arg: sessionManager.currentSession?.remoteMediaClient?.mediaStatus)
        
    }
    private func getDictionaryFromMediaInfo(arg: GCKMediaStatus?) -> Dictionary<String,Any>?{
        if(arg == nil){
            return nil
        }
        var data = [String:Any]()
        
            
        data["currentTime"] = arg?.streamPosition
            
           
        
        
        return arg?.toDictionary()
    }
    private func queueNext(){
        sessionManager.currentSession?.remoteMediaClient?.queueNextItem()
    }
    private func queuePrevious(){
        sessionManager.currentSession?.remoteMediaClient?.queuePreviousItem()
    }

    private func loadMediaTvShow(args: Any?){
        guard
            let args = args as? [String: Any],
            let url = args["url"] as? String,
            let image = args["image"] as? String,
            let seriesTitle = args["seriesTitle"] as? String,
            let season = args["season"] as? Int,
            let episode = args["episode"] as? Int,
            let currentTime = args["currentTime"] as? Int,
            let mediaUrl = URL(string: url) else {
                print("Invalid URL")
                return
            }
        let metadata = GCKMediaMetadata(metadataType: GCKMediaMetadataType.tvShow)
        
        metadata.setString(seriesTitle,forKey:kGCKMetadataKeySeriesTitle)
        metadata.setInteger(season,forKey:kGCKMetadataKeySeasonNumber)
        metadata.setInteger(episode,forKey:kGCKMetadataKeyEpisodeNumber)
        metadata.addImage(GCKImage(url:URL(string:image)!,width: 480,height: 360))

        let mediaInfoBuilder = GCKMediaInformationBuilder.init(contentURL: mediaUrl)
        mediaInfoBuilder.streamType=GCKMediaStreamType.buffered;
        mediaInfoBuilder.contentType="video/mp4"
        mediaInfoBuilder.metadata=metadata;
        
        let mediaInformation = mediaInfoBuilder.build()
        let mediaLoadOptions = GCKMediaLoadOptions.init()
        mediaLoadOptions.playPosition = Double(currentTime / 1000)


        if let request = sessionManager.currentSession?.remoteMediaClient?.loadMedia(mediaInformation, with: mediaLoadOptions) {
        request.delegate = self
        }
    }

    private func play() {
        if let request = sessionManager.currentCastSession?.remoteMediaClient?.play() {
            request.delegate = self
        }
    }

    private func pause() {
        if let request = sessionManager.currentCastSession?.remoteMediaClient?.pause() {
            request.delegate = self
        }
    }

    private func seek(args: Any?) {
        guard
            let args = args as? [String: Any],
            let relative = args["relative"] as? Bool,
            let interval = args["interval"] as? Double else {
                return
        }
        let seekOptions = GCKMediaSeekOptions()
        seekOptions.relative = relative
        seekOptions.interval = interval
        if let request = sessionManager.currentCastSession?.remoteMediaClient?.seek(with: seekOptions) {
            request.delegate = self
        }
    }

    private func stop() {
        if let request = sessionManager.currentCastSession?.remoteMediaClient?.stop() {
            request.delegate = self
        }
    }

    private func isConnected() -> Bool {
        return sessionManager.currentCastSession?.remoteMediaClient?.connected ?? false
    }

    private func isPlaying() -> Bool {
        return sessionManager.currentCastSession?.remoteMediaClient?.mediaStatus?.playerState == GCKMediaPlayerState.playing
    }

    private func addSessionListener() {
        sessionManager.add(self)
    }

    private func removeSessionListener() {
        sessionManager.remove(self)
    }

    private func position() -> Int {
//        return 200;
        return Int(sessionManager.currentCastSession?.remoteMediaClient?.approximateStreamPosition() ?? 0) * 1000
    }

}

// MARK: - GCKSessionManagerListener

extension ChromeCastController: GCKSessionManagerListener {
    func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKSession) {
        channel.invokeMethod("chromeCast#didStartSession", arguments: nil)
    }

    func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
        channel.invokeMethod("chromeCast#didEndSession", arguments: nil)
    }
}

// MARK: - GCKRequestDelegate

extension ChromeCastController: GCKRequestDelegate {
    func requestDidComplete(_ request: GCKRequest) {
        channel.invokeMethod("chromeCast#requestDidComplete", arguments: nil)
    }

    func request(_ request: GCKRequest, didFailWithError error: GCKError) {
        channel.invokeMethod("chromeCast#requestDidFail", arguments: ["error" : error.localizedDescription])
    }
}

extension GCKMediaStatus{
    func toDictionary() -> Dictionary<String,Any>{
        var dd = [String:Any]()
        dd["currentTime"] = self.streamPosition
        if(self.playerState != GCKMediaPlayerState.unknown){
            dd["playerState"] = self.playerState.toS()
        }
        
        if(self.mediaInformation != nil){
            dd["media"] = self.mediaInformation?.toMap()
//            do{
//                dd["assss"] = try JSONSerialization.data(withJSONObject:self.mediaInformation!.toMap(), options:.prettyPrinted).description
//            }catch{}
        }
        if(self.queueData != nil){
            dd["queueData"] = self.queueData?.toMap()
        }
//        self.queueData?.items.map(<#T##transform: ([GCKMediaQueueItem]) throws -> U##([GCKMediaQueueItem]) throws -> U#>)
//        var dd1 = [String:Any]()
//        dd1["subString"] = 100
//        dd["queueData"] = self.queueData
        if(self.idleReason != GCKMediaPlayerIdleReason.none){
        dd["idleReason"] = self.idleReason.toS()
        }
//        dd["sub"] = dd1
        
        return dd
    }
}
extension GCKMediaQueueData{
    func toMap() -> Dictionary<String,Any>{
        var d = [String:Any]()
        d["startIndex"] = self.startIndex
        return d;
    }
}

extension GCKMediaInformation{
    func toMap() -> Dictionary<String,Any>{
        var d = [String:Any]();
        d["contentId"] = self.contentID
        d["contentType"] = self.contentType
        d["streamType"] = self.streamType.toS()
        d["duration"] = self.streamDuration
        d["metadata"] = self.metadata?.toMap()
        return d;
    }
}
extension GCKMediaMetadata{
    func toMap() -> Dictionary<String,Any>{
        var d = [String:Any]()
//        GCKMediaMetadataType
        d["metadataType"] = self.metadataType.rawValue
        switch(self.metadataType.rawValue){
        case 1 :
            d["title"] = self.string(forKey: kGCKMetadataKeyTitle)
            d["subtitle"] = self.string(forKey: kGCKMetadataKeySubtitle)
            d["studio"] = self.string(forKey: kGCKMetadataKeyStudio)
            let images = self.images()
            var imageArray: Array<Dictionary<String,Any>> = Array<Dictionary<String,Any>>()
            for val in images{
                if(val is GCKImage){
                    let v = val as? GCKImage
            
                    imageArray.append(["url":v?.url.absoluteURL])
                  
                }
            }
            
            break
        case 2:
            d["seriesTitle"] = self.string(forKey: kGCKMetadataKeySeriesTitle)
            d["subtitle"] = self.string(forKey: kGCKMetadataKeySubtitle)
            d["episode"] = self.integer(forKey: kGCKMetadataKeyEpisodeNumber)
            let images = self.images()
            var imageArray = NSArray()
            for val in images{
                if(val is GCKImage){
                    let v = val as? GCKImage
                    let add = ["url":v?.url.absoluteURL.description]
                    imageArray = imageArray.adding(add) as NSArray
                }
            }
//            d["images"] = imageArray.description
            break
        default:
            break
        }
        return d;
    }
}
extension GCKMediaStreamType{
    func toS() -> String{
        var streamtypeString = ""
        switch(self.rawValue){
        case 0:
            streamtypeString = "NONE"
            break
        case 1 :
            streamtypeString = "BUFFERED"
            break;
        case 2:
            streamtypeString = "LIVE"
            break;
        default:
            break;
        }
        return streamtypeString;
    }
}


extension GCKMediaPlayerIdleReason{
    func toS() -> String{
        var reasonString = ""
        switch(self.rawValue){
        case 0:
    //        reasonString = "NONE"
            break;
        case 1:
            reasonString = "FINISHED"
            break;
        case 2:
            reasonString = "CANCELLED"
        case 3:
            reasonString = "Interrupted".uppercased()
            break;
        case 4 :
            reasonString = "ERROR"
            break;
        default:
            break;
            
        }
        return reasonString
    }
}
//func getStringFromIdelReason(reason:GCKMediaPlayerIdleReason) -> String{
//    var reasonString = ""
//    switch(reason.rawValue){
//    case 0:
////        reasonString = "NONE"
//        break;
//    case 1:
//        reasonString = "FINISHED"
//        break;
//    case 2:
//        reasonString = "CANCELLED"
//    case 3:
//        reasonString = "Interrupted".uppercased()
//        break;
//    case 4 :
//        reasonString = "ERROR"
//        break;
//    default:
//        break;
//
//    }
//    return reasonString
//}

extension GCKMediaPlayerState{
    func toS() -> String{
        var playerState = "";
        switch(self.rawValue){
        case 0 :
            playerState = "UNKNOWN"
            break
        case 1 :
            playerState = "IDLE"
            break
        case 2 :
            playerState = "PLAYING"
            break
        case 3:
            playerState = "PAUSED"
            break
        case 4:
            playerState = "BUFFERING"
            break
        case 5:
            playerState = "LOADING"
            break
            default:
                break;
            
        };
        return playerState
    }
}
