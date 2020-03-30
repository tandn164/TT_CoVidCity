//
//  Posts.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/29/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
struct User {
    var userName: String?
    var profileImage: UIImage?
}
struct Posts {
    var createBy: User
    var timeAgo: String?
    var caption: String?
    var image: UIImage?
    var numberOfLikes: Int?
    var numberOfComments: Int?
    var numberOfShares: Int?
    static func fetchPosts() -> [Posts]
    {
        var posts = [Posts]()
        let BoYTe = User(userName: "Bộ y tế", profileImage: UIImage(named: "boyte"))
        let post1 = Posts(createBy: BoYTe, timeAgo: "1 hr", caption: "Ổ dịch BV Bạch Mai: Phải dập bằng được Phó Thủ tướng nhấn mạnh: Việc dập các ổ dịch có tính quyết định khi dịch đã lây lan vào cộng đồng. Chúng ta đã làm tốt với ổ dịch tại Sơn Lôi (Vĩnh Phúc), ổ dịch ở Bình Thuận và chuyến bay VN0054…, hiện chúng ta có hai ổ dịch cần đặc biệt lưu ý là ổ dịch ở quán bar Buddah (TPHCM) và ổ dịch tại BV Bạch Mai (Hà Nội).BV Bạch Mai là BV tuyến cuối, mỗi ngày có hàng chục nghìn người qua lại và trong những ngày qua UBND TP Hà Nội đã rất chủ động, tích cực, trách nhiệm, phối hợp chặt chẽ với Bộ Y tế để chỉ đạo BV Bạch Mai thực hiện các biện pháp cần thiết. Tới đây, nhất định chúng ta phải quyết liệt hơn, lên danh sách toàn bộ những người đã đến BV Bạch Mai từ ngày 12/3/2020 đến nay. Tỉnh thành nào có người đến BV Bạch Mai đều phải vào cuộc quyết liệt chứ không chỉ TP. Hà Nội. Các lực lượng phải phối hợp chặt chẽ, đồng bộ để dập bằng được ổ dịch này.", image: UIImage(named: "1"), numberOfLikes: 12, numberOfComments: 32, numberOfShares: 40)
        let post2 = Posts(createBy: BoYTe, timeAgo: "12 m", caption:"Trong tháng 3 năm 2020, công tác phòng, chống dịch COVID-19 tiếp tục được triển khai rộng khắp với sự vào cuộc của cả hệ thống chính trị, các ngành, các cấp và của toàn dân. Chúng ta đã và đang kiềm chế và kiểm soát được dịch bệnh, được cộng đồng quốc tế đánh giá cao, nhân dân đồng tình, tin tưởng vào sự lãnh đạo của Đảng và Nhà nước.Tuy nhiên, dịch bệnh vẫn tiếp tục diễn biến phức tạp, khó lường trên phạm vi toàn cầu, số lượng người mắc, tử vong tăng nhanh và chưa có dấu hiệu dừng lại. Ở nước ta, trong tháng 2 chỉ có 16 ca mắc, nhưng chỉ trong vòng 20 ngày (từ ngày 6 đến 26 tháng 3), đã có 137 ca mắc mới tại 23 tỉnh, thành phố, gấp trên 8,5 lần số ca mắc trước đó, đưa tổng số ca mắc lên 153 ca; đã có hiện tượng lây nhiễm đối với cán bộ y tế, xuất hiện lây nhiễm trong cộng đồng, nhất là tại một số thành phố lớn, gây lo lắng trong nhân dân. Nước ta đã bước vào giai đoạn cao điểm có ý nghĩa quyết định trong phòng chống dịch bệnh COVID-19.", image: UIImage(named: "2"), numberOfLikes: 100, numberOfComments: 100, numberOfShares: 100)
        let post3 = Posts(createBy: BoYTe, timeAgo: "1 m", caption: "Stay at home", image: UIImage(named: "3"), numberOfLikes: 1, numberOfComments: 0, numberOfShares: 1000)
        posts.append(post1)
        posts.append(post2)
        posts.append(post3)
        return posts
    }
}
