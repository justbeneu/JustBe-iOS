//
//  PebbleHelper.swift
//  Repressor Destressor
//
//  Created by Kyle Venn on 3/20/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

protocol PebbleHelperDelegate {
    func pebbleHelper(pebbleHelper: PebbleHelper, receivedMessage: Dictionary<NSObject, AnyObject>)
}

class PebbleHelper: NSObject, PBPebbleCentralDelegate, PBDataLoggingServiceDelegate {
    
    class var instance : PebbleHelper {
        struct Static {
            static let instance : PebbleHelper = PebbleHelper()
        }
        return Static.instance
    }
    
    var watch: PBWatch?
    var delegate: PebbleHelperDelegate?
    var parts = Array<String>()
    var keys = Array<Int>()
    var dictionary = Dictionary<Int, String>()
    
    //Set the app UUID
    var UUID: String? {
        didSet {
            let myAppUUID = NSUUID(UUIDString: self.UUID!)
            var myAppUUIDbytes = Array<UInt8>(count:16, repeatedValue:0)
            myAppUUID?.getUUIDBytes(&myAppUUIDbytes)
            PBPebbleCentral.defaultCentral().appUUID = NSData(bytes: &myAppUUIDbytes, length: 16)
            if (self.watch != nil) {
                self.watch?.appMessagesAddReceiveUpdateHandler({ (watch, msgDictionary) -> Bool in
                    println("Message received")
                    self.delegate?.pebbleHelper(self, receivedMessage: msgDictionary)
                    return true
                })
            }
        }
        
    }
    
    override init() {
        super.init()
        PBPebbleCentral.defaultCentral().delegate = self
        PBPebbleCentral.defaultCentral().dataLoggingService.delegate = self
        self.watch = PBPebbleCentral.defaultCentral().lastConnectedWatch()
        if (self.watch != nil) {
            println("Pebble connected: \(self.watch!.name)")
        }
        
    }
    
    func pebbleCentral(central: PBPebbleCentral!, watchDidConnect watch: PBWatch!, isNew: Bool) {
        println("Pebble connected: \(watch.name)")
    }
    
    func pebbleCentral(central: PBPebbleCentral!, watchDidDisconnect watch: PBWatch!) {
        println("Pebble disconnected: \(watch.name)")
        if (self.watch == watch) {
            self.watch = nil
        }
    }
    
    func launchApp(completionHandler: (error: NSError?) -> Void) {
        self.watch?.appMessagesLaunch({ (watch, error) -> Void in
            completionHandler(error: error)
        })
    }
    
    func killApp(completionHandler: (error: NSError?) -> Void) {
        self.watch?.appMessagesKill({ (watch, error) -> Void in
            completionHandler(error: error)
        })
    }
    
    func checkCompatibility(completionHandler: (isAppMessagesSupported: Bool) -> Void) {
        self.watch?.appMessagesGetIsSupported({ (watch, isSupported) -> Void in
            completionHandler(isAppMessagesSupported: isSupported)
        })
    }
    
    func printInfo() {
        if (self.watch != nil) {
            println("Pebble name: \(self.watch!.name)")
            println("Pebble serial number: \(self.watch!.serialNumber)")
            self.watch?.getVersionInfo({ (watch, versionInfo) -> Void in
                println("Pebble firmware os version: \(versionInfo.runningFirmwareMetadata.version.os)")
                println("Pebble firmware major version: \(versionInfo.runningFirmwareMetadata.version.major)")
                println("Pebble firmware minor version: \(versionInfo.runningFirmwareMetadata.version.minor)")
                println("Pebble firmware suffix version: \(versionInfo.runningFirmwareMetadata.version.suffix)")
                }, onTimeout: { (watch) -> Void in
                    println("Timed out trying to get version info from Pebble.")
            })
        }
    }
    
    func sendDictionary(dictionary: Dictionary<Int, String>, completionHandler: (error: NSError?) -> Void) {
        if dictionary.isEmpty {
            return
        }
        self.dictionary = dictionary
        keys = dictionary.keys.array
        keys.sort { $0 < $1 }
        sendLine { (error) -> Void in
            completionHandler(error: error)
        }
    }
    
    private func sendLine(completionHandler: (error: NSError?) -> Void) {
        let key = keys[0]
        sendMessage(dictionary[keys[0]]!, key: keys[0]) { (error) -> Void in
            self.keys.removeAtIndex(0)
            if (self.keys.isEmpty) {
                completionHandler(error: nil)
            } else {
                self.sendLine(completionHandler)
            }
            
        }
    }
    
    func sendMessage(message: String, key: Int, completionHandler: (error: NSError?) -> Void) {
        
        let maxLength = 64
        parts.removeAll(keepCapacity: false)
        var msg = message
        do {
            var part = ""
            if (count(msg) > maxLength) {
                parts.append(msg.substringToIndex(advance(minElement(indices(msg)), maxLength)))
                msg = msg.substringFromIndex(advance(minElement(indices(msg)), maxLength))
            } else {
                parts.append(msg)
                msg = ""
            }
        } while !msg.isEmpty
        
        sendToWatch(key, completionHandler: completionHandler)
    }
    
    private func sendToWatch(key: Int, completionHandler: (error: NSError?) -> Void) {
        let msgDictionary = [0: key, 1: parts[0]]
        self.watch?.appMessagesPushUpdate(msgDictionary as [NSObject : AnyObject], onSent: { (watch, msgDictionary, error) -> Void in
            self.parts.removeAtIndex(0)
            if (self.parts.count > 0) {
                self.sendToWatch(key, completionHandler: completionHandler)
            } else {
                completionHandler(error: error)
            }
        })
    }
    
    // Sends a message string (less than 64 characters) that will set the exercise message that is displayed on the interval
    // If any failure, retry a max of 'retries' times
    private func pushNewExerciseMessage(message: String, retries: Int)
    {
        var pebbleHelper = PebbleHelper.instance
        
        if(retries > 0)
        {
            NSLog("Trying to send message on try number %d", 4-retries)
            pebbleHelper.launchApp({ (error) -> Void in
                if (error == nil)
                {
                    pebbleHelper.sendMessage(message, key: 0, completionHandler: { (error) -> Void in
                        if (error == nil)
                        {
                            NSLog("Message sent to Pebble: \(message)")
                            // Close the app once the message has been sent
                            pebbleHelper.killApp({ (error) -> Void in
                                if(error != nil)
                                {
                                    NSLog("Unresolved Pebble Error While Killing WatchApp: \(error), \(error!.userInfo)");
                                    // Retry this method again if something went wrong
                                    self.pushNewExerciseMessage(message, retries: retries-1)
                                }
                            })
                        }
                        else
                        {
                            NSLog("Unresolved Pebble Error While Sending Message: \(error), \(error!.userInfo)")
                            // Retry this method again if something went wrong
                            self.pushNewExerciseMessage(message, retries: retries-1)
                        }
                    })
                }
                else
                {
                    NSLog("Unresolved Pebble Error While Launching WatchApp: \(error), \(error!.userInfo)")
                    // Retry this method again if something went wrong
                    self.pushNewExerciseMessage(message, retries: retries-1)
                }
            })
        }
    }
    
    // Sends a message string (less than 64 characters) that will set the message that is displayed on the interval
    func pushNewExerciseMessage(message: String)
    {
        // Run method with 3 retries
        pushNewExerciseMessage(message, retries: 3)
    }
    
    //MARK: PBDataLoggingDelegate Methods
    func dataLoggingService(service: PBDataLoggingService!, hasUInt32s data: UnsafePointer<UInt32>, numberOfItems: UInt16, forDataLoggingSession session: PBDataLoggingSessionMetadata!) -> Bool
    {
        // Sometimes the logger sends other random garbage so only accept it if its our 1 item (the date)
        // Also needs to have our specified tag of 42
        if Int(numberOfItems) == 1 && session.tag == 42
        {
            for (var i = 0; i < Int(numberOfItems); ++i)
            {
                var loggedTime = data[i]; //const UInt32
                
                let time = NSDate(timeIntervalSince1970: NSTimeInterval(loggedTime));
                
                NSLog("Received Vibrate Time: \(time.description)");
                
                UserDefaultsManager.sharedInstance.addNotificationTime(NotificationTime(notificationTime: time))
            }
        }
        
        // We consumed the data, let the data logging service know:
        return true;
    }
    
    // This method just gets called when the service is done logging the particular session
    func dataLoggingService(service: PBDataLoggingService!, sessionDidFinish session: PBDataLoggingSessionMetadata!)
    {
    }

}