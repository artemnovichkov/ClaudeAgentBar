import Foundation

public struct StatsClient: Sendable {
    public enum Error: Swift.Error {
        case fileNotFound
    }

    public static var statsPath: String {
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        return "\(home)/Library/Developer/Xcode/CodingAssistant/ClaudeAgentConfig/stats-cache.json"
    }

    public var loadStats: @Sendable () throws -> StatsCache?
    public var startMonitoring: @Sendable (@escaping @Sendable () -> Void) -> Void

    public init(
        loadStats: @escaping @Sendable () throws -> StatsCache?,
        startMonitoring: @escaping @Sendable (@escaping @Sendable () -> Void) -> Void
    ) {
        self.loadStats = loadStats
        self.startMonitoring = startMonitoring
    }
}

extension StatsClient {
    public static var live: StatsClient {
        StatsClient(
            loadStats: {
                guard FileManager.default.fileExists(atPath: statsPath) else {
                    throw Error.fileNotFound
                }
                let data = try Data(contentsOf: URL(fileURLWithPath: statsPath))
                return try StatsCache.decode(from: data)
            },
            startMonitoring: { eventHandler in
                let path = Self.statsPath
                var fileDescriptor = open(path, O_EVTONLY)
                if fileDescriptor == -1 {
                    return
                }

                let source = DispatchSource.makeFileSystemObjectSource(
                    fileDescriptor: fileDescriptor,
                    eventMask: .write,
                    queue: .main
                )

                source.setEventHandler(handler: eventHandler)

                source.setCancelHandler {
                    close(fileDescriptor)
                    fileDescriptor = -1
                }

                source.resume()
            }
        )
    }
}

extension StatsClient {
    public static var empty: StatsClient {
        StatsClient(
            loadStats: { throw Error.fileNotFound },
            startMonitoring: { _ in }
        )
    }
}
