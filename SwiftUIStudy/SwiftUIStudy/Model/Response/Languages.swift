struct DynamicCodingKeys: CodingKey {
    
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }
}

struct Languages: Decodable {
    
    var languages: [String]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        languages = container.allKeys.map { $0.stringValue }
    }
    
    var languagesCount: Int {
        return self.languages.count
    }
    
    func getLanguage(_ index: Int) -> String? {
        guard index >= 0 && index < self.languages.count else {
            return nil
        }
        return self.languages[index]
    }
}
