//
//  OPC.swift
//  Swift-OPC
//
//  Created by Kaan Dedeoglu on 5/22/16.
//
//

import Foundation

public class OPC {
    public typealias PixelColor = (UInt8, UInt8, UInt8)
    
    let hostName: String
    let port: Int32
    
    var socket: Socket?
    
    public init(hostName: String, port: Int32) {
        self.hostName = hostName
        self.port = port
    }
    
    public func connect() {
        disconnect()
        
        do {
            socket = try Socket.create(family: .inet, type: .stream, proto: .tcp)
            try socket?.connect(to: hostName, port: port)
        } catch {
            print("Cannot create the socket")
        }
    }
    
    func checkIfConnected() -> Bool {
        if socket == nil {
            connect()
            return false
        }
        
        if socket?.isConnected == false {
            connect()
            return false
        }
        
        return true
    }
    
    public func disconnect() {
        socket?.close()
    }
    
    public func setPixels(pixels: [PixelColor], channel: UInt8 = 0) {
        guard checkIfConnected() == true else {
            print("Not connected, skipping this command")
            return
        }
        
        let numPixels = pixels.count * 3
        let hiByte: UInt8 = UInt8(numPixels / 256)
        let loByte: UInt8 = UInt8(numPixels % 256)
        let command: UInt8 = 0
        let pixelBytes = pixels.flatMap { (r,g,b) -> [UInt8] in
            return [r,g,b]
        }
        
        let resultBytes: [UInt8] = [channel, command, hiByte, loByte] + pixelBytes
        let resultData = NSData(bytes: resultBytes, length: resultBytes.count * sizeof(UInt8))
        do {
            try socket?.write(from: resultData)
        } catch {
            "Print cannot send data"
        }
    }
}
