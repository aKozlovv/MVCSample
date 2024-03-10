enum ViewData: Decodable {
    case initial
    case loading
    case success(Joke)
    case failure
    
    struct Joke: Decodable {
        let iconURL: String?
        let id: String?
        let URL: String?
        let value: String?
        
        private enum CodingKeys: String, CodingKey {
            case iconURL = "icon_url"
            case id = "id"
            case URL = "url"
            case value
        }
    }
}
