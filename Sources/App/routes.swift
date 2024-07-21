import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("hello", "vapor") { req async -> String in
        "Hello, vapor!"
    }
    
    app.get("hello", ":name") { req in
        let name = req.parameters.get("name", as: String.self)
        return "Hello \(name ?? "Nothing")"
    }

    app.get("date") { req in
        return "\(Date.now)"
    }
    
    app.get("counter", ":count") { req in
        let num = req.parameters.get("count", as: Int.self)
        return "Counter \(num ?? -1)"
    }
    
    app.post("info") { req in
        let data = try req.content.decode(InfoData.self)
        return ResponseInfo(request: data)
    }
    
    app.post("user-info") { req in
        let data = try req.content.decode(UserInfoData.self)
        return ResponseInfo(request: data)
    }
    
    try app.register(collection: TodoController())
}

struct InfoData: Content {
    let name: String
}

struct ResponseInfo<T: Content>: Content {
    let request: T
}

struct UserInfoData: Content {
    let name: String
    let age: Int
}
