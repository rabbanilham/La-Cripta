# La Cripta

### Overview

La Cripta is an app created for Nostratech iOS Technical Challenge. The app has two main features:

1. Get at least 50 cryptocurrency ticker data and display them in a `UITableViewController`.
  - Data retrieved from [CryptoCompare Toplists API](https://min-api.cryptocompare.com/documentation?key=Toplists&cat=topTotalTopTierVolumeEndpointFull)
  - User can refresh the list by pulling from the top.
  - Ticker color turns green when the price increases and red for the opposite, or it will turns yellow if no change happens (which is rarely happens).
  
2. Display news related to the currency selected upon tapping a cell from the toplists.
  - Data retrieved from [News API](https://min-api.cryptocompare.com/documentation?key=News&cat=latestNewsArticlesEndpoint).
  

### Additional Features

Besides the main features, there are several additional features to make the app even more powerful and easy to use.

1. Show live price update from a cryptocurrency. User can swipe a cell from right to show the live update page. Data retrieved from [CryptoCompare WebSocket API](https://min-api.cryptocompare.com/documentation/websockets)
2. Change the price change duration. User can choose either by day, hour, and the last 24 hours.
3. Sort news by the latest, oldest, or in a random order.
4. Read the news detail by tapping the news cell.
5. Share news to friends or colleagues just by tapping the share button.


### Solution explanation

#### Design Pattern

La Cripta started small, so it uses MVC as its design pattern.

#### Libraries
  - [Alamofire](https://github.com/Alamofire/Alamofire.git) used for networking, mainly fetching data from APIs.
  - [Kingfisher](https://github.com/onevcat/Kingfisher.git) used for image downloading and caching.
  
#### Extensions
  - `UIView` : `fadeIn()` and `fadeOut()` function. Their names are self-explanatory. `addSubviews(_ views: UIView...)` is like `addSubview(_ : UIView)` but can accept multiple views.
  - `String` : `convertToDateInterval()` converts an en_US_POSIX formatted date string to a string representing the interval between a date and now. (e.g.: "2 hours ago", "5 days ago")
  - `Double` : `convertToCurrency()` converts a `Double` to accounting currency. (e.g.: $19.45)
  - `NSMutableAttributedString` : `addLineSpacing(_ spacing: CGFloat)` function. Also a self-explanatory name.
  
#### Views and Custom Views
 - `ToplistsTableViewCell` is a `UITableViewCell` used in `ToplistsViewController` and `LiveUpdateViewController`. Showing a crypto's name, full name, price, price change, and price change percentage.
 - `NewsTableViewCell` is a `UITableViewCell` used in `NewsViewController`. Showing an article image, title, content, author & source, and share button.

#### Logics
1. After loading the `ToplistsViewController`, `ToplistsAPI` will fetch data from the API. If it successfully get the data, it will decode the data to `LCToplistsDataResponse`, assign the `toplists` let to the view controller's toplists array, and reload the table view. The number of cell returned equals to number of toplists, and each cell filled by a toplist.

![Simulator Screen Shot - iPhone 13 - 2022-07-29 at 00 26 18](https://user-images.githubusercontent.com/99727731/181600377-744c1eb0-978e-49f4-9ace-ee42c223837b.png)

2. Selecting a cell will present the `NewsViewController`. `NewsAPI` query is the crypto's full name, so the news shown will be related to the crypto. Fetching the news data shares the same idea as fetching the toplists data. Dismissing the news page will clear the Kingfisher cache to free up memory.

![Simulator Screen Shot - iPhone 13 - 2022-07-28 at 11 04 04](https://user-images.githubusercontent.com/99727731/181418094-c6f052e2-06af-4db7-adf5-641fad9bd960.png)

3. Swiping a cell to the left will show the present `LiveUpdateViewController` option (or swiping it all the way to the end left will automatically present it).

![Simulator Screen Shot - iPhone 13 - 2022-07-29 at 00 27 56](https://user-images.githubusercontent.com/99727731/181600649-e987d1b2-04a4-4439-9678-879b8969a38c.png)


4. Live update will start automatically after entering the live update page, thanks to the `connectToSocket`, `sendSubscription`, and `receiveMessage` methods called in `viewDidLoad`. **Some internet provider may block your connection to the live update view. If this happens, try using another network or connect to a VPN**

![Simulator Screen Shot - iPhone 13 - 2022-07-28 at 11 03 49](https://user-images.githubusercontent.com/99727731/181418241-7878d03d-e961-4307-bb0b-abafd4525f2e.png)


5. `LiveUpdateViewController` will refresh its cell contents every time the web socket receives data. Dismissing the view will automatically disconnect web socket connection.
