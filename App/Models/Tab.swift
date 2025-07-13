//
//  Tab.swift
//  
//
//  Created by Camila Souza on 1/9/25.
//

class Tab {
    let title: String
    let image: String
    let path: String
    
    var isStarted = false
    
    static var all = [
        Tab(title: "Home", image: "house", path: "/"),
        Tab(title: "Events", image: "calendar", path: "home_events"),
        Tab(title: "Favorites", image: "heart", path: "my_favorites"),
        Tab(title: "Account", image: "person.crop.circle", path: "native_index")
    ]
    
    init(title: String, image: String, path: String) {
        self.title = title
        self.image = image
        self.path = path
    }
}
