</br>
<p align="center">
    <img src="https://raw.githubusercontent.com/Kolos65/Covid/master/title.png" width="500”  alt="Covid" />
</p>

# 

![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-iOS-blue)
![Quality](https://img.shields.io/badge/code%20quality-A%2B-yellow)

An iOS app to check real time statistics of COVID19 cases in 47 countries.

## Usage
Covid is single view app, that lets you browse the current statistics of COVID19 cases in 47 countries. The app shows the number of deaths, confimed, recovered and active cases for every country. You can sort the records by any of the listed fields. Each row displays a chart that shows the rate of the different data fields with the corresponding colors.
</br>
</br>
<p align="center">
    <img src="https://raw.githubusercontent.com/Kolos65/Covid/master/screenshots.png" width="800”  alt="Screenshots" />
</p>

## Installation
Covid uses a publicly available API to fetch data. You can find the API on [rapidapi.com](https://rapidapi.com/KishCom/api/covid-19-coronavirus-statistics). In order to use it, you will have to create an account, and aquire an api-key. Once you have your key, just copy-paste it to the Constants in `CovidRemoteDataSource`.
```swift
private enum Constants {
    ...
    static let headers = [
        "x-rapidapi-host": "covid-19-coronavirus-statistics.p.rapidapi.com",
        "x-rapidapi-key": PASTE.YOUR.OWN.API.KEY.HERE
    ]
}
```

## Implementation
### Sorting with key paths
A great example of [the power of keypaths](https://www.swiftbysundell.com/articles/the-power-of-key-paths-in-swift/) in Swift is when you want to dynamically change which attribute to use in a `sort(by:)` function.
```swift
typealias SortOption = KeyPath<CountryStatViewModel, Int>

private func sort(by option: SortOption) {
    ...
    var countries = viewModels.compactMap { $0 as? CountryStatViewModel }
    countries.sort { $0[keyPath: option] > $1[keyPath: option] }
    ...
}
```
### Searching with fuse
Fuzzy searching can highly improve user experience, there is nothing more frustrating when you have to type an exact substring match to find what you are searching for. [Fuse](https://github.com/krisk/fuse-swift) is a great Swift library that implements a fast approximate string matching algorithm which provides match ranges too.
```swift
private func search(text: String) {
    let countryStats = viewModels.compactMap { $0 as? CountryStatViewModel }
    let search = fuse.search(text, in: countryStats.map { $0.country.name })
    searchResults = search.map { countryStats[$0.index] }
    tableView.reloadData()
}
```
### Constrained type extensions
When you implement type specific functionality in an extension, you can use generic where clauses to specify the type requirements of the extension. To make your [extensions more reusable](https://www.swiftbysundell.com/articles/writing-reusable-swift-extensions/), you can also specify a protocol conformance requirement. Always choose the most abstract protocol possible to extend the usage of your code as widely as you can.
```swift
extension Array where Element == CovidRecord {
    var sumRecovered: Int {
        return map { $0.recovered }
            .reduce(0, +)
    }
}

extension Array where Element: AdditiveArithmetic {
    func sum(first n: Int) -> Element {
        return prefix(n).reduce(.zero, +)
    }
}
```
### Lazy initialization
The lazy modifier defers the initialization of variables until the first call. This lets you create properties with a function, which can be reused to create similar components.
```swift
private lazy var activeView = createStatField(
    icon: Constants.activeIcon,
    tintColor: .covidOrange
)
```
### Tuples as lightweight types
As the ducumentation says: always start with a struct. Before really starting with a struct, consider using a tuple first. When all you need is a container of named properties, tuples can come in really handy if your model is just for grouping components.
```swift
typealias StatField = (iconView: UIImageView, nameLabel: UILabel,  valueLabel: UILabel)

private func createStatField(icon: UIImage?, tintColor: UIColor) -> StatField {
    ...
}
```
### Layout with closures
All autolayout code is implemented using [ClosureLayout](https://github.com/Kolos65/ClosureLayout) which is a lightweight auto layout DSL that enables you to define constraints in a convenient and easy way.
```swift
navigationView.layout {
    $0.top == view.topAnchor
    $0.leading == view.leadingAnchor
    $0.trailing == view.trailingAnchor
}
```
### Simplifying table views
When working with table views, managing cell identifiers can be exhausting. Using these extensions makes it unnecesary.
```Swift
extension UITableView {
    func dequeuCellOfType<Cell: UITableViewCell>(_ type: Cell.Type) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.identifier) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(reuseIdentifier)")
        }
        return cell
    }
    
    func register<Cell: UITableViewCell>(_ type: Cell.Type) {
        register(type, forCellReuseIdentifier: Cell.identifier)
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
```
With the help of these generic functions, you can register your cells like this:
```swift
tableView.register(WorldStatCell.self)
```
and dequeue as the corresponding cell type like this:
```swift
let cell = tableView.dequeuCellOfType(WorldStatCell.self)
```
### MVVM in practice
MVVM is an essential design pattern to learn and comes especially useful when you implement table views with multiple row types. Despite Covid having only two types of cells, and the `WorldStatCell` has only one instance on the top of the table view, it is always a good idea to think about extensibility early on. The main idea is to dequeue and configure cells based on the corresponding ViewModels. First, you need an abstract type so you can store your ViewModels in an array:
```swift
protocol CovidStatViewModel {}
```
You then create your viewmodels and make them conform to this protocol. 
```swift
struct WorldStatViewModel: CovidStatViewModel {
    var title: String
    var subtitle: String
    ...
}

struct CountryStatViewModel: CovidStatViewModel {
    var country: String
    var flag: UIImage?
    ...
}
```
The purpose of these ViewModels is to capture the data in a format that is the closest to what will be rendered on the UI. For this, you need to transform your domain models to the desired format. This is usually implemented in the initializer of the ViewModel. This is the perfect place to use date formatters. The `WorldStatViewModel` for example is created from a `CovidStats` instance, that stores an array of COVID19 records.
```swift
extension WorldStatViewModel {
    init(from stats: CovidStats) {
        ...
    }
}
```
On the view side, you have to create a configuration function that fills the table view cell with the formatted data of the ViewModels:
```swift
class WorldStatCell: UITableViewCell {
    ...
    func configure(with vm: WorldStatViewModel) {
        titleLabel.text = vm.title
        subtitleLabel.text = vm.subtitle
        ...
    }
}
```
With all this set up, your cell configuration becomes an ease. In your table view managing view controller, you store your ViewModels in an array.
```swift
var viewModels = [CovidStatViewModel]()
```
which enables your setup to be completely data driven:
```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch viewModels[indexPath.row] {
    case let vm as WorldStatViewModel:
        let cell = tableView.dequeuCellOfType(WorldStatCell.self)
        cell.configure(with: vm)
        return cell
    case let vm as CountryStatViewModel:
        let cell = tableView.dequeuCellOfType(CountryStatCell.self)
        cell.configure(with: vm)
        return cell
    }
}
```

## License

Covid is available under the MIT license. See the LICENSE file for more info.

