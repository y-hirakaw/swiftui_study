struct Repositories: Decodable {
    var repositories: [Repository]

    struct Repository: Decodable {
        let name: String
        let owner: Owner
        let languagesUrl: String
        let starCount: Int
        let url: String
        
        enum CodingKeys: String, CodingKey {
            case name = "name"
            case owner = "owner"
            case languagesUrl = "languages_url"
            case starCount = "stargazers_count"
            case url = "html_url"
        }
        
        struct Owner: Decodable  {
            let login: String
        }
    }
    
    var repositoriesCount: Int {
        return self.repositories.count
    }
    
    func getRepository(_ index: Int) -> Repository? {
        guard index >= 0 && index < self.repositories.count else {
            return nil
        }
        return self.repositories[index]
    }
}
