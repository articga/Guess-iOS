//
//  SocketService.swift
//  Guess
//
//  Created by Rene Dubrovski on 3/29/20.
//  Copyright © 2020 articga. All rights reserved.
//

import SocketIO

open class SocketService {

    public static let `default` = SocketService()
    private let manager: SocketManager
    private var socket: SocketIOClient

    private init() {
        manager = SocketManager(socketURL: URL(string: "http://192.168.0.3:5050")!, config: [.log(false), .compress])
        socket = manager.defaultSocket
        socket.on("test") { (data, ack) in
            print("Socket Ack: \(ack)")
            print("Emitted Data: \(data)")
            //Do something with the data you got back from your server.
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func emitUser(withID: Int) {
        socket.emit("connectUser", ["id": withID])
    }
    
    func makeUserAvailForMatchmaking(guessMode: Int, nickname: String) {
        socket.emit("newAvailMatchmaker", ["nickname": nickname, "guessMode": guessMode])
    }
}
