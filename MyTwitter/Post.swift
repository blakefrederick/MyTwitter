import FirebaseFirestore
import Foundation

struct Post: Identifiable, Decodable {
    @DocumentID var id: String?
    let title: String?
    let username: String
    let text: String
    let imageUrl: String
    let timestamp: Date
    let favouriteCount: Int?
    let favouriteTimestamp: Date?
}
