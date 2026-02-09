//
//  StatsClient.swift
//  CodexAgentBar
//
//  Created by Artem Novichkov on 09.02.2026.
//


struct StatsClient {

    enum Error: Swift.Error {
        case fileNotFound
    }
    var loadStats: () throws -> StatsCache?
    var startMonitoring: () -> Void
    var stopMonitoring: () -> Void
}

extension StatsClient {
    static var live: StatsClient {
        StatsClient(
            loadStats: {
                let home = FileManager.default.homeDirectoryForCurrentUser.path
                let path =  "\(home)/Library/Developer/Xcode/CodingAssistant/ClaudeAgentConfig/stats-cache.json"
                guard FileManager.default.fileExists(atPath: path) else {
                    throw Error.fileNotFound
                }
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return try StatsCache.decode(from: data)
            },
            startMonitoring: { },
            stopMonitoring: { }
        )
    }
}

extension StatsClient {
    static var empty: StatsClient {
        StatsClient(
            loadStats: { throw Error.fileNotFound },
            startMonitoring: { },
            stopMonitoring: { }
        )
    }
}